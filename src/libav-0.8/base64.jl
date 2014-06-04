# Julia wrapper for header: /usr/include/libavutil/base64.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_base64_decode(_out::Union(Ptr,ByteString),__in::Union(Ptr,ByteString),_out_size::Integer)
    out = convert(Ptr{Uint8},_out)
    _in = convert(Ptr{Uint8},__in)
    out_size = int32(_out_size)
    ccall((:av_base64_decode,libavutil),Cint,(Ptr{Uint8},Ptr{Uint8},Cint),out,_in,out_size)
end
function av_base64_encode(_out::Union(Ptr,ByteString),_out_size::Integer,__in::Union(Ptr,ByteString),_in_size::Integer)
    out = convert(Ptr{Uint8},_out)
    out_size = int32(_out_size)
    _in = convert(Ptr{Uint8},__in)
    in_size = int32(_in_size)
    ccall((:av_base64_encode,libavutil),Ptr{Uint8},(Ptr{Uint8},Cint,Ptr{Uint8},Cint),out,out_size,_in,in_size)
end
