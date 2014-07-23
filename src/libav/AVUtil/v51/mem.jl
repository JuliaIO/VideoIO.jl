# Julia wrapper for header: /usr/local/include/libavutil/mem.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_malloc,
    av_realloc,
    av_free,
    av_mallocz,
    av_strdup,
    av_freep


function av_malloc(size::Csize_t)
    ccall((:av_malloc,libavutil),Ptr{Void},(Csize_t,),size)
end

function av_realloc(ptr,size::Csize_t)
    ccall((:av_realloc,libavutil),Ptr{Void},(Ptr{Void},Csize_t),ptr,size)
end

function av_free(ptr)
    ccall((:av_free,libavutil),Void,(Ptr{Void},),ptr)
end

function av_mallocz(size::Csize_t)
    ccall((:av_mallocz,libavutil),Ptr{Void},(Csize_t,),size)
end

function av_strdup(s)
    ccall((:av_strdup,libavutil),Ptr{Uint8},(Ptr{Uint8},),s)
end

function av_freep(ptr)
    ccall((:av_freep,libavutil),Void,(Ptr{Void},),ptr)
end
