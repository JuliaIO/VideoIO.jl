include("../../../util.jl")
include("libavcodec_h.jl")

include("avcodec.jl")

const AV_NOPTS_VALUE  =  reinterpret(Int64, 0x8000000000000000)

function AVFrame()
    ts = AVFrame.types
    parms = [T <: Ptr ? C_NULL : zero(T) for T in ts]

    fmt_pos = fieldposition(AVFrame, :format)
    parms[fmt_pos] = -one(ts[fmt_pos])

    pts_pos = fieldposition(AVFrame, :pts)
    parms[pts_pos] = AV_NOPTS_VALUE

    AVFrame(parms...)
end
