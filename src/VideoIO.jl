module VideoIO

using Libdl
using Requires, Dates, ProgressMeter
using ImageCore: channelview, rawview
using ColorTypes: RGB, Gray, N0f8, N6f10, YCbCr, Normed, red, green, blue
using FileIO: File

using Base: fieldindex, RefValue, sigatomic_begin, sigatomic_end, cconvert
using Base.GC: @preserve
import Base:
    iterate,
    IteratorSize,
    IteratorEltype,
    setproperty!,
    convert,
    getproperty,
    unsafe_convert,
    propertynames,
    getindex,
    setindex!,
    parent,
    position,
    unsafe_wrap,
    unsafe_copyto!,
    write

const VIO_LOCK = ReentrantLock()

include("util.jl")
include("../lib/libffmpeg.jl")
using .libffmpeg
using FFMPEG: ffmpeg

include("avptr.jl")

include("info.jl")
include("avdictionary.jl")
include("avframe_transfer.jl")
include("frame_graph.jl")
include("avio.jl")
include("encoding.jl")
include("testvideos.jl")
using .TestVideos

if Sys.islinux()
    using Glob: Glob
    function init_camera_devices()
        append!(CAMERA_DEVICES, Glob.glob("video*", "/dev"))
        return DEFAULT_CAMERA_FORMAT[] = libffmpeg.av_find_input_format("video4linux2")
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        return DEFAULT_CAMERA_DEVICE[] = isempty(CAMERA_DEVICES) ? "" : CAMERA_DEVICES[1]
    end
elseif Sys.iswindows()
    function init_camera_devices()
        append!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "dshow", "dummy"))
        return DEFAULT_CAMERA_FORMAT[] = libffmpeg.av_find_input_format("dshow")
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        return DEFAULT_CAMERA_DEVICE[] = string("video=", isempty(CAMERA_DEVICES) ? "0" : CAMERA_DEVICES[1])
    end
elseif Sys.isapple()
    function init_camera_devices()
        try
            append!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "avfoundation", "\"\""))
            DEFAULT_CAMERA_FORMAT[] = libffmpeg.av_find_input_format("avfoundation")
        catch
            try
                append!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "qtkit", "\"\""))
                DEFAULT_CAMERA_FORMAT[] = libffmpeg.av_find_input_format("qtkit")
            catch
            end
        end
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        # Note: "Integrated" is another possible default value
        DEFAULT_CAMERA_OPTIONS["pixel_format"] = "uyvy422"
        return DEFAULT_CAMERA_DEVICE[] = isempty(CAMERA_DEVICES) ? "0" : CAMERA_DEVICES[1]
    end
elseif Sys.isbsd()
    # copied loosely from apple above - needs figuring out
    function init_camera_devices()
        append!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "avfoundation", "\"\""))
        return DEFAULT_CAMERA_FORMAT[] = libffmpeg.av_find_input_format("avfoundation")
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        DEFAULT_CAMERA_OPTIONS["pixel_format"] = "uyvy422"
        return DEFAULT_CAMERA_DEVICE[] = isempty(CAMERA_DEVICES) ? "0" : CAMERA_DEVICES[1]
    end
end

#Helper functions to explain about GLMakie load order requirement
function play(f; flipx = false, flipy = false)
    return error(
        "GLMakie must be loaded before VideoIO to provide video playback functionality. Try a new session with `using GLMakie, VideoIO`",
    )
end
function playvideo(video; flipx = false, flipy = false)
    return error(
        "GLMakie must be loaded before VideoIO to provide video playback functionality. Try a new session with `using GLMakie, VideoIO`",
    )
end
function viewcam(device = DEFAULT_CAMERA_DEVICE, format = DEFAULT_CAMERA_FORMAT)
    return error(
        "GLMakie must be loaded before VideoIO to provide camera playback functionality. Try a new session with `using GLMakie, VideoIO`",
    )
end

## FileIO interface
fileio_load(f::File; kwargs...) = load(f.filename; kwargs...)
fileio_save(f::File, video; kwargs...) = save(f.filename, video; kwargs...)

function __init__()
    # Always check your dependencies from `deps.jl`
    # TODO remove uncessary ENV["LD_LIBRARY_PATH"] from check_deps, so that
    # it doesn't mess with LD_LIBRARY_PATH, which was causing CI download issues due to issues with julia's curl
    # since check_deps is optional, I hope this is ok for now

    #check_deps()

    loglevel!(libffmpeg.AV_LOG_FATAL)
    # @info "VideoIO: Low-level FFMPEG reporting set to minimal (AV_LOG_FATAL). See `? VideoIO.loglevel!` for options"

    read_packet[] = @cfunction(_read_packet, Cint, (Ptr{AVInput}, Ptr{UInt8}, Cint))

    av_register_all()

    libffmpeg.avdevice_register_all()

    @require GLMakie = "e9467ef8-e4e7-5192-8a1a-b1aee30e663a" begin
        # Define read and retrieve for Images
        function play(f; flipx = false, flipy = false, pixelaspectratio = nothing)
            eof(f) && error("VideoReader at end of file. Use `seekstart(f)` to rewind")
            # if user did not specify the aspect ratio we'll try to use the one stored in the video file
            pixelaspectratio = @something pixelaspectratio aspect_ratio(f)
            h = height(f)
            w = round(typeof(h), width(f) * pixelaspectratio) # has to be an integer
            flips_to_dims = Dict(
                (true, true) => (1, 2),
                (true, false) => 1,
                (false, true) => 2,
                (false, false) => nothing,
            )
            flipping_dims = flips_to_dims[(flipx, flipy)]
            flipping = i -> i
            if flipping_dims !== nothing
                flipping = i -> reverse(i, dims = flipping_dims)
            end
            flip_and_rotate = i -> begin
                rotated = GLMakie.rotr90(i)
                flipping(rotated)
            end
            img = read(f)
            obs_img = GLMakie.Observable(flip_and_rotate(img))
            scene =
                GLMakie.Scene(camera = GLMakie.campixel!, resolution = reverse(size(img)))

            GLMakie.image!(scene, obs_img)
            display(scene)
            # issue 343: camera can't run at full speed on MacOS
            fps = Sys.isapple() ? min(framerate(f), 24) : framerate(f)
            while isopen(scene) && !eof(f)
                read!(f, img)
                obs_img[] = flip_and_rotate(img)
                sleep(1 / fps)
            end
        end

        function playvideo(video; flipx = false, flipy = false, pixelaspectratio = nothing)
            f = VideoIO.openvideo(video)
            try
                play(f, flipx=flipx, flipy=flipy, pixelaspectratio=pixelaspectratio)
            finally
                close(f)
            end
        end

        function viewcam(device=nothing, format=nothing, options=nothing, pixelaspectratio=nothing)
            camera = opencamera(device, format, options)
            try
                play(camera; flipx=true, pixelaspectratio)
            finally
                close(camera)
            end
        end
    end
end

"""
VideoIO supports reading and writing video files.

  - `VideoIO.load` to load an entire video into memory as a vector of images (a framestack)
  - `openvideo` and `opencamera` provide access to video files and livestreams
  - `read` and `read!` allow reading frames
  - `seek`, `seekstart`, `skipframe`, and `skipframes` support access of specific frames
  - `VideoIO.save` for encoding an entire framestack in one step
  - `open_video_out`, `write` for writing frames sequentially to a file
  - `gettime` and `counttotalframes` provide information

Here's a brief demo reading through each frame of a video:

```julia
using VideoIO
r = openvideo(filename)
img = read(r)
while !eof(r)
    read!(r, img)
end
```

An example of encoding one frame at a time:

```julia
using VideoIO
framestack = map(x -> rand(UInt8, 100, 100), 1:100) #vector of 2D arrays
encoder_options = (crf = 23, preset = "medium")
open_video_out("video.mp4", framestack[1], framerate = 24, encoder_options = encoder_options) do writer
    for frame in framestack
        write(writer, frame)
    end
end
```
"""
VideoIO

end # VideoIO
