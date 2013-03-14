# Julia wrapper for header: /usr/include/libavutil/rational.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 av_cmp_q (:AVRational,:AVRational) libavutil
@c Float64 av_q2d (:AVRational,) libavutil
@c Int32 av_reduce (Ptr{:Int32},Ptr{:Int32},:int64_t,:int64_t,:int64_t) libavutil
@c AVRational av_mul_q (:AVRational,:AVRational) libavutil
@c AVRational av_div_q (:AVRational,:AVRational) libavutil
@c AVRational av_add_q (:AVRational,:AVRational) libavutil
@c AVRational av_sub_q (:AVRational,:AVRational) libavutil
@c AVRational av_d2q (:Float64,:Int32) libavutil
@c Int32 av_nearer_q (:AVRational,:AVRational,:AVRational) libavutil
@c Int32 av_find_nearest_q_idx (:AVRational,Ptr{:AVRational}) libavutil

