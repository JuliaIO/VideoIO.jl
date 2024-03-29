module VideoIO

using ColorTypes: RGB, Gray, N0f8, N6f10, YCbCr, Normed, red, green, blue
using Dates
using FileIO: File
using ImageCore: channelview, rawview
using PrecompileTools

using Base: fieldindex, RefValue, cconvert
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

include("deprecations.jl")

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
        append!(CAMERA_DEVICES, get_camera_devices("dshow", "dummy"))
        return DEFAULT_CAMERA_FORMAT[] = libffmpeg.av_find_input_format("dshow")
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        return DEFAULT_CAMERA_DEVICE[] = string("video=", isempty(CAMERA_DEVICES) ? "0" : CAMERA_DEVICES[1])
    end
elseif Sys.isapple()
    function init_camera_devices()
        try
            append!(CAMERA_DEVICES, get_camera_devices("avfoundation", "\"\""))
            DEFAULT_CAMERA_FORMAT[] = libffmpeg.av_find_input_format("avfoundation")
        catch
            try
                append!(CAMERA_DEVICES, get_camera_devices("qtkit", "\"\""))
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
        append!(CAMERA_DEVICES, get_camera_devices("avfoundation", "\"\""))
        return DEFAULT_CAMERA_FORMAT[] = libffmpeg.av_find_input_format("avfoundation")
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        DEFAULT_CAMERA_OPTIONS["pixel_format"] = "uyvy422"
        return DEFAULT_CAMERA_DEVICE[] = isempty(CAMERA_DEVICES) ? "0" : CAMERA_DEVICES[1]
    end
end

## FileIO interface
fileio_load(f::File; kwargs...) = load(f.filename; kwargs...)
fileio_save(f::File, video; kwargs...) = save(f.filename, video; kwargs...)

function __init__()
    loglevel!(libffmpeg.AV_LOG_FATAL)
    # @info "VideoIO: Low-level FFMPEG reporting set to minimal (AV_LOG_FATAL). See `? VideoIO.loglevel!` for options"
    read_packet[] = @cfunction(_read_packet, Cint, (Ptr{AVInput}, Ptr{UInt8}, Cint))
    libffmpeg.avdevice_register_all()
end

@setup_workload begin
    imgstack = map(_->rand(UInt8, 10, 10), 1:10)
    @compile_workload begin
        loglevel!(libffmpeg.AV_LOG_FATAL) # Silence precompilation process
        fname = string(tempname(), ".mp4")
        VideoIO.save(fname, imgstack)
        VideoIO.save(fname, VideoIO.load(fname)) # the loaded video is RGB type
        r = openvideo(fname)
        img = read(r)
        eof(r)
        read!(r, img)
        seekstart(r)
        seek(r, 0.01)
        skipframe(r)
        skipframes(r, 3)
        gettime(r)
        counttotalframes(r)
        close(r)
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
