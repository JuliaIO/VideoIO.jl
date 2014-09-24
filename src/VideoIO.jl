module VideoIO

include("init.jl")

using AVUtil
using AVCodecs
using AVFormat
using AVDevice
using SWScale

include("util.jl")
include("avio.jl")
include("avoptions.jl")
include("testvideos.jl")
using .TestVideos

end # VideoIO
