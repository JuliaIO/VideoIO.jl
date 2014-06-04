# Julia wrapper for header: /usr/include/libavutil/dict.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_dict_get(_m::Ptr,_key::Union(Ptr,ByteString),_prev::Ptr,_flags::Integer)
    m = convert(Ptr{AVDictionary},_m)
    key = convert(Ptr{Uint8},_key)
    prev = convert(Ptr{AVDictionaryEntry},_prev)
    flags = int32(_flags)
    ccall((:av_dict_get,libavutil),Ptr{AVDictionaryEntry},(Ptr{AVDictionary},Ptr{Uint8},Ptr{AVDictionaryEntry},Cint),m,key,prev,flags)
end
function av_dict_set(_pm::Ptr,_key::Union(Ptr,ByteString),_value::Union(Ptr,ByteString),_flags::Integer)
    pm = convert(Ptr{Ptr{AVDictionary}},_pm)
    key = convert(Ptr{Uint8},_key)
    value = convert(Ptr{Uint8},_value)
    flags = int32(_flags)
    ccall((:av_dict_set,libavutil),Cint,(Ptr{Ptr{AVDictionary}},Ptr{Uint8},Ptr{Uint8},Cint),pm,key,value,flags)
end
function av_dict_copy(_dst::Ptr,_src::Ptr,_flags::Integer)
    dst = convert(Ptr{Ptr{AVDictionary}},_dst)
    src = convert(Ptr{AVDictionary},_src)
    flags = int32(_flags)
    ccall((:av_dict_copy,libavutil),Void,(Ptr{Ptr{AVDictionary}},Ptr{AVDictionary},Cint),dst,src,flags)
end
function av_dict_free(_m::Ptr)
    m = convert(Ptr{Ptr{AVDictionary}},_m)
    ccall((:av_dict_free,libavutil),Void,(Ptr{Ptr{AVDictionary}},),m)
end
