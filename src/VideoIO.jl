__precompile__(false)

module VideoIO

using FixedPointNumbers, ColorTypes, ImageCore

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

end # VideoIO
