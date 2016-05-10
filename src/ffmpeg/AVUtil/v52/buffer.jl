# Julia wrapper for header: /opt/ffmpeg/include/libavutil/buffer.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffer_alloc,
    av_buffer_allocz,
    av_buffer_create,
    av_buffer_default_free,
    av_buffer_ref,
    av_buffer_unref,
    av_buffer_is_writable,
    av_buffer_get_opaque,
    av_buffer_get_ref_count,
    av_buffer_make_writable,
    av_buffer_realloc,
    av_buffer_pool_init,
    av_buffer_pool_uninit,
    av_buffer_pool_get


function av_buffer_alloc(size::Integer)
    ccall((:av_buffer_alloc,libavutil),Ptr{AVBufferRef},(Cint,),size)
end

function av_buffer_allocz(size::Integer)
    ccall((:av_buffer_allocz,libavutil),Ptr{AVBufferRef},(Cint,),size)
end

function av_buffer_create(data,size::Integer,free,opaque,flags::Integer)
    ccall((:av_buffer_create,libavutil),Ptr{AVBufferRef},(Ptr{UInt8},Cint,Ptr{Void},Ptr{Void},Cint),data,size,free,opaque,flags)
end

function av_buffer_default_free(opaque,data)
    ccall((:av_buffer_default_free,libavutil),Void,(Ptr{Void},Ptr{UInt8}),opaque,data)
end

function av_buffer_ref(buf)
    ccall((:av_buffer_ref,libavutil),Ptr{AVBufferRef},(Ptr{AVBufferRef},),buf)
end

function av_buffer_unref(buf)
    ccall((:av_buffer_unref,libavutil),Void,(Ptr{Ptr{AVBufferRef}},),buf)
end

function av_buffer_is_writable(buf)
    ccall((:av_buffer_is_writable,libavutil),Cint,(Ptr{AVBufferRef},),buf)
end

function av_buffer_get_opaque(buf)
    ccall((:av_buffer_get_opaque,libavutil),Ptr{Void},(Ptr{AVBufferRef},),buf)
end

function av_buffer_get_ref_count(buf)
    ccall((:av_buffer_get_ref_count,libavutil),Cint,(Ptr{AVBufferRef},),buf)
end

function av_buffer_make_writable(buf)
    ccall((:av_buffer_make_writable,libavutil),Cint,(Ptr{Ptr{AVBufferRef}},),buf)
end

function av_buffer_realloc(buf,size::Integer)
    ccall((:av_buffer_realloc,libavutil),Cint,(Ptr{Ptr{AVBufferRef}},Cint),buf,size)
end

function av_buffer_pool_init(size::Integer,alloc)
    ccall((:av_buffer_pool_init,libavutil),Ptr{AVBufferPool},(Cint,Ptr{Void}),size,alloc)
end

function av_buffer_pool_uninit(pool)
    ccall((:av_buffer_pool_uninit,libavutil),Void,(Ptr{Ptr{AVBufferPool}},),pool)
end

function av_buffer_pool_get(pool)
    ccall((:av_buffer_pool_get,libavutil),Ptr{AVBufferRef},(Ptr{AVBufferPool},),pool)
end
