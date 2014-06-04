# Julia wrapper for header: /usr/include/libswscale/swscale.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

function swscale_version()
    ccall((:swscale_version,libswscale),Uint32,())
end
function swscale_configuration()
    ccall((:swscale_configuration,libswscale),Ptr{Uint8},())
end
function swscale_license()
    ccall((:swscale_license,libswscale),Ptr{Uint8},())
end
function sws_getCoefficients(_colorspace::Integer)
    colorspace = int32(_colorspace)
    ccall((:sws_getCoefficients,libswscale),Ptr{Cint},(Cint,),colorspace)
end
function sws_isSupportedInput(pix_fmt::PixelFormat)
    ccall((:sws_isSupportedInput,libswscale),Cint,(PixelFormat,),pix_fmt)
end
function sws_isSupportedOutput(pix_fmt::PixelFormat)
    ccall((:sws_isSupportedOutput,libswscale),Cint,(PixelFormat,),pix_fmt)
end
function sws_alloc_context()
    ccall((:sws_alloc_context,libswscale),Ptr{SwsContext},())
end
function sws_init_context(_sws_context::Ptr,_srcFilter::Ptr,_dstFilter::Ptr)
    sws_context = convert(Ptr{SwsContext},_sws_context)
    srcFilter = convert(Ptr{SwsFilter},_srcFilter)
    dstFilter = convert(Ptr{SwsFilter},_dstFilter)
    ccall((:sws_init_context,libswscale),Cint,(Ptr{SwsContext},Ptr{SwsFilter},Ptr{SwsFilter}),sws_context,srcFilter,dstFilter)
end
function sws_freeContext(_swsContext::Ptr)
    swsContext = convert(Ptr{SwsContext},_swsContext)
    ccall((:sws_freeContext,libswscale),Void,(Ptr{SwsContext},),swsContext)
end
function sws_getContext(_srcW::Integer,_srcH::Integer,srcFormat::PixelFormat,_dstW::Integer,_dstH::Integer,dstFormat::PixelFormat,_flags::Integer,_srcFilter::Ptr,_dstFilter::Ptr,_param::Ptr)
    srcW = int32(_srcW)
    srcH = int32(_srcH)
    dstW = int32(_dstW)
    dstH = int32(_dstH)
    flags = int32(_flags)
    srcFilter = convert(Ptr{SwsFilter},_srcFilter)
    dstFilter = convert(Ptr{SwsFilter},_dstFilter)
    param = convert(Ptr{Cdouble},_param)
    ccall((:sws_getContext,libswscale),Ptr{SwsContext},(Cint,Cint,PixelFormat,Cint,Cint,PixelFormat,Cint,Ptr{SwsFilter},Ptr{SwsFilter},Ptr{Cdouble}),srcW,srcH,srcFormat,dstW,dstH,dstFormat,flags,srcFilter,dstFilter,param)
end
function sws_scale(_c::Ptr,_srcSlice::Ptr,_srcStride::Ptr,_srcSliceY::Integer,_srcSliceH::Integer,_dst::Ptr,_dstStride::Ptr)
    c = convert(Ptr{SwsContext},_c)
    srcSlice = convert(Ptr{Ptr{Uint8}},_srcSlice)
    srcStride = convert(Ptr{Cint},_srcStride)
    srcSliceY = int32(_srcSliceY)
    srcSliceH = int32(_srcSliceH)
    dst = convert(Ptr{Ptr{Uint8}},_dst)
    dstStride = convert(Ptr{Cint},_dstStride)
    ccall((:sws_scale,libswscale),Cint,(Ptr{SwsContext},Ptr{Ptr{Uint8}},Ptr{Cint},Cint,Cint,Ptr{Ptr{Uint8}},Ptr{Cint}),c,srcSlice,srcStride,srcSliceY,srcSliceH,dst,dstStride)
end
function sws_setColorspaceDetails(_c::Ptr,_inv_table::Ptr,_srcRange::Integer,_table::Ptr,_dstRange::Integer,_brightness::Integer,_contrast::Integer,_saturation::Integer)
    c = convert(Ptr{SwsContext},_c)
    inv_table = convert(Ptr{Cint},_inv_table)
    srcRange = int32(_srcRange)
    table = convert(Ptr{Cint},_table)
    dstRange = int32(_dstRange)
    brightness = int32(_brightness)
    contrast = int32(_contrast)
    saturation = int32(_saturation)
    ccall((:sws_setColorspaceDetails,libswscale),Cint,(Ptr{SwsContext},Ptr{Cint},Cint,Ptr{Cint},Cint,Cint,Cint,Cint),c,inv_table,srcRange,table,dstRange,brightness,contrast,saturation)
end
function sws_getColorspaceDetails(_c::Ptr,_inv_table::Ptr,_srcRange::Ptr,_table::Ptr,_dstRange::Ptr,_brightness::Ptr,_contrast::Ptr,_saturation::Ptr)
    c = convert(Ptr{SwsContext},_c)
    inv_table = convert(Ptr{Ptr{Cint}},_inv_table)
    srcRange = convert(Ptr{Cint},_srcRange)
    table = convert(Ptr{Ptr{Cint}},_table)
    dstRange = convert(Ptr{Cint},_dstRange)
    brightness = convert(Ptr{Cint},_brightness)
    contrast = convert(Ptr{Cint},_contrast)
    saturation = convert(Ptr{Cint},_saturation)
    ccall((:sws_getColorspaceDetails,libswscale),Cint,(Ptr{SwsContext},Ptr{Ptr{Cint}},Ptr{Cint},Ptr{Ptr{Cint}},Ptr{Cint},Ptr{Cint},Ptr{Cint},Ptr{Cint}),c,inv_table,srcRange,table,dstRange,brightness,contrast,saturation)
end
function sws_allocVec(_length::Integer)
    length = int32(_length)
    ccall((:sws_allocVec,libswscale),Ptr{SwsVector},(Cint,),length)
end
function sws_getGaussianVec(variance::Cdouble,quality::Cdouble)
    ccall((:sws_getGaussianVec,libswscale),Ptr{SwsVector},(Cdouble,Cdouble),variance,quality)
end
function sws_getConstVec(c::Cdouble,_length::Integer)
    length = int32(_length)
    ccall((:sws_getConstVec,libswscale),Ptr{SwsVector},(Cdouble,Cint),c,length)
end
function sws_getIdentityVec()
    ccall((:sws_getIdentityVec,libswscale),Ptr{SwsVector},())
end
function sws_scaleVec(_a::Ptr,scalar::Cdouble)
    a = convert(Ptr{SwsVector},_a)
    ccall((:sws_scaleVec,libswscale),Void,(Ptr{SwsVector},Cdouble),a,scalar)
end
function sws_normalizeVec(_a::Ptr,height::Cdouble)
    a = convert(Ptr{SwsVector},_a)
    ccall((:sws_normalizeVec,libswscale),Void,(Ptr{SwsVector},Cdouble),a,height)
end
function sws_convVec(_a::Ptr,_b::Ptr)
    a = convert(Ptr{SwsVector},_a)
    b = convert(Ptr{SwsVector},_b)
    ccall((:sws_convVec,libswscale),Void,(Ptr{SwsVector},Ptr{SwsVector}),a,b)
end
function sws_addVec(_a::Ptr,_b::Ptr)
    a = convert(Ptr{SwsVector},_a)
    b = convert(Ptr{SwsVector},_b)
    ccall((:sws_addVec,libswscale),Void,(Ptr{SwsVector},Ptr{SwsVector}),a,b)
end
function sws_subVec(_a::Ptr,_b::Ptr)
    a = convert(Ptr{SwsVector},_a)
    b = convert(Ptr{SwsVector},_b)
    ccall((:sws_subVec,libswscale),Void,(Ptr{SwsVector},Ptr{SwsVector}),a,b)
end
function sws_shiftVec(_a::Ptr,_shift::Integer)
    a = convert(Ptr{SwsVector},_a)
    shift = int32(_shift)
    ccall((:sws_shiftVec,libswscale),Void,(Ptr{SwsVector},Cint),a,shift)
end
function sws_cloneVec(_a::Ptr)
    a = convert(Ptr{SwsVector},_a)
    ccall((:sws_cloneVec,libswscale),Ptr{SwsVector},(Ptr{SwsVector},),a)
end
function sws_printVec2(_a::Ptr,_log_ctx::Ptr,_log_level::Integer)
    a = convert(Ptr{SwsVector},_a)
    log_ctx = convert(Ptr{AVClass},_log_ctx)
    log_level = int32(_log_level)
    ccall((:sws_printVec2,libswscale),Void,(Ptr{SwsVector},Ptr{AVClass},Cint),a,log_ctx,log_level)
end
function sws_freeVec(_a::Ptr)
    a = convert(Ptr{SwsVector},_a)
    ccall((:sws_freeVec,libswscale),Void,(Ptr{SwsVector},),a)
end
function sws_getDefaultFilter(lumaGBlur::Cfloat,chromaGBlur::Cfloat,lumaSharpen::Cfloat,chromaSharpen::Cfloat,chromaHShift::Cfloat,chromaVShift::Cfloat,_verbose::Integer)
    verbose = int32(_verbose)
    ccall((:sws_getDefaultFilter,libswscale),Ptr{SwsFilter},(Cfloat,Cfloat,Cfloat,Cfloat,Cfloat,Cfloat,Cint),lumaGBlur,chromaGBlur,lumaSharpen,chromaSharpen,chromaHShift,chromaVShift,verbose)
end
function sws_freeFilter(_filter::Ptr)
    filter = convert(Ptr{SwsFilter},_filter)
    ccall((:sws_freeFilter,libswscale),Void,(Ptr{SwsFilter},),filter)
end
function sws_getCachedContext(_context::Ptr,_srcW::Integer,_srcH::Integer,srcFormat::PixelFormat,_dstW::Integer,_dstH::Integer,dstFormat::PixelFormat,_flags::Integer,_srcFilter::Ptr,_dstFilter::Ptr,_param::Ptr)
    context = convert(Ptr{SwsContext},_context)
    srcW = int32(_srcW)
    srcH = int32(_srcH)
    dstW = int32(_dstW)
    dstH = int32(_dstH)
    flags = int32(_flags)
    srcFilter = convert(Ptr{SwsFilter},_srcFilter)
    dstFilter = convert(Ptr{SwsFilter},_dstFilter)
    param = convert(Ptr{Cdouble},_param)
    ccall((:sws_getCachedContext,libswscale),Ptr{SwsContext},(Ptr{SwsContext},Cint,Cint,PixelFormat,Cint,Cint,PixelFormat,Cint,Ptr{SwsFilter},Ptr{SwsFilter},Ptr{Cdouble}),context,srcW,srcH,srcFormat,dstW,dstH,dstFormat,flags,srcFilter,dstFilter,param)
end
function sws_convertPalette8ToPacked32(_src::Union(Ptr,ByteString),_dst::Union(Ptr,ByteString),_num_pixels::Integer,_palette::Union(Ptr,ByteString))
    src = convert(Ptr{Uint8},_src)
    dst = convert(Ptr{Uint8},_dst)
    num_pixels = int32(_num_pixels)
    palette = convert(Ptr{Uint8},_palette)
    ccall((:sws_convertPalette8ToPacked32,libswscale),Void,(Ptr{Uint8},Ptr{Uint8},Cint,Ptr{Uint8}),src,dst,num_pixels,palette)
end
function sws_convertPalette8ToPacked24(_src::Union(Ptr,ByteString),_dst::Union(Ptr,ByteString),_num_pixels::Integer,_palette::Union(Ptr,ByteString))
    src = convert(Ptr{Uint8},_src)
    dst = convert(Ptr{Uint8},_dst)
    num_pixels = int32(_num_pixels)
    palette = convert(Ptr{Uint8},_palette)
    ccall((:sws_convertPalette8ToPacked24,libswscale),Void,(Ptr{Uint8},Ptr{Uint8},Cint,Ptr{Uint8}),src,dst,num_pixels,palette)
end
function sws_get_class()
    ccall((:sws_get_class,libswscale),Ptr{AVClass},())
end
