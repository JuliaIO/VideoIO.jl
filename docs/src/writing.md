# Writing Videos

Note: Writing of audio streams is not yet implemented

## Single-step Encoding

Videos can be encoded directly from image stack using `VideoIO.save(filename::String, imgstack::Array)` where `imgstack` is an array of image arrays with identical type and size.

The entire image stack can be encoded in a single step:
```julia
import VideoIO
encoder_options = (crf=23, preset="medium")
VideoIO.save("video.mp4", imgstack, framerate=30, encoder_options=encoder_options)
```

```@docs
VideoIO.save
```

## Iterative Encoding

Alternatively, videos can be encoded iteratively within custom loops.

```julia
using VideoIO
framestack = map(x->rand(UInt8, 100, 100), 1:100) #vector of 2D arrays

encoder_options = (crf=23, preset="medium")
framerate=24
open_video_out("video.mp4", framestack[1], framerate=framerate, encoder_options=encoder_options) do writer
    for frame in framestack
        write(writer, frame)
    end
end
```

An example saving a series of png files as a video:

```julia
using VideoIO, ProgressMeter

dir = "" #path to directory holding images
imgnames = filter(x->occursin(".png",x), readdir(dir)) # Populate list of all .pngs
intstrings =  map(x->split(x,".")[1], imgnames) # Extract index from filenames
p = sortperm(parse.(Int, intstrings)) #sort files numerically
imgnames = imgnames[p]

encoder_options = (crf=23, preset="medium")

firstimg = load(joinpath(dir, imgnames[1]))
open_video_out("video.mp4", firstimg, framerate=24, encoder_options=encoder_options) do writer
    @showprogress "Encoding video frames.." for i in eachindex(imgnames)
        img = load(joinpath(dir, imgnames[i]))
        write(writer, img)
    end
end
```

```@docs
VideoIO.open_video_out
```

```@docs
VideoIO.write
```

```@docs
VideoIO.close_video_out!
```

## Supported Colortypes
Encoding of the following image element color types currently supported:
- `UInt8`
- `Gray{N0f8}`
- `RGB{N0f8}`

## Encoder Options

The `encoder_options` keyword argument allows control over FFmpeg encoding
options. Optional fields can be found
[here](https://ffmpeg.org/ffmpeg-codecs.html#Codec-Options).

More details about options specific to h264 can be found [here](https://trac.ffmpeg.org/wiki/Encode/H.264).

Some example values for the `encoder_options` keyword argument are:

| Goal | `encoder_options` value |
|:----:|:------|
| Perceptual compression, h264 default. Best for most cases | ```(crf=23, preset="medium")``` |
| Lossless compression. Fastest, largest file size | ```(crf=0, preset="ultrafast")``` |
| Lossless compression. Slowest, smallest file size | ```(crf=0, preset="ultraslow")``` |
| Direct control of bitrate and frequency of intra frames (every 10) | ```(bit_rate = 400000, gop_size = 10, max_b_frames = 1)``` |

## Lossless Encoding
### Lossless RGB
If lossless encoding of `RGB{N0f8}` is required, _true_ lossless requires using `codec_name = "libx264rgb"`, to avoid the lossy RGB->YUV420 conversion, and `crf=0`.

### Lossless Grayscale
If lossless encoding of `Gray{N0f8}` or `UInt8` is required, `crf=0` should be set, as well as `color_range=2` to ensure full 8-bit pixel color representation. i.e.
```(color_range=2, crf=0, preset="medium")```

### Encoding Performance
See [`util/lossless_video_encoding_testing.jl`](https://github.com/JuliaIO/VideoIO.jl/blob/master/util/lossless_video_encoding_testing.jl) for testing of losslessness, speed, and compression as a function of h264 encoding preset, for 3 example videos.
