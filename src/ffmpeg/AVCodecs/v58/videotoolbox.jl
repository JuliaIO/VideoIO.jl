# Julia wrapper for header: /usr/include/libavcodec/videotoolbox.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_videotoolbox_alloc_context,
    av_videotoolbox_default_init,
    av_videotoolbox_default_init2,
    av_videotoolbox_default_free


function av_videotoolbox_alloc_context()
    ccall((:av_videotoolbox_alloc_context, libavcodec), Ptr{AVVideotoolboxContext}, ())
end

function av_videotoolbox_default_init(avctx)
    ccall((:av_videotoolbox_default_init, libavcodec), Cint, (Ptr{AVCodecContext},), avctx)
end

function av_videotoolbox_default_init2(avctx, vtctx)
    ccall((:av_videotoolbox_default_init2, libavcodec), Cint, (Ptr{AVCodecContext}, Ptr{AVVideotoolboxContext}), avctx, vtctx)
end

function av_videotoolbox_default_free(avctx)
    ccall((:av_videotoolbox_default_free, libavcodec), Cvoid, (Ptr{AVCodecContext},), avctx)
end
