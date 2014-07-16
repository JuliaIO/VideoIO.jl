include("libavcodec_h.jl")

include("avcodec.jl")

const AV_NOPTS_VALUE = int64( 0x8000000000000000 )

function AVFrame()
    ns = names(AVFrame)
    ts = AVFrame.types
    parms = [zero(T) for T in ts]

    fmt_pos = findfirst(ns, :format)
    parms[fmt_pos] = -one(ts[fmt_pos])

    pts_pos = findfirst(ns, :pts)
    parms[pts_pos] = AV_NOPTS_VALUE

    AVFrame(parms...)
end
