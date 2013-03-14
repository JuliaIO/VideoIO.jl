# Julia wrapper for header: /usr/include/libavutil/log.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c None av_log (Ptr{:None},:Int32,Ptr{:Uint8}) libavutil
@c None av_vlog (Ptr{:None},:Int32,Ptr{:Uint8},Ptr{:__va_list_tag}) libavutil
@c Int32 av_log_get_level () libavutil
@c None av_log_set_level (:Int32,) libavutil
@c None av_log_set_callback (Ptr{:Void},) libavutil
@c None av_log_default_callback (Ptr{:None},:Int32,Ptr{:Uint8},Ptr{:__va_list_tag}) libavutil
@c Ptr{:Uint8} av_default_item_name (Ptr{:None},) libavutil
@c None av_log_set_flags (:Int32,) libavutil

