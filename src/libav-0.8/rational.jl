# Julia wrapper for header: /usr/include/libavutil/rational.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_cmp_q(a::AVRational,b::AVRational)
    ccall((:av_cmp_q,libavutil),Cint,(AVRational,AVRational),a,b)
end
function av_q2d(a::AVRational)
    ccall((:av_q2d,libavutil),Cdouble,(AVRational,),a)
end
function av_reduce(_dst_num::Ptr,_dst_den::Ptr,num::Int64,den::Int64,max::Int64)
    dst_num = convert(Ptr{Cint},_dst_num)
    dst_den = convert(Ptr{Cint},_dst_den)
    ccall((:av_reduce,libavutil),Cint,(Ptr{Cint},Ptr{Cint},Int64,Int64,Int64),dst_num,dst_den,num,den,max)
end
function av_mul_q(b::AVRational,c::AVRational)
    ccall((:av_mul_q,libavutil),AVRational,(AVRational,AVRational),b,c)
end
function av_div_q(b::AVRational,c::AVRational)
    ccall((:av_div_q,libavutil),AVRational,(AVRational,AVRational),b,c)
end
function av_add_q(b::AVRational,c::AVRational)
    ccall((:av_add_q,libavutil),AVRational,(AVRational,AVRational),b,c)
end
function av_sub_q(b::AVRational,c::AVRational)
    ccall((:av_sub_q,libavutil),AVRational,(AVRational,AVRational),b,c)
end
function av_d2q(d::Cdouble,_max::Integer)
    max = int32(_max)
    ccall((:av_d2q,libavutil),AVRational,(Cdouble,Cint),d,max)
end
function av_nearer_q(q::AVRational,q1::AVRational,q2::AVRational)
    ccall((:av_nearer_q,libavutil),Cint,(AVRational,AVRational,AVRational),q,q1,q2)
end
function av_find_nearest_q_idx(q::AVRational,_q_list::Ptr)
    q_list = convert(Ptr{AVRational},_q_list)
    ccall((:av_find_nearest_q_idx,libavutil),Cint,(AVRational,Ptr{AVRational}),q,q_list)
end
