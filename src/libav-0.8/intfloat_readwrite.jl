# Julia wrapper for header: /usr/include/libavutil/intfloat_readwrite.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_int2dbl(v::Int64)
    ccall((:av_int2dbl,libavutil),Cdouble,(Int64,),v)
end
function av_int2flt(_v::Integer)
    v = int32(_v)
    ccall((:av_int2flt,libavutil),Cfloat,(Int32,),v)
end
function av_ext2dbl(ext::AVExtFloat)
    ccall((:av_ext2dbl,libavutil),Cdouble,(AVExtFloat,),ext)
end
function av_dbl2int(d::Cdouble)
    ccall((:av_dbl2int,libavutil),Int64,(Cdouble,),d)
end
function av_flt2int(d::Cfloat)
    ccall((:av_flt2int,libavutil),Int32,(Cfloat,),d)
end
function av_dbl2ext(d::Cdouble)
    ccall((:av_dbl2ext,libavutil),AVExtFloat,(Cdouble,),d)
end
