include("libavutil_h.jl")

#include("aes_ctr.jl")
#include("audio_fifo.jl")
#include("avutil.jl")
#include("buffer.jl")
#include("camellia.jl")
#include("cast5.jl")
#include("channel_layout.jl")
#include("des.jl")
#include("dict.jl")
#include("display.jl")
#include("downmix_info.jl")
#include("fifo.jl")
#include("file.jl")
#include("frame.jl")
#include("hash.jl")
#include("imgutils.jl")
include("log.jl")
#include("mastering_display_metadata.jl")
include("mem.jl")
#include("motion_vector.jl")
#include("opencl.jl")
#include("opt.jl")
include("pixdesc.jl")
#include("pixelutils.jl")
#include("pixfmt.jl")
#include("rational.jl")
#include("rc4.jl")
#include("replaygain.jl")
#include("samplefmt.jl")
#include("stereo3d.jl")
#include("tea.jl")
#include("threadmessage.jl")
#include("timecode.jl")
#include("tree.jl")
#include("twofish.jl")
#include("version.jl")
#include("xtea.jl")

using Compat

function AVFrame()
    ns = fieldnames(AVFrame)
    ts = AVFrame.types
    parms = [T <: Ptr ? C_NULL : zero(T) for T in ts]

    fmt_pos = findfirst(ns, :format)
    parms[fmt_pos] = -one(ts[fmt_pos])

    pts_pos = findfirst(ns, :pts)
    parms[pts_pos] = AV_NOPTS_VALUE

    AVFrame(parms...)
end
