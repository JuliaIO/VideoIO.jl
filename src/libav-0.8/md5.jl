# Julia wrapper for header: /usr/include/libavutil/md5.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c None av_md5_init (Ptr{Void},) libavutil
@c None av_md5_update (Ptr{Void}, Ptr{uint8_t}, Int32) libavutil
@c None av_md5_final (Ptr{Void}, Ptr{uint8_t}) libavutil
@c None av_md5_sum (Ptr{uint8_t}, Ptr{uint8_t}, Int32) libavutil

