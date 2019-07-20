# Video Reading
Note: Reading of audio streams is not yet implemented

## Reading Video Files
### Direct Video Playback
A trivial video player interface exists (no audio):
Note: `Makie` must be imported first to enable playback functionality.

```julia
using Makie
using VideoIO

f = VideoIO.testvideo("annie_oakley")  # downloaded if not available
VideoIO.playvideo(f)  # no sound
```

### Custom Frame Reading

VideoIO contains a simple high-level interface which allows reading of
video frames from a supported video file, or from a camera device:
```julia
import Makie
import VideoIO

io = VideoIO.open(video_file)
f = VideoIO.openvideo(io)

# One can seek to an arbitrary position in the video
seek(f,2.5)  ## The second parameter is the time in seconds and must be Float64
img = read(f)
scene = Makie.Scene(resolution = size(img))
makieimg = Makie.image!(scene, img, show_axis = false, scale_plot = false)[end]
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

## Reading Camera Output
### Direct Camera Playback
The default system webcam can be viewed directly
```julia
using Makie
using VideoIO
VideoIO.viewcam()
```
Alternatively, frames can be read iteratively
```julia
using VideoIO
cam = VideoIO.opencamera()
for i in 1:100
    img = read(cam)
    sleep(1/framerate)
end
```

## Video Properties & Metadata
```@docs
VideoIO.get_start_time
```
```@docs
VideoIO.get_time_duration
```
```@docs
VideoIO.get_duration
```
