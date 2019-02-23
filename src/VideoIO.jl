module VideoIO

using Libdl
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

include("util.jl")
include("avio.jl")
include("testvideos.jl")
using .TestVideos

function __init__()
    global read_packet  =  @cfunction(_read_packet, Cint, (Ptr{AVInput}, Ptr{UInt8}, Cint))
    # Always check your dependencies from `deps.jl`
    check_deps()
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
