# Julia wrapper for header: /usr/local/include/libavutil/cast5.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_cast5_alloc,
    av_cast5_init,
    av_cast5_crypt,
    av_cast5_crypt2


function av_cast5_alloc()
    ccall((:av_cast5_alloc,libavutil),Ptr{AVCAST5},())
end

function av_cast5_init(ctx,key,key_bits::Integer)
    ccall((:av_cast5_init,libavutil),Cint,(Ptr{AVCAST5},Ptr{UInt8},Cint),ctx,key,key_bits)
end

function av_cast5_crypt(ctx,dst,src,count::Integer,decrypt::Integer)
    ccall((:av_cast5_crypt,libavutil),Void,(Ptr{AVCAST5},Ptr{UInt8},Ptr{UInt8},Cint,Cint),ctx,dst,src,count,decrypt)
end

function av_cast5_crypt2(ctx,dst,src,count::Integer,iv,decrypt::Integer)
    ccall((:av_cast5_crypt2,libavutil),Void,(Ptr{AVCAST5},Ptr{UInt8},Ptr{UInt8},Cint,Ptr{UInt8},Cint),ctx,dst,src,count,iv,decrypt)
end
