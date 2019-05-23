using Test
using ColorTypes, FileIO, ImageCore, ImageMagick, Dates

import VideoIO

testdir = dirname(@__FILE__)
videodir = joinpath(testdir, "..", "videos")

VideoIO.TestVideos.available()
VideoIO.TestVideos.download_all()

swapext(f, new_ext) = "$(splitext(f)[1])$new_ext"

# tesing that the executables run by testing the standard first line output
println(stderr, "Tesing ffmpeg executable...")
withenv("PATH" => VideoIO.libpath, "LD_LIBRARY_PATH" => VideoIO.libpath, "DYLD_LIBRARY_PATH" => VideoIO.libpath) do
    out = VideoIO.collectexecoutput(`$(VideoIO.ffmpeg)`)
    @test occursin("ffmpeg version ",out[1])
end

println(stderr, "Tesing ffprobe executable...")
withenv("PATH" => VideoIO.libpath, "LD_LIBRARY_PATH" => VideoIO.libpath, "DYLD_LIBRARY_PATH" => VideoIO.libpath) do
    out = VideoIO.collectexecoutput(`$(VideoIO.ffprobe)`)
    @test occursin("ffprobe version ",out[1])
end

println(stderr, "Testing file reading...")

@noinline function isblank(img)
    all(c->green(c) == 0, img) || all(c->blue(c) == 0, img) || all(c->red(c) == 0, img) || maximum(rawview(channelview(img))) < 0xcf
end

for name in VideoIO.TestVideos.names()
    Sys.isapple() && startswith(name, "crescent") && continue
    println(stderr, "   Testing $name...")

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

println(stderr, "Testing IO reading...")
for name in VideoIO.TestVideos.names()
    Sys.isapple() && startswith(name, "crescent") && continue
    # TODO: fix me?
    (startswith(name, "ladybird") || startswith(name, "NPS")) && continue

    println(stderr, "   Testing $name...")
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

VideoIO.testvideo("ladybird") # coverage testing
@test_throws ErrorException VideoIO.testvideo("rickroll")
@test_throws ErrorException VideoIO.testvideo("")


#VideoIO.TestVideos.remove_all()

println(stderr, "Tesing reading of video duration and date/datetime...")
# tesing the duration and date & time functions:
println(stderr, "   Testing annie_oakley.ogg...")
file = joinpath(videodir, "annie_oakley.ogg")
@test VideoIO.get_duration(file) == Dates.Microsecond(24224200)
@test VideoIO.get_start_time(file) == DateTime(1970, 1, 1)
@test VideoIO.get_time_duration(file) == (DateTime(1970, 1, 1), Dates.Microsecond(24224200))
