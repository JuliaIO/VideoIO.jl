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

include("util.jl")
include("avdictionary.jl")
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
            DEFAULT_CAMERA_FORMAT[] = AVFormat.av_find_input_format("dshow")
            push!(CAMERA_DEVICES[], get_camera_devices(ffmpeg, "dshow", "dummy")...)
            DEFAULT_CAMERA_DEVICE[] = "video=" * (length(CAMERA_DEVICES[]) > 0 ? "\"$(CAMERA_DEVICES[1])\"" : "0")
            DEFAULT_CAMERA_OPTIONS[] = AVDict("framerate" => 30)

        end

        if Sys.islinux()
            DEFAULT_CAMERA_FORMAT[] = AVFormat.av_find_input_format("video4linux2")
            CAMERA_DEVICES[] = Glob.glob("video*", "/dev")
            DEFAULT_CAMERA_DEVICE[] = length(CAMERA_DEVICES[]) > 0 ? CAMERA_DEVICES[][1] : ""
            DEFAULT_CAMERA_OPTIONS[] = AVDict("framerate" => 30)
        end

        if Sys.isapple()
            CAMERA_DEVICES[] = String[]
            try
                CAMERA_DEVICES[] = get_camera_devices(ffmpeg, "avfoundation", "\"\"")
                DEFAULT_CAMERA_FORMAT[] = AVFormat.av_find_input_format("avfoundation")
            catch
                try
                    CAMERA_DEVICES[] = get_camera_devices(ffmpeg, "qtkit", "\"\"")
                    DEFAULT_CAMERA_FORMAT[] = AVFormat.av_find_input_format("qtkit")
                catch
                end
            end

            # Note: "Integrated" is another possible default value
            DEFAULT_CAMERA_DEVICE[] = length(CAMERA_DEVICES[]) > 0 ? CAMERA_DEVICES[][1] : "0"
            DEFAULT_CAMERA_OPTIONS[] = AVDict("framerate" => 30, "pixel_format" => "uyvy422")

        end
    end

    @require Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" begin
        # Define read and retrieve for Images
        function play(f; flipx=false, flipy=false)
            scene = Makie.Scene(resolution = (f.width, f.height))
            buf = read(f)
            makieimg = Makie.image!(scene,buf, show_axis = false, scale_plot = false)[end]
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
                makieimg[1] = buf
                sleep(1 / f.framerate)
            end
        end

        function playvideo(video;flipx=false,flipy=false)
            f = VideoIO.openvideo(video)
            play(f,flipx=flipx,flipy=flipy)
        end

        if have_avdevice()
            function viewcam(device=DEFAULT_CAMERA_DEVICE, format=DEFAULT_CAMERA_FORMAT)
                camera = opencamera(device[], format[])
                play(camera, flipx=true)
                close(camera)
            end
        else
            function viewcam()
                error("libavdevice not present")
            end
        end
    end
end


end # VideoIO
