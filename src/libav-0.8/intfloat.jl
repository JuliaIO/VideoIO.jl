# Julia wrapper for header: /usr/include/libavutil/intfloat.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_int2float(_i::Integer)
    i = uint32(_i)
    ccall((:av_int2float,libavutil),Cfloat,(Uint32,),i)
end
function av_float2int(f::Cfloat)
    ccall((:av_float2int,libavutil),Uint32,(Cfloat,),f)
end
function av_int2double(i::Uint64)
    ccall((:av_int2double,libavutil),Cdouble,(Uint64,),i)
end
function av_double2int(f::Cdouble)
    ccall((:av_double2int,libavutil),Uint64,(Cdouble,),f)
end
