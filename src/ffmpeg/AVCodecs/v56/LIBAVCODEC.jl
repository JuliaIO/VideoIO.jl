include("libavcodec_h.jl")

include("avcodec.jl")
#include("dv_profile.jl")
#include("vaapi.jl")
#include("vdpau.jl")
#include("xvmc.jl")

function Base.unsafe_convert(::Type{Ptr{AVPicture}}, ptr::AVFramePtr)
  return reinterpret(Ptr{AVPicture}, ptr.p)
end
