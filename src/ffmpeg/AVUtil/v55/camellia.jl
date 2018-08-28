# Julia wrapper for header: /usr/local/include/libavutil/camellia.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_camellia_alloc,
    av_camellia_init,
    av_camellia_crypt


function av_camellia_alloc()
    ccall((:av_camellia_alloc,libavutil),Ptr{AVCAMELLIA},())
end

function av_camellia_init(ctx,key,key_bits::Integer)
    ccall((:av_camellia_init,libavutil),Cint,(Ptr{AVCAMELLIA},Ptr{UInt8},Cint),ctx,key,key_bits)
end

function av_camellia_crypt(ctx,dst,src,count::Integer,iv,decrypt::Integer)
    ccall((:av_camellia_crypt,libavutil),Cvoid,(Ptr{AVCAMELLIA},Ptr{UInt8},Ptr{UInt8},Cint,Ptr{UInt8},Cint),ctx,dst,src,count,iv,decrypt)
end
