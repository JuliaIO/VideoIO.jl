# Julia wrapper for header: /usr/include/libavutil/avutil.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function avutil_version()
    ccall((:avutil_version,libavutil),Uint32,())
end
function avutil_configuration()
    ccall((:avutil_configuration,libavutil),Ptr{Uint8},())
end
function avutil_license()
    ccall((:avutil_license,libavutil),Ptr{Uint8},())
end
function av_get_picture_type_char(pict_type::AVPictureType)
    ccall((:av_get_picture_type_char,libavutil),Uint8,(AVPictureType,),pict_type)
end
