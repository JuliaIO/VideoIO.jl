using Base.Test
using ColorTypes, FileIO, ImageCore

import VideoIO

testdir = dirname(@__FILE__)
videodir = joinpath(testdir, "..", "videos")

VideoIO.TestVideos.available()
VideoIO.TestVideos.download_all()

swapext(f, new_ext) = "$(splitext(f)[1])$new_ext"

println(STDERR, "Testing file reading...")

@noinline function notblank(img)
    all(c->green(c) == 0, img) || all(c->blue(c) == 0, img) || all(c->red(c) == 0, img) || maximum(rawview(channelview(img))) < 0xcf
end

for name in VideoIO.TestVideos.names()
    is_apple() && startswith(name, "crescent") && continue
    println(STDERR, "   Testing $name...")

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
    while notblank(img)
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

    if (video_tstamp == VideoIO.AV_NOPTS_VALUE ||
        VideoIO._avformat_version().major < 54 ||
        VideoIO.ffmpeg_or_libav == "libav")
        println("Skipping seek tests")
    else

        seek(v,float(fiftytime))
        read!(v,img)

        @test img == fiftieth_frame

        # read first frames again, and compare
        seekstart(v)

        read!(v, img)

        while notblank(img)
            read!(v, img)
        end

        @test img == first_frame
    end

    close(v)
end

println(STDERR, "Testing IO reading...")
for name in VideoIO.TestVideos.names()
    is_apple() && startswith(name, "crescent") && continue
    # TODO: fix me?
    (startswith(name, "ladybird") || startswith(name, "NPS")) && continue

    println(STDERR, "   Testing $name...")
    first_frame_file = joinpath(testdir, swapext(name, ".png"))
    first_frame = load(first_frame_file) # comment line when creating png files

    filename = joinpath(videodir, name)
    v = VideoIO.openvideo(open(filename))

    if size(first_frame, 1) > v.height
        first_frame = first_frame[1+size(first_frame,1)-v.height:end,:]
    end

    img = read(v)

    # Find the first non-trivial image
    while notblank(img)
        read!(v, img)
    end

    #save(first_frame_file,img)        # uncomment line when creating png files

    @test img == first_frame               # comment line when creating png files

    while !eof(v)
        read!(v, img)
    end

end

VideoIO.testvideo("ladybird") # coverage testing
@test_throws ErrorException VideoIO.testvideo("rickroll")
@test_throws ErrorException VideoIO.testvideo("")


#VideoIO.TestVideos.remove_all()
