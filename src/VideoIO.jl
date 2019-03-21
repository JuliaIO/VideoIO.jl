module VideoIO

using FixedPointNumbers, ColorTypes, ImageCore, Requires

include("init.jl")
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
include("avio.jl")
include("testvideos.jl")
using .TestVideos

if Sys.islinux()
    import Glob
end

function __init__()
    global read_packet
    read_packet[] = @cfunction(_read_packet, Cint, (Ptr{AVInput}, Ptr{UInt8}, Cint))

    av_register_all()

    if have_avdevice()
        AVDevice.avdevice_register_all()

        if Sys.iswindows()
            ffmpeg = joinpath(dirname(@__FILE__), "..", "deps", "ffmpeg-4.1-win$(Sys.WORD_SIZE)-shared", "bin", "ffmpeg.exe")

            global DEFAULT_CAMERA_FORMAT = AVFormat.av_find_input_format("dshow")
            global CAMERA_DEVICES
            push!(CAMERA_DEVICES, get_camera_devices(ffmpeg, "dshow", "dummy")...)
            global DEFAULT_CAMERA_DEVICE = "video=" * (length(CAMERA_DEVICES) > 0 ? "\"$(CAMERA_DEVICES[1])\"" : "0")

        end

        if Sys.islinux()
            global DEFAULT_CAMERA_FORMAT = AVFormat.av_find_input_format("video4linux2")
            global CAMERA_DEVICES = Glob.glob("video*", "/dev")
            global DEFAULT_CAMERA_DEVICE = length(CAMERA_DEVICES) > 0 ? CAMERA_DEVICES[1] : ""
        end

        if Sys.isapple()
            ffmpeg = joinpath(INSTALL_ROOT, "bin", "ffmpeg")

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

    @require ImageView = "86fae568-95e7-573e-a6b2-d8a6b900c9ef" begin
        # Define read and retrieve for Images
        function play(f, flip=false)
            buf = read(f)
            canvas, _ = ImageView.imshow(buf, flipx=flip, interactive=false)

            while !eof(f)
                read!(f, buf)
                ImageView.imshow(canvas, buf, flipx=flip, interactive=false)
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
