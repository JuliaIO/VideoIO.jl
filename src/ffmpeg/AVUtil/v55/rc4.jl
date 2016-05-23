# Julia wrapper for header: /usr/local/include/libavutil/rc4.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_rc4_alloc,
    av_rc4_init,
    av_rc4_crypt


function av_rc4_alloc()
    ccall((:av_rc4_alloc,libavutil),Ptr{AVRC4},())
end

function av_rc4_init(d,key,key_bits::Integer,decrypt::Integer)
    ccall((:av_rc4_init,libavutil),Cint,(Ptr{AVRC4},Ptr{UInt8},Cint,Cint),d,key,key_bits,decrypt)
end

function av_rc4_crypt(d,dst,src,count::Integer,iv,decrypt::Integer)
    ccall((:av_rc4_crypt,libavutil),Void,(Ptr{AVRC4},Ptr{UInt8},Ptr{UInt8},Cint,Ptr{UInt8},Cint),d,dst,src,count,iv,decrypt)
end
