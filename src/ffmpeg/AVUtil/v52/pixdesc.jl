# Julia wrapper for header: /opt/ffmpeg/include/libavutil/pixdesc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_read_image_line,
    av_write_image_line,
    av_get_pix_fmt,
    av_get_pix_fmt_name,
    av_get_pix_fmt_string,
    av_get_bits_per_pixel,
    av_get_padded_bits_per_pixel,
    av_pix_fmt_desc_get,
    av_pix_fmt_desc_next,
    av_pix_fmt_desc_get_id,
    av_pix_fmt_get_chroma_sub_sample,
    av_pix_fmt_count_planes,
    ff_check_pixfmt_descriptors,
    av_pix_fmt_swap_endianness,
    av_get_pix_fmt_loss,
    av_find_best_pix_fmt_of_2


function av_read_image_line(dst,data,linesize,desc,x::Integer,y::Integer,c::Integer,w::Integer,read_pal_component::Integer)
    ccall((:av_read_image_line,libavutil),Void,(Ptr{UInt16},Ptr{Ptr{UInt8}},Ptr{Cint},Ptr{AVPixFmtDescriptor},Cint,Cint,Cint,Cint,Cint),dst,data,linesize,desc,x,y,c,w,read_pal_component)
end

function av_write_image_line(src,data,linesize,desc,x::Integer,y::Integer,c::Integer,w::Integer)
    ccall((:av_write_image_line,libavutil),Void,(Ptr{UInt16},Ptr{Ptr{UInt8}},Ptr{Cint},Ptr{AVPixFmtDescriptor},Cint,Cint,Cint,Cint),src,data,linesize,desc,x,y,c,w)
end

function av_get_pix_fmt(name)
    ccall((:av_get_pix_fmt,libavutil),Cint,(Ptr{UInt8},),name)
end

function av_get_pix_fmt_name(pix_fmt::AVPixelFormat)
    ccall((:av_get_pix_fmt_name,libavutil),Ptr{UInt8},(AVPixelFormat,),pix_fmt)
end

function av_get_pix_fmt_string(buf,buf_size::Integer,pix_fmt::AVPixelFormat)
    ccall((:av_get_pix_fmt_string,libavutil),Ptr{UInt8},(Ptr{UInt8},Cint,AVPixelFormat),buf,buf_size,pix_fmt)
end

function av_get_bits_per_pixel(pixdesc)
    ccall((:av_get_bits_per_pixel,libavutil),Cint,(Ptr{AVPixFmtDescriptor},),pixdesc)
end

function av_get_padded_bits_per_pixel(pixdesc)
    ccall((:av_get_padded_bits_per_pixel,libavutil),Cint,(Ptr{AVPixFmtDescriptor},),pixdesc)
end

function av_pix_fmt_desc_get(pix_fmt::AVPixelFormat)
    ccall((:av_pix_fmt_desc_get,libavutil),Ptr{AVPixFmtDescriptor},(AVPixelFormat,),pix_fmt)
end

function av_pix_fmt_desc_next(prev)
    ccall((:av_pix_fmt_desc_next,libavutil),Ptr{AVPixFmtDescriptor},(Ptr{AVPixFmtDescriptor},),prev)
end

function av_pix_fmt_desc_get_id(desc)
    ccall((:av_pix_fmt_desc_get_id,libavutil),Cint,(Ptr{AVPixFmtDescriptor},),desc)
end

function av_pix_fmt_get_chroma_sub_sample(pix_fmt::AVPixelFormat,h_shift,v_shift)
    ccall((:av_pix_fmt_get_chroma_sub_sample,libavutil),Cint,(AVPixelFormat,Ptr{Cint},Ptr{Cint}),pix_fmt,h_shift,v_shift)
end

function av_pix_fmt_count_planes(pix_fmt::AVPixelFormat)
    ccall((:av_pix_fmt_count_planes,libavutil),Cint,(AVPixelFormat,),pix_fmt)
end

function ff_check_pixfmt_descriptors()
    ccall((:ff_check_pixfmt_descriptors,libavutil),Void,())
end

function av_pix_fmt_swap_endianness(pix_fmt::AVPixelFormat)
    ccall((:av_pix_fmt_swap_endianness,libavutil),Cint,(AVPixelFormat,),pix_fmt)
end

function av_get_pix_fmt_loss(dst_pix_fmt::AVPixelFormat,src_pix_fmt::AVPixelFormat,has_alpha::Integer)
    ccall((:av_get_pix_fmt_loss,libavutil),Cint,(AVPixelFormat,AVPixelFormat,Cint),dst_pix_fmt,src_pix_fmt,has_alpha)
end

function av_find_best_pix_fmt_of_2(dst_pix_fmt1::AVPixelFormat,dst_pix_fmt2::AVPixelFormat,src_pix_fmt::AVPixelFormat,has_alpha::Integer,loss_ptr)
    ccall((:av_find_best_pix_fmt_of_2,libavutil),Cint,(AVPixelFormat,AVPixelFormat,AVPixelFormat,Cint,Ptr{Cint}),dst_pix_fmt1,dst_pix_fmt2,src_pix_fmt,has_alpha,loss_ptr)
end
