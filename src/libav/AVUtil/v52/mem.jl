# Julia wrapper for header: /usr/include/libavutil/mem.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_malloc,
    av_malloc_array,
    av_realloc,
    av_free,
    av_mallocz,
    av_mallocz_array,
    av_strdup,
    av_freep,
    av_memcpy_backptr


function av_malloc(size::Csize_t)
    ccall((:av_malloc,libavutil),Ptr{Cvoid},(Csize_t,),size)
end

function av_malloc_array(nmemb::Csize_t,size::Csize_t)
    ccall((:av_malloc_array,libavutil),Ptr{Cvoid},(Csize_t,Csize_t),nmemb,size)
end

function av_realloc(ptr,size::Csize_t)
    ccall((:av_realloc,libavutil),Ptr{Cvoid},(Ptr{Cvoid},Csize_t),ptr,size)
end

function av_free(ptr)
    ccall((:av_free,libavutil),Cvoid,(Ptr{Cvoid},),ptr)
end

function av_mallocz(size::Csize_t)
    ccall((:av_mallocz,libavutil),Ptr{Cvoid},(Csize_t,),size)
end

function av_mallocz_array(nmemb::Csize_t,size::Csize_t)
    ccall((:av_mallocz_array,libavutil),Ptr{Cvoid},(Csize_t,Csize_t),nmemb,size)
end

function av_strdup(s)
    ccall((:av_strdup,libavutil),Ptr{UInt8},(Ptr{UInt8},),s)
end

function av_freep(ptr)
    ccall((:av_freep,libavutil),Cvoid,(Ptr{Cvoid},),ptr)
end

function av_memcpy_backptr(dst,back::Integer,cnt::Integer)
    ccall((:av_memcpy_backptr,libavutil),Cvoid,(Ptr{UInt8},Cint,Cint),dst,back,cnt)
end
