# Julia wrapper for header: /usr/include/libavutil/fifo.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_fifo_alloc(_size::Integer)
    size = uint32(_size)
    ccall((:av_fifo_alloc,libavutil),Ptr{AVFifoBuffer},(Uint32,),size)
end
function av_fifo_free(_f::Ptr)
    f = convert(Ptr{AVFifoBuffer},_f)
    ccall((:av_fifo_free,libavutil),Void,(Ptr{AVFifoBuffer},),f)
end
function av_fifo_reset(_f::Ptr)
    f = convert(Ptr{AVFifoBuffer},_f)
    ccall((:av_fifo_reset,libavutil),Void,(Ptr{AVFifoBuffer},),f)
end
function av_fifo_size(_f::Ptr)
    f = convert(Ptr{AVFifoBuffer},_f)
    ccall((:av_fifo_size,libavutil),Cint,(Ptr{AVFifoBuffer},),f)
end
function av_fifo_space(_f::Ptr)
    f = convert(Ptr{AVFifoBuffer},_f)
    ccall((:av_fifo_space,libavutil),Cint,(Ptr{AVFifoBuffer},),f)
end
function av_fifo_generic_read(_f::Ptr,_dest::Ptr,_buf_size::Integer,_func::Ptr)
    f = convert(Ptr{AVFifoBuffer},_f)
    dest = convert(Ptr{Void},_dest)
    buf_size = int32(_buf_size)
    func = convert(Ptr{Void},_func)
    ccall((:av_fifo_generic_read,libavutil),Cint,(Ptr{AVFifoBuffer},Ptr{Void},Cint,Ptr{Void}),f,dest,buf_size,func)
end
function av_fifo_generic_write(_f::Ptr,_src::Ptr,_size::Integer,_func::Ptr)
    f = convert(Ptr{AVFifoBuffer},_f)
    src = convert(Ptr{Void},_src)
    size = int32(_size)
    func = convert(Ptr{Void},_func)
    ccall((:av_fifo_generic_write,libavutil),Cint,(Ptr{AVFifoBuffer},Ptr{Void},Cint,Ptr{Void}),f,src,size,func)
end
function av_fifo_realloc2(_f::Ptr,_size::Integer)
    f = convert(Ptr{AVFifoBuffer},_f)
    size = uint32(_size)
    ccall((:av_fifo_realloc2,libavutil),Cint,(Ptr{AVFifoBuffer},Uint32),f,size)
end
function av_fifo_drain(_f::Ptr,_size::Integer)
    f = convert(Ptr{AVFifoBuffer},_f)
    size = int32(_size)
    ccall((:av_fifo_drain,libavutil),Void,(Ptr{AVFifoBuffer},Cint),f,size)
end
function av_fifo_peek2(_f::Ptr,_offs::Integer)
    f = convert(Ptr{AVFifoBuffer},_f)
    offs = int32(_offs)
    ccall((:av_fifo_peek2,libavutil),Ptr{Uint8},(Ptr{AVFifoBuffer},Cint),f,offs)
end
function av_fifo_peek(_f::Ptr,_offs::Integer)
    f = convert(Ptr{AVFifoBuffer},_f)
    offs = int32(_offs)
    ccall((:av_fifo_peek,libavutil),Uint8,(Ptr{AVFifoBuffer},Cint),f,offs)
end
