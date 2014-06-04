# Julia wrapper for header: /usr/include/libavutil/bswap.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_bswap16(x::Uint16)
    ccall((:av_bswap16,libavutil),Uint16,(Uint16,),x)
end
function av_bswap32(_x::Integer)
    x = uint32(_x)
    ccall((:av_bswap32,libavutil),Uint32,(Uint32,),x)
end
function av_bswap64(x::Uint64)
    ccall((:av_bswap64,libavutil),Uint64,(Uint64,),x)
end
