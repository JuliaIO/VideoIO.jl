__precompile__(true)

module VideoIO

using FixedPointNumbers, ColorTypes, ImageCore

include("init.jl")

include(joinpath(dirname(@__FILE__), ffmpeg_or_libav, "AVUtil", "src", "AVUtil.jl"))
using .AVUtil
include(joinpath(dirname(@__FILE__), ffmpeg_or_libav, "AVCodecs", "src", "AVCodecs.jl"))
using .AVCodecs
include(joinpath(dirname(@__FILE__), ffmpeg_or_libav, "AVFormat", "src", "AVFormat.jl"))
using .AVFormat
include(joinpath(dirname(@__FILE__), ffmpeg_or_libav, "SWScale", "src", "SWScale.jl"))
using .SWScale

if have_avdevice()
    include(joinpath(dirname(@__FILE__), ffmpeg_or_libav, "AVDevice", "src", "AVDevice.jl"))
    import .AVDevice
    include("camera.jl")
end

include("util.jl")
include("avio.jl")
include("testvideos.jl")
using .TestVideos

function __init__()
    # Register all codecs and formats
    av_register_all()
    av_log_set_level(AVUtil.AV_LOG_ERROR)
    if have_avdevice()
        AVDevice.avdevice_register_all()
    end
end

end # VideoIO
