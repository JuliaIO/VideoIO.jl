# Julia wrapper for header: /usr/include/libavutil/hwcontext_videotoolbox.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_map_videotoolbox_format_to_pixfmt,
    av_map_videotoolbox_format_from_pixfmt


function av_map_videotoolbox_format_to_pixfmt(cv_fmt::Integer)
    ccall((:av_map_videotoolbox_format_to_pixfmt, libavutil), AVPixelFormat, (UInt32,), cv_fmt)
end

function av_map_videotoolbox_format_from_pixfmt(pix_fmt::AVPixelFormat)
    ccall((:av_map_videotoolbox_format_from_pixfmt, libavutil), UInt32, (AVPixelFormat,), pix_fmt)
end
