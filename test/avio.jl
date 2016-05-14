using Base.Test
using Compat
using FixedPointNumbers

import Images: Image
import VideoIO

testdir = joinpath(Pkg.dir("VideoIO"), "test")
videodir = joinpath(Pkg.dir("VideoIO"), "videos")

VideoIO.TestVideos.available()
VideoIO.TestVideos.download_all()

swapext(f, new_ext) = "$(splitext(f)[1])$new_ext"

println(STDERR, "Testing file reading...")

if !isdefined(Main, :UFixed8)
    UFixed8 = Ufixed8
end

function notblank(img)
    all(Images.green(img) .== 0x00uf8) || all(Images.blue(img) .== 0x00uf8) || all(Images.red(img) .== 0x00uf8) || maximum(reinterpret(UFixed8, img)) < 0xcfuf8
end

if isdefined(Images, :load)
    imload = Images.load
else
    imload = Images.imread
end

for name in VideoIO.TestVideos.names()
    @osx_only startswith(name, "crescent") && continue
    println(STDERR, "   Testing $name...")

    first_frame_file = joinpath(testdir, swapext(name, ".png"))
    first_frame = imload(first_frame_file) # comment line when creating png files

    f = VideoIO.testvideo(name)
    v = VideoIO.openvideo(f)

    img = read(v, Image)

    # Find the first non-trivial image
    while notblank(img)
        read!(v, img)
    end

    #imwrite(img, first_frame_file)        # uncomment line when creating png files

    @test img == first_frame               # comment line when creating png files

    while !eof(v)
        read!(v, img)
    end

    # read first frames again, and compare
    seekstart(v)

    read!(v, img)

    while notblank(img)
        read!(v, img)
    end

    @test img == first_frame

    close(v)
end

println(STDERR, "Testing IO reading...")
for name in VideoIO.TestVideos.names()
    @osx_only startswith(name, "crescent") && continue
    # TODO: fix me?
    (startswith(name, "ladybird") || startswith(name, "NPS")) && continue

    println(STDERR, "   Testing $name...")
    first_frame_file = joinpath(testdir, swapext(name, ".png"))
    first_frame = imload(first_frame_file) # comment line when creating png files

    filename = joinpath(videodir, name)
    v = VideoIO.openvideo(open(filename))

    img = read(v, Image)

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
