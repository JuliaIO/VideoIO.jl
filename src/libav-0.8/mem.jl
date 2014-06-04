# Julia wrapper for header: /usr/include/libavutil/mem.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_malloc(size::Csize_t)
    ccall((:av_malloc,libavutil),Ptr{Void},(Csize_t,),size)
end
function av_realloc(_ptr::Ptr,size::Csize_t)
    ptr = convert(Ptr{Void},_ptr)
    ccall((:av_realloc,libavutil),Ptr{Void},(Ptr{Void},Csize_t),ptr,size)
end
function av_free(_ptr::Ptr)
    ptr = convert(Ptr{Void},_ptr)
    ccall((:av_free,libavutil),Void,(Ptr{Void},),ptr)
end
function av_mallocz(size::Csize_t)
    ccall((:av_mallocz,libavutil),Ptr{Void},(Csize_t,),size)
end
function av_strdup(_s::Union(Ptr,ByteString))
    s = convert(Ptr{Uint8},_s)
    ccall((:av_strdup,libavutil),Ptr{Uint8},(Ptr{Uint8},),s)
end
function av_freep(_ptr::Ptr)
    ptr = convert(Ptr{Void},_ptr)
    ccall((:av_freep,libavutil),Void,(Ptr{Void},),ptr)
end
