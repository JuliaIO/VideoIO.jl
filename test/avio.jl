using Base.Test
using Images
import AV

testdir = joinpath(Pkg.dir("AV"), "test")
videodir = joinpath(Pkg.dir("AV"), "videos")

AV.TestVideos.available()
AV.TestVideos.download_all()

swapext(f, new_ext) = "$(splitext(f)[1])$new_ext"

println(STDERR, "Testing file reading...")
for name in AV.TestVideos.names()
    println(STDERR, "   Testing $name...")

    first_frame_file = joinpath(testdir, swapext(name, ".png"))
    first_frame = imread(first_frame_file) # comment line when creating png files

    f = AV.testvideo(name)
    v = AV.openvideo(f)

    img = read(v, Image)

    # Find the first non-trivial image
    while all(green(img) .== 0x00) || all(blue(img) .== 0x00) || all(red(img) .== 0x00) || maximum(img) < 0xcf
        read!(v, img)
    end

    #imwrite(img, first_frame_file)        # uncomment line when creating png files

    @test img == first_frame               # comment line when creating png files

    while !eof(v)
        read!(v, img)
    end
end

println(STDERR, "Testing IO reading...")
for name in AV.TestVideos.names()
    # TODO: fix me?
    (beginswith(name, "ladybird") || beginswith(name, "NPS")) && continue

    println(STDERR, "   Testing $name...")
    first_frame_file = joinpath(testdir, swapext(name, ".png"))
    first_frame = imread(first_frame_file) # comment line when creating png files

    filename = joinpath(videodir, name)
    v = AV.openvideo(open(filename))

    img = read(v, Image)

    # Find the first non-trivial image
    while all(green(img) .== 0x00) || all(blue(img) .== 0x00) || all(red(img) .== 0x00) || maximum(img) < 0xcf
        read!(v, img)
    end

    #imwrite(img, first_frame_file)        # uncomment line when creating png files

    @test img == first_frame               # comment line when creating png files

    while !eof(v)
        read!(v, img)
    end
end

AV.testvideo("ladybird") # coverage testing
@test_throws ErrorException AV.testvideo("rickroll")
@test_throws ErrorException AV.testvideo("")


#AV.TestVideos.remove_all()
