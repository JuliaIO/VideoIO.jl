# Writing Videos

Note: Writing of audio streams is not yet implemented

## Single-step Encoding

Videos can be encoded directly from image stack using `encodevideo(filename::String,imgstack::Array)` where `imgstack` is an array of image arrays with identical type and size.

For instance, say an image stack has been constructed from reading a series of image files `1.png`, `2.png`,`3.png` etc. :
```julia
using FileIO
imgnames = filter(x->occursin(".png",x),readdir()) # Populate list of all .pngs
intstrings =  map(x->split(x,".")[1],imgnames) # Extract index from filenames
p = sortperm(parse.(Int,intstrings)) #sort files numerically
imgstack = []
for imgname in imgnames[p]
    push!(imgstack,load(imgname))
end
```

The entire image stack can be encoded in a single step:
```julia
using VideoIO
props = [:priv_data => ("crf"=>"22","preset"=>"medium")]
encodevideo("video.mp4",imgstack,framerate=30,AVCodecContextProperties=props)

[ Info: Video file saved: /Users/username/Documents/video.mp4
[ Info: frame=  100 fps=0.0 q=-1.0 Lsize=  129867kB time=00:00:03.23 bitrate=329035.1kbits/s speed=8.17x    
[ Info: video:129865kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.001692%
```

```@docs
VideoIO.encodevideo
```

## Iterative Encoding

Alternatively, videos can be encoded iteratively within custom loops.
The encoding steps follow:
1. Initialize encoder with `prepareencoder`
2. Iteratively add frames with `appendencode`
3. End the encoding with `finishencode`
4. Multiplex the stream into a video container with `mux`

For instance:
```julia
using VideoIO, ProgressMeter

imgnames = filter(x->occursin(".png",x),readdir()) # Populate list of all .pngs
intstrings =  map(x->split(x,".")[1],imgnames) # Extract index from filenames
p = sortperm(parse.(Int,intstrings)) #sort files numerically
imgnames = imgnames[p]

filename = "manual.mp4"
framerate = 24
props = [:priv_data => ("crf"=>"22","preset"=>"medium")]

firstimg = read(imgnames[1])
encoder = prepareencoder(firstimg, framerate=framerate, AVCodecContextProperties=props)

io = Base.open("temp.stream","w")
p = Progress(length(imgstack), 1)
index = 1
for imgname in imgnames
    global index
    img = read(imgname)
    appendencode!(encoder, io, img, index)
    next!(p)
    index += 1
end

finishencode!(encoder, io)
close(io)

mux("temp.stream",filename,framerate) #Multiplexes the stream into a video container
```

```@docs
VideoIO.prepareencoder
```

```@docs
VideoIO.appendencode!
```

```@docs
VideoIO.finishencode!
```

```@docs
VideoIO.mux
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
| Perceptual compression, h264 default.<br>Best for most cases | ```[:priv_data => ("crf"=>"23","preset"=>"medium")``` |
| Lossless compression.<br>Fastest, largest file size | ```[:priv_data => ("crf"=>"0","preset"=>"ultrafast")]``` |
| Lossless compression.<br>Slowest, smallest file size | ```[:priv_data => ("crf"=>"0","preset"=>"ultraslow")]``` |
| Direct control of bitrate and frequency of intra frames (every 10) | ```[:bit_rate => 400000,:gop_size = 10,:max_b_frames=1]``` |

## Lossless Encoding
### Lossless RGB
If lossless encoding of `RGB{N0f8}` is required, _true_ lossless requires using `codec_name = "libx264rgb"`, to avoid the lossy RGB->YUV420 conversion, and `"crf" => "0"`.

### Lossless Grayscale
If lossless encoding of `Gray{N0f8}` or `UInt8` is required, `"crf" => "0"` should be set, as well as `:color_range=>2` to ensure full 8-bit pixel color representation. i.e.
```[:color_range=>2, :priv_data => ("crf"=>"0","preset"=>"medium")]```

### Encoding Performance
See [`examples/lossless_video_encoding_testing.jl`](https://github.com/JuliaIO/VideoIO.jl/blob/master/examples/lossless_video_encoding_testing.jl) for testing of losslessness, speed, and compression as a function of h264 encoding preset, for 3 example videos.  
