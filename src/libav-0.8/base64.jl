# Julia wrapper for header: /usr/include/libavutil/base64.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 av_base64_decode (Ptr{uint8_t}, Ptr{Uint8}, Int32) libavutil
@c Ptr{Uint8} av_base64_encode (Ptr{Uint8}, Int32, Ptr{uint8_t}, Int32) libavutil

