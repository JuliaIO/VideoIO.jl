# Julia wrapper for header: /opt/ffmpeg/include/libavutil/xtea.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_xtea_init,
    av_xtea_crypt


function av_xtea_init(ctx,key)
    ccall((:av_xtea_init,libavutil),Void,(Ptr{AVXTEA},Ptr{UInt8}),ctx,key)
end

function av_xtea_crypt(ctx,dst,src,count::Integer,iv,decrypt::Integer)
    ccall((:av_xtea_crypt,libavutil),Void,(Ptr{AVXTEA},Ptr{UInt8},Ptr{UInt8},Cint,Ptr{UInt8},Cint),ctx,dst,src,count,iv,decrypt)
end
