include("libavcodec_h.jl")

include("avcodec.jl")
#include("vdpau.jl")

function Base.unsafe_convert(::Type{Ptr{AVPicture}}, ptr::AVFramePtr)
  return reinterpret(Ptr{AVPicture}, ptr.p)
end
