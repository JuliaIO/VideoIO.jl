# Julia wrapper for header: /usr/local/include/libavutil/mem.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_malloc,
    av_malloc_array,
    av_realloc,
    av_reallocp,
    av_realloc_array,
    av_reallocp_array,
    av_free,
    av_mallocz,
    av_mallocz_array,
    av_strdup,
    av_freep,
    av_memcpy_backptr,
    av_fast_realloc,
    av_fast_malloc


function av_malloc(size::Csize_t)
    ccall((:av_malloc,libavutil),Ptr{Void},(Csize_t,),size)
end

function av_malloc_array(nmemb::Csize_t,size::Csize_t)
    ccall((:av_malloc_array,libavutil),Ptr{Void},(Csize_t,Csize_t),nmemb,size)
end

function av_realloc(ptr,size::Csize_t)
    ccall((:av_realloc,libavutil),Ptr{Void},(Ptr{Void},Csize_t),ptr,size)
end

function av_reallocp(ptr,size::Csize_t)
    ccall((:av_reallocp,libavutil),Cint,(Ptr{Void},Csize_t),ptr,size)
end

function av_realloc_array(ptr,nmemb::Csize_t,size::Csize_t)
    ccall((:av_realloc_array,libavutil),Ptr{Void},(Ptr{Void},Csize_t,Csize_t),ptr,nmemb,size)
end

function av_reallocp_array(ptr,nmemb::Csize_t,size::Csize_t)
    ccall((:av_reallocp_array,libavutil),Cint,(Ptr{Void},Csize_t,Csize_t),ptr,nmemb,size)
end

function av_free(ptr)
    ccall((:av_free,libavutil),Void,(Ptr{Void},),ptr)
end

function av_mallocz(size::Csize_t)
    ccall((:av_mallocz,libavutil),Ptr{Void},(Csize_t,),size)
end

function av_mallocz_array(nmemb::Csize_t,size::Csize_t)
    ccall((:av_mallocz_array,libavutil),Ptr{Void},(Csize_t,Csize_t),nmemb,size)
end

function av_strdup(s)
    ccall((:av_strdup,libavutil),Ptr{UInt8},(Ptr{UInt8},),s)
end

function av_freep(ptr)
    ccall((:av_freep,libavutil),Void,(Ptr{Void},),ptr)
end

function av_memcpy_backptr(dst,back::Integer,cnt::Integer)
    ccall((:av_memcpy_backptr,libavutil),Void,(Ptr{UInt8},Cint,Cint),dst,back,cnt)
end

function av_fast_realloc(ptr,size,min_size::Csize_t)
    ccall((:av_fast_realloc,libavutil),Ptr{Void},(Ptr{Void},Ptr{UInt32},Csize_t),ptr,size,min_size)
end

function av_fast_malloc(ptr,size,min_size::Csize_t)
    ccall((:av_fast_malloc,libavutil),Void,(Ptr{Void},Ptr{UInt32},Csize_t),ptr,size,min_size)
end
