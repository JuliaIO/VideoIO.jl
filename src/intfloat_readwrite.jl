# Julia wrapper for header: /usr/include/libavutil/intfloat_readwrite.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Float64 av_int2dbl (int64_t,) libavutil
@c Float32 av_int2flt (int32_t,) libavutil
@c Float64 av_ext2dbl (AVExtFloat,) libavutil
@c int64_t av_dbl2int (Float64,) libavutil
@c int32_t av_flt2int (Float32,) libavutil
@c AVExtFloat av_dbl2ext (Float64,) libavutil

