@testset "Encoding video across all supported colortypes" begin
    for el in [UInt8, RGB{N0f8}]
        @testset "Encoding $el imagestack" begin
            n = 100
            imgstack = map(x->rand(el,100,100),1:n)
            encoder_settings = (priv_data = (crf="23", preset="medium"))
            VideoIO.encode_mux_video(tempvidpath, imgstack, framerate = 30, encoder_settings = encoder_settings)
            @test stat(tempvidpath).size > 100
            @test_broken VideoIO.openvideo(VideoIO.counttotalframes, tempvidpath) == n
        end
    end
end

@testset "Simultaneous encoding and muxing" begin
    n = 100
    encoder_settings = (color_range = 2,)
    container_private_settings = (movflags = "+write_colr",)
    for el in [Gray{N0f8}, Gray{N6f10}, RGB{N0f8}, RGB{N6f10}]
        for scanline_arg in [true, false]
            @testset "Encoding $el imagestack, scanline_major = $scanline_arg" begin
                img_stack = map(x -> rand(el, 100, 100), 1 : n)
                lossless = el <: Gray
                crf = lossless ? 0 : 23
                encoder_private_settings = (crf = crf, preset = "medium")
                VideoIO.encode_mux_video(tempvidpath,
                                         img_stack;
                                         encoder_private_settings = encoder_private_settings,
                                         encoder_settings = encoder_settings,
                                         container_private_settings = container_private_settings,
                                         scanline_major = scanline_arg)
                @test stat(tempvidpath).size > 100
                f = VideoIO.openvideo(tempvidpath, target_format =
                                      VideoIO.get_transfer_pix_fmt(el))
                try
                    if lossless
                        notempty = !eof(f)
                        @test notempty
                        if notempty
                            img = read(f)
                            test_img = scanline_arg ? parent(img) : img
                            i = 1
                            if el == Gray{N0f8}
                                @test test_img == img_stack[i]
                            else
                                @test_broken test_img == img_stack[i]
                            end
                            while !eof(f) && i < n
                                read!(f, img)
                                i += 1
                                if el == Gray{N0f8}
                                    @test test_img == img_stack[i]
                                else
                                    @test_broken test_img == img_stack[i]
                                end
                            end
                            @test i == n
                        end
                    else
                        @test VideoIO.counttotalframes(f) == n
                    end
                finally
                    close(f)
                end
            end
        end
    end
end

@testset "Monochrome rescaling" begin
    nw = nh = 100
    s = VideoIO.GrayTransform()
    s.srcframe.color_range = VideoIO.AVCOL_RANGE_JPEG
    s.dstframe.color_range = VideoIO.AVCOL_RANGE_MPEG
    s.srcframe.format = VideoIO.AV_PIX_FMT_GRAY8
    s.dstframe.format = VideoIO.AV_PIX_FMT_GRAY8
    s.src_depth = s.dst_depth = 8
    f, src_t, dst_t = VideoIO.make_scale_function(s)
    @test f(0x00) == 16
    @test f(0xff) == 235
    s.srcframe.format = s.dstframe.format = VideoIO.AV_PIX_FMT_GRAY10LE
    s.src_depth = s.dst_depth = 10
    f, src_t, dst_t = VideoIO.make_scale_function(s)
    @test f(0x0000) == 64
    @test f(UInt16(1023)) == 940

    # Test that range conversion is working properly
    img_full_range = reinterpret(UInt16, test_tone(N6f10, nw, nh))
    writer = VideoIO.open_video_out(tempvidpath, img_full_range;
                                    target_pix_fmt = VideoIO.AV_PIX_FMT_GRAY10LE,
                                    scanline_major = true)
    @test VideoIO.get_codec_name(writer) != "None"
    try
        VideoIO.append_encode_mux!(writer, img_full_range, 0)
        bwidth = nw * 2
        buff = Vector{UInt8}(undef, bwidth * nh)
        # Input frame should be full range
        copy_imgbuf_to_buf!(buff, bwidth, nh, writer.frame_graph.srcframe.data[1],
                            writer.frame_graph.srcframe.linesize[1])
        raw_vals = reinterpret(UInt16, buff)
        @test extrema(raw_vals) == (0x0000, 0x03ff)
        # Output frame should be limited range
        copy_imgbuf_to_buf!(buff, bwidth, nh, writer.frame_graph.dstframe.data[1],
                            writer.frame_graph.dstframe.linesize[1])

        @test extrema(raw_vals) == (0x0040, 0x03ac)
    finally
        VideoIO.close_video_out!(writer)
    end
    @test_throws ErrorException VideoIO.append_encode_mux!(writer, img_full_range, 0)
end

@testset "Encoding monochrome videos" begin
    encoder_private_settings = (crf = 0, preset = "fast")
    nw = nh = 100
    nf = 5
    for elt in (N0f8, N6f10)
        if elt == N0f8
            limited_min = 16
            limited_max = 235
            full_min = 0
            full_max = 255
            target_fmt  = VideoIO.AV_PIX_FMT_GRAY8
        else
            limited_min = 64
            limited_max = 940
            full_min = 0
            full_max = 1023
            target_fmt  = VideoIO.AV_PIX_FMT_GRAY10LE
        end
        img_stack_full_range = make_test_tones(elt, nw, nh, nf)
        # Test that full-range input is automatically converted to limited range
        VideoIO.encode_mux_video(tempvidpath, img_stack_full_range,
                                 target_pix_fmt = target_fmt,
                                 encoder_private_settings =
                                 encoder_private_settings)

        minp, maxp = get_raw_luma_extrema(elt, tempvidpath, nw, nh)
        @test minp > full_min
        @test maxp < full_max

        # Test that this conversion is NOT done if output video is full range
        VideoIO.encode_mux_video(tempvidpath, img_stack_full_range,
                                 target_pix_fmt = target_fmt,
                                 encoder_private_settings =
                                 encoder_private_settings,
                                 encoder_settings = (color_range = 2,))
        minp, maxp = get_raw_luma_extrema(elt, tempvidpath, nw, nh)
        @test minp == full_min
        @test maxp == full_max

        # Test that you can override this automatic conversion when writing videos
        img_stack_limited_range = make_test_tones(elt, nw, nh, nf,
                                                   limited_min,
                                                   limited_max)
        VideoIO.encode_mux_video(tempvidpath, img_stack_limited_range,
                                 target_pix_fmt = target_fmt,
                                 encoder_private_settings =
                                 encoder_private_settings,
                                 input_colorspace_details =
                                 VideoIO.VioColorspaceDetails())
        minp, maxp = get_raw_luma_extrema(elt, tempvidpath, nw, nh)
        @test minp > full_min # Actual N6f10 values are messed up during encoding
        @test maxp < full_max # Actual N6f10 values are messed up during encoding
    end
end

@testset "Encoding video with rational frame rates" begin
    n = 100
    fr = 59 // 2 # 29.5
    target_dur = 3.39
    @testset "Encoding with frame rate $(float(fr))" begin
        imgstack = map(x->rand(UInt8,100,100),1:n)
        encoder_settings = (priv_data = (crf="22", preset="medium"))
        VideoIO.encode_mux_video(tempvidpath, imgstack, framerate = fr, encoder_settings = encoder_settings)
        @test stat(tempvidpath).size > 100
        measured_dur_str = VideoIO.FFMPEG.exe(`-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $(tempvidpath)`, command = VideoIO.FFMPEG.ffprobe, collect = true)
        @test parse(Float64, measured_dur_str[1]) == target_dur
    end
end

@testset "Encoding video with float frame rates" begin
    n = 100
    fr = 29.5 # 59 // 2
    target_dur = 3.39
    @testset "Encoding with frame rate $(float(fr))" begin
        imgstack = map(x->rand(UInt8,100,100),1:n)
        encoder_settings = (priv_data = (crf="22", preset="medium"))
        VideoIO.encode_mux_video(tempvidpath, imgstack, framerate = fr, encoder_settings = encoder_settings)
        @test stat(tempvidpath).size > 100
        measured_dur_str = VideoIO.FFMPEG.exe(`-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $(tempvidpath)`, command = VideoIO.FFMPEG.ffprobe, collect = true)
        @test parse(Float64, measured_dur_str[1]) == target_dur
    end
end