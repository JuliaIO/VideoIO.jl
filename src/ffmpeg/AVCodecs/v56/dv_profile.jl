# Julia wrapper for header: /usr/local/ffmpeg/2.4/include/libavcodec/dv_profile.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    avpriv_dv_frame_profile2,
    av_dv_frame_profile,
    av_dv_codec_profile


function avpriv_dv_frame_profile2(codec,sys,frame,buf_size::Integer)
    ccall((:avpriv_dv_frame_profile2,libavcodec),Ptr{AVDVProfile},(Ptr{AVCodecContext},Ptr{AVDVProfile},Ptr{Uint8},Uint32),codec,sys,frame,buf_size)
end

function av_dv_frame_profile(sys,frame,buf_size::Integer)
    ccall((:av_dv_frame_profile,libavcodec),Ptr{AVDVProfile},(Ptr{AVDVProfile},Ptr{Uint8},Uint32),sys,frame,buf_size)
end

function av_dv_codec_profile(width::Integer,height::Integer,pix_fmt::AVPixelFormat)
    ccall((:av_dv_codec_profile,libavcodec),Ptr{AVDVProfile},(Cint,Cint,AVPixelFormat),width,height,pix_fmt)
end
