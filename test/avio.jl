using Test
using ColorTypes: RGB, Gray, N0f8, red, green, blue
import ColorVectorSpace
using FileIO, ImageCore, Dates, Statistics, StatsBase

import FFMPEG

import VideoIO

const testdir = dirname(@__FILE__)
const videodir = joinpath(testdir, "..", "videos")
const tempvidname = "testvideo.mp4"
const tempvidpath = joinpath(tempdir(), tempvidname)
const required_accuracy = 0.07

VideoIO.TestVideos.available()
VideoIO.TestVideos.download_all()

include("test_tones.jl") # Testing utility functions

swapext(f, new_ext) = "$(splitext(f)[1])$new_ext"

isarm() = Base.Sys.ARCH in (:arm,:arm32,:arm7l,:armv7l,:arm8l,:armv8l,:aarch64,:arm64)

#@show Base.Sys.ARCH

@noinline function isblank(img)
    all(c->green(c) == 0, img) || all(c->blue(c) == 0, img) || all(c->red(c) == 0, img) || maximum(rawview(channelview(img))) < 0xcf
end

function compare_colors(a::RGB, b::RGB, tol)
    ok = true
    for f in (red, green, blue)
        ok &= abs(float(f(a)) - float(f(b))) <= tol
    end
    ok
end

# Helper functions
function test_compare_frames(test_frame, ref_frame, tol = 0.05)
    if isarm()
        @test_skip test_frame == ref_frame
    else
        frames_similar = true
        for (a, b) in zip(test_frame, ref_frame)
            frames_similar &= compare_colors(a, b, tol)
        end
        @test frames_similar
    end
end

# uses read!
function read_frameno!(img, v, frameno)
    seekstart(v)
    i = 0
    while !eof(v) && i < frameno
        read!(v, img)
        i += 1
    end
end

function make_comparison_frame_png(vidpath::AbstractString, frameno::Integer,
                                   writedir = tempdir())
    vid_basename = first(splitext(basename(vidpath)))
    png_name = joinpath(writedir, "$(vid_basename)_$(frameno).png")
    FFMPEG.exe(`-y -v error -i $(vidpath) -vf "select=eq(n\,$(frameno-1))" -vframes 1 $(png_name)`)
    png_name
end

function make_comparison_frame_png(f, args...)
    png_name = make_comparison_frame_png(args...)
    try
        f(png_name)
    finally
        rm(png_name, force = true)
    end
end

function get_video_extrema(v)
    img = read(v)
    raw_img = parent(img)
    # Test that the limited range of this video is converted to full range
    minp, maxp = extrema(raw_img)
    while !eof(v)
        read!(v, raw_img)
        this_minp, this_maxp = extrema(raw_img)
        minp = min(minp, this_minp)
        maxp = max(maxp, this_maxp)
    end
    return minp, maxp
end

function get_raw_luma_extrema(elt, vidpath, nw, nh)
    buff, align = VideoIO.openvideo(vidpath) do v
        VideoIO.read_raw(v, 1)
    end
    luma_buff = view(buff, 1 : nw * nh * sizeof(elt))
    luma_vals = reinterpret(elt, luma_buff)
    reinterpret.(extrema(luma_vals))
end

include("avptr.jl")

@testset "Reading of various example file formats" begin
    for testvid in values(VideoIO.TestVideos.videofiles)
        name = testvid.name
        test_frameno = testvid.testframe
        @testset "Reading $(testvid.name)" begin
            testvid_path = joinpath(@__DIR__, "../videos", name)
            comparison_frame = make_comparison_frame_png(load, testvid_path, test_frameno)
            f = VideoIO.testvideo(testvid_path)
            v = VideoIO.openvideo(f)
            try
                time_seconds = VideoIO.gettime(v)
                @test time_seconds == 0
                width, height = VideoIO.out_frame_size(v)
                if size(comparison_frame, 1) > height
                    trimmed_comparison_frame =
                        comparison_frame[1+size(comparison_frame,1)-height:end,:]
                else
                    trimmed_comparison_frame = comparison_frame
                end

                # Find the first non-trivial image
                first_img = read(v)
                first_time = VideoIO.gettime(v)
                seekstart(v)
                img = read(v)
                @test VideoIO.gettime(v) == first_time
                @test img == first_img
                @test size(img) == VideoIO.out_frame_size(v)[[2, 1]]
                # no scaling currently
                @test VideoIO.out_frame_size(v) == VideoIO.raw_frame_size(v)
                @test VideoIO.raw_pixel_format(v) == 0 # true for current test videos
                i=1
                while i < test_frameno
                    read!(v, img)
                    i += 1
                end
                test_compare_frames(img, trimmed_comparison_frame, required_accuracy)
                test_time = VideoIO.gettime(v)
                seek(v, test_time)
                raw_img = parent(img)
                read!(v, raw_img) # VideoReader should accept scanline-major images
                test_compare_frames(img, trimmed_comparison_frame, required_accuracy)
                @test VideoIO.gettime(v) == test_time
                if size(img, 1) != size(img, 2)
                    # Passing an arrray that is not scanline-major does not work
                    @test_throws ArgumentError read!(v, similar(img))
                    @test VideoIO.gettime(v) == test_time
                end
                @test_throws(ArgumentError,
                             read!(v, similar(raw_img, size(raw_img) .- 1)))
                @test_throws MethodError read!(v, similar(raw_img, Rational{Int}))
                @test_throws ArgumentError read!(v, similar(raw_img, Gray{N0f8}))
                @test VideoIO.gettime(v) == test_time

                seekstart(v)
                for i in 1:50
                    read!(v,img)
                end
                fiftieth_frame = copy(img)
                fiftytime = VideoIO.gettime(v)

                while !eof(v)
                    read!(v, img)
                end

                seek(v,fiftytime)
                read!(v,img)

                @test img == fiftieth_frame

                seekstart(v)
                start_t = VideoIO.gettime(v)
                @test start_t <= 0
                buff, align = VideoIO.read_raw(v, 1)
                @test VideoIO.out_bytes_size(v) == length(buff)
                @test align == 1
                buff_bak = copy(buff)
                seekstart(v)
                VideoIO.read_raw!(v, buff, 1)
                last_time = VideoIO.gettime(v)
                @test buff == buff_bak
                @test_throws(ArgumentError,
                             VideoIO.read_raw!(v, similar(buff, size(buff) .- 1)))
                @test_throws MethodError VideoIO.read_raw!(v, similar(buff, Int))
                @test VideoIO.gettime(v) == last_time
                notranscode_buff = VideoIO.openvideo(read, testvid_path,
                                                     transcode = false)
                @test notranscode_buff == buff_bak

                # read first frames again, and compare
                read_frameno!(img, v, test_frameno)
                test_compare_frames(img, trimmed_comparison_frame, required_accuracy)

                # make sure read! works with both PermutedDimsArray and Array
                # The above tests already use read! for PermutedDimsArray,
                # so just test the type of img
                @test typeof(img) <: PermutedDimsArray

                img_p = parent(img)
                @assert typeof(img_p) <: Array
                # img is a view of img_p, so calling read! on img_p should alter img
                #
                # first, zero img out to be sure we get the desired result from
                # calls to read on img_p!
                fill!(img, zero(eltype(img)))
                # Then get the first frame, which uses read!
                read_frameno!(img_p, v, test_frameno)
                # Finally compare the result to make sure it's right
                test_compare_frames(img, trimmed_comparison_frame, required_accuracy)

                # Skipping & frame counting
                VideoIO.seekstart(v)
                VideoIO.skipframe(v)
                VideoIO.skipframes(v, 10)
                @test VideoIO.counttotalframes(v) ==
                    VideoIO.TestVideos.videofiles[name].numframes
            finally
                close(f)
            end
        end
    end
end

@testset "Reading monochrome videos" begin
    testvid = first(values(VideoIO.TestVideos.videofiles))
    testvid_path = joinpath(@__DIR__, "../videos", testvid.name)
    # Test that limited range YCbCr values are translated to "full range"
    minp, maxp = VideoIO.openvideo(get_video_extrema, testvid_path,
                                   target_format = VideoIO.AV_PIX_FMT_GRAY8)
    @test typeof(minp) == Gray{N0f8}
    @test minp.val.i < 16
    @test maxp.val.i > 235
    # Disable automatic rescaling
    minp, maxp = VideoIO.openvideo(get_video_extrema, testvid_path,
                                   target_format = VideoIO.AV_PIX_FMT_GRAY8,
                                   target_colorspace_details =
                                   VideoIO.VioColorspaceDetails())
    @test minp.val.i >= 16
    @test maxp.val.i <= 235
end

@testset "IO reading of various example file formats" begin
    for testvid in values(VideoIO.TestVideos.videofiles)
        name = testvid.name
        test_frameno = testvid.testframe
        # TODO: fix me?
        (startswith(name, "ladybird") || startswith(name, "NPS")) && continue
        @testset "Testing $name" begin
            testvid_path = joinpath(@__DIR__, "../videos", name)
            comparison_frame = make_comparison_frame_png(load, testvid_path, test_frameno)
            filename = joinpath(videodir, name)
            v = VideoIO.openvideo(filename)
            try
                width, height = VideoIO.out_frame_size(v)
                if size(comparison_frame, 1) > height
                    trimmed_comparison_frame =
                        comparison_frame[1+size(comparison_frame,1)-height:end,:]
                else
                    trimmed_comparison_frame = comparison_frame
                end
                img = read(v)
                i=1
                while i < test_frameno
                    read!(v, img)
                    i += 1
                end
                test_compare_frames(img, trimmed_comparison_frame,
                                    required_accuracy)
                while !eof(v)
                    read!(v, img)
                end

                # Iterator interface
                VT = typeof(v)
                @test Base.IteratorSize(VT) === Base.SizeUnknown()
                @test Base.IteratorEltype(VT) === Base.EltypeUnknown()

                VideoIO.seekstart(v)
                i = 0
                local first_frame
                local last_frame
                for frame in v
                    i += 1
                    if i == 1
                        first_frame = frame
                    end
                    last_frame = frame
                end
                @test i == VideoIO.TestVideos.videofiles[name].numframes
                # test that the frames returned by the iterator have distinct storage
                if i > 1
                    @test first_frame !== last_frame
                end

                ## Test that iterator is mutable, and continues where iteration last
                ## stopped.
                @test iterate(v) === nothing
            finally
                close(v)
            end
        end
    end

    VideoIO.testvideo("ladybird") # coverage testing
    @test_throws ErrorException VideoIO.testvideo("rickroll")
    @test_throws ErrorException VideoIO.testvideo("")
end

@testset "Reading video metadata" begin
    @testset "Reading Storage Aspect Ratio: SAR" begin
        # currently, the SAR of all the test videos is 1, we should get another video with a valid SAR that is not equal to 1
        vids = Dict("ladybird.mp4" => 1, "black_hole.webm" => 1, "crescent-moon.ogv" => 1, "annie_oakley.ogg" => 1)
        @test all(VideoIO.aspect_ratio(VideoIO.openvideo(joinpath(videodir, k))) == v for (k,v) in vids)
    end
    @testset "Reading video duration, start date, and duration" begin
        # tesing the duration and date & time functions:
        file = joinpath(videodir, "annie_oakley.ogg")
        @test VideoIO.get_duration(file) == 24224200/1e6
        @test VideoIO.get_start_time(file) == DateTime(1970, 1, 1)
        @test VideoIO.get_time_duration(file) == (DateTime(1970, 1, 1), 24224200/1e6)
        @test VideoIO.get_number_frames(file) === nothing
    end
    @testset "Reading the number of frames from container" begin
        file = joinpath(videodir, "ladybird.mp4")
        @test VideoIO.get_number_frames(file) == 398
        @test VideoIO.get_number_frames(file, 0) == 398
        @test_throws ArgumentError VideoIO.get_number_frames(file, -1)
        @test_throws ErrorException VideoIO.get_number_frames("Not_a_file")
    end
end


@testset "Encoding video across all supported colortypes" begin
    for el in [UInt8, RGB{N0f8}]
        @testset "Encoding $el imagestack" begin
            n = 100
            imgstack = map(x->rand(el,100,100),1:n)
            props = [:priv_data => ("crf"=>"23", "preset"=>"medium")]
            VideoIO.encodevideo(tempvidpath, imgstack, framerate = 30,
                                AVCodecContextProperties = props, silent = true)
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
                                         encoder_private_settings =
                                         encoder_private_settings,
                                         encoder_settings = encoder_settings,
                                         container_private_settings =
                                         container_private_settings,
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
        props = [:priv_data => ("crf"=>"22","preset"=>"medium")]
        VideoIO.encodevideo(tempvidpath, imgstack, framerate = fr,
                            AVCodecContextProperties = props, silent = true)
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
        props = [:priv_data => ("crf"=>"22","preset"=>"medium")]
        VideoIO.encodevideo(tempvidpath, imgstack, framerate = fr,
                            AVCodecContextProperties = props, silent = true)
        @test stat(tempvidpath).size > 100
        measured_dur_str = VideoIO.FFMPEG.exe(`-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $(tempvidpath)`, command = VideoIO.FFMPEG.ffprobe, collect = true)
        @test parse(Float64, measured_dur_str[1]) == target_dur
    end
end

@testset "Video encode/decode accuracy (read, encode, read, compare)" begin
    file = joinpath(videodir, "annie_oakley.ogg")
    imgstack_rgb = VideoIO.openvideo(collect, file)
    imgstack_gray = convert.(Array{Gray{N0f8}}, imgstack_rgb)
    @testset "Lossless Grayscale encoding" begin
        prop = [:color_range=>2, :priv_data => ("crf"=>"0","preset"=>"medium")]
        codec_name="libx264"
        VideoIO.encodevideo(tempvidpath, imgstack_gray, codec_name = codec_name,
                            AVCodecContextProperties = prop, silent = true)
        imgstack_gray_copy = VideoIO.openvideo(collect, tempvidpath,
                                               target_format = VideoIO.AV_PIX_FMT_GRAY8)
        @test eltype(eltype(imgstack_gray)) == eltype(eltype(imgstack_gray_copy))
        @test length(imgstack_gray) == length(imgstack_gray_copy)
        @test size(imgstack_gray[1]) == size(imgstack_gray_copy[1])
        @test !any(.!(imgstack_gray .== imgstack_gray_copy))
    end

    @testset "Lossless RGB encoding" begin
        prop = [:priv_data => ("crf"=>"0","preset"=>"medium")]
        codec_name="libx264rgb"
        VideoIO.encodevideo(tempvidpath, imgstack_rgb, codec_name = codec_name,
                            AVCodecContextProperties = prop, silent = true)
        imgstack_rgb_copy = VideoIO.openvideo(collect, tempvidpath)
        @test eltype(imgstack_rgb) == eltype(imgstack_rgb_copy)
        @test length(imgstack_rgb) == length(imgstack_rgb_copy)
        @test size(imgstack_rgb[1]) == size(imgstack_rgb_copy[1])
        @test !any(.!(imgstack_rgb .== imgstack_rgb_copy))
    end

    @testset "UInt8 accuracy during read & lossless encode" begin
        # Test that reading truth video has one of each UInt8 value pixels (16x16 frames = 256 pixels)
        raw_img = VideoIO.openvideo(read,
                                    joinpath(testdir, "precisiontest_gray_truth.mp4"),
                                    target_format = VideoIO.AV_PIX_FMT_GRAY8)
        frame_truth = collect(rawview(channelview(raw_img)))
        h_truth = fit(Histogram, frame_truth[:], 0:256)
        @test h_truth.weights == fill(1,256) #Test that reading is precise

        # Test that encoding new test video has one of each UInt8 value pixels (16x16 frames = 256 pixels)
        img = Array{UInt8}(undef,16,16)
        for i in 1:256
            img[i] = UInt8(i-1)
        end
        imgstack = []
        for i=1:24
            push!(imgstack,img)
        end
        props = [:color_range=>2, :priv_data => ("crf"=>"0","preset"=>"medium")]
        VideoIO.encodevideo(tempvidpath, imgstack,
                            AVCodecContextProperties = props, silent = true)
        f = VideoIO.openvideo(tempvidpath,
                              target_format = VideoIO.AV_PIX_FMT_GRAY8)
        try
            frame_test = collect(rawview(channelview(read(f))))
            h_test = fit(Histogram, frame_test[:], 0:256)
            @test h_test.weights == fill(1,256) #Test that encoding is precise (if above passes)
            @test VideoIO.counttotalframes(f) == 24
        finally
            close(f)
        end
    end

    @testset "Correct frame order when reading & encoding" begin
        @testset "Frame order when reading ground truth video" begin
            # Test that reading a video with frame-incremental pixel values is read in in-order
            f = VideoIO.openvideo(joinpath(testdir,"ordertest_gray_truth.mp4"),target_format=VideoIO.AV_PIX_FMT_GRAY8)
            frame_ids_truth = []
            while !eof(f)
                img = collect(rawview(channelview(read(f))))
                push!(frame_ids_truth,img[1,1])
            end
            @test frame_ids_truth == collect(0:255) #Test that reading is in correct frame order
            @test VideoIO.counttotalframes(f) == 256
        end
        @testset "Frame order when encoding, then reading video" begin
            # Test that writing and reading a video with frame-incremental pixel values is read in in-order
            imgstack = []
            img = Array{UInt8}(undef,16,16)
            for i in 0:255
                push!(imgstack,fill(UInt8(i),(16,16)))
            end
            props = [:color_range=>2, :priv_data => ("crf"=>"0","preset"=>"medium")]
            VideoIO.encodevideo(tempvidpath, imgstack,
                                AVCodecContextProperties = props, silent = true)
            f = VideoIO.openvideo(tempvidpath,
                                  target_format = VideoIO.AV_PIX_FMT_GRAY8)
            try
                frame_ids_test = []
                while !eof(f)
                    img = collect(rawview(channelview(read(f))))
                    push!(frame_ids_test,img[1,1])
                end
                @test frame_ids_test == collect(0:255) #Test that reading is in correct frame order
                @test VideoIO.counttotalframes(f) == 256
            finally
                close(f)
            end
        end
    end
end

GC.gc()
rm(tempvidpath, force = true)

@testset "c api memory leak test" begin # Issue https://github.com/JuliaIO/VideoIO.jl/issues/246

    if(Sys.islinux())  # TODO: find a method to get cross platform memory usage, see: https://discourse.julialang.org/t/how-to-get-current-julia-process-memory-usage/41734/4

        function get_memory_usage()
            open("/proc/$(getpid())/statm") do io
                split(read(io, String))[1]
            end
        end

        file = joinpath(videodir, "annie_oakley.ogg")

        @testset "open file test" begin
            check_size = 10
            usage_vec = Vector{String}(undef, check_size)

            for i in 1:check_size

                f = VideoIO.openvideo(file)
                close(f)
                GC.gc()

                usage_vec[i] = get_memory_usage()
            end

            println(usage_vec)

            @test usage_vec[end-1] == usage_vec[end]
        end

        @testset "open and read file test" begin
            check_size = 10
            usage_vec = Vector{String}(undef, check_size)

            for i in 1:check_size

                f = VideoIO.openvideo(file)
                img = read(f)
                close(f)
                GC.gc()

                usage_vec[i] = get_memory_usage()
            end

            println(usage_vec)

            @test usage_vec[end-1] == usage_vec[end]
        end
    end
end



#VideoIO.TestVideos.remove_all()
