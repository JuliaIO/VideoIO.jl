# Julia wrapper for header: /usr/local/include/libavutil/pixdesc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_read_image_line,
    av_write_image_line,
    av_get_pix_fmt,
    av_get_pix_fmt_name,
    av_get_pix_fmt_string,
    av_get_bits_per_pixel


function av_read_image_line(dst,data,linesize,desc,x::Integer,y::Integer,c::Integer,w::Integer,read_pal_component::Integer)
    ccall((:av_read_image_line,libavutil),Void,(Ptr{UInt16},Ptr{Ptr{UInt8}},Ptr{Cint},Ptr{AVPixFmtDescriptor},Cint,Cint,Cint,Cint,Cint),dst,data,linesize,desc,x,y,c,w,read_pal_component)
end

function av_write_image_line(src,data,linesize,desc,x::Integer,y::Integer,c::Integer,w::Integer)
    ccall((:av_write_image_line,libavutil),Void,(Ptr{UInt16},Ptr{Ptr{UInt8}},Ptr{Cint},Ptr{AVPixFmtDescriptor},Cint,Cint,Cint,Cint),src,data,linesize,desc,x,y,c,w)
end

function av_get_pix_fmt(name)
    ccall((:av_get_pix_fmt,libavutil),Cint,(Ptr{UInt8},),name)
end

function av_get_pix_fmt_name(pix_fmt::PixelFormat)
    ccall((:av_get_pix_fmt_name,libavutil),Ptr{UInt8},(PixelFormat,),pix_fmt)
end

function av_get_pix_fmt_string(buf,buf_size::Integer,pix_fmt::PixelFormat)
    ccall((:av_get_pix_fmt_string,libavutil),Ptr{UInt8},(Ptr{UInt8},Cint,PixelFormat),buf,buf_size,pix_fmt)
end

function av_get_bits_per_pixel(pixdesc)
    ccall((:av_get_bits_per_pixel,libavutil),Cint,(Ptr{AVPixFmtDescriptor},),pixdesc)
end
