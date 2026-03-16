@testset "Hardware acceleration" begin
    hw_devs = VideoIO.available_hw_devices()
    @info "Available HW device types (compile-time)" hw_devs

    @testset "available_hw_devices returns a Vector{Symbol}" begin
        @test hw_devs isa Vector{Symbol}
    end

    @testset "hwaccel_available" begin
        @test VideoIO.hwaccel_available(:not_a_real_device) == false
        for dev in hw_devs
            @test VideoIO.hwaccel_available(dev) isa Bool
        end
    end

    # Filter to devices that are actually functional on this machine
    working_hw_devs = filter(VideoIO.hwaccel_available, hw_devs)
    @info "Functional HW device types (runtime)" working_hw_devs

    if isempty(working_hw_devs)
        @info "No functional hardware devices on this platform; skipping hwaccel decode tests"
    else
        for dev in working_hw_devs
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
                h, w = 64, 64
                frame = zeros(RGB{N0f8}, h, w)
                frame[1:h÷2, :] .= RGB{N0f8}(1, 0, 0)
                frame[h÷2+1:end, :] .= RGB{N0f8}(0, 1, 0)
                frames_in = [frame for _ in 1:5]

                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_content_test.mp4")
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
                        @test true
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

            # This exercises the AVFramePtr graph path where input_pix_fmt must be
            # updated from the actual downloaded frame format (not the heuristic guess).
            @testset "hwaccel = :$dev transcode=false raw interface" begin
                frames_in = [rand(RGB{N0f8}, 64, 64) for _ in 1:5]
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_raw_test.mp4")
                    VideoIO.save(vidpath, frames_in; framerate = 30)
                    VideoIO.openvideo(vidpath; hwaccel = dev, transcode = false) do r
                        # Read one frame to trigger the lazy format correction.
                        buf, align = VideoIO.read_raw(r)
                        # After reading, raw_pixel_format should be a known valid format
                        # (not a stale heuristic that differs from the actual frame).
                        fmt = VideoIO.raw_pixel_format(r)
                        @test fmt >= 0
                        # out_bytes_size must be consistent with the actual buffer returned.
                        @test length(buf) == VideoIO.out_bytes_size(r, align)
                        # Subsequent reads should succeed without error.
                        while !eof(r)
                            VideoIO.read_raw(r)
                        end
                        @test true
                    end
                end
            end

            # This exercises the _vio_rebuild_sws_for_hw! path that reads back destination
            # colorspace info from fg.dstframe rather than re-deriving defaults.
            @testset "hwaccel = :$dev with explicit target_colorspace_details" begin
                frames_in = [rand(RGB{N0f8}, 64, 64) for _ in 1:5]
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_cs_test.mp4")
                    # Encode full-range to ensure VT may produce YUVJ420P on download,
                    # exercising the lazy sws rebuild on first frame.
                    VideoIO.save(vidpath, frames_in;
                        framerate = 30,
                        encoder_options = (color_range = 2, crf = 0, preset = "ultrafast"))
                    # Use VioColorspaceDetails() (all-unspecified, FFmpeg defaults) —
                    # a distinctly non-default colorspace descriptor.
                    VideoIO.openvideo(vidpath;
                        hwaccel = dev,
                        target_colorspace_details = VideoIO.VioColorspaceDetails()) do r
                        @test VideoIO.out_frame_eltype(r) == RGB{N0f8}
                        frames_out = collect(r)
                        @test length(frames_out) == length(frames_in)
                        @test size(frames_out[1]) == size(frames_in[1])
                    end
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

    if !isempty(working_hw_devs) && !isempty(hw_encoders)
        for dev in working_hw_devs
            @testset "hwaccel = :$dev encoding" begin
                frames_in = [rand(RGB{N0f8}, 64, 64) for _ in 1:10]
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_enc_test.mp4")
                    try
                        VideoIO.save(vidpath, frames_in; framerate = 30, hwaccel = dev)
                    catch e
                        @info "HW encoding with :$dev not supported for this codec/platform" exception = e
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
                        return
                    end
                    frames_hw = VideoIO.openvideo(collect, vidpath; hwaccel = dev)
                    @test length(frames_hw) == length(frames_in)
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
            dev = first(working_hw_devs)
            # ProRes requires a .mov container; H.264/HEVC work with .mp4.
            # HEVC VideoToolbox also requires at least 128×128.
            container_for_codec = Dict(
                "prores_videotoolbox" => "mov",
            )
            for enc_name in hw_encoders
                ext = get(container_for_codec, enc_name, "mp4")
                mktempdir() do dir
                    vidpath = joinpath(dir, "hw_explicit_codec.$ext")
                    # 128×128 satisfies the minimum-dimension requirements of all
                    # VideoToolbox codecs (hevc_videotoolbox requires ≥128×128).
                    frames_in = [rand(RGB{N0f8}, 128, 128) for _ in 1:5]
                    try
                        # hwaccel + codec_name: device context is set up so that the
                        # HW encoder can accept SW (YUV/RGB) input frames directly.
                        VideoIO.save(vidpath, frames_in; framerate = 30,
                            codec_name = enc_name, hwaccel = dev)
                        frames_out = VideoIO.openvideo(collect, vidpath)
                        @test length(frames_out) == length(frames_in)
                        @test size(frames_out[1]) == size(frames_in[1])
                    catch e
                        @info "Codec $enc_name failed" exception = e
                    end
                end
            end
        end
    else
        @info "No functional HW devices or encoders available; skipping hwaccel encoding tests"
    end
end
