# Julia wrapper for header: /usr/include/libavutil/imgutils.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_image_fill_max_pixsteps(_max_pixsteps::Ptr,_max_pixstep_comps::Ptr,_pixdesc::Ptr)
    max_pixsteps = convert(Ptr{Cint},_max_pixsteps)
    max_pixstep_comps = convert(Ptr{Cint},_max_pixstep_comps)
    pixdesc = convert(Ptr{AVPixFmtDescriptor},_pixdesc)
    ccall((:av_image_fill_max_pixsteps,libavutil),Void,(Ptr{Cint},Ptr{Cint},Ptr{AVPixFmtDescriptor}),max_pixsteps,max_pixstep_comps,pixdesc)
end
function av_image_get_linesize(pix_fmt::PixelFormat,_width::Integer,_plane::Integer)
    width = int32(_width)
    plane = int32(_plane)
    ccall((:av_image_get_linesize,libavutil),Cint,(PixelFormat,Cint,Cint),pix_fmt,width,plane)
end
function av_image_fill_linesizes(_linesizes::Ptr,pix_fmt::PixelFormat,_width::Integer)
    linesizes = convert(Ptr{Cint},_linesizes)
    width = int32(_width)
    ccall((:av_image_fill_linesizes,libavutil),Cint,(Ptr{Cint},PixelFormat,Cint),linesizes,pix_fmt,width)
end
function av_image_fill_pointers(_data::Ptr,pix_fmt::PixelFormat,_height::Integer,_ptr::Union(Ptr,ByteString),_linesizes::Ptr)
    data = convert(Ptr{Ptr{Uint8}},_data)
    height = int32(_height)
    ptr = convert(Ptr{Uint8},_ptr)
    linesizes = convert(Ptr{Cint},_linesizes)
    ccall((:av_image_fill_pointers,libavutil),Cint,(Ptr{Ptr{Uint8}},PixelFormat,Cint,Ptr{Uint8},Ptr{Cint}),data,pix_fmt,height,ptr,linesizes)
end
function av_image_alloc(_pointers::Ptr,_linesizes::Ptr,_w::Integer,_h::Integer,pix_fmt::PixelFormat,_align::Integer)
    pointers = convert(Ptr{Ptr{Uint8}},_pointers)
    linesizes = convert(Ptr{Cint},_linesizes)
    w = int32(_w)
    h = int32(_h)
    align = int32(_align)
    ccall((:av_image_alloc,libavutil),Cint,(Ptr{Ptr{Uint8}},Ptr{Cint},Cint,Cint,PixelFormat,Cint),pointers,linesizes,w,h,pix_fmt,align)
end
function av_image_copy_plane(_dst::Union(Ptr,ByteString),_dst_linesize::Integer,_src::Union(Ptr,ByteString),_src_linesize::Integer,_bytewidth::Integer,_height::Integer)
    dst = convert(Ptr{Uint8},_dst)
    dst_linesize = int32(_dst_linesize)
    src = convert(Ptr{Uint8},_src)
    src_linesize = int32(_src_linesize)
    bytewidth = int32(_bytewidth)
    height = int32(_height)
    ccall((:av_image_copy_plane,libavutil),Void,(Ptr{Uint8},Cint,Ptr{Uint8},Cint,Cint,Cint),dst,dst_linesize,src,src_linesize,bytewidth,height)
end
function av_image_copy(_dst_data::Ptr,_dst_linesizes::Ptr,_src_data::Ptr,_src_linesizes::Ptr,pix_fmt::PixelFormat,_width::Integer,_height::Integer)
    dst_data = convert(Ptr{Ptr{Uint8}},_dst_data)
    dst_linesizes = convert(Ptr{Cint},_dst_linesizes)
    src_data = convert(Ptr{Ptr{Uint8}},_src_data)
    src_linesizes = convert(Ptr{Cint},_src_linesizes)
    width = int32(_width)
    height = int32(_height)
    ccall((:av_image_copy,libavutil),Void,(Ptr{Ptr{Uint8}},Ptr{Cint},Ptr{Ptr{Uint8}},Ptr{Cint},PixelFormat,Cint,Cint),dst_data,dst_linesizes,src_data,src_linesizes,pix_fmt,width,height)
end
function av_image_check_size(_w::Integer,_h::Integer,_log_offset::Integer,_log_ctx::Ptr)
    w = uint32(_w)
    h = uint32(_h)
    log_offset = int32(_log_offset)
    log_ctx = convert(Ptr{Void},_log_ctx)
    ccall((:av_image_check_size,libavutil),Cint,(Uint32,Uint32,Cint,Ptr{Void}),w,h,log_offset,log_ctx)
end
function ff_set_systematic_pal2(_pal::Ptr,pix_fmt::PixelFormat)
    pal = convert(Ptr{Uint32},_pal)
    ccall((:ff_set_systematic_pal2,libavutil),Cint,(Ptr{Uint32},PixelFormat),pal,pix_fmt)
end
