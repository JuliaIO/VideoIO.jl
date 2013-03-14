# Julia wrapper for header: /usr/include/libavutil/dict.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Ptr{:AVDictionaryEntry} av_dict_get (Ptr{:AVDictionary},Ptr{:Uint8},Ptr{:AVDictionaryEntry},:Int32) libavutil
@c Int32 av_dict_set (Ptr{Ptr{:AVDictionary}},Ptr{:Uint8},Ptr{:Uint8},:Int32) libavutil
@c None av_dict_copy (Ptr{Ptr{:AVDictionary}},Ptr{:AVDictionary},:Int32) libavutil
@c None av_dict_free (Ptr{Ptr{:AVDictionary}},) libavutil

