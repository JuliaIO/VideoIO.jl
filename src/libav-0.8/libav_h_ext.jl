### Libraries
const libavutil = :libavutil
const libavformat = :libavformat
const libavcodec = :libavcodec
const libswscale = :libswscale

### Aliases
typealias AVResampleContext Void
typealias FILE Void
typealias SwsContext Void
typealias AVAES Void

###
include("exports.jl")
include("libav_h.jl")
include("avutil.jl")
include("pixdesc.jl")

### Manually defined global var, func
const p_av_pix_fmt_descriptors = cglobal((:av_pix_fmt_descriptors, :libavutil), AVPixFmtDescriptor)
get_pix_fmt_descriptor_ptr(n::Integer) = p_av_pix_fmt_descriptors + n*sizeof(AVPixFmtDescriptor)

