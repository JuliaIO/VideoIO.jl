# Julia wrapper for header: /opt/ffmpeg/include/libavutil/mem.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_malloc,
    av_malloc_array,
    av_realloc,
    av_realloc_f,
    av_reallocp,
    av_realloc_array,
    av_reallocp_array,
    av_free,
    av_mallocz,
    av_calloc,
    av_mallocz_array,
    av_strdup,
    av_memdup,
    av_freep,
    av_dynarray_add,
    av_dynarray_add_nofree,
    av_dynarray2_add,
    av_size_mult,
    av_max_alloc,
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

function av_realloc_f(ptr,nelem::Csize_t,elsize::Csize_t)
    ccall((:av_realloc_f,libavutil),Ptr{Void},(Ptr{Void},Csize_t,Csize_t),ptr,nelem,elsize)
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

function av_calloc(nmemb::Csize_t,size::Csize_t)
    ccall((:av_calloc,libavutil),Ptr{Void},(Csize_t,Csize_t),nmemb,size)
end

function av_mallocz_array(nmemb::Csize_t,size::Csize_t)
    ccall((:av_mallocz_array,libavutil),Ptr{Void},(Csize_t,Csize_t),nmemb,size)
end

function av_strdup(s)
    ccall((:av_strdup,libavutil),Ptr{Uint8},(Ptr{Uint8},),s)
end

function av_memdup(p,size::Csize_t)
    ccall((:av_memdup,libavutil),Ptr{Void},(Ptr{Void},Csize_t),p,size)
end

function av_freep(ptr)
    ccall((:av_freep,libavutil),Void,(Ptr{Void},),ptr)
end

function av_dynarray_add(tab_ptr,nb_ptr,elem)
    ccall((:av_dynarray_add,libavutil),Void,(Ptr{Void},Ptr{Cint},Ptr{Void}),tab_ptr,nb_ptr,elem)
end

function av_dynarray_add_nofree(tab_ptr,nb_ptr,elem)
    ccall((:av_dynarray_add_nofree,libavutil),Cint,(Ptr{Void},Ptr{Cint},Ptr{Void}),tab_ptr,nb_ptr,elem)
end

function av_dynarray2_add(tab_ptr,nb_ptr,elem_size::Csize_t,elem_data)
    ccall((:av_dynarray2_add,libavutil),Ptr{Void},(Ptr{Ptr{Void}},Ptr{Cint},Csize_t,Ptr{Uint8}),tab_ptr,nb_ptr,elem_size,elem_data)
end

function av_size_mult(a::Csize_t,b::Csize_t,r)
    ccall((:av_size_mult,libavutil),Cint,(Csize_t,Csize_t,Ptr{Csize_t}),a,b,r)
end

function av_max_alloc(max::Csize_t)
    ccall((:av_max_alloc,libavutil),Void,(Csize_t,),max)
end

function av_memcpy_backptr(dst,back::Integer,cnt::Integer)
    ccall((:av_memcpy_backptr,libavutil),Void,(Ptr{Uint8},Cint,Cint),dst,back,cnt)
end

function av_fast_realloc(ptr,size,min_size::Csize_t)
    ccall((:av_fast_realloc,libavutil),Ptr{Void},(Ptr{Void},Ptr{Uint32},Csize_t),ptr,size,min_size)
end

function av_fast_malloc(ptr,size,min_size::Csize_t)
    ccall((:av_fast_malloc,libavutil),Void,(Ptr{Void},Ptr{Uint32},Csize_t),ptr,size,min_size)
end
