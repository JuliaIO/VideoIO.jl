# Julia wrapper for header: /usr/include/libavutil/lfg.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_lfg_init(_c::Ptr,_seed::Integer)
    c = convert(Ptr{AVLFG},_c)
    seed = uint32(_seed)
    ccall((:av_lfg_init,libavutil),Void,(Ptr{AVLFG},Uint32),c,seed)
end
function av_lfg_get(_c::Ptr)
    c = convert(Ptr{AVLFG},_c)
    ccall((:av_lfg_get,libavutil),Uint32,(Ptr{AVLFG},),c)
end
function av_mlfg_get(_c::Ptr)
    c = convert(Ptr{AVLFG},_c)
    ccall((:av_mlfg_get,libavutil),Uint32,(Ptr{AVLFG},),c)
end
function av_bmg_get(_lfg::Ptr,_out::Ptr)
    lfg = convert(Ptr{AVLFG},_lfg)
    out = convert(Ptr{Cdouble},_out)
    ccall((:av_bmg_get,libavutil),Void,(Ptr{AVLFG},Ptr{Cdouble}),lfg,out)
end
