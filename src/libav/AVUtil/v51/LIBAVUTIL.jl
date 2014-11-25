include("libavutil_h.jl")

#include("audioconvert.jl")
include("avutil.jl")
include("dict.jl")
#include("fifo.jl")
include("file.jl")
include("imgutils.jl")
include("log.jl")
include("mem.jl")
include("opt.jl")
include("pixdesc.jl")
include("rational.jl")
#include("samplefmt.jl")

### Manually define av_pix_fmt_desc_get to match later versions
export av_pix_fmt_desc_get

const p_av_pix_fmt_descriptors = cglobal((:av_pix_fmt_descriptors, :libavutil), AVPixFmtDescriptor)
av_pix_fmt_desc_get(n::Integer) = p_av_pix_fmt_descriptors + n*sizeof(AVPixFmtDescriptor)


