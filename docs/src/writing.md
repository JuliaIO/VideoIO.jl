# Writing Videos

Note: Writing of audio streams is not yet implemented

## Single-step Encoding

Videos can be encoded directly from image stack using `encode_mux_video(filename::String, imgstack::Array)` where `imgstack` is an array of image arrays with identical type and size.

The entire image stack can be encoded in a single step:
```julia
using VideoIO
encoder_settings = ("crf"=>"22","preset"=>"medium")]
encode_mux_video("video.mp4", imgstack, framerate=30, encoder_settings=encoder_settings)
```

```@docs
VideoIO.encode_mux_video
```

## Iterative Encoding

Alternatively, videos can be encoded iteratively within custom loops.

```julia
using VideoIO
framestack = map(x->rand(UInt8, 100, 100), 1:100) #vector of 2D arrays

encoder_settings = (crf="22", preset="medium")
framerate=24
open_video_out("video.mp4", framestack[1], framerate=framerate, encoder_settings=encoder_settings) do writer
    for i in eachindex(framestack)
        append_encode_mux!(writer, framestack[i], i)
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

encoder_settings = (crf="22", preset="medium")

firstimg = load(joinpath(dir, imgnames[1]))
open_video_out("video.mp4", firstimg, framerate=24, encoder_settings=encoder_settings) do writer
    @showprogress "Encoding video frames.." for i in eachindex(imgnames)
        img = load(joinpath(dir, imgnames[i]))
        append_encode_mux!(writer, img, i)
    end
end
```

```@doc
VideoIO.encode_mux_video
```

```@docs
VideoIO.open_video_out
```

```@docs
VideoIO.append_encode_mux!
```

```@docs
VideoIO.close_video_out!
```

## Supported Colortypes
Encoding of the following image element color types currently supported:
- `UInt8`
- `Gray{N0f8}`
- `RGB{N0f8}`

## Encoder Settings

The `AVCodecContextProperties` object allows control of the majority of settings required.
Optional fields can be found [here](https://ffmpeg.org/doxygen/4.1/structAVCodecContext.html).

A few helpful presets for h264:

| Goal | `AVCodecContextProperties` value |
|:----:|:------|
| Perceptual compression, h264 default. Best for most cases | ```(priv_data = (crf="23", preset="medium"))``` |
| Lossless compression. Fastest, largest file size | ```(priv_data = (crf="0", preset="ultrafast"))``` |
| Lossless compression. Slowest, smallest file size | ```(priv_data = (crf="0", preset="ultraslow"))``` |
| Direct control of bitrate and frequency of intra frames (every 10) | ```[:bit_rate => 400000,:gop_size = 10,:max_b_frames=1]``` |

## Lossless Encoding
### Lossless RGB
If lossless encoding of `RGB{N0f8}` is required, _true_ lossless requires using `codec_name = "libx264rgb"`, to avoid the lossy RGB->YUV420 conversion, and `"crf" => "0"`.

### Lossless Grayscale
If lossless encoding of `Gray{N0f8}` or `UInt8` is required, `"crf" => "0"` should be set, as well as `:color_range=>2` to ensure full 8-bit pixel color representation. i.e.
```[:color_range=>2, :priv_data => ("crf"=>"0","preset"=>"medium")]```

### Encoding Performance
See [`examples/lossless_video_encoding_testing.jl`](https://github.com/JuliaIO/VideoIO.jl/blob/master/examples/lossless_video_encoding_testing.jl) for testing of losslessness, speed, and compression as a function of h264 encoding preset, for 3 example videos.
