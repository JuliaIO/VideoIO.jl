# Julia wrapper for header: /usr/include/libavutil/parseutils.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 av_parse_video_size (Ptr{Int32}, Ptr{Int32}, Ptr{Uint8}) libavutil
@c Int32 av_parse_video_rate (Ptr{AVRational}, Ptr{Uint8}) libavutil
@c Int32 av_parse_color (Ptr{uint8_t}, Ptr{Uint8}, Int32, Ptr{None}) libavutil
@c Int32 av_parse_time (Ptr{int64_t}, Ptr{Uint8}, Int32) libavutil
@c Int32 av_find_info_tag (Ptr{Uint8}, Int32, Ptr{Uint8}, Ptr{Uint8}) libavutil
@c time_t av_timegm (Ptr{Void},) libavutil

