# Julia wrapper for header: /usr/include/libavutil/avutil.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    #avutil_version,
    avutil_configuration,
    avutil_license,
    av_get_picture_type_char


function avutil_version()
    ccall((:avutil_version,libavutil),UInt32,())
end

function avutil_configuration()
    ccall((:avutil_configuration,libavutil),Ptr{UInt8},())
end

function avutil_license()
    ccall((:avutil_license,libavutil),Ptr{UInt8},())
end

function av_get_picture_type_char(pict_type::AVPictureType)
    ccall((:av_get_picture_type_char,libavutil),UInt8,(AVPictureType,),pict_type)
end
