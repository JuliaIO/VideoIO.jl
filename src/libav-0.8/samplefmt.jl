# Julia wrapper for header: /usr/include/libavutil/samplefmt.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Ptr{Uint8} av_get_sample_fmt_name (Void,) libavutil
@c Int32 av_get_sample_fmt (Ptr{Uint8},) libavutil
@c Ptr{Uint8} av_get_sample_fmt_string (Ptr{Uint8}, Int32, Void) libavutil
@c Int32 av_get_bits_per_sample_fmt (Void,) libavutil
@c Int32 av_get_bytes_per_sample (Void,) libavutil
@c Int32 av_sample_fmt_is_planar (Void,) libavutil
@c Int32 av_samples_get_buffer_size (Ptr{Int32}, Int32, Int32, Void, Int32) libavutil
@c Int32 av_samples_fill_arrays (Ptr{Ptr{uint8_t}}, Ptr{Int32}, Ptr{uint8_t}, Int32, Int32, Void, Int32) libavutil
@c Int32 av_samples_alloc (Ptr{Ptr{uint8_t}}, Ptr{Int32}, Int32, Int32, Void, Int32) libavutil

