# Julia wrapper for header: /usr/include/libavutil/hwcontext.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_hwdevice_find_type_by_name,
    av_hwdevice_get_type_name,
    av_hwdevice_iterate_types,
    av_hwdevice_ctx_alloc,
    av_hwdevice_ctx_init,
    av_hwdevice_ctx_create,
    av_hwdevice_ctx_create_derived,
    av_hwframe_ctx_alloc,
    av_hwframe_ctx_init,
    av_hwframe_get_buffer,
    av_hwframe_transfer_data,
    av_hwframe_transfer_get_formats,
    av_hwdevice_hwconfig_alloc,
    av_hwdevice_get_hwframe_constraints,
    av_hwframe_constraints_free,
    av_hwframe_map,
    av_hwframe_ctx_create_derived


function av_hwdevice_find_type_by_name(name)
    ccall((:av_hwdevice_find_type_by_name, libavutil), AVHWDeviceType, (Cstring,), name)
end

function av_hwdevice_get_type_name(_type::AVHWDeviceType)
    ccall((:av_hwdevice_get_type_name, libavutil), Cstring, (AVHWDeviceType,), _type)
end

function av_hwdevice_iterate_types(prev::AVHWDeviceType)
    ccall((:av_hwdevice_iterate_types, libavutil), AVHWDeviceType, (AVHWDeviceType,), prev)
end

function av_hwdevice_ctx_alloc(_type::AVHWDeviceType)
    ccall((:av_hwdevice_ctx_alloc, libavutil), Ptr{AVBufferRef}, (AVHWDeviceType,), _type)
end

function av_hwdevice_ctx_init(ref)
    ccall((:av_hwdevice_ctx_init, libavutil), Cint, (Ptr{AVBufferRef},), ref)
end

function av_hwdevice_ctx_create(device_ctx, _type::AVHWDeviceType, device, opts, flags::Integer)
    ccall((:av_hwdevice_ctx_create, libavutil), Cint, (Ptr{Ptr{AVBufferRef}}, AVHWDeviceType, Cstring, Ptr{AVDictionary}, Cint), device_ctx, _type, device, opts, flags)
end

function av_hwdevice_ctx_create_derived(dst_ctx, _type::AVHWDeviceType, src_ctx, flags::Integer)
    ccall((:av_hwdevice_ctx_create_derived, libavutil), Cint, (Ptr{Ptr{AVBufferRef}}, AVHWDeviceType, Ptr{AVBufferRef}, Cint), dst_ctx, _type, src_ctx, flags)
end

function av_hwframe_ctx_alloc(device_ctx)
    ccall((:av_hwframe_ctx_alloc, libavutil), Ptr{AVBufferRef}, (Ptr{AVBufferRef},), device_ctx)
end

function av_hwframe_ctx_init(ref)
    ccall((:av_hwframe_ctx_init, libavutil), Cint, (Ptr{AVBufferRef},), ref)
end

function av_hwframe_get_buffer(hwframe_ctx, frame, flags::Integer)
    ccall((:av_hwframe_get_buffer, libavutil), Cint, (Ptr{AVBufferRef}, Ptr{AVFrame}, Cint), hwframe_ctx, frame, flags)
end

function av_hwframe_transfer_data(dst, src, flags::Integer)
    ccall((:av_hwframe_transfer_data, libavutil), Cint, (Ptr{AVFrame}, Ptr{AVFrame}, Cint), dst, src, flags)
end

function av_hwframe_transfer_get_formats(hwframe_ctx, dir::AVHWFrameTransferDirection, formats, flags::Integer)
    ccall((:av_hwframe_transfer_get_formats, libavutil), Cint, (Ptr{AVBufferRef}, AVHWFrameTransferDirection, Ptr{Ptr{AVPixelFormat}}, Cint), hwframe_ctx, dir, formats, flags)
end

function av_hwdevice_hwconfig_alloc(device_ctx)
    ccall((:av_hwdevice_hwconfig_alloc, libavutil), Ptr{Cvoid}, (Ptr{AVBufferRef},), device_ctx)
end

function av_hwdevice_get_hwframe_constraints(ref, hwconfig)
    ccall((:av_hwdevice_get_hwframe_constraints, libavutil), Ptr{AVHWFramesConstraints}, (Ptr{AVBufferRef}, Ptr{Cvoid}), ref, hwconfig)
end

function av_hwframe_constraints_free(constraints)
    ccall((:av_hwframe_constraints_free, libavutil), Cvoid, (Ptr{Ptr{AVHWFramesConstraints}},), constraints)
end

function av_hwframe_map(dst, src, flags::Integer)
    ccall((:av_hwframe_map, libavutil), Cint, (Ptr{AVFrame}, Ptr{AVFrame}, Cint), dst, src, flags)
end

function av_hwframe_ctx_create_derived(derived_frame_ctx, format::AVPixelFormat, derived_device_ctx, source_frame_ctx, flags::Integer)
    ccall((:av_hwframe_ctx_create_derived, libavutil), Cint, (Ptr{Ptr{AVBufferRef}}, AVPixelFormat, Ptr{AVBufferRef}, Ptr{AVBufferRef}, Cint), derived_frame_ctx, format, derived_device_ctx, source_frame_ctx, flags)
end
