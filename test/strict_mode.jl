using VideoIO
using Test
using ColorTypes
using FixedPointNumbers

@testset "Strict Mode" begin
    @testset "VideoCorruptionError" begin
        err = VideoIO.VideoCorruptionError("bad bits")
        @test err isa Exception
        @test err.message == "bad bits"
        io = IOBuffer()
        showerror(io, err)
        s = String(take!(io))
        @test occursin("VideoCorruptionError", s)
        @test occursin("bad bits", s)
    end

    mktempdir() do dir
        clean_video = joinpath(dir, "clean.mp4")
        height, width = 48, 64
        open_video_out(clean_video, RGB{N0f8}, (height, width),
                       framerate = 30, encoder_options = (crf = 23, preset = "medium")) do writer
            for i in 1:10
                write(writer, fill(RGB{N0f8}(i/10, 0.5, 0.5), height, width))
            end
        end

        @testset "Clean video, strict=true decodes successfully" begin
            n = 0
            openvideo(clean_video, strict = true) do video
                @test video isa VideoIO.VideoReader
                @test video.strict === true
                for _ in video
                    n += 1
                end
            end
            @test n == 10
        end

        @testset "Default is strict=false" begin
            openvideo(clean_video) do video
                @test video.strict === false
            end
        end

        @testset "Corrupted bitstream detection in strict mode" begin
            # Create a corrupt video using a known recipe that triggers AVERROR_INVALIDDATA
            # Recipe discovered empirically: write 0xFFFFFFFF at offset 772 triggers
            # bitstream corruption in a small H.264 video with specific encoding settings
            
            corrupt_video = joinpath(dir, "corrupt.mp4")
            
            # Create a clean video with settings that make corruption detectable
            height, width = 32, 48
            clean_tmp = joinpath(dir, "clean_tmp.mp4")
            open_video_out(clean_tmp, RGB{N0f8}, (height, width),
                         framerate = 30, 
                         encoder_options = (crf = 23, preset = "ultrafast")) do writer
                for i in 1:5
                    write(writer, fill(RGB{N0f8}(i/5, 0.5, 0.5), height, width))
                end
            end
            
            # Apply corruption at known offset that reliably triggers AVERROR_INVALIDDATA
            cp(clean_tmp, corrupt_video, force=true)
            rm(clean_tmp)
            
            open(corrupt_video, "r+") do f
                seek(f, 772)  # Empirically found offset in H.264 bitstream
                write(f, UInt8[0xff, 0xff, 0xff, 0xff])
            end
            
            # Test strict mode - must throw VideoCorruptionError
            @test_throws VideoIO.VideoCorruptionError begin
                openvideo(corrupt_video, strict = true) do video
                    for _ in video
                    end
                end
            end
            
            # Test non-strict mode - should NOT throw VideoCorruptionError
            # (it may succeed with concealment or throw a different error)
            non_strict_threw_corruption = false
            try
                openvideo(corrupt_video, strict = false) do video
                    for _ in video
                    end
                end
            catch e
                if e isa VideoIO.VideoCorruptionError
                    non_strict_threw_corruption = true
                end
            end
            @test !non_strict_threw_corruption
        end
    end
end
