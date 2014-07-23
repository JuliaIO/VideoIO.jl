# Julia wrapper for header: /opt/ffmpeg/include/libswscale/swscale.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    #swscale_version,
    swscale_configuration,
    swscale_license,
    sws_getCoefficients,
    sws_isSupportedInput,
    sws_isSupportedOutput,
    sws_isSupportedEndiannessConversion,
    sws_alloc_context,
    sws_init_context,
    sws_freeContext,
    sws_getContext,
    sws_scale,
    sws_setColorspaceDetails,
    sws_getColorspaceDetails,
    sws_allocVec,
    sws_getGaussianVec,
    sws_getConstVec,
    sws_getIdentityVec,
    sws_scaleVec,
    sws_normalizeVec,
    sws_convVec,
    sws_addVec,
    sws_subVec,
    sws_shiftVec,
    sws_cloneVec,
    sws_printVec2,
    sws_freeVec,
    sws_getDefaultFilter,
    sws_freeFilter,
    sws_getCachedContext,
    sws_convertPalette8ToPacked32,
    sws_convertPalette8ToPacked24,
    sws_get_class


function swscale_version()
    ccall((:swscale_version,libswscale),Uint32,())
end

function swscale_configuration()
    ccall((:swscale_configuration,libswscale),Ptr{Uint8},())
end

function swscale_license()
    ccall((:swscale_license,libswscale),Ptr{Uint8},())
end

function sws_getCoefficients(colorspace::Integer)
    ccall((:sws_getCoefficients,libswscale),Ptr{Cint},(Cint,),colorspace)
end

function sws_isSupportedInput(pix_fmt::AVPixelFormat)
    ccall((:sws_isSupportedInput,libswscale),Cint,(AVPixelFormat,),pix_fmt)
end

function sws_isSupportedOutput(pix_fmt::AVPixelFormat)
    ccall((:sws_isSupportedOutput,libswscale),Cint,(AVPixelFormat,),pix_fmt)
end

function sws_isSupportedEndiannessConversion(pix_fmt::AVPixelFormat)
    ccall((:sws_isSupportedEndiannessConversion,libswscale),Cint,(AVPixelFormat,),pix_fmt)
end

function sws_alloc_context()
    ccall((:sws_alloc_context,libswscale),Ptr{SwsContext},())
end

function sws_init_context(sws_context,srcFilter,dstFilter)
    ccall((:sws_init_context,libswscale),Cint,(Ptr{SwsContext},Ptr{SwsFilter},Ptr{SwsFilter}),sws_context,srcFilter,dstFilter)
end

function sws_freeContext(swsContext)
    ccall((:sws_freeContext,libswscale),Void,(Ptr{SwsContext},),swsContext)
end

function sws_getContext(srcW::Integer,srcH::Integer,srcFormat::AVPixelFormat,dstW::Integer,dstH::Integer,dstFormat::AVPixelFormat,flags::Integer,srcFilter,dstFilter,param)
    ccall((:sws_getContext,libswscale),Ptr{SwsContext},(Cint,Cint,AVPixelFormat,Cint,Cint,AVPixelFormat,Cint,Ptr{SwsFilter},Ptr{SwsFilter},Ptr{Cdouble}),srcW,srcH,srcFormat,dstW,dstH,dstFormat,flags,srcFilter,dstFilter,param)
end

function sws_scale(c,srcSlice,srcStride,srcSliceY::Integer,srcSliceH::Integer,dst,dstStride)
    ccall((:sws_scale,libswscale),Cint,(Ptr{SwsContext},Ptr{Ptr{Uint8}},Ptr{Cint},Cint,Cint,Ptr{Ptr{Uint8}},Ptr{Cint}),c,srcSlice,srcStride,srcSliceY,srcSliceH,dst,dstStride)
end

function sws_setColorspaceDetails(c,inv_table,srcRange::Integer,table,dstRange::Integer,brightness::Integer,contrast::Integer,saturation::Integer)
    ccall((:sws_setColorspaceDetails,libswscale),Cint,(Ptr{SwsContext},Ptr{Cint},Cint,Ptr{Cint},Cint,Cint,Cint,Cint),c,inv_table,srcRange,table,dstRange,brightness,contrast,saturation)
end

function sws_getColorspaceDetails(c,inv_table,srcRange,table,dstRange,brightness,contrast,saturation)
    ccall((:sws_getColorspaceDetails,libswscale),Cint,(Ptr{SwsContext},Ptr{Ptr{Cint}},Ptr{Cint},Ptr{Ptr{Cint}},Ptr{Cint},Ptr{Cint},Ptr{Cint},Ptr{Cint}),c,inv_table,srcRange,table,dstRange,brightness,contrast,saturation)
end

function sws_allocVec(length::Integer)
    ccall((:sws_allocVec,libswscale),Ptr{SwsVector},(Cint,),length)
end

function sws_getGaussianVec(variance::Cdouble,quality::Cdouble)
    ccall((:sws_getGaussianVec,libswscale),Ptr{SwsVector},(Cdouble,Cdouble),variance,quality)
end

function sws_getConstVec(c::Cdouble,length::Integer)
    ccall((:sws_getConstVec,libswscale),Ptr{SwsVector},(Cdouble,Cint),c,length)
end

function sws_getIdentityVec()
    ccall((:sws_getIdentityVec,libswscale),Ptr{SwsVector},())
end

function sws_scaleVec(a,scalar::Cdouble)
    ccall((:sws_scaleVec,libswscale),Void,(Ptr{SwsVector},Cdouble),a,scalar)
end

function sws_normalizeVec(a,height::Cdouble)
    ccall((:sws_normalizeVec,libswscale),Void,(Ptr{SwsVector},Cdouble),a,height)
end

function sws_convVec(a,b)
    ccall((:sws_convVec,libswscale),Void,(Ptr{SwsVector},Ptr{SwsVector}),a,b)
end

function sws_addVec(a,b)
    ccall((:sws_addVec,libswscale),Void,(Ptr{SwsVector},Ptr{SwsVector}),a,b)
end

function sws_subVec(a,b)
    ccall((:sws_subVec,libswscale),Void,(Ptr{SwsVector},Ptr{SwsVector}),a,b)
end

function sws_shiftVec(a,shift::Integer)
    ccall((:sws_shiftVec,libswscale),Void,(Ptr{SwsVector},Cint),a,shift)
end

function sws_cloneVec(a)
    ccall((:sws_cloneVec,libswscale),Ptr{SwsVector},(Ptr{SwsVector},),a)
end

function sws_printVec2(a,log_ctx,log_level::Integer)
    ccall((:sws_printVec2,libswscale),Void,(Ptr{SwsVector},Ptr{AVClass},Cint),a,log_ctx,log_level)
end

function sws_freeVec(a)
    ccall((:sws_freeVec,libswscale),Void,(Ptr{SwsVector},),a)
end

function sws_getDefaultFilter(lumaGBlur::Cfloat,chromaGBlur::Cfloat,lumaSharpen::Cfloat,chromaSharpen::Cfloat,chromaHShift::Cfloat,chromaVShift::Cfloat,verbose::Integer)
    ccall((:sws_getDefaultFilter,libswscale),Ptr{SwsFilter},(Cfloat,Cfloat,Cfloat,Cfloat,Cfloat,Cfloat,Cint),lumaGBlur,chromaGBlur,lumaSharpen,chromaSharpen,chromaHShift,chromaVShift,verbose)
end

function sws_freeFilter(filter)
    ccall((:sws_freeFilter,libswscale),Void,(Ptr{SwsFilter},),filter)
end

function sws_getCachedContext(context,srcW::Integer,srcH::Integer,srcFormat::AVPixelFormat,dstW::Integer,dstH::Integer,dstFormat::AVPixelFormat,flags::Integer,srcFilter,dstFilter,param)
    ccall((:sws_getCachedContext,libswscale),Ptr{SwsContext},(Ptr{SwsContext},Cint,Cint,AVPixelFormat,Cint,Cint,AVPixelFormat,Cint,Ptr{SwsFilter},Ptr{SwsFilter},Ptr{Cdouble}),context,srcW,srcH,srcFormat,dstW,dstH,dstFormat,flags,srcFilter,dstFilter,param)
end

function sws_convertPalette8ToPacked32(src,dst,num_pixels::Integer,palette)
    ccall((:sws_convertPalette8ToPacked32,libswscale),Void,(Ptr{Uint8},Ptr{Uint8},Cint,Ptr{Uint8}),src,dst,num_pixels,palette)
end

function sws_convertPalette8ToPacked24(src,dst,num_pixels::Integer,palette)
    ccall((:sws_convertPalette8ToPacked24,libswscale),Void,(Ptr{Uint8},Ptr{Uint8},Cint,Ptr{Uint8}),src,dst,num_pixels,palette)
end

function sws_get_class()
    ccall((:sws_get_class,libswscale),Ptr{AVClass},())
end
