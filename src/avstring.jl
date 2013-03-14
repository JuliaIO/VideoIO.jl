# Julia wrapper for header: /usr/include/libavutil/avstring.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 av_strstart (Ptr{:Uint8},Ptr{:Uint8},Ptr{Ptr{:Uint8}}) libavutil
@c Int32 av_stristart (Ptr{:Uint8},Ptr{:Uint8},Ptr{Ptr{:Uint8}}) libavutil
@c Ptr{:Uint8} av_stristr (Ptr{:Uint8},Ptr{:Uint8}) libavutil
@c size_t av_strlcpy (Ptr{:Uint8},Ptr{:Uint8},:size_t) libavutil
@c size_t av_strlcat (Ptr{:Uint8},Ptr{:Uint8},:size_t) libavutil
@c size_t av_strlcatf (Ptr{:Uint8},:size_t,Ptr{:Uint8}) libavutil
@c Ptr{:Uint8} av_d2str (:Float64,) libavutil
@c Ptr{:Uint8} av_get_token (Ptr{Ptr{:Uint8}},Ptr{:Uint8}) libavutil
@c Int32 av_toupper (:Int32,) libavutil
@c Int32 av_tolower (:Int32,) libavutil
@c Int32 av_strcasecmp (Ptr{:Uint8},Ptr{:Uint8}) libavutil
@c Int32 av_strncasecmp (Ptr{:Uint8},Ptr{:Uint8},:size_t) libavutil

