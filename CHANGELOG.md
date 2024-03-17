VideoIO v1.1.0 Release Notes
======================
## Removal

- The GLMakie-based video player that was accessed through Requires by loading GLMakie separately has been removed
  after being deprecated in v1.0.8.


VideoIO v0.9 Release Notes
======================
## New features

- Add support for 10 bit gray, RGB, and YUV encoding and decoding
- Support do-block syntax for `openvideo` and `open_video_out`
- Support 444 chroma downsampling, among other pixel formats
- Simultaneous muxing and encoding by default
- Support "scanline-major" encoding
- New `VideoIO.load(filename::String; ...)` function to read entire video into memory
- Allow ffmpeg to choose default codec based on container format

## Bugfixes
- Encoding videos now encodes the correct number of frames
- Fixed seeking inaccuracies (#275, #242)
- Fix bug which caused the last two frames to be dropped while reading some videos (#270)
- Fix bug which caused the first two frames to be dropped when writing videos (#271)
- Prevent final frame in video stream from being hidden due to it having zero duration
- Fix inconsistency with color ranges and clipping of user input (#283)
- Make color encoding more similar to ffmpeg binary (#284)
- Make the first video frame occurs at `pts` 0, not 1
- Make image buffer for decoding compatible with multi-planar image formats
- Eliminate use of deprecated libav functions
- Properly initialize libav structs
- Make `NO_TRANSCODE` encoding work
- Reduce multi-threaded access to libav functions that are not thread safe
- Make code generally more safe from accessing data after the GC frees it
- Eliminate segfault when `VideoReader` was used with `IOStream`
- Reduce type instability

## Breaking Changes

The encoding API has been renamed and simplified:

| Original function | Equivalent function in v0.9 |
| :---------------- | :-------------------------- |
| `encode_video`    | `save`                      |
| `prepareencoder`  | `open_video_out!`           |
| `appendencode!`   | `write`                     |
| `finish_encode`   | `close_video_out!`          |
| `close(io)`       | N/A (no longer needed)      |
| `mux`             | N/A (no longer needed)      |

The keyword arguments of the replacement functions may no longer be the same as
the original, so please see their documentation. In particular, note that
`AVCodecContextProperties` has been replaced with `encoder_options` and
`encoder_private_options`.

### Single-shot encoding
Before:
```julia
using VideoIO
props = [:priv_data => ("crf"=>"22","preset"=>"medium")]
encodevideo("video.mp4", imgstack, framerate=30, AVCodecContextProperties=props)
```

v0.9:
```julia
using VideoIO
encoder_options = (crf=23, preset="medium")
VideoIO.save("video.mp4", imgstack, framerate=30, encoder_options=encoder_options)
```

Note that `save` is not exported.
Also note that the encoder options are now provided as a named tuple.

VideoIO will automatically attempt to route these options between the public and private ffmpeg options, so for instance
it is possible to specify lossless settings as:
```julia
VideoIO.save("video.mp4", imgstack, framerate=30,
            encoder_options=(color_range=2, crf=0, preset="medium")
            )
```

however the most fail-safe way would be to specify the public and private options specifically
```julia
VideoIO.save("video.mp4", imgstack, framerate=30,
            encoder_options=(color_range=2),
            encoder_private_options=(crf=0, preset="medium")
            )
```

### Iterative encoding

Before:
```julia
framestack = map(x->rand(UInt8, 100, 100), 1:100) #vector of 2D arrays

using VideoIO
props = [:priv_data => ("crf"=>"22","preset"=>"medium")]
encoder = prepareencoder(first(framestack), framerate=24, AVCodecContextProperties=props)
open("temp.stream", "w") do io
    for i in eachindex(framestack)
        appendencode!(encoder, io, framestack[i], i)
    end
    finishencode!(encoder, io)
end

mux("temp.stream", "video.mp4", framerate) #Multiplexes the stream into a video container
```

v0.9:
```julia
framestack = map(x->rand(UInt8, 100, 100), 1:100) #vector of 2D arrays

using VideoIO
encoder_options = (crf=23, preset="medium")
open_video_out("video.mp4", first(framestack), framerate=30, encoder_options=encoder_options) do writer
    for frame in framestack
        write(writer, frame)
    end
end
```
Note that the multiplexing (mux) is now done in parallel with the encoding loop, so no need for an intermediate
".stream" file. Lower level functions should be used for more elaborate encoding/multiplexing tasks.

### Performance improvement

The speed of encoding `UInt8` frames losslessly has more than doubled.
And.. encoding no longer has verbose printing.

For `imgstack = map(x-> rand(UInt8, 2048, 1536), 1:100)`

v0.8.4
```julia
julia> props = [:color_range=>2, :priv_data => ("crf"=>"0","preset"=>"ultrafast")];

julia> @btime encodevideo("video.mp4", imgstack, AVCodecContextProperties = props)
Progress: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| Time: 0:00:01
[ Info: Video file saved: /Users/ian/video.mp4
frame=  100 fps= 39 q=-1.0 Lsize=  480574kB time=00:00:04.12 bitrate=954382.6kbits/s speed= 1.6x    77x
[ Info: video:480572kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.000459%
... # hiding 6 subsequent repeated outputs
  4.163 s (2205 allocations: 340.28 KiB)
"video.mp4"
```

v0.9.0
```julia
julia> @btime VideoIO.save("video.mp4", imgstack, encoder_options = (color_range=2,crf=0,preset="ultrafast"))
  1.888 s (445 allocations: 7.22 KiB)
```

## Known performance "regression"

Monochrome encoding with default arguments has become a bit slower in
v0.9. This is because by default user supplied data is assumed to be full-range
(jpeg), while the default libav output range is limited range (mpeg), and
VideoIO will now scale the user data to fit in the limited destination range.
Prior to v0.9, no such automatic scaling would be done, causing the user data to
be simply clipped. While this may seem like a regression, it is actually the
consequence of fixing a bug in the previous versions of VideoIO.

To avoid this slowdown, either specify `color_range=2` in `encoder_options`, or
alternatively specify the color space of the user-supplied data to already be
limited range. Note that `color_range=2` may produce videos that are
incompatible with some video players.

If you are encoding data that is already limited range, then the simplest way to
avoid automatic scaling is to indicate that the user data is in the FFmpeg
default colorspace. This is accomplished by setting
`input_colorspace_details = VideoIO.VioColorspaceDetails()` when encoding the
video. While the FFmpeg default color range is "unknown", setting this will
also prevent automatic scaling by VideoIO. If you have further details about
your input colorspace, and your colorspace differs from Julia's default, then
create a `VioColorspaceDetails` object with the settings that correspond to your
input data's colorspace.

In the future we hope to make this re-scaling more performant so it won't be as
noticeable.
