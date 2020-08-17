# Video Reading
Note: Reading of audio streams is not yet implemented

## Reading Video Files

VideoIO contains a simple high-level interface which allows reading of
video frames from a supported video file (or from a camera device, shown later).

```julia
using VideoIO

# Construct a AVInput object to access the video and audio streams in a video container
# io = VideoIO.open(video_file)
io = VideoIO.testvideo("annie_oakley") # for testing purposes

# Access the video stream in an AVInput, and return a VideoReader object:
f = VideoIO.openvideo(io) # you can also use a file name, instead of a AVInput

img = read(f)

while !eof(f)
    read!(f, img)
    # Do something with frames
end
close(f)
```

Alternatively, you can open the video stream in a file directly with
`VideoIO.openvideo(filename)`, without making an intermediate `AVInput`
object, if you only need the video.

VideoIO also provides an iterator interface for [`VideoReader`](@ref), which
behaves like other mutable iterators in Julia (e.g. Channels). If iteration is
stopped early, for example with a `break` statement, then it can be resumed in
the same spot by iterating on the same `VideoReader` object. Consequently, if
you have already iterated over all the frames of a `VideoReader` object, then it
will be empty for further iteration unless its position in the video is changed
with `seek`.

```julia
using VideoIO


io = VideoIO.testvideo("annie_oakley")
f = VideoIO.openvideo(io)

for img in f
    # Do something with img
end

# You can also use collect(f) to get all of the frames

# Further iteration will show that f is now empty!

close(f)
```


Seeking through the video can be achieved via `seek(f, seconds::Float64)` and `seekstart(f)` to return to the start.
```@docs
VideoIO.seek
```
```@docs
VideoIO.seekstart
```

Frames can be skipped without reading frame content via `skipframe(f)` and `skipframes(f, n)`
```@docs
VideoIO.skipframe
```
```@docs
VideoIO.skipframes
```

Total available frame count is available via `counttotalframes(f)`
```@docs
VideoIO.counttotalframes
```

!!! note H264 videos encoded with `crf>0` have been observed to have 4-fewer frames 
available for reading.

### Changing the target pixel format for reading
It can be helpful to be explicit in which pixel format you wish to read frames as.
Here a grayscale video is read and parsed into a `Vector(Array{UInt8}}`
```julia
f = VideoIO.openvideo(filename, target_format=VideoIO.AV_PIX_FMT_GRAY8)

while !eof(f)
    img = reinterpret(UInt8, read(f))
end
close(f)
```

## Video Playback

A trivial video player interface exists (no audio) through `Makie.jl`.
Note: `Makie` must be imported first to enable playback functionality.

```julia
using Makie
using VideoIO

f = VideoIO.testvideo("annie_oakley")  # downloaded if not available
VideoIO.playvideo(f)  # no sound
```

Customization of playback can be achieved by looking at the basic expanded version of this function:

```julia
import Makie
import VideoIO

#io = VideoIO.open(video_file)
io = VideoIO.testvideo("annie_oakley") # for testing purposes
f = VideoIO.openvideo(io)

img = read(f)
scene = Makie.Scene(resolution = reverse(size(img)))
makieimg = Makie.image!(scene, img, show_axis = false, scale_plot = true)[end]
Makie.rotate!(scene, -0.5pi)
display(scene)

while !eof(f)
    read!(f, img)
    makieimg[1] = img
    sleep(1/f.framerate)
end
```
This code is essentially the code in `playvideo`, and will read and
(without the `sleep`) play a movie file as fast as possible.


## Reading Camera Output
Frames can be read iteratively
```julia
using VideoIO
cam = VideoIO.opencamera()
for i in 1:100
    img = read(cam)
    sleep(1/cam.framerate)
end
```
### Webcam playback
The default system webcam can be viewed directly
```julia
using Makie
using VideoIO
VideoIO.viewcam()
```

An expanded version of this approach:
```julia
import Makie, VideoIO

cam = VideoIO.opencamera()

img = read(cam)
scene = Makie.Scene(resolution = size(img'))
makieimg = Makie.image!(scene, img, show_axis = false, scale_plot = false)[end]
Makie.rotate!(scene, -0.5pi)
display(scene)

while isopen(scene)
    read!(cam, img)
    makieimg[1] = img
    sleep(1/cam.framerate)
end

close(cam)
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
```@docs
VideoIO.get_number_frames
```
