# Julia wrapper for header: /usr/local/ffmpeg/2.4/include/libavutil/fifo.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_fifo_alloc,
    av_fifo_alloc_array,
    av_fifo_free,
    av_fifo_freep,
    av_fifo_reset,
    av_fifo_size,
    av_fifo_space,
    av_fifo_generic_read,
    av_fifo_generic_write,
    av_fifo_realloc2,
    av_fifo_grow,
    av_fifo_drain,
    av_fifo_peek2


function av_fifo_alloc(size::Integer)
    ccall((:av_fifo_alloc,libavutil),Ptr{AVFifoBuffer},(Uint32,),size)
end

function av_fifo_alloc_array(nmemb::Csize_t,size::Csize_t)
    ccall((:av_fifo_alloc_array,libavutil),Ptr{AVFifoBuffer},(Csize_t,Csize_t),nmemb,size)
end

function av_fifo_free(f)
    ccall((:av_fifo_free,libavutil),Void,(Ptr{AVFifoBuffer},),f)
end

function av_fifo_freep(f)
    ccall((:av_fifo_freep,libavutil),Void,(Ptr{Ptr{AVFifoBuffer}},),f)
end

function av_fifo_reset(f)
    ccall((:av_fifo_reset,libavutil),Void,(Ptr{AVFifoBuffer},),f)
end

function av_fifo_size(f)
    ccall((:av_fifo_size,libavutil),Cint,(Ptr{AVFifoBuffer},),f)
end

function av_fifo_space(f)
    ccall((:av_fifo_space,libavutil),Cint,(Ptr{AVFifoBuffer},),f)
end

function av_fifo_generic_read(f,dest,buf_size::Integer,func)
    ccall((:av_fifo_generic_read,libavutil),Cint,(Ptr{AVFifoBuffer},Ptr{Void},Cint,Ptr{Void}),f,dest,buf_size,func)
end

function av_fifo_generic_write(f,src,size::Integer,func)
    ccall((:av_fifo_generic_write,libavutil),Cint,(Ptr{AVFifoBuffer},Ptr{Void},Cint,Ptr{Void}),f,src,size,func)
end

function av_fifo_realloc2(f,size::Integer)
    ccall((:av_fifo_realloc2,libavutil),Cint,(Ptr{AVFifoBuffer},Uint32),f,size)
end

function av_fifo_grow(f,additional_space::Integer)
    ccall((:av_fifo_grow,libavutil),Cint,(Ptr{AVFifoBuffer},Uint32),f,additional_space)
end

function av_fifo_drain(f,size::Integer)
    ccall((:av_fifo_drain,libavutil),Void,(Ptr{AVFifoBuffer},Cint),f,size)
end

function av_fifo_peek2(f,offs::Integer)
    ccall((:av_fifo_peek2,libavutil),Ptr{Uint8},(Ptr{AVFifoBuffer},Cint),f,offs)
end
