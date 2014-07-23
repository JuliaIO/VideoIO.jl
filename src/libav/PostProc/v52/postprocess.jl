# Julia wrapper for header: /usr/include/libpostproc/postprocess.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    #postproc_version,
    postproc_configuration,
    postproc_license,
    pp_postprocess,
    pp_get_mode_by_name_and_quality,
    pp_free_mode,
    pp_get_context,
    pp_free_context


function postproc_version()
    ccall((:postproc_version,libpostproc),Uint32,())
end

function postproc_configuration()
    ccall((:postproc_configuration,libpostproc),Ptr{Uint8},())
end

function postproc_license()
    ccall((:postproc_license,libpostproc),Ptr{Uint8},())
end

function pp_postprocess(src,srcStride,dst,dstStride,horizontalSize::Integer,verticalSize::Integer,QP_store,QP_stride::Integer,mode,ppContext,pict_type::Integer)
    ccall((:pp_postprocess,libpostproc),Void,(Ptr{Ptr{Uint8}},Ptr{Cint},Ptr{Ptr{Uint8}},Ptr{Cint},Cint,Cint,Ptr{Int8},Cint,Ptr{pp_mode},Ptr{pp_context},Cint),src,srcStride,dst,dstStride,horizontalSize,verticalSize,QP_store,QP_stride,mode,ppContext,pict_type)
end

function pp_get_mode_by_name_and_quality(name,quality::Integer)
    ccall((:pp_get_mode_by_name_and_quality,libpostproc),Ptr{pp_mode},(Ptr{Uint8},Cint),name,quality)
end

function pp_free_mode(mode)
    ccall((:pp_free_mode,libpostproc),Void,(Ptr{pp_mode},),mode)
end

function pp_get_context(width::Integer,height::Integer,flags::Integer)
    ccall((:pp_get_context,libpostproc),Ptr{pp_context},(Cint,Cint,Cint),width,height,flags)
end

function pp_free_context(ppContext)
    ccall((:pp_free_context,libpostproc),Void,(Ptr{pp_context},),ppContext)
end
