# Test is broken at line 19, see https://github.com/kmsquire/VideoIO.jl/pull/47

using Base.Test
using Images, FixedPointNumbers
import VideoIO

testdir = joinpath(Pkg.dir("VideoIO"), "test")
videodir = joinpath(Pkg.dir("VideoIO"), "videos")

VideoIO.TestVideos.available()
VideoIO.TestVideos.download_all()

swapext(f, new_ext) = "$(splitext(f)[1])$new_ext"

println(STDERR, "Testing file reading...")

function notblank(img)
    all(green(img) .== 0x00uf8) || all(blue(img) .== 0x00uf8) || all(red(img) .== 0x00uf8) || maximum(reinterpret(Ufixed8, img)) < 0xcfuf8
end

for name in VideoIO.TestVideos.names()
    println(STDERR, "   Testing $name...")

    first_frame_file = joinpath(testdir, swapext(name, ".png"))

    first_frame = imread(first_frame_file) # comment line when creating png files

    f = VideoIO.testvideo(name)
    v = VideoIO.openvideo(f)

    #img = read(v, Image)
    img = read(v)
    img = colorim(img)
    fframe_arr = data(first_frame)        #RGB4
    fframe_rgb = share(img2, fframe_arr)  #RGB

    # Find the first non-trivial image
    while notblank(img2)  #img2 =>img
        read!(v, img2)
    end

    #imwrite(img, first_frame_file)        # uncomment line when creating png files

    @test img == first_frame               # comment line when creating png files


    while !eof(v)
        read!(v, img)
    end
end

println(STDERR, "Testing IO reading...")
for name in VideoIO.TestVideos.names()
    # TODO: fix me?
    (beginswith(name, "ladybird") || beginswith(name, "NPS")) && continue

    println(STDERR, "   Testing $name...")
    first_frame_file = joinpath(testdir, swapext(name, ".png"))
    first_frame = imread(first_frame_file) # comment line when creating png files

    filename = joinpath(videodir, name)
    v = VideoIO.openvideo(open(filename))

    #img = read(v, Image)
    img = read(v)
    img = colorimg(img)

    # Find the first non-trivial image
    while notblank(img)
        read!(v, img)
    end

    #imwrite(img, first_frame_file)        # uncomment line when creating png files

    @test img == first_frame               # comment line when creating png files

    while !eof(v)
        read!(v, img)
    end
end

VideoIO.testvideo("ladybird") # coverage testing
@test_throws ErrorException VideoIO.testvideo("rickroll")
@test_throws ErrorException VideoIO.testvideo("")


#VideoIO.TestVideos.remove_all()
