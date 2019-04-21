# Julia wrapper for header: /usr/include/libavutil/rational.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_make_q,
    av_cmp_q,
    av_q2d,
    av_reduce,
    av_mul_q,
    av_div_q,
    av_add_q,
    av_sub_q,
    av_inv_q,
    av_d2q,
    av_nearer_q,
    av_find_nearest_q_idx,
    av_q2intfloat


function av_make_q(num::Integer, den::Integer)
    ccall((:av_make_q, libavutil), AVRational, (Cint, Cint), num, den)
end

function av_cmp_q(a::AVRational, b::AVRational)
    ccall((:av_cmp_q, libavutil), Cint, (AVRational, AVRational), a, b)
end

function av_q2d(a::AVRational)
    ccall((:av_q2d, libavutil), Cdouble, (AVRational,), a)
end

function av_reduce(dst_num, dst_den, num::Int64, den::Int64, max::Int64)
    ccall((:av_reduce, libavutil), Cint, (Ptr{Cint}, Ptr{Cint}, Int64, Int64, Int64), dst_num, dst_den, num, den, max)
end

function av_mul_q(b::AVRational, c::AVRational)
    ccall((:av_mul_q, libavutil), AVRational, (AVRational, AVRational), b, c)
end

function av_div_q(b::AVRational, c::AVRational)
    ccall((:av_div_q, libavutil), AVRational, (AVRational, AVRational), b, c)
end

function av_add_q(b::AVRational, c::AVRational)
    ccall((:av_add_q, libavutil), AVRational, (AVRational, AVRational), b, c)
end

function av_sub_q(b::AVRational, c::AVRational)
    ccall((:av_sub_q, libavutil), AVRational, (AVRational, AVRational), b, c)
end

function av_inv_q(q::AVRational)
    ccall((:av_inv_q, libavutil), AVRational, (AVRational,), q)
end

function av_d2q(d::Cdouble, max::Integer)
    ccall((:av_d2q, libavutil), AVRational, (Cdouble, Cint), d, max)
end

function av_nearer_q(q::AVRational, q1::AVRational, q2::AVRational)
    ccall((:av_nearer_q, libavutil), Cint, (AVRational, AVRational, AVRational), q, q1, q2)
end

function av_find_nearest_q_idx(q::AVRational, q_list)
    ccall((:av_find_nearest_q_idx, libavutil), Cint, (AVRational, Ptr{AVRational}), q, q_list)
end

function av_q2intfloat(q::AVRational)
    ccall((:av_q2intfloat, libavutil), UInt32, (AVRational,), q)
end
