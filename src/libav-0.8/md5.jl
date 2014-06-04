# Julia wrapper for header: /usr/include/libavutil/md5.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_md5_init(_ctx::Ptr)
    ctx = convert(Ptr{AVMD5},_ctx)
    ccall((:av_md5_init,libavutil),Void,(Ptr{AVMD5},),ctx)
end
function av_md5_update(_ctx::Ptr,_src::Union(Ptr,ByteString),_len::Integer)
    ctx = convert(Ptr{AVMD5},_ctx)
    src = convert(Ptr{Uint8},_src)
    len = int32(_len)
    ccall((:av_md5_update,libavutil),Void,(Ptr{AVMD5},Ptr{Uint8},Cint),ctx,src,len)
end
function av_md5_final(_ctx::Ptr,_dst::Union(Ptr,ByteString))
    ctx = convert(Ptr{AVMD5},_ctx)
    dst = convert(Ptr{Uint8},_dst)
    ccall((:av_md5_final,libavutil),Void,(Ptr{AVMD5},Ptr{Uint8}),ctx,dst)
end
function av_md5_sum(_dst::Union(Ptr,ByteString),_src::Union(Ptr,ByteString),_len::Integer)
    dst = convert(Ptr{Uint8},_dst)
    src = convert(Ptr{Uint8},_src)
    len = int32(_len)
    ccall((:av_md5_sum,libavutil),Void,(Ptr{Uint8},Ptr{Uint8},Cint),dst,src,len)
end
