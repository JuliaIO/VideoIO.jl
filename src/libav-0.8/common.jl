# Julia wrapper for header: /usr/include/libavutil/common.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_log2_c(_v::Integer)
    v = uint32(_v)
    ccall((:av_log2_c,libavutil),Cint,(Uint32,),v)
end
function av_log2_16bit_c(_v::Integer)
    v = uint32(_v)
    ccall((:av_log2_16bit_c,libavutil),Cint,(Uint32,),v)
end
function av_clip_c(_a::Integer,_amin::Integer,_amax::Integer)
    a = int32(_a)
    amin = int32(_amin)
    amax = int32(_amax)
    ccall((:av_clip_c,libavutil),Cint,(Cint,Cint,Cint),a,amin,amax)
end
function av_clip_uint8_c(_a::Integer)
    a = int32(_a)
    ccall((:av_clip_uint8_c,libavutil),Uint8,(Cint,),a)
end
function av_clip_int8_c(_a::Integer)
    a = int32(_a)
    ccall((:av_clip_int8_c,libavutil),Int8,(Cint,),a)
end
function av_clip_uint16_c(_a::Integer)
    a = int32(_a)
    ccall((:av_clip_uint16_c,libavutil),Uint16,(Cint,),a)
end
function av_clip_int16_c(_a::Integer)
    a = int32(_a)
    ccall((:av_clip_int16_c,libavutil),Int16,(Cint,),a)
end
function av_clipl_int32_c(a::Int64)
    ccall((:av_clipl_int32_c,libavutil),Int32,(Int64,),a)
end
function av_clip_uintp2_c(_a::Integer,_p::Integer)
    a = int32(_a)
    p = int32(_p)
    ccall((:av_clip_uintp2_c,libavutil),Uint32,(Cint,Cint),a,p)
end
function av_clipf_c(a::Cfloat,amin::Cfloat,amax::Cfloat)
    ccall((:av_clipf_c,libavutil),Cfloat,(Cfloat,Cfloat,Cfloat),a,amin,amax)
end
function av_ceil_log2_c(_x::Integer)
    x = int32(_x)
    ccall((:av_ceil_log2_c,libavutil),Cint,(Cint,),x)
end
function av_popcount_c(_x::Integer)
    x = uint32(_x)
    ccall((:av_popcount_c,libavutil),Cint,(Uint32,),x)
end
function av_popcount64_c(x::Uint64)
    ccall((:av_popcount64_c,libavutil),Cint,(Uint64,),x)
end
