# Writing Videos

N.B. Writing of audio streams is currently not implemented

## Writing (encoding) video files

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
encoder = prepareencoder(firstimg, framerate=framerate)

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


```@docs
VideoIO.appendencode!
```

```@docs
VideoIO.encodevideo
```

```@docs
VideoIO.finishencode!
```

```@docs
VideoIO.mux
```

```@docs
VideoIO.prepareencoder
```

```@docs
VideoIO.encode!
```


