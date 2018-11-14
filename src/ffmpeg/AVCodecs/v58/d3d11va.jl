# Julia wrapper for header: /usr/include/libavcodec/d3d11va.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_d3d11va_alloc_context


function av_d3d11va_alloc_context()
    ccall((:av_d3d11va_alloc_context, libavcodec), Ptr{AVD3D11VAContext}, ())
end
