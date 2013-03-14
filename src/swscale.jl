# Julia wrapper for header: /usr/include/libswscale/swscale.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Uint32 swscale_version () libswscale
@c Ptr{:Uint8} swscale_configuration () libswscale
@c Ptr{:Uint8} swscale_license () libswscale
@c Ptr{:Int32} sws_getCoefficients (:Int32,) libswscale
@c Int32 sws_isSupportedInput (:Void,) libswscale
@c Int32 sws_isSupportedOutput (:Void,) libswscale
@c Ptr{:Void} sws_alloc_context () libswscale
@c Int32 sws_init_context (Ptr{:Void},Ptr{:SwsFilter},Ptr{:SwsFilter}) libswscale
@c None sws_freeContext (Ptr{:Void},) libswscale
@c Ptr{:Void} sws_getContext (:Int32,:Int32,:Void,:Int32,:Int32,:Void,:Int32,Ptr{:SwsFilter},Ptr{:SwsFilter},Ptr{:Float64}) libswscale
@c Int32 sws_scale (Ptr{:Void},Ptr{Ptr{:uint8_t}},Ptr{:Int32},:Int32,:Int32,Ptr{Ptr{:uint8_t}},Ptr{:Int32}) libswscale
@c Int32 sws_setColorspaceDetails (Ptr{:Void},Ptr{:Int32},:Int32,Ptr{:Int32},:Int32,:Int32,:Int32,:Int32) libswscale
@c Int32 sws_getColorspaceDetails (Ptr{:Void},Ptr{Ptr{:Int32}},Ptr{:Int32},Ptr{Ptr{:Int32}},Ptr{:Int32},Ptr{:Int32},Ptr{:Int32},Ptr{:Int32}) libswscale
@c Ptr{:SwsVector} sws_allocVec (:Int32,) libswscale
@c Ptr{:SwsVector} sws_getGaussianVec (:Float64,:Float64) libswscale
@c Ptr{:SwsVector} sws_getConstVec (:Float64,:Int32) libswscale
@c Ptr{:SwsVector} sws_getIdentityVec () libswscale
@c None sws_scaleVec (Ptr{:SwsVector},:Float64) libswscale
@c None sws_normalizeVec (Ptr{:SwsVector},:Float64) libswscale
@c None sws_convVec (Ptr{:SwsVector},Ptr{:SwsVector}) libswscale
@c None sws_addVec (Ptr{:SwsVector},Ptr{:SwsVector}) libswscale
@c None sws_subVec (Ptr{:SwsVector},Ptr{:SwsVector}) libswscale
@c None sws_shiftVec (Ptr{:SwsVector},:Int32) libswscale
@c Ptr{:SwsVector} sws_cloneVec (Ptr{:SwsVector},) libswscale
@c None sws_printVec2 (Ptr{:SwsVector},Ptr{:AVClass},:Int32) libswscale
@c None sws_freeVec (Ptr{:SwsVector},) libswscale
@c Ptr{:SwsFilter} sws_getDefaultFilter (:Float32,:Float32,:Float32,:Float32,:Float32,:Float32,:Int32) libswscale
@c None sws_freeFilter (Ptr{:SwsFilter},) libswscale
@c Ptr{:Void} sws_getCachedContext (Ptr{:Void},:Int32,:Int32,:Void,:Int32,:Int32,:Void,:Int32,Ptr{:SwsFilter},Ptr{:SwsFilter},Ptr{:Float64}) libswscale
@c None sws_convertPalette8ToPacked32 (Ptr{:uint8_t},Ptr{:uint8_t},:Int32,Ptr{:uint8_t}) libswscale
@c None sws_convertPalette8ToPacked24 (Ptr{:uint8_t},Ptr{:uint8_t},:Int32,Ptr{:uint8_t}) libswscale
@c Ptr{:AVClass} sws_get_class () libswscale

