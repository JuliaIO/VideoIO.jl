module VideoIO

using Libdl
using FixedPointNumbers, ColorTypes, ImageCore, Requires, Dates

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

if have_avdevice()
    import .AVDevice
end

include("info.jl")
include("avio.jl")
include("testvideos.jl")
using .TestVideos

if Sys.islinux()
    import Glob
end

function __init__()
    # Always check your dependencies from `deps.jl`
    # TODO remove uncessary ENV["LD_LIBRARY_PATH"] from check_deps, so that
    # it doesn't mess with LD_LIBRARY_PATH
    # since check_deps is optional, I hope this is ok for now

    # check_deps()

    global read_packet
    read_packet[] = @cfunction(_read_packet, Cint, (Ptr{AVInput}, Ptr{UInt8}, Cint))

    av_register_all()

    if have_avdevice()
        AVDevice.avdevice_register_all()

        if Sys.iswindows()
            global DEFAULT_CAMERA_FORMAT = AVFormat.av_find_input_format("dshow")
            global CAMERA_DEVICES
            push!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "dshow", "dummy")...)
            global DEFAULT_CAMERA_DEVICE = length(CAMERA_DEVICES) > 0 ? CAMERA_DEVICES[1] : "0"

        end

        if Sys.islinux()
            global DEFAULT_CAMERA_FORMAT = AVFormat.av_find_input_format("video4linux2")
            global CAMERA_DEVICES = Glob.glob("video*", "/dev")
            global DEFAULT_CAMERA_DEVICE = length(CAMERA_DEVICES) > 0 ? CAMERA_DEVICES[1] : ""
        end

        if Sys.isapple()
            global CAMERA_DEVICES = String[]
            try
                global CAMERA_DEVICES = get_camera_devices(ffmpeg, "avfoundation", "\"\"")
                global DEFAULT_CAMERA_FORMAT = AVFormat.av_find_input_format("avfoundation")
            catch
                try
                    global CAMERA_DEVICES = get_camera_devices(ffmpeg, "qtkit", "\"\"")
                    global DEFAULT_CAMERA_FORMAT = AVFormat.av_find_input_format("qtkit")
                catch
                end
            end

            # Note: "Integrated" is another possible default value
            DEFAULT_CAMERA_DEVICE = length(CAMERA_DEVICES) > 0 ? CAMERA_DEVICES[1] : "FaceTime"
        end
    end

    @require Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" begin
        # Define read and retrieve for Images
        function play(f, flip=false)
            scene = Makie.Scene(resolution = (f.width, f.height))
            
            buf = read(f)
            hmap = Makie.image!(scene,buf, show_axis = false, scale_plot = false)[end]
            Makie.rotate!(scene, -0.5pi)
            display(scene)

            while !eof(f)
                read!(f, buf)
                hmap[1] = buf
                sleep(1 / f.framerate)
            end
        end

        function playvideo(video)
            f = VideoIO.openvideo(video)
            play(f)
        end

        if have_avdevice()
            function viewcam(device=DEFAULT_CAMERA_DEVICE, format=DEFAULT_CAMERA_FORMAT)
                camera = opencamera(device, format)
                play(camera, true)
            end
        else
            function viewcam()
                error("libavdevice not present")
            end
        end
    end
end


end # VideoIO
