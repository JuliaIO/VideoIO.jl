# Julia wrapper for header: /usr/include/libavutil/fifo.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Ptr{:AVFifoBuffer} av_fifo_alloc (:Uint32,) libavutil
@c None av_fifo_free (Ptr{:AVFifoBuffer},) libavutil
@c None av_fifo_reset (Ptr{:AVFifoBuffer},) libavutil
@c Int32 av_fifo_size (Ptr{:AVFifoBuffer},) libavutil
@c Int32 av_fifo_space (Ptr{:AVFifoBuffer},) libavutil
@c Int32 av_fifo_generic_read (Ptr{:AVFifoBuffer},Ptr{:None},:Int32,Ptr{:Void}) libavutil
@c Int32 av_fifo_generic_write (Ptr{:AVFifoBuffer},Ptr{:None},:Int32,Ptr{:Void}) libavutil
@c Int32 av_fifo_realloc2 (Ptr{:AVFifoBuffer},:Uint32) libavutil
@c None av_fifo_drain (Ptr{:AVFifoBuffer},:Int32) libavutil
@c Ptr{:uint8_t} av_fifo_peek2 (Ptr{:AVFifoBuffer},:Int32) libavutil
@c uint8_t av_fifo_peek (Ptr{:AVFifoBuffer},:Int32) libavutil

