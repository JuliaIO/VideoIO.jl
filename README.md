[![Build Status](https://travis-ci.org/JuliaIO/VideoIO.jl.svg?branch=master)](https://travis-ci.org/JuliaIO/VideoIO.jl)
[![Appveyor Build](https://ci.appveyor.com/api/projects/status/44g5t95ev6ww6kro?svg=true)](https://ci.appveyor.com/project/JuliaIO/videoio-jl)
[![Coverage Status](https://coveralls.io/repos/JuliaIO/VideoIO.jl/badge.png)](https://coveralls.io/r/JuliaIO/VideoIO.jl)

VideoIO.jl
==========

Julia bindings for ffmpeg, using a dedicated installation of ffmpeg 4.1.

Reading and writing of videos is supported.

Video images may be read as raw arrays, or optionally, `Image`
objects (if `Images.jl` is installed and loaded first).

Videos can be encoded from image stacks (a vector of same-sized `Image` objects),
or encoded iteratively in custom loops.

### Platform Nodes: 

- ARM: There is a known issue on ARM that results in very small and rare precision differences when reading/writing some video files. As such, tests for frame comparison are currently skipped on ARM. Issues/PRs welcome for helping to get this fixed.


Installation
------------
Use the Julia package manager.  Within Julia, do:
```julia
]add VideoIO
```

Simple Interface
----------------
A trivial video player interface exists (no audio):
Note: `Makie` must be imported first to enable playback functionality.

```julia
import Makie
import VideoIO

f = VideoIO.testvideo("annie_oakley")  # downloaded if not available
VideoIO.playvideo(f)  # no sound

# Aternatively, you can just open the camera
#VideoIO.viewcam()
```

High Level Interface
--------------------

### Video Reading

VideoIO contains a simple high-level interface which allows reading of
video frames from a supported video file, or from a camera device:
```julia
import Makie
import VideoIO

io = VideoIO.open(video_file)
f = VideoIO.openvideo(io)

# As a shortcut for just video, you can open the file directly
# with openvideo
#f = VideoIO.openvideo(video_file)

# Alternatively, you can open the camera with opencamera().
# The default device is "0" on Windows, "/dev/video0" on Linux,
# and "Integrated Camera" on OSX.  If using something other
# than the default, pass it in as the first parameter (as a string).
#f = VideoIO.opencamera()

# One can seek to an arbitrary position in the video
seek(f,2.5)  ## The second parameter is the time in seconds and must be Float64
img = read(f)
scene = Makie.Scene(resolution = size(img))
makieimg = Makie.image!(scene, buf, show_axis = false, scale_plot = false)[end]
Makie.rotate!(scene, -0.5pi)
display(scene)

while !eof(f)
    read!(f, img)
    makieimg[1] = img
    #sleep(1/30)
end
```

This code is essentially the code in `playvideo`, and will read and
(without the `sleep`) play a movie file as fast as possible.

As with the `playvideo` function, the `Images` and `ImageView` packages
must be loaded for the appropriate functions to be available.

As an additional handling example, here a grayscale video is read and parsed into a `Vector(Array{UInt8}}`
```julia
f = VideoIO.openvideo(filename,target_format=VideoIO.AV_PIX_FMT_GRAY8)
v = Vector{Array{UInt8}}(undef,0)
while !eof(f)
    push!(v,reinterpret(UInt8, read(f)))
end
close(f)
```

### Video Writing

Given an image stack.. say, where image files `1.png`, `2.png`,`3.png` etc. are in the current directory:
```julia
filenames = filter(x->occursin(".png",x),readdir()) # Populate list of all .pngs
intstrings =  map(x->split(x,".")[1],filenames) # Extract index from filenames
p = sortperm(parse.(Int,intstrings)) #sort files numerically
imgstack = []
for filename in filenames[p]
    push!(imgstack,read(filename))
end
```

Encode entire imgstack in one go:
```julia
> using VideoIO
> props = [:priv_data => ("crf"=>"22","preset"=>"medium")]
> encodevideo("video.mp4",imgstack,framerate=30,AVCodecContextProperties=props)

[ Info: Video file saved: /Users/username/Documents/video.mp4
[ Info: frame=  100 fps=0.0 q=-1.0 Lsize=  129867kB time=00:00:03.23 bitrate=329035.1kbits/s speed=8.17x    
[ Info: video:129865kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.001692%
```

Encode by appending within a custom loop:
```julia
using VideoIO, ProgressMeter
filename = "manual.mp4"
framerate = 24

firstimg = read(filenames[1])
encoder = prepareencoder(firstimg, framerate=30.0)

io = Base.open("temp.stream","w")
p = Progress(length(imgstack), 1)
index = 1
for filename in filenames
    global index
    img = read(filename)
    appendencode!(encoder, io, img, index)
    next!(p)
    index += 1
end

finishencode!(encoder, io)
close(io)

mux("temp.stream",filename,framerate) #Multiplexes the stream into a video container
```

The AVCodecContextProperties object allows control of the majority of settings required.
Optional fields can be found [here](https://ffmpeg.org/doxygen/4.1/structAVCodecContext.html)

A few helpful presets for h264:

- Perceptual compression, h264 default - Best for most cases:
```AVCodecContextProperties = [:priv_data => ("crf"=>"23","preset"=>"medium")]```
- Lossless compression - Fastest, largest file size:
```AVCodecContextProperties = [:priv_data => ("crf"=>"0","preset"=>"ultrafast")]```
- Lossless compression - Slowest, smallest file size:
```AVCodecContextProperties = [:priv_data => ("crf"=>"0","preset"=>"ultraslow")]```
- Direct control of bitrate and frequency of intra frames (every 10):
```AVCodecContextProperties = [:bit_rate => 400000,:gop_size = 10,:max_b_frames=1]```

Encoding of the following image element color types currently supported:
- `UInt8`
- `Gray{N0f8}`
- `RGB{N0f8}`


### Lossless encoding
If lossless encoding of `RGB{N0f8}` is required, _true_ lossless
requires using `codec_name = "libx264rgb"`, to avoid the lossy RGB->YUV420 conversion,
and `"crf" => "0"`.

If lossless encoding of `Gray{N0f8}` or `UInt8` is required, `"crf" => "0"` should be
set, as well as `:color_range=>2` to ensure full 8-bit pixel color representation.
i.e. `[:color_range=>2, :priv_data => ("crf"=>"0","preset"=>"medium")]`

See [examples/lossless_video_encoding_testing.jl](https://github.com/JuliaIO/VideoIO.jl/blob/master/examples/lossless_video_encoding_testing.jl) for testing of losslessness, speed, and compression as a function of h264 encoding preset, for 3 example videos.  

Low Level Interface
-------------------
Each ffmpeg library has its own VideoIO subpackage:

    libavcodec    -> AVCodecs
    libavdevice   -> AVDevice
    libavfilter   -> AVFilters
    libavformat   -> AVFormat
    libavutil     -> AVUtil
    libswscale    -> SWScale

The following three files are related to ffmpeg, but currently not
exposed:

    libswresample -> SWResample
    libpostproc   -> PostProc   (not wrapped)

After importing VideoIO, you can import and use any of the subpackages directly

    import VideoIO
    import SWResample  # SWResample functions are now available

Note that much of the functionality of these subpackages is not enabled
by default, to avoid long compilation times as they load.  To control
what is loaded, each library version has a file which imports that's
modules files.  For example, ffmpeg's libswscale-v2 files are loaded by
$(VideoIO_PKG_DIR)/src/ffmpeg/SWScale/v2/LIBSWSCALE.jl.

Check these files to enable any needed functionality that isn't already
enabled. Note that you'll probably need to do this for each version
of the package for ffmpeg, and that the interfaces do
change some from version to version.

Note that, in general, the low-level functions are not very fun to use,
so it is good to focus initially on enabling a nice, higher-level
function for these interfaces.

Test Videos
-----------

A small number of test videos are available through VideoIO.TestVideos.
These are short videos in a variety of formats with non-restrictive
(public domain or Creative Commons) licenses.

* `VideoIO.TestVideos.available()` prints a list of all available test videos.
* `VideoIO.testvideo("annie_oakley")` returns an AVInput object for the
  `"annie_oakley"` video.  The video will be downloaded if it isn't available.
* `VideoIO.TestVideos.download_all()` downloads all test videos
* `VideoIO.TestVideos.remove_all()` removes all test videos


Status
------
Prior to version 6.0, this package used a BinDeps approach, using system-level ffmpeg
installs, and thus provided support of many versions of ffmpeg and libav. See [v0.5.6](https://github.com/JuliaIO/VideoIO.jl/releases/tag/v0.5.6) for that prior functionality.

v0.6.0 onwards uses a BinaryProvider approach, with a dedicated ffmpeg 4.1 install.  

Currently, a simple video interface is available. See TODO.md for some possible directions
forward.

Issues, requests, and/or pull requests for problems or additional
functionality are very welcome.
