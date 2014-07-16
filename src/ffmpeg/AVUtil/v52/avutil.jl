# Julia wrapper for header: /opt/ffmpeg/include/libavutil/avutil.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    #avutil_version,
    avutil_configuration,
    avutil_license,
    av_get_media_type_string,
    av_get_picture_type_char,
    av_x_if_null,
    av_int_list_length_for_size,
    av_fopen_utf8,
    av_get_time_base_q


function avutil_version()
    ccall((:avutil_version,libavutil),Uint32,())
end

function avutil_configuration()
    ccall((:avutil_configuration,libavutil),Ptr{Uint8},())
end

function avutil_license()
    ccall((:avutil_license,libavutil),Ptr{Uint8},())
end

function av_get_media_type_string(media_type::AVMediaType)
    ccall((:av_get_media_type_string,libavutil),Ptr{Uint8},(AVMediaType,),media_type)
end

function av_get_picture_type_char(pict_type::AVPictureType)
    ccall((:av_get_picture_type_char,libavutil),Uint8,(AVPictureType,),pict_type)
end

function av_x_if_null(p,x)
    ccall((:av_x_if_null,libavutil),Ptr{Void},(Ptr{Void},Ptr{Void}),p,x)
end

function av_int_list_length_for_size(elsize::Integer,list,term::Uint64)
    ccall((:av_int_list_length_for_size,libavutil),Uint32,(Uint32,Ptr{Void},Uint64),elsize,list,term)
end

function av_fopen_utf8(path,mode)
    ccall((:av_fopen_utf8,libavutil),Ptr{FILE},(Ptr{Uint8},Ptr{Uint8}),path,mode)
end

function av_get_time_base_q()
    ccall((:av_get_time_base_q,libavutil),AVRational,())
end
