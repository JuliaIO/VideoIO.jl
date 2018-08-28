# Julia wrapper for header: /usr/local/ffmpeg/2.4/include/libavutil/pixelutils.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_pixelutils_get_sad_fn


function av_pixelutils_get_sad_fn(w_bits::Integer,h_bits::Integer,aligned::Integer,log_ctx)
    ccall((:av_pixelutils_get_sad_fn,libavutil),av_pixelutils_sad_fn,(Cint,Cint,Cint,Ptr{Cvoid}),w_bits,h_bits,aligned,log_ctx)
end
