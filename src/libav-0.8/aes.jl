# Julia wrapper for header: /usr/include/libavutil/aes.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_aes_init(_a::Ptr,_key::Union(Ptr,ByteString),_key_bits::Integer,_decrypt::Integer)
    a = convert(Ptr{AVAES},_a)
    key = convert(Ptr{Uint8},_key)
    key_bits = int32(_key_bits)
    decrypt = int32(_decrypt)
    ccall((:av_aes_init,libavutil),Cint,(Ptr{AVAES},Ptr{Uint8},Cint,Cint),a,key,key_bits,decrypt)
end
function av_aes_crypt(_a::Ptr,_dst::Union(Ptr,ByteString),_src::Union(Ptr,ByteString),_count::Integer,_iv::Union(Ptr,ByteString),_decrypt::Integer)
    a = convert(Ptr{AVAES},_a)
    dst = convert(Ptr{Uint8},_dst)
    src = convert(Ptr{Uint8},_src)
    count = int32(_count)
    iv = convert(Ptr{Uint8},_iv)
    decrypt = int32(_decrypt)
    ccall((:av_aes_crypt,libavutil),Void,(Ptr{AVAES},Ptr{Uint8},Ptr{Uint8},Cint,Ptr{Uint8},Cint),a,dst,src,count,iv,decrypt)
end
