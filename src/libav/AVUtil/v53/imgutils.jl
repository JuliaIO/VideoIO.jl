# Julia wrapper for header: /usr/local/include/libavutil/imgutils.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_image_fill_max_pixsteps,
    av_image_get_linesize,
    av_image_fill_linesizes,
    av_image_fill_pointers,
    av_image_alloc,
    av_image_copy_plane,
    av_image_copy,
    av_image_check_size,
    avpriv_set_systematic_pal2


function av_image_fill_max_pixsteps(max_pixsteps,max_pixstep_comps,pixdesc)
    ccall((:av_image_fill_max_pixsteps,libavutil),Cvoid,(Ptr{Cint},Ptr{Cint},Ptr{AVPixFmtDescriptor}),max_pixsteps,max_pixstep_comps,pixdesc)
end

function av_image_get_linesize(pix_fmt::AVPixelFormat,width::Integer,plane::Integer)
    ccall((:av_image_get_linesize,libavutil),Cint,(AVPixelFormat,Cint,Cint),pix_fmt,width,plane)
end

function av_image_fill_linesizes(linesizes,pix_fmt::AVPixelFormat,width::Integer)
    ccall((:av_image_fill_linesizes,libavutil),Cint,(Ptr{Cint},AVPixelFormat,Cint),linesizes,pix_fmt,width)
end

function av_image_fill_pointers(data,pix_fmt::AVPixelFormat,height::Integer,ptr,linesizes)
    ccall((:av_image_fill_pointers,libavutil),Cint,(Ptr{Ptr{UInt8}},AVPixelFormat,Cint,Ptr{UInt8},Ptr{Cint}),data,pix_fmt,height,ptr,linesizes)
end

function av_image_alloc(pointers,linesizes,w::Integer,h::Integer,pix_fmt::AVPixelFormat,align::Integer)
    ccall((:av_image_alloc,libavutil),Cint,(Ptr{Ptr{UInt8}},Ptr{Cint},Cint,Cint,AVPixelFormat,Cint),pointers,linesizes,w,h,pix_fmt,align)
end

function av_image_copy_plane(dst,dst_linesize::Integer,src,src_linesize::Integer,bytewidth::Integer,height::Integer)
    ccall((:av_image_copy_plane,libavutil),Cvoid,(Ptr{UInt8},Cint,Ptr{UInt8},Cint,Cint,Cint),dst,dst_linesize,src,src_linesize,bytewidth,height)
end

function av_image_copy(dst_data,dst_linesizes,src_data,src_linesizes,pix_fmt::AVPixelFormat,width::Integer,height::Integer)
    ccall((:av_image_copy,libavutil),Cvoid,(Ptr{Ptr{UInt8}},Ptr{Cint},Ptr{Ptr{UInt8}},Ptr{Cint},AVPixelFormat,Cint,Cint),dst_data,dst_linesizes,src_data,src_linesizes,pix_fmt,width,height)
end

function av_image_check_size(w::Integer,h::Integer,log_offset::Integer,log_ctx)
    ccall((:av_image_check_size,libavutil),Cint,(UInt32,UInt32,Cint,Ptr{Cvoid}),w,h,log_offset,log_ctx)
end

function avpriv_set_systematic_pal2(pal,pix_fmt::AVPixelFormat)
    ccall((:avpriv_set_systematic_pal2,libavutil),Cint,(Ptr{UInt32},AVPixelFormat),pal,pix_fmt)
end
