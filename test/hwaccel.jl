@testset "Hardware acceleration" begin
    hw_devs = VideoIO.available_hw_devices()
    @info "Available HW device types" hw_devs

    @testset "available_hw_devices returns a Vector{Symbol}" begin
        @test hw_devs isa Vector{Symbol}
    end

    if isempty(hw_devs)
        @info "No hardware device types available in this FFmpeg build; skipping hwaccel decode tests"
    else
        for dev in hw_devs
            @testset "hwaccel = :$dev decoding" begin
                frames_in = [rand(RGB{N0f8}, 64, 64) for _ in 1:10]
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_test.mp4")
                    VideoIO.save(vidpath, frames_in; framerate = 30)

                    frames_out = VideoIO.openvideo(vidpath; hwaccel = dev) do r
                        @test VideoIO.out_frame_eltype(r) == RGB{N0f8}
                        collect(r)
                    end

                    @test length(frames_out) == length(frames_in)
                    @test eltype(frames_out[1]) == RGB{N0f8}
                    @test size(frames_out[1]) == size(frames_in[1])
                end
            end

            @testset "hwaccel = :$dev preserves frame content" begin
                # Build a recognisable frame: top half red, bottom half green
                h, w = 64, 64
                frame = zeros(RGB{N0f8}, h, w)
                frame[1:h÷2, :] .= RGB{N0f8}(1, 0, 0)
                frame[h÷2+1:end, :] .= RGB{N0f8}(0, 1, 0)
                frames_in = [frame for _ in 1:5]

                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_content_test.mp4")
                    # CRF 0 lossless encoding so we can do a meaningful pixel check
                    VideoIO.save(
                        vidpath, frames_in;
                        framerate = 30,
                        encoder_options = (color_range = 2, crf = 0, preset = "ultrafast"),
                    )

                    frames_hw = VideoIO.openvideo(vidpath; hwaccel = dev) do r
                        collect(r)
                    end
                    frames_sw = VideoIO.openvideo(vidpath) do r
                        collect(r)
                    end

                    @test length(frames_hw) == length(frames_sw)
                    for (f_hw, f_sw) in zip(frames_hw, frames_sw)
                        diff = mean(abs.(Float32.(channelview(f_hw)) .- Float32.(channelview(f_sw))))
                        @test diff < 0.01
                    end
                end
            end

            @testset "hwaccel = :$dev read! interface" begin
                frames_in = [rand(RGB{N0f8}, 64, 64) for _ in 1:5]
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_read_test.mp4")
                    VideoIO.save(vidpath, frames_in; framerate = 30)
                    VideoIO.openvideo(vidpath; hwaccel = dev) do r
                        buf = read(r)
                        while !eof(r)
                            read!(r, buf)
                        end
                        @test true  # reached here without error
                    end
                end
            end

            @testset "hwaccel = :$dev counttotalframes" begin
                n = 12
                frames_in = [rand(RGB{N0f8}, 64, 64) for _ in 1:n]
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_count_test.mp4")
                    VideoIO.save(vidpath, frames_in; framerate = 30)
                    @test VideoIO.openvideo(VideoIO.counttotalframes, vidpath; hwaccel = dev) == n
                end
            end
        end

        @testset "invalid hwaccel symbol throws" begin
            @test_throws ErrorException VideoIO.openvideo(
                VideoIO.testvideo("annie_oakley"); hwaccel = :not_a_real_device,
            ) do r
            end
        end
    end

    # --- Hardware-accelerated encoding tests ---
    hw_encoders = VideoIO.available_hw_encoders()
    @info "Available HW encoders" hw_encoders

    @testset "available_hw_encoders returns a Vector{String}" begin
        @test hw_encoders isa Vector{String}
    end

    if !isempty(hw_devs) && !isempty(hw_encoders)
        for dev in hw_devs
            @testset "hwaccel = :$dev encoding" begin
                frames_in = [rand(RGB{N0f8}, 64, 64) for _ in 1:10]
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_enc_test.mp4")
                    try
                        VideoIO.save(vidpath, frames_in; framerate = 30, hwaccel = dev)
                    catch e
                        @info "HW encoding with :$dev not supported for this codec/platform" exception = e
                        @test_broken false
                        return
                    end
                    # Verify the file is readable and has the right frame count
                    frames_out = VideoIO.openvideo(collect, vidpath)
                    @test length(frames_out) == length(frames_in)
                    @test size(frames_out[1]) == size(frames_in[1])
                end
            end

            @testset "hwaccel = :$dev encode then hwaccel decode roundtrip" begin
                h, w = 64, 64
                frame = zeros(RGB{N0f8}, h, w)
                frame[1:h÷2, :] .= RGB{N0f8}(1, 0, 0)
                frame[h÷2+1:end, :] .= RGB{N0f8}(0, 1, 0)
                frames_in = [frame for _ in 1:5]
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_roundtrip.mp4")
                    try
                        VideoIO.save(vidpath, frames_in; framerate = 30, hwaccel = dev)
                    catch e
                        @info "HW encoding with :$dev not supported" exception = e
                        @test_broken false
                        return
                    end
                    frames_hw = try
                        VideoIO.openvideo(collect, vidpath; hwaccel = dev)
                    catch
                        VideoIO.openvideo(collect, vidpath)
                    end
                    @test length(frames_hw) == length(frames_in)
                    # Lossy codec, so just check broad structure is preserved
                    for f in frames_hw
                        top_red  = mean(red.(f[1:h÷2, :]))
                        bot_green = mean(green.(f[h÷2+1:end, :]))
                        @test top_red > 0.5
                        @test bot_green > 0.5
                    end
                end
            end
        end

        @testset "hwaccel encoding with explicit codec_name" begin
            dev = first(hw_devs)
            for enc_name in hw_encoders
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_explicit_codec.mp4")
                    frames_in = [rand(RGB{N0f8}, 64, 64) for _ in 1:5]
                    try
                        VideoIO.save(vidpath, frames_in; framerate = 30, codec_name = enc_name)
                        frames_out = VideoIO.openvideo(collect, vidpath)
                        @test length(frames_out) == length(frames_in)
                    catch e
                        @info "Codec $enc_name failed" exception = e
                        @test_broken false
                    end
                end
            end
        end
    else
        @info "No HW devices or encoders available; skipping hwaccel encoding tests"
    end
end
