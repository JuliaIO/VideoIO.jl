# Video Reading
Note: Reading of audio streams is not yet implemented

## Reading Video Files

VideoIO contains a simple high-level interface which allows reading of
video frames from a supported video file (or from a camera device, shown later).

The simplest form will load the entire video into memory as a vector of image arrays.

```julia
using VideoIO
VideoIO.load("video.mp4")
```
```@docs
VideoIO.load
```

Frames can be read sequentially until the end of the file:

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

```@docs
VideoIO.openvideo
```

Alternatively, you can open the video stream in a file directly with
`VideoIO.openvideo(filename)`, without making an intermediate `AVInput`
object, if you only need the video.

VideoIO also provides an iterator interface for `VideoReader`, which
behaves like other mutable iterators in Julia (e.g. Channels). If iteration is
stopped early, for example with a `break` statement, then it can be resumed in
the same spot by iterating on the same `VideoReader` object. Consequently, if
you have already iterated over all the frames of a `VideoReader` object, then it
will be empty for further iteration unless its position in the video is changed
with `seek`.

```julia
using VideoIO

f = VideoIO.openvideo("video.mp4")
for img in f
    # Do something with img
end
# Alternatively use collect(f) to get all of the frames

# Further iteration will show that f is now empty
@assert isempty(f)

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
## Reading Camera Output
Frames can be read iteratively
```julia
using VideoIO
cam = VideoIO.opencamera()
fps = VideoIO.framerate(cam)
for i in 1:100
    img = read(cam)
    sleep(1/fps)
end
```
To change settings such as the frame rate or resolution of the captured frames, set the
appropriate value in the `options` positional argument.
```julia
julia> opts = VideoIO.DEFAULT_CAMERA_OPTIONS
VideoIO.AVDict with 2 entries:
  "framerate"    => "30"
  "pixel_format" => "uyvy422"

julia> opts["framerate"] = "24"
"24"

julia> opts["video_size"] = "640x480"
"640x480"

julia> opencamera(VideoIO.DEFAULT_CAMERA_DEVICE[], VideoIO.DEFAULT_CAMERA_FORMAT[], opts)
VideoReader(...)
```

Or more simply, change the default. For example:
```julia
julia> VideoIO.DEFAULT_CAMERA_OPTIONS["video_size"] = "640x480"

julia> VideoIO.DEFAULT_CAMERA_OPTIONS["framerate"] = 30

julia> julia> opencamera()
VideoReader(...)
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
