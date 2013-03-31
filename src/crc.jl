# Julia wrapper for header: /usr/include/libavutil/crc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 av_crc_init (Ptr{AVCRC}, Int32, Int32, uint32_t, Int32) libavutil
@c Ptr{AVCRC} av_crc_get_table (AVCRCId,) libavutil
@c uint32_t av_crc (Ptr{AVCRC}, uint32_t, Ptr{uint8_t}, size_t) libavutil

