# Julia wrapper for header: /usr/local/include/libavcodec/vdpau.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_vdpau_alloc_context,
    av_vdpau_get_profile


function av_vdpau_alloc_context()
    ccall((:av_vdpau_alloc_context,libavcodec),Ptr{AVVDPAUContext},())
end

function av_vdpau_get_profile(avctx,profile)
    ccall((:av_vdpau_get_profile,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{VdpDecoderProfile}),avctx,profile)
end
