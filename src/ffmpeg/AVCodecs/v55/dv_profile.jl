# Julia wrapper for header: /opt/ffmpeg/include/libavcodec/dv_profile.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    avpriv_dv_frame_profile2,
    avpriv_dv_frame_profile,
    avpriv_dv_codec_profile,
    av_dv_frame_profile,
    av_dv_codec_profile


function avpriv_dv_frame_profile2(codec,sys,frame,buf_size::Integer)
    ccall((:avpriv_dv_frame_profile2,libavcodec),Ptr{AVDVProfile},(Ptr{AVCodecContext},Ptr{AVDVProfile},Ptr{UInt8},UInt32),codec,sys,frame,buf_size)
end

function avpriv_dv_frame_profile(sys,frame,buf_size::Integer)
    ccall((:avpriv_dv_frame_profile,libavcodec),Ptr{AVDVProfile},(Ptr{AVDVProfile},Ptr{UInt8},UInt32),sys,frame,buf_size)
end

function avpriv_dv_codec_profile(codec)
    ccall((:avpriv_dv_codec_profile,libavcodec),Ptr{AVDVProfile},(Ptr{AVCodecContext},),codec)
end

function av_dv_frame_profile(sys,frame,buf_size::Integer)
    ccall((:av_dv_frame_profile,libavcodec),Ptr{AVDVProfile},(Ptr{AVDVProfile},Ptr{UInt8},UInt32),sys,frame,buf_size)
end

function av_dv_codec_profile(width::Integer,height::Integer,pix_fmt::AVPixelFormat)
    ccall((:av_dv_codec_profile,libavcodec),Ptr{AVDVProfile},(Cint,Cint,AVPixelFormat),width,height,pix_fmt)
end
