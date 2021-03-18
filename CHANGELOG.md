VideoIO v0.9 Release Notes
======================
## New features


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
    for i in eachindex(framestack)
        append_encode_mux!(writer, framestack[i], i)
    end
end
```
Note that the multiplexing (mux) is done in parallel with the encoding loop, so no need for an intermediate
".stream" file.
