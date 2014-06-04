# Julia wrapper for header: /usr/include/libavutil/sha.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_sha_init(_context::Ptr,_bits::Integer)
    context = convert(Ptr{AVSHA},_context)
    bits = int32(_bits)
    ccall((:av_sha_init,libavutil),Cint,(Ptr{AVSHA},Cint),context,bits)
end
function av_sha_update(_context::Ptr,_data::Union(Ptr,ByteString),_len::Integer)
    context = convert(Ptr{AVSHA},_context)
    data = convert(Ptr{Uint8},_data)
    len = uint32(_len)
    ccall((:av_sha_update,libavutil),Void,(Ptr{AVSHA},Ptr{Uint8},Uint32),context,data,len)
end
function av_sha_final(_context::Ptr,_digest::Union(Ptr,ByteString))
    context = convert(Ptr{AVSHA},_context)
    digest = convert(Ptr{Uint8},_digest)
    ccall((:av_sha_final,libavutil),Void,(Ptr{AVSHA},Ptr{Uint8}),context,digest)
end
