# Julia wrapper for header: /opt/ffmpeg/include/libavcodec/vdpau.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_alloc_vdpaucontext,
    av_vdpau_hwaccel_get_render2,
    av_vdpau_hwaccel_set_render2,
    av_vdpau_alloc_context,
    av_vdpau_get_profile


function av_alloc_vdpaucontext()
    ccall((:av_alloc_vdpaucontext,libavcodec),Ptr{AVVDPAUContext},())
end

function av_vdpau_hwaccel_get_render2(arg1)
    ccall((:av_vdpau_hwaccel_get_render2,libavcodec),AVVDPAU_Render2,(Ptr{AVVDPAUContext},),arg1)
end

function av_vdpau_hwaccel_set_render2(arg1,arg2::AVVDPAU_Render2)
    ccall((:av_vdpau_hwaccel_set_render2,libavcodec),Void,(Ptr{AVVDPAUContext},AVVDPAU_Render2),arg1,arg2)
end

function av_vdpau_alloc_context()
    ccall((:av_vdpau_alloc_context,libavcodec),Ptr{AVVDPAUContext},())
end

function av_vdpau_get_profile(avctx,profile)
    ccall((:av_vdpau_get_profile,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{VdpDecoderProfile}),avctx,profile)
end
