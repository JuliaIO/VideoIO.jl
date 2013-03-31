# Julia wrapper for header: /usr/include/libavutil/sha.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 av_sha_init (Ptr{Void}, Int32) libavutil
@c None av_sha_update (Ptr{Void}, Ptr{uint8_t}, Uint32) libavutil
@c None av_sha_final (Ptr{Void}, Ptr{uint8_t}) libavutil

