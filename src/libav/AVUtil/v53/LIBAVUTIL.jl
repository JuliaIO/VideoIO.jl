include("../../../util.jl")
include("libavutil_h.jl")

#include("audio_fifo.jl")
#include("avutil.jl")
#include("buffer.jl")
#include("channel_layout.jl")
include("dict.jl")
#include("downmix_info.jl")
#include("fifo.jl")
#include("file.jl")
#include("frame.jl")
#include("imgutils.jl")
include("log.jl")
include("mem.jl")
include("opt.jl")
include("pixdesc.jl")
#include("rational.jl")
#include("samplefmt.jl")
#include("stereo3d.jl")
#include("xtea.jl")

function AVFrame()
    ts = AVFrame.types
    parms = [T <: Ptr ? C_NULL : zero(T) for T in ts]

    fmt_pos = fieldposition(AVFrame, :format)
    parms[fmt_pos] = -one(ts[fmt_pos])

    pts_pos = fieldposition(AVFrame, :pts)
    parms[pts_pos] = AV_NOPTS_VALUE

    AVFrame(parms...)
end
