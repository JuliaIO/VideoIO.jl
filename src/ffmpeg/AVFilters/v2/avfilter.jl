# Julia wrapper for header: /usr/local/include/libavfilter/avfilter.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    #avfilter_version,
    avfilter_configuration,
    avfilter_license,
    avfilter_copy_buffer_ref_props,
    avfilter_ref_buffer,
    avfilter_unref_buffer,
    avfilter_make_format_list,
    avfilter_add_format,
    avfilter_all_formats,
    avfilter_merge_formats,
    avfilter_formats_ref,
    avfilter_formats_unref,
    avfilter_formats_changeref,
    avfilter_default_start_frame,
    avfilter_default_draw_slice,
    avfilter_default_end_frame,
    avfilter_default_filter_samples,
    avfilter_default_config_output_link,
    avfilter_default_config_input_link,
    avfilter_default_get_video_buffer,
    avfilter_default_get_audio_buffer,
    avfilter_set_common_formats,
    avfilter_default_query_formats,
    avfilter_null_start_frame,
    avfilter_null_draw_slice,
    avfilter_null_end_frame,
    avfilter_null_filter_samples,
    avfilter_null_get_video_buffer,
    avfilter_null_get_audio_buffer,
    avfilter_link,
    avfilter_config_links,
    avfilter_get_video_buffer,
    avfilter_get_video_buffer_ref_from_arrays,
    avfilter_get_audio_buffer,
    avfilter_request_frame,
    avfilter_poll_frame,
    avfilter_start_frame,
    avfilter_end_frame,
    avfilter_draw_slice,
    avfilter_filter_samples,
    avfilter_register_all,
    avfilter_uninit,
    avfilter_register,
    avfilter_get_by_name,
    av_filter_next,
    avfilter_open,
    avfilter_init_filter,
    avfilter_free,
    avfilter_insert_filter,
    avfilter_insert_pad,
    avfilter_insert_inpad,
    avfilter_insert_outpad,
    avfilter_copy_frame_props


function avfilter_version()
    ccall((:avfilter_version,libavfilter),UInt32,())
end

function avfilter_configuration()
    ccall((:avfilter_configuration,libavfilter),Ptr{UInt8},())
end

function avfilter_license()
    ccall((:avfilter_license,libavfilter),Ptr{UInt8},())
end

function avfilter_copy_buffer_ref_props(dst,src)
    ccall((:avfilter_copy_buffer_ref_props,libavfilter),Cvoid,(Ptr{AVFilterBufferRef},Ptr{AVFilterBufferRef}),dst,src)
end

function avfilter_ref_buffer(ref,pmask::Integer)
    ccall((:avfilter_ref_buffer,libavfilter),Ptr{AVFilterBufferRef},(Ptr{AVFilterBufferRef},Cint),ref,pmask)
end

function avfilter_unref_buffer(ref)
    ccall((:avfilter_unref_buffer,libavfilter),Cvoid,(Ptr{AVFilterBufferRef},),ref)
end

function avfilter_make_format_list(fmts)
    ccall((:avfilter_make_format_list,libavfilter),Ptr{AVFilterFormats},(Ptr{Cint},),fmts)
end

function avfilter_add_format(avff,fmt::Integer)
    ccall((:avfilter_add_format,libavfilter),Cint,(Ptr{Ptr{AVFilterFormats}},Cint),avff,fmt)
end

function avfilter_all_formats(_type::AVMediaType)
    ccall((:avfilter_all_formats,libavfilter),Ptr{AVFilterFormats},(AVMediaType,),_type)
end

function avfilter_merge_formats(a,b)
    ccall((:avfilter_merge_formats,libavfilter),Ptr{AVFilterFormats},(Ptr{AVFilterFormats},Ptr{AVFilterFormats}),a,b)
end

function avfilter_formats_ref(formats,ref)
    ccall((:avfilter_formats_ref,libavfilter),Cvoid,(Ptr{AVFilterFormats},Ptr{Ptr{AVFilterFormats}}),formats,ref)
end

function avfilter_formats_unref(ref)
    ccall((:avfilter_formats_unref,libavfilter),Cvoid,(Ptr{Ptr{AVFilterFormats}},),ref)
end

function avfilter_formats_changeref(oldref,newref)
    ccall((:avfilter_formats_changeref,libavfilter),Cvoid,(Ptr{Ptr{AVFilterFormats}},Ptr{Ptr{AVFilterFormats}}),oldref,newref)
end

function avfilter_default_start_frame(link,picref)
    ccall((:avfilter_default_start_frame,libavfilter),Cvoid,(Ptr{AVFilterLink},Ptr{AVFilterBufferRef}),link,picref)
end

function avfilter_default_draw_slice(link,y::Integer,h::Integer,slice_dir::Integer)
    ccall((:avfilter_default_draw_slice,libavfilter),Cvoid,(Ptr{AVFilterLink},Cint,Cint,Cint),link,y,h,slice_dir)
end

function avfilter_default_end_frame(link)
    ccall((:avfilter_default_end_frame,libavfilter),Cvoid,(Ptr{AVFilterLink},),link)
end

function avfilter_default_filter_samples(link,samplesref)
    ccall((:avfilter_default_filter_samples,libavfilter),Cvoid,(Ptr{AVFilterLink},Ptr{AVFilterBufferRef}),link,samplesref)
end

function avfilter_default_config_output_link(link)
    ccall((:avfilter_default_config_output_link,libavfilter),Cint,(Ptr{AVFilterLink},),link)
end

function avfilter_default_config_input_link(link)
    ccall((:avfilter_default_config_input_link,libavfilter),Cint,(Ptr{AVFilterLink},),link)
end

function avfilter_default_get_video_buffer(link,perms::Integer,w::Integer,h::Integer)
    ccall((:avfilter_default_get_video_buffer,libavfilter),Ptr{AVFilterBufferRef},(Ptr{AVFilterLink},Cint,Cint,Cint),link,perms,w,h)
end

function avfilter_default_get_audio_buffer(link,perms::Integer,sample_fmt::AVSampleFormat,size::Integer,channel_layout::UInt64,planar::Integer)
    ccall((:avfilter_default_get_audio_buffer,libavfilter),Ptr{AVFilterBufferRef},(Ptr{AVFilterLink},Cint,AVSampleFormat,Cint,UInt64,Cint),link,perms,sample_fmt,size,channel_layout,planar)
end

function avfilter_set_common_formats(ctx,formats)
    ccall((:avfilter_set_common_formats,libavfilter),Cvoid,(Ptr{AVFilterContext},Ptr{AVFilterFormats}),ctx,formats)
end

function avfilter_default_query_formats(ctx)
    ccall((:avfilter_default_query_formats,libavfilter),Cint,(Ptr{AVFilterContext},),ctx)
end

function avfilter_null_start_frame(link,picref)
    ccall((:avfilter_null_start_frame,libavfilter),Cvoid,(Ptr{AVFilterLink},Ptr{AVFilterBufferRef}),link,picref)
end

function avfilter_null_draw_slice(link,y::Integer,h::Integer,slice_dir::Integer)
    ccall((:avfilter_null_draw_slice,libavfilter),Cvoid,(Ptr{AVFilterLink},Cint,Cint,Cint),link,y,h,slice_dir)
end

function avfilter_null_end_frame(link)
    ccall((:avfilter_null_end_frame,libavfilter),Cvoid,(Ptr{AVFilterLink},),link)
end

function avfilter_null_filter_samples(link,samplesref)
    ccall((:avfilter_null_filter_samples,libavfilter),Cvoid,(Ptr{AVFilterLink},Ptr{AVFilterBufferRef}),link,samplesref)
end

function avfilter_null_get_video_buffer(link,perms::Integer,w::Integer,h::Integer)
    ccall((:avfilter_null_get_video_buffer,libavfilter),Ptr{AVFilterBufferRef},(Ptr{AVFilterLink},Cint,Cint,Cint),link,perms,w,h)
end

function avfilter_null_get_audio_buffer(link,perms::Integer,sample_fmt::AVSampleFormat,size::Integer,channel_layout::UInt64,planar::Integer)
    ccall((:avfilter_null_get_audio_buffer,libavfilter),Ptr{AVFilterBufferRef},(Ptr{AVFilterLink},Cint,AVSampleFormat,Cint,UInt64,Cint),link,perms,sample_fmt,size,channel_layout,planar)
end

function avfilter_link(src,srcpad::Integer,dst,dstpad::Integer)
    ccall((:avfilter_link,libavfilter),Cint,(Ptr{AVFilterContext},UInt32,Ptr{AVFilterContext},UInt32),src,srcpad,dst,dstpad)
end

function avfilter_config_links(filter)
    ccall((:avfilter_config_links,libavfilter),Cint,(Ptr{AVFilterContext},),filter)
end

function avfilter_get_video_buffer(link,perms::Integer,w::Integer,h::Integer)
    ccall((:avfilter_get_video_buffer,libavfilter),Ptr{AVFilterBufferRef},(Ptr{AVFilterLink},Cint,Cint,Cint),link,perms,w,h)
end

function avfilter_get_video_buffer_ref_from_arrays(data,linesize,perms::Integer,w::Integer,h::Integer,format::PixelFormat)
    ccall((:avfilter_get_video_buffer_ref_from_arrays,libavfilter),Ptr{AVFilterBufferRef},(Ptr{Ptr{UInt8}},Ptr{Cint},Cint,Cint,Cint,PixelFormat),data,linesize,perms,w,h,format)
end

function avfilter_get_audio_buffer(link,perms::Integer,sample_fmt::AVSampleFormat,size::Integer,channel_layout::UInt64,planar::Integer)
    ccall((:avfilter_get_audio_buffer,libavfilter),Ptr{AVFilterBufferRef},(Ptr{AVFilterLink},Cint,AVSampleFormat,Cint,UInt64,Cint),link,perms,sample_fmt,size,channel_layout,planar)
end

function avfilter_request_frame(link)
    ccall((:avfilter_request_frame,libavfilter),Cint,(Ptr{AVFilterLink},),link)
end

function avfilter_poll_frame(link)
    ccall((:avfilter_poll_frame,libavfilter),Cint,(Ptr{AVFilterLink},),link)
end

function avfilter_start_frame(link,picref)
    ccall((:avfilter_start_frame,libavfilter),Cvoid,(Ptr{AVFilterLink},Ptr{AVFilterBufferRef}),link,picref)
end

function avfilter_end_frame(link)
    ccall((:avfilter_end_frame,libavfilter),Cvoid,(Ptr{AVFilterLink},),link)
end

function avfilter_draw_slice(link,y::Integer,h::Integer,slice_dir::Integer)
    ccall((:avfilter_draw_slice,libavfilter),Cvoid,(Ptr{AVFilterLink},Cint,Cint,Cint),link,y,h,slice_dir)
end

function avfilter_filter_samples(link,samplesref)
    ccall((:avfilter_filter_samples,libavfilter),Cvoid,(Ptr{AVFilterLink},Ptr{AVFilterBufferRef}),link,samplesref)
end

function avfilter_register_all()
    ccall((:avfilter_register_all,libavfilter),Cvoid,())
end

function avfilter_uninit()
    ccall((:avfilter_uninit,libavfilter),Cvoid,())
end

function avfilter_register(filter)
    ccall((:avfilter_register,libavfilter),Cint,(Ptr{AVFilter},),filter)
end

function avfilter_get_by_name(name)
    ccall((:avfilter_get_by_name,libavfilter),Ptr{AVFilter},(Ptr{UInt8},),name)
end

function av_filter_next(filter)
    ccall((:av_filter_next,libavfilter),Ptr{Ptr{AVFilter}},(Ptr{Ptr{AVFilter}},),filter)
end

function avfilter_open(filter_ctx,filter,inst_name)
    ccall((:avfilter_open,libavfilter),Cint,(Ptr{Ptr{AVFilterContext}},Ptr{AVFilter},Ptr{UInt8}),filter_ctx,filter,inst_name)
end

function avfilter_init_filter(filter,args,opaque)
    ccall((:avfilter_init_filter,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{UInt8},Ptr{Cvoid}),filter,args,opaque)
end

function avfilter_free(filter)
    ccall((:avfilter_free,libavfilter),Cvoid,(Ptr{AVFilterContext},),filter)
end

function avfilter_insert_filter(link,filt,filt_srcpad_idx::Integer,filt_dstpad_idx::Integer)
    ccall((:avfilter_insert_filter,libavfilter),Cint,(Ptr{AVFilterLink},Ptr{AVFilterContext},UInt32,UInt32),link,filt,filt_srcpad_idx,filt_dstpad_idx)
end

function avfilter_insert_pad(idx::Integer,count,padidx_off::Csize_t,pads,links,newpad)
    ccall((:avfilter_insert_pad,libavfilter),Cvoid,(UInt32,Ptr{UInt32},Csize_t,Ptr{Ptr{AVFilterPad}},Ptr{Ptr{Ptr{AVFilterLink}}},Ptr{AVFilterPad}),idx,count,padidx_off,pads,links,newpad)
end

function avfilter_insert_inpad(f,index::Integer,p)
    ccall((:avfilter_insert_inpad,libavfilter),Cvoid,(Ptr{AVFilterContext},UInt32,Ptr{AVFilterPad}),f,index,p)
end

function avfilter_insert_outpad(f,index::Integer,p)
    ccall((:avfilter_insert_outpad,libavfilter),Cvoid,(Ptr{AVFilterContext},UInt32,Ptr{AVFilterPad}),f,index,p)
end

function avfilter_copy_frame_props(dst,src)
    ccall((:avfilter_copy_frame_props,libavfilter),Cint,(Ptr{AVFilterBufferRef},Ptr{AVFrame}),dst,src)
end
