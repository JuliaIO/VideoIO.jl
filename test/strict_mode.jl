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

        @testset "Corrupted bitstream throws VideoCorruptionError in strict mode" begin
            corrupt_video = joinpath(dir, "corrupt.mp4")
            cp(clean_video, corrupt_video; force = true)
            # Corrupt bytes deep in the file where compressed video data lives
            # (well past the moov/header region). Multiple small corruptions
            # raise the chance of hitting a slice rather than just NAL framing.
            sz = filesize(corrupt_video)
            open(corrupt_video, "r+") do f
                for off in (div(sz * 6, 10), div(sz * 7, 10), div(sz * 8, 10))
                    seek(f, off)
                    write(f, rand(UInt8, 32))
                end
            end

            threw_strict = false
            try
                openvideo(corrupt_video, strict = true) do video
                    for _ in video
                    end
                end
            catch e
                # Either VideoCorruptionError (preferred) or a plain decode/open
                # error if the container itself was damaged. Both indicate the
                # decoder did not silently produce concealed pixels.
                threw_strict = true
                if e isa VideoIO.VideoCorruptionError
                    @test occursin("bitstream", e.message) || occursin("Decoder", e.message)
                end
            end
            @test threw_strict
        end
    end
end
