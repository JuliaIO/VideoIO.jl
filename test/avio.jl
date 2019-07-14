using Test
using ColorTypes, FileIO, ImageCore, ImageMagick, Dates, Statistics
using Statistics, StatsBase

import VideoIO

createmode = false

testdir = dirname(@__FILE__)
videodir = joinpath(testdir, "..", "videos")

VideoIO.TestVideos.available()
VideoIO.TestVideos.download_all()

swapext(f, new_ext) = "$(splitext(f)[1])$new_ext"

isarm() = Base.Sys.ARCH in (:arm,:arm32,:arm7l,:armv7l,:arm8l,:armv8l,:aarch64,:arm64)

#@show Base.Sys.ARCH

@noinline function isblank(img)
    all(c->green(c) == 0, img) || all(c->blue(c) == 0, img) || all(c->red(c) == 0, img) || maximum(rawview(channelview(img))) < 0xcf
end

@testset "UInt8 accuracy during read & encode" begin
    # Test that reading truth video has one of each UInt8 value pixels (16x16 frames = 256 pixels)
    f = VideoIO.openvideo(joinpath(testdir,"precisiontest_gray_truth.mp4"),target_format=VideoIO.AV_PIX_FMT_GRAY8)
    frame_truth = collect(rawview(channelview(read(f))))
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
    VideoIO.encodevideo(joinpath(testdir,"precisiontest_gray_test.mp4"), imgstack,
    AVCodecContextProperties = props,silent=true)
    f = VideoIO.openvideo(joinpath(testdir,"precisiontest_gray_test.mp4"),
    target_format=VideoIO.AV_PIX_FMT_GRAY8)
    frame_test = collect(rawview(channelview(read(f))))
    h_test = fit(Histogram, frame_test[:], 0:256)
    @test h_test.weights == fill(1,256) #Test that encoding is precise (if above passes)
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
    end
    @testset "Frame order when encoding, then reading video" begin
        # Test that writing and reading a video with frame-incremental pixel values is read in in-order
        imgstack = []
        img = Array{UInt8}(undef,16,16)
        for i in 0:255
            push!(imgstack,fill(UInt8(i),(16,16)))
        end
        props = [:color_range=>2, :priv_data => ("crf"=>"0","preset"=>"medium")]
        VideoIO.encodevideo(joinpath(testdir,"ordertest_gray_test.mp4"), imgstack,
        AVCodecContextProperties = props,silent=true)
        f = VideoIO.openvideo(joinpath(testdir,"ordertest_gray_test.mp4"),
        target_format=VideoIO.AV_PIX_FMT_GRAY8)
        frame_ids_test = []
        while !eof(f)
            img = collect(rawview(channelview(read(f))))
            push!(frame_ids_test,img[1,1])
        end
        @test frame_ids_test == collect(0:255) #Test that reading is in correct frame order
    end
end

@testset "Reading of various example file formats" begin
    for name in VideoIO.TestVideos.names()
        @testset "Reading $name" begin
            first_frame_file = joinpath(testdir, swapext(name, ".png"))
            !createmode && (first_frame = load(first_frame_file))

            f = VideoIO.testvideo(name)
            v = VideoIO.openvideo(f)

            if !createmode && (size(first_frame, 1) > v.height)
                first_frame = first_frame[1+size(first_frame,1)-v.height:end,:]
            end

            # Find the first non-trivial image
            img = read(v)
            i=1
            while isblank(img)
                read!(v, img)
                i += 1
            end
            # println("$name vs. $first_frame_file - First non-blank frame: $i") # for debugging
            createmode && save(first_frame_file,img)
            if isarm()
                !createmode && (@test_skip img == first_frame)
            else
                !createmode && (@test img == first_frame)
            end

            for i in 1:50
                read!(v,img)
            end
            fiftieth_frame = img
            timebase = v.avin.video_info[1].stream.time_base
            tstamp = v.aVideoFrame[1].pkt_dts
            video_tstamp = v.avin.video_info[1].stream.first_dts
            fiftytime = (tstamp-video_tstamp)/(convert(Float64,timebase.den)/convert(Float64,timebase.num))

            while !eof(v)
                read!(v, img)
            end

            seek(v,float(fiftytime))
            read!(v,img)

            @test img == fiftieth_frame

            # read first frames again, and compare
            seekstart(v)

            read!(v, img)

            while isblank(img)
                read!(v, img)
            end

            if isarm()
                !createmode && (@test_skip img == first_frame)
            else
                !createmode && (@test img == first_frame)
            end

            close(v)
        end
    end
end

@testset "IO reading of various example file formats" begin
    for name in VideoIO.TestVideos.names()
        # TODO: fix me?
        (startswith(name, "ladybird") || startswith(name, "NPS")) && continue
        @testset "Testing $name" begin
            first_frame_file = joinpath(testdir, swapext(name, ".png"))
            first_frame = load(first_frame_file)

            filename = joinpath(videodir, name)
            v = VideoIO.openvideo(open(filename))

            if size(first_frame, 1) > v.height
                first_frame = first_frame[1+size(first_frame,1)-v.height:end,:]
            end
            img = read(v)
            # Find the first non-trivial image
            while isblank(img)
                read!(v, img)
            end

            if isarm()
                @test_skip img == first_frame
            else
                @test img == first_frame
            end
            while !eof(v)
                read!(v, img)
            end
        end
    end

    VideoIO.testvideo("ladybird") # coverage testing
    @test_throws ErrorException VideoIO.testvideo("rickroll")
    @test_throws ErrorException VideoIO.testvideo("")
end

@testset "Reading video duration, start date, and duration" begin
    # tesing the duration and date & time functions:
    file = joinpath(videodir, "annie_oakley.ogg")
    @test VideoIO.get_duration(file) == Dates.Microsecond(24224200)
    @test VideoIO.get_start_time(file) == DateTime(1970, 1, 1)
    @test VideoIO.get_time_duration(file) == (DateTime(1970, 1, 1), Dates.Microsecond(24224200))
end

@testset "Lossless video encoding (read, encode, read, compare)" begin
    file = joinpath(videodir, "annie_oakley.ogg")
    f = VideoIO.openvideo(file)
    imgstack_rgb = []
    imgstack_gray = []
    while !eof(f)
        img = collect(read(f))
        img_gray = convert(Array{Gray{N0f8}},img)
        push!(imgstack_rgb,img)
        push!(imgstack_gray,img_gray)
    end
    @testset "Lossless Grayscale encoding" begin
        file_lossless_gray_copy = joinpath(videodir, "annie_oakley_lossless_gray.mp4")
        prop = [:color_range=>2, :priv_data => ("crf"=>"0","preset"=>"medium")]
        codec_name="libx264"
        VideoIO.encodevideo(file_lossless_gray_copy,imgstack_gray,codec_name=codec_name,AVCodecContextProperties=prop, silent=true)

        fcopy = VideoIO.openvideo(file_lossless_gray_copy,target_format=VideoIO.AV_PIX_FMT_GRAY8)
        imgstack_gray_copy = []
        while !eof(fcopy)
            push!(imgstack_gray_copy,collect(read(fcopy)))
        end
        close(f)
        @test eltype(imgstack_gray) == eltype(imgstack_gray_copy)
        @test length(imgstack_gray) == length(imgstack_gray_copy)
        @test size(imgstack_gray[1]) == size(imgstack_gray_copy[1])
        @test !any(.!(imgstack_gray .== imgstack_gray_copy))
    end

    @testset "Lossless RGB encoding" begin
        file_lossless_rgb_copy = joinpath(videodir, "annie_oakley_lossless_rgb.mp4")
        prop = [:priv_data => ("crf"=>"0","preset"=>"medium")]
        codec_name="libx264rgb"
        VideoIO.encodevideo(file_lossless_rgb_copy,imgstack_rgb,codec_name=codec_name,AVCodecContextProperties=prop, silent=true)

        fcopy = VideoIO.openvideo(file_lossless_rgb_copy)
        imgstack_rgb_copy = []
        while !eof(fcopy)
            img = collect(read(fcopy))
            push!(imgstack_rgb_copy,img)
        end
        close(f)
        @test eltype(imgstack_rgb) == eltype(imgstack_rgb_copy)
        @test length(imgstack_rgb) == length(imgstack_rgb_copy)
        @test size(imgstack_rgb[1]) == size(imgstack_rgb_copy[1])
        @test !any(.!(imgstack_rgb .== imgstack_rgb_copy))
    end
end

@testset "Storage Aspect Ratio: SAR" begin
    # currently, the SAR of all the test videos is 1, we should get another video with a valid SAR that is not equal to 1
    vids = Dict("ladybird.mp4" => 1, "black_hole.webm" => 1, "crescent-moon.ogv" => 1, "annie_oakley.ogg" => 1)
    @test all(VideoIO.aspect_ratio(VideoIO.openvideo(joinpath(videodir, k))) == v for (k,v) in vids)
end

#VideoIO.TestVideos.remove_all()
