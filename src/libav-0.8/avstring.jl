# Julia wrapper for header: /usr/include/libavutil/avstring.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_strstart(_str::Union(Ptr,ByteString),_pfx::Union(Ptr,ByteString),_ptr::Ptr)
    str = convert(Ptr{Uint8},_str)
    pfx = convert(Ptr{Uint8},_pfx)
    ptr = convert(Ptr{Ptr{Uint8}},_ptr)
    ccall((:av_strstart,libavutil),Cint,(Ptr{Uint8},Ptr{Uint8},Ptr{Ptr{Uint8}}),str,pfx,ptr)
end
function av_stristart(_str::Union(Ptr,ByteString),_pfx::Union(Ptr,ByteString),_ptr::Ptr)
    str = convert(Ptr{Uint8},_str)
    pfx = convert(Ptr{Uint8},_pfx)
    ptr = convert(Ptr{Ptr{Uint8}},_ptr)
    ccall((:av_stristart,libavutil),Cint,(Ptr{Uint8},Ptr{Uint8},Ptr{Ptr{Uint8}}),str,pfx,ptr)
end
function av_stristr(_haystack::Union(Ptr,ByteString),_needle::Union(Ptr,ByteString))
    haystack = convert(Ptr{Uint8},_haystack)
    needle = convert(Ptr{Uint8},_needle)
    ccall((:av_stristr,libavutil),Ptr{Uint8},(Ptr{Uint8},Ptr{Uint8}),haystack,needle)
end
function av_strlcpy(_dst::Union(Ptr,ByteString),_src::Union(Ptr,ByteString),size::Csize_t)
    dst = convert(Ptr{Uint8},_dst)
    src = convert(Ptr{Uint8},_src)
    ccall((:av_strlcpy,libavutil),Csize_t,(Ptr{Uint8},Ptr{Uint8},Csize_t),dst,src,size)
end
function av_strlcat(_dst::Union(Ptr,ByteString),_src::Union(Ptr,ByteString),size::Csize_t)
    dst = convert(Ptr{Uint8},_dst)
    src = convert(Ptr{Uint8},_src)
    ccall((:av_strlcat,libavutil),Csize_t,(Ptr{Uint8},Ptr{Uint8},Csize_t),dst,src,size)
end
function av_d2str(d::Cdouble)
    ccall((:av_d2str,libavutil),Ptr{Uint8},(Cdouble,),d)
end
function av_get_token(_buf::Ptr,_term::Union(Ptr,ByteString))
    buf = convert(Ptr{Ptr{Uint8}},_buf)
    term = convert(Ptr{Uint8},_term)
    ccall((:av_get_token,libavutil),Ptr{Uint8},(Ptr{Ptr{Uint8}},Ptr{Uint8}),buf,term)
end
function av_toupper(_c::Integer)
    c = int32(_c)
    ccall((:av_toupper,libavutil),Cint,(Cint,),c)
end
function av_tolower(_c::Integer)
    c = int32(_c)
    ccall((:av_tolower,libavutil),Cint,(Cint,),c)
end
function av_strcasecmp(_a::Union(Ptr,ByteString),_b::Union(Ptr,ByteString))
    a = convert(Ptr{Uint8},_a)
    b = convert(Ptr{Uint8},_b)
    ccall((:av_strcasecmp,libavutil),Cint,(Ptr{Uint8},Ptr{Uint8}),a,b)
end
function av_strncasecmp(_a::Union(Ptr,ByteString),_b::Union(Ptr,ByteString),n::Csize_t)
    a = convert(Ptr{Uint8},_a)
    b = convert(Ptr{Uint8},_b)
    ccall((:av_strncasecmp,libavutil),Cint,(Ptr{Uint8},Ptr{Uint8},Csize_t),a,b,n)
end
