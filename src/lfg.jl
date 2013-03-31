# Julia wrapper for header: /usr/include/libavutil/lfg.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c None av_lfg_init (Ptr{AVLFG}, Uint32) libavutil
@c Uint32 av_lfg_get (Ptr{AVLFG},) libavutil
@c Uint32 av_mlfg_get (Ptr{AVLFG},) libavutil
@c None av_bmg_get (Ptr{AVLFG}, Ptr{Float64}) libavutil

