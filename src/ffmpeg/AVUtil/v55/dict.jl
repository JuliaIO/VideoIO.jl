# Julia wrapper for header: /usr/local/include/libavutil/dict.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_dict_get,
    av_dict_count,
    av_dict_set,
    av_dict_set_int,
    av_dict_parse_string,
    av_dict_copy,
    av_dict_free,
    av_dict_get_string


function av_dict_get(m,key,prev,flags::Integer)
    ccall((:av_dict_get,libavutil),Ptr{AVDictionaryEntry},(Ptr{AVDictionary},Cstring,Ptr{AVDictionaryEntry},Cint),m,key,prev,flags)
end

function av_dict_count(m)
    ccall((:av_dict_count,libavutil),Cint,(Ptr{AVDictionary},),m)
end

function av_dict_set(pm,key,value,flags::Integer)
    ccall((:av_dict_set,libavutil),Cint,(Ptr{Ptr{AVDictionary}},Cstring,Cstring,Cint),pm,key,value,flags)
end

function av_dict_set_int(pm,key,value::Int64,flags::Integer)
    ccall((:av_dict_set_int,libavutil),Cint,(Ptr{Ptr{AVDictionary}},Cstring,Int64,Cint),pm,key,value,flags)
end

function av_dict_parse_string(pm,str,key_val_sep,pairs_sep,flags::Integer)
    ccall((:av_dict_parse_string,libavutil),Cint,(Ptr{Ptr{AVDictionary}},Cstring,Cstring,Cstring,Cint),pm,str,key_val_sep,pairs_sep,flags)
end

function av_dict_copy(dst,src,flags::Integer)
    ccall((:av_dict_copy,libavutil),Cint,(Ptr{Ptr{AVDictionary}},Ptr{AVDictionary},Cint),dst,src,flags)
end

function av_dict_free(m)
    ccall((:av_dict_free,libavutil),Cvoid,(Ptr{Ptr{AVDictionary}},),m)
end

function av_dict_get_string(m,buffer,key_val_sep::UInt8,pairs_sep::UInt8)
    ccall((:av_dict_get_string,libavutil),Cint,(Ptr{AVDictionary},Ptr{Cstring},UInt8,UInt8),m,buffer,key_val_sep,pairs_sep)
end
