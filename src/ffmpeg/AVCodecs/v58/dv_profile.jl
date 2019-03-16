# Julia wrapper for header: /usr/include/libavcodec/dv_profile.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_dv_frame_profile,
    av_dv_codec_profile,
    av_dv_codec_profile2


function av_dv_frame_profile(sys, frame, buf_size::Integer)
    ccall((:av_dv_frame_profile, libavcodec), Ptr{AVDVProfile}, (Ptr{AVDVProfile}, Ptr{UInt8}, UInt32), sys, frame, buf_size)
end

function av_dv_codec_profile(width::Integer, height::Integer, pix_fmt::AVPixelFormat)
    ccall((:av_dv_codec_profile, libavcodec), Ptr{AVDVProfile}, (Cint, Cint, AVPixelFormat), width, height, pix_fmt)
end

function av_dv_codec_profile2(width::Integer, height::Integer, pix_fmt::AVPixelFormat, frame_rate::AVRational)
    ccall((:av_dv_codec_profile2, libavcodec), Ptr{AVDVProfile}, (Cint, Cint, AVPixelFormat, AVRational), width, height, pix_fmt, frame_rate)
end
