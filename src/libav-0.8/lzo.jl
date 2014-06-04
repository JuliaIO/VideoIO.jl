# Julia wrapper for header: /usr/include/libavutil/lzo.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_lzo1x_decode(_out::Ptr,_outlen::Ptr,__in::Ptr,_inlen::Ptr)
    out = convert(Ptr{Void},_out)
    outlen = convert(Ptr{Cint},_outlen)
    _in = convert(Ptr{Void},__in)
    inlen = convert(Ptr{Cint},_inlen)
    ccall((:av_lzo1x_decode,libavutil),Cint,(Ptr{Void},Ptr{Cint},Ptr{Void},Ptr{Cint}),out,outlen,_in,inlen)
end
function av_memcpy_backptr(_dst::Union(Ptr,ByteString),_back::Integer,_cnt::Integer)
    dst = convert(Ptr{Uint8},_dst)
    back = int32(_back)
    cnt = int32(_cnt)
    ccall((:av_memcpy_backptr,libavutil),Void,(Ptr{Uint8},Cint,Cint),dst,back,cnt)
end
