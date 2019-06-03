using Test
using ColorTypes, FileIO, ImageCore, ImageMagick, Dates, FixedPointNumbers, Statistics

import VideoIO

testdir = dirname(@__FILE__)
videodir = joinpath(testdir, "..", "videos")

VideoIO.TestVideos.available()
VideoIO.TestVideos.download_all()

swapext(f, new_ext) = "$(splitext(f)[1])$new_ext"

@noinline function isblank(img)
    all(c->green(c) == 0, img) || all(c->blue(c) == 0, img) || all(c->red(c) == 0, img) || maximum(rawview(channelview(img))) < 0xcf
end

# tesing that the executables run by testing the standard first line output
@testset "Executable functionality (ffmpeg & ffprobe)" begin
    withenv(VideoIO.execenv) do
        out = VideoIO.collectexecoutput(`$(VideoIO.ffmpeg)`)
        @test occursin("ffmpeg version ",out[1])
    end
    withenv(VideoIO.execenv) do
        out = VideoIO.collectexecoutput(`$(VideoIO.ffprobe)`)
        @test occursin("ffprobe version ",out[1])
    end
end

@testset "File reading" begin

    for name in VideoIO.TestVideos.names()
        Sys.isapple() && startswith(name, "crescent") && continue
        @testset "Reading $name" begin
            first_frame_file = joinpath(testdir, swapext(name, ".png"))
            fiftieth_frame_file = joinpath(testdir, swapext(name, "")*"50.png")
            first_frame = load(first_frame_file) # comment line when creating png files

            f = VideoIO.testvideo(name)
            v = VideoIO.openvideo(f)

            if size(first_frame, 1) > v.height
                first_frame = first_frame[1+size(first_frame,1)-v.height:end,:]
            end

            img = read(v)

            # Find the first non-trivial image
            while isblank(img)
                read!(v, img)
            end

            #save(first_frame_file,img)        # uncomment line when creating png files)

            @test img == first_frame               # comment line when creating png files
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

            @test img == first_frame

            close(v)
        end
    end
end

@testset "IO reading" begin
    for name in VideoIO.TestVideos.names()
        Sys.isapple() && startswith(name, "crescent") && continue
        # TODO: fix me?
        (startswith(name, "ladybird") || startswith(name, "NPS")) && continue
        @testset "Testing $name" begin
            first_frame_file = joinpath(testdir, swapext(name, ".png"))
            first_frame = load(first_frame_file) # comment line when creating png files

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

            #save(first_frame_file,img)        # uncomment line when creating png files

            @test img == first_frame               # comment line when creating png files

            while !eof(v)
                read!(v, img)
            end
        end
    end

    VideoIO.testvideo("ladybird") # coverage testing
    @test_throws ErrorException VideoIO.testvideo("rickroll")
    @test_throws ErrorException VideoIO.testvideo("")
end

@testset "Reading video duration and date/datetime" begin
    # tesing the duration and date & time functions:
    file = joinpath(videodir, "annie_oakley.ogg")
    @test VideoIO.get_duration(file) == Dates.Microsecond(24224200)
    @test VideoIO.get_start_time(file) == DateTime(1970, 1, 1)
    @test VideoIO.get_time_duration(file) == (DateTime(1970, 1, 1), Dates.Microsecond(24224200))
end

@testset "Video encoding (read, encode, read, compare)" begin
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

#VideoIO.TestVideos.remove_all()
