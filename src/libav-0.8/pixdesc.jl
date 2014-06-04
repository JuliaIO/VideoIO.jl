# Julia wrapper for header: /usr/include/libavutil/pixdesc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_read_image_line(_dst::Ptr,_data::Ptr,_linesize::Ptr,_desc::Ptr,_x::Integer,_y::Integer,_c::Integer,_w::Integer,_read_pal_component::Integer)
    dst = convert(Ptr{Uint16},_dst)
    data = convert(Ptr{Ptr{Uint8}},_data)
    linesize = convert(Ptr{Cint},_linesize)
    desc = convert(Ptr{AVPixFmtDescriptor},_desc)
    x = int32(_x)
    y = int32(_y)
    c = int32(_c)
    w = int32(_w)
    read_pal_component = int32(_read_pal_component)
    ccall((:av_read_image_line,libavutil),Void,(Ptr{Uint16},Ptr{Ptr{Uint8}},Ptr{Cint},Ptr{AVPixFmtDescriptor},Cint,Cint,Cint,Cint,Cint),dst,data,linesize,desc,x,y,c,w,read_pal_component)
end
function av_write_image_line(_src::Ptr,_data::Ptr,_linesize::Ptr,_desc::Ptr,_x::Integer,_y::Integer,_c::Integer,_w::Integer)
    src = convert(Ptr{Uint16},_src)
    data = convert(Ptr{Ptr{Uint8}},_data)
    linesize = convert(Ptr{Cint},_linesize)
    desc = convert(Ptr{AVPixFmtDescriptor},_desc)
    x = int32(_x)
    y = int32(_y)
    c = int32(_c)
    w = int32(_w)
    ccall((:av_write_image_line,libavutil),Void,(Ptr{Uint16},Ptr{Ptr{Uint8}},Ptr{Cint},Ptr{AVPixFmtDescriptor},Cint,Cint,Cint,Cint),src,data,linesize,desc,x,y,c,w)
end
function av_get_pix_fmt(_name::Union(Ptr,ByteString))
    name = convert(Ptr{Uint8},_name)
    ccall((:av_get_pix_fmt,libavutil),Cint,(Ptr{Uint8},),name)
end
function av_get_pix_fmt_name(pix_fmt::PixelFormat)
    ccall((:av_get_pix_fmt_name,libavutil),Ptr{Uint8},(PixelFormat,),pix_fmt)
end
function av_get_pix_fmt_string(_buf::Union(Ptr,ByteString),_buf_size::Integer,pix_fmt::PixelFormat)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    ccall((:av_get_pix_fmt_string,libavutil),Ptr{Uint8},(Ptr{Uint8},Cint,PixelFormat),buf,buf_size,pix_fmt)
end
function av_get_bits_per_pixel(_pixdesc::Ptr)
    pixdesc = convert(Ptr{AVPixFmtDescriptor},_pixdesc)
    ccall((:av_get_bits_per_pixel,libavutil),Cint,(Ptr{AVPixFmtDescriptor},),pixdesc)
end
