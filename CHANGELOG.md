VideoIO v0.9 Release Notes
======================
## New features

- New `VideoIO.load(filename::String; ...)` function to read entire video into memory

## Bugfixes
- Encoding videos now encodes the correct number of frames


## Breaking Changes

The encoding API has been renamed and simplified:

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
