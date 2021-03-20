module VideoIO

using Libdl
using Requires, Dates, ProgressMeter
using ImageCore: channelview, rawview
using ColorTypes: RGB, Gray, N0f8, N6f10, YCbCr, Normed, red, green, blue

using Base: fieldindex, RefValue, sigatomic_begin, sigatomic_end, cconvert
using Base.GC: @preserve
import Base: iterate, IteratorSize, IteratorEltype, setproperty!, convert,
    getproperty, unsafe_convert, propertynames, getindex, setindex!, parent,
    position, unsafe_wrap, unsafe_copyto!

const VIO_LOCK = ReentrantLock()

include("init.jl")
include("util.jl")
include(joinpath(av_load_path, "AVUtil", "src", "AVUtil.jl"))
include(joinpath(av_load_path, "AVCodecs", "src", "AVCodecs.jl"))
include(joinpath(av_load_path, "AVFormat", "src", "AVFormat.jl"))
include(joinpath(av_load_path, "AVDevice", "src", "AVDevice.jl"))
include(joinpath(av_load_path, "SWScale", "src", "SWScale.jl"))

using .AVUtil
using .AVCodecs
using .AVFormat
using .SWScale
import .AVDevice

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
    import Glob
    function init_camera_devices()
        append!(CAMERA_DEVICES, Glob.glob("video*", "/dev"))
        DEFAULT_CAMERA_FORMAT[] = AVFormat.av_find_input_format("video4linux2")
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        DEFAULT_CAMERA_DEVICE[] = isempty(CAMERA_DEVICES) ? "" : CAMERA_DEVICES[1]
    end
end

if Sys.iswindows()
    function init_camera_devices()
        append!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "dshow", "dummy"))
        DEFAULT_CAMERA_FORMAT[] = AVFormat.av_find_input_format("dshow")
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        DEFAULT_CAMERA_DEVICE[] = string(
            "video=",
            isempty(CAMERA_DEVICES) ? "0" : CAMERA_DEVICES[1]
        )
    end
end

if Sys.isapple()
    function init_camera_devices()
        try
            append!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "avfoundation", "\"\""))
            DEFAULT_CAMERA_FORMAT[] = AVFormat.av_find_input_format("avfoundation")
        catch
            try
                append!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "qtkit", "\"\""))
                DEFAULT_CAMERA_FORMAT[] = AVFormat.av_find_input_format("qtkit")
            catch
            end
        end
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        # Note: "Integrated" is another possible default value
        DEFAULT_CAMERA_OPTIONS["pixel_format"] = "uyvy422"
        DEFAULT_CAMERA_DEVICE[] = isempty(CAMERA_DEVICES) ? "0" : CAMERA_DEVICES[1]
    end
elseif Sys.isbsd()
    # copied loosely from apple above - needs figuring out
    function init_camera_devices()
        append!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "avfoundation", "\"\""))
        DEFAULT_CAMERA_FORMAT[] = AVFormat.av_find_input_format("avfoundation")
    end
    function init_camera_settings()
        DEFAULT_CAMERA_OPTIONS["framerate"] = 30
        DEFAULT_CAMERA_OPTIONS["pixel_format"] = "uyvy422"
        DEFAULT_CAMERA_DEVICE[] = isempty(CAMERA_DEVICES) ? "0" : CAMERA_DEVICES[1]
    end
end

#Helper functions to explain about Makie load order requirement
function play(f; flipx=false, flipy=false)
    error("Makie must be loaded before VideoIO to provide video playback functionality. Try a new session with `using Makie, VideoIO`")
end
function playvideo(video;flipx=false,flipy=false)
    error("Makie must be loaded before VideoIO to provide video playback functionality. Try a new session with `using Makie, VideoIO`")
end
function viewcam(device=DEFAULT_CAMERA_DEVICE, format=DEFAULT_CAMERA_FORMAT)
    error("Makie must be loaded before VideoIO to provide camera playback functionality. Try a new session with `using Makie, VideoIO`")
end

function __init__()
    # Always check your dependencies from `deps.jl`
    # TODO remove uncessary ENV["LD_LIBRARY_PATH"] from check_deps, so that
    # it doesn't mess with LD_LIBRARY_PATH, which was causing CI download issues due to issues with julia's curl
    # since check_deps is optional, I hope this is ok for now

    #check_deps()

    loglevel!(AVUtil.AV_LOG_FATAL)
    # @info "VideoIO: Low-level FFMPEG reporting set to minimal (AV_LOG_FATAL). See `? VideoIO.loglevel!` for options"

    read_packet[] = @cfunction(_read_packet, Cint, (Ptr{AVInput}, Ptr{UInt8}, Cint))

    av_register_all()

    AVDevice.avdevice_register_all()
    init_camera_devices()
    init_camera_settings()

    @require Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" begin
        # Define read and retrieve for Images
        function play(f; flipx=false, flipy=false, pixelaspectratio=nothing)
            if pixelaspectratio ≡ nothing # if user did not specify the aspect ratio we'll try to use the one stored in the video file
                pixelaspectratio = aspect_ratio(f)
            end
            h = f.height
            w = round(typeof(h), f.width*pixelaspectratio) # has to be an integer
            scene = Makie.Scene(resolution = (w, h))
            buf = read(f)
            makieimg = Makie.image!(scene, 1:h, 1:w, buf, show_axis = false, scale_plot = false)[end]
            Makie.rotate!(scene, -0.5pi)
            if flipx && flipy
                Makie.scale!(scene, -1, -1, 1)
            else
                flipx && Makie.scale!(scene, -1, 1, 1)
                flipy && Makie.scale!(scene, 1, -1, 1)
            end
            display(scene)
            while !eof(f) && isopen(scene)
                read!(f, buf)
                makieimg[3] = buf
                sleep(1 / f.framerate)
            end

        end

        function playvideo(video;flipx=false,flipy=false,pixelaspectratio=nothing)
            f = VideoIO.openvideo(video)
            play(f,flipx=flipx,flipy=flipy,pixelaspectratio=pixelaspectratio)
        end

        function viewcam(device=DEFAULT_CAMERA_DEVICE, format=DEFAULT_CAMERA_FORMAT, pixelaspectratio=nothing)
            init_camera_settings()
            camera = opencamera(device[], format[])
            play(camera, flipx=true, pixelaspectratio=pixelaspectratio)
            close(camera)
        end

    end
end

include("precompile.jl")
_precompile()

"""
VideoIO supports reading and writing video files.

- `VideoIO.load` to load an entire video into memory as a vector of images (a framestack)
- `openvideo` and `opencamera` provide access to video files and livestreams
- `read` and `read!` allow reading frames
- `seek`, `seekstart`, `skipframe`, and `skipframes` support access of specific frames
- `VideoIO.save` for encoding an entire framestack in one step
- `open_video_out`, `append_encode_mux!` for writing frames sequentially to a file
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
framestack = map(x->rand(UInt8, 100, 100), 1:100) #vector of 2D arrays
encoder_options = (crf=23, preset="medium")
open_video_out("video.mp4", framestack[1], framerate=24, encoder_options=encoder_options) do writer
    for i in eachindex(framestack)
        append_encode_mux!(writer, framestack[i], i)
    end
end
````
"""
VideoIO

end # VideoIO
