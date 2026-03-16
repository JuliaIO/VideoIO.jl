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
using VideoIO, ProgressMeter, FileIO

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
Base.write(writer::VideoIO.VideoWriter, img, index::Int)
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
| Lossless compression. Slowest, smallest file size | ```(crf=0, preset="veryslow")``` |
| Direct control of bitrate and frequency of intra frames (every 10) | ```(bit_rate = 400000, gop_size = 10, max_b_frames = 1)``` |

If a hyphenated parameter is needed, it can be added using `var"param-name" = value`.

## Lossless Encoding
### Lossless RGB
If lossless encoding of `RGB{N0f8}` is required, _true_ lossless requires passing `codec_name = "libx264rgb"` to the function to avoid the lossy RGB->YUV420 conversion, as well as adding `crf=0` in `encoder_options`.

### Lossless Grayscale
If lossless encoding of `Gray{N0f8}` or `UInt8` is required, `crf=0` should be set, as well as `color_range=2` to ensure full 8-bit pixel color representation. i.e.
```(color_range=2, crf=0, preset="medium")```

### Encoding Performance
See [`util/lossless_video_encoding_testing.jl`](https://github.com/JuliaIO/VideoIO.jl/blob/master/util/lossless_video_encoding_testing.jl) for testing of losslessness, speed, and compression as a function of h264 encoding preset, for 3 example videos.

## Hardware-accelerated encoding

On systems with supported hardware (macOS VideoToolbox, NVIDIA NVENC, Intel
VAAPI/QSV), VideoIO can offload encoding to the GPU or media engine.  Pass
`hwaccel = :<device>` to `open_video_out` or `save`:

```julia
# macOS – VideoToolbox
VideoIO.save("video.mp4", imgstack; framerate = 30, hwaccel = :videotoolbox)

# Linux – VAAPI
VideoIO.save("video.mp4", imgstack; framerate = 30, hwaccel = :vaapi)

# NVIDIA
VideoIO.save("video.mp4", imgstack; framerate = 30, hwaccel = :cuda)
```

When `hwaccel` is set and no `codec_name` is specified, VideoIO automatically
selects the best hardware encoder for the container's default codec (e.g.
`h264_videotoolbox` for `.mp4` on macOS).  You can also combine `hwaccel` with an
explicit `codec_name`:

```julia
VideoIO.save("video.mp4", imgstack; codec_name = "hevc_videotoolbox", hwaccel = :videotoolbox)
```

or use `codec_name` alone with a hardware encoder name (no `hwaccel` needed for
codecs like VideoToolbox that don't require an explicit device context):

```julia
VideoIO.save("video.mp4", imgstack; codec_name = "h264_videotoolbox")
```

To list available hardware encoders:

```julia
# All hardware encoders in this FFmpeg build
VideoIO.available_hw_encoders()  # e.g. ["h264_videotoolbox", "hevc_videotoolbox"]

# Check a specific device is usable before encoding
VideoIO.hwaccel_available(:videotoolbox)  # true on macOS with hardware
```

```@docs
VideoIO.available_hw_encoders
```

**Requirements:**  Hardware encoding requires an FFmpeg build that includes the
relevant hardware backend.  Use `VideoIO.hwaccel_available` to confirm the
device is actually accessible at runtime. If `available_hw_encoders()` returns
an empty vector no hardware encoders are available.
