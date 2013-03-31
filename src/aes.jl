# Julia wrapper for header: /usr/include/libavutil/aes.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 av_aes_init (Ptr{Void}, Ptr{uint8_t}, Int32, Int32) libavutil
@c None av_aes_crypt (Ptr{Void}, Ptr{uint8_t}, Ptr{uint8_t}, Int32, Ptr{uint8_t}, Int32) libavutil

