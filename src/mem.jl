# Julia wrapper for header: /usr/include/libavutil/mem.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Ptr{:None} av_malloc (:size_t,) libavutil
@c Ptr{:None} av_realloc (Ptr{:None},:size_t) libavutil
@c None av_free (Ptr{:None},) libavutil
@c Ptr{:None} av_mallocz (:size_t,) libavutil
@c Ptr{:Uint8} av_strdup (Ptr{:Uint8},) libavutil
@c None av_freep (Ptr{:None},) libavutil

