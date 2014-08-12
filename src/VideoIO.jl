module VideoIO

include("init.jl")

abstract _AVClass # used to set options on AVClass-enabled types

using AVUtil
using AVCodecs
using AVFormat
using SWScale

include("util.jl")
include("avio.jl")
include("testvideos.jl")
using .TestVideos

end # VideoIO
