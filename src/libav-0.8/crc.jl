# Julia wrapper for header: /usr/include/libavutil/crc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_crc_init(_ctx::Ptr,_le::Integer,_bits::Integer,_poly::Integer,_ctx_size::Integer)
    ctx = convert(Ptr{AVCRC},_ctx)
    le = int32(_le)
    bits = int32(_bits)
    poly = uint32(_poly)
    ctx_size = int32(_ctx_size)
    ccall((:av_crc_init,libavutil),Cint,(Ptr{AVCRC},Cint,Cint,Uint32,Cint),ctx,le,bits,poly,ctx_size)
end
function av_crc_get_table(crc_id::AVCRCId)
    ccall((:av_crc_get_table,libavutil),Ptr{AVCRC},(AVCRCId,),crc_id)
end
function av_crc(_ctx::Ptr,_start_crc::Integer,_buffer::Union(Ptr,ByteString),length::Csize_t)
    ctx = convert(Ptr{AVCRC},_ctx)
    start_crc = uint32(_start_crc)
    buffer = convert(Ptr{Uint8},_buffer)
    ccall((:av_crc,libavutil),Uint32,(Ptr{AVCRC},Uint32,Ptr{Uint8},Csize_t),ctx,start_crc,buffer,length)
end
