# Julia wrapper for header: /usr/include/libavcodec/mediacodec.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_mediacodec_alloc_context,
    av_mediacodec_default_init,
    av_mediacodec_default_free,
    av_mediacodec_release_buffer,
    av_mediacodec_render_buffer_at_time


function av_mediacodec_alloc_context()
    ccall((:av_mediacodec_alloc_context, libavcodec), Ptr{AVMediaCodecContext}, ())
end

function av_mediacodec_default_init(avctx, ctx, surface)
    ccall((:av_mediacodec_default_init, libavcodec), Cint, (Ptr{AVCodecContext}, Ptr{AVMediaCodecContext}, Ptr{Cvoid}), avctx, ctx, surface)
end

function av_mediacodec_default_free(avctx)
    ccall((:av_mediacodec_default_free, libavcodec), Cvoid, (Ptr{AVCodecContext},), avctx)
end

function av_mediacodec_release_buffer(buffer, render::Integer)
    ccall((:av_mediacodec_release_buffer, libavcodec), Cint, (Ptr{AVMediaCodecBuffer}, Cint), buffer, render)
end

function av_mediacodec_render_buffer_at_time(buffer, time::Int64)
    ccall((:av_mediacodec_render_buffer_at_time, libavcodec), Cint, (Ptr{AVMediaCodecBuffer}, Int64), buffer, time)
end
