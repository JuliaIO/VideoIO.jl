# Julia wrapper for header: /usr/local/include/libavfilter/avfilter.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    #avfilter_version,
    avfilter_configuration,
    avfilter_license,
    avfilter_copy_buffer_ref_props,
    avfilter_ref_buffer,
    avfilter_unref_buffer,
    avfilter_unref_bufferp,
    avfilter_pad_count,
    avfilter_pad_get_name,
    avfilter_pad_get_type,
    avfilter_link,
    avfilter_config_links,
    avfilter_get_video_buffer_ref_from_arrays,
    avfilter_get_audio_buffer_ref_from_arrays,
    avfilter_register_all,
    avfilter_uninit,
    avfilter_register,
    avfilter_get_by_name,
    avfilter_next,
    av_filter_next,
    avfilter_open,
    avfilter_init_filter,
    avfilter_init_str,
    avfilter_init_dict,
    avfilter_free,
    avfilter_insert_filter,
    avfilter_copy_frame_props,
    avfilter_copy_buf_props,
    avfilter_get_class,
    avfilter_graph_alloc,
    avfilter_graph_alloc_filter,
    avfilter_graph_get_filter,
    avfilter_graph_add_filter,
    avfilter_graph_create_filter,
    avfilter_graph_config,
    avfilter_graph_free,
    avfilter_inout_alloc,
    avfilter_inout_free,
    avfilter_graph_parse,
    avfilter_graph_parse2


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

function avfilter_unref_bufferp(ref)
    ccall((:avfilter_unref_bufferp,libavfilter),Cvoid,(Ptr{Ptr{AVFilterBufferRef}},),ref)
end

function avfilter_pad_count(pads)
    ccall((:avfilter_pad_count,libavfilter),Cint,(Ptr{AVFilterPad},),pads)
end

function avfilter_pad_get_name(pads,pad_idx::Integer)
    ccall((:avfilter_pad_get_name,libavfilter),Ptr{UInt8},(Ptr{AVFilterPad},Cint),pads,pad_idx)
end

function avfilter_pad_get_type(pads,pad_idx::Integer)
    ccall((:avfilter_pad_get_type,libavfilter),Cint,(Ptr{AVFilterPad},Cint),pads,pad_idx)
end

function avfilter_link(src,srcpad::Integer,dst,dstpad::Integer)
    ccall((:avfilter_link,libavfilter),Cint,(Ptr{AVFilterContext},UInt32,Ptr{AVFilterContext},UInt32),src,srcpad,dst,dstpad)
end

function avfilter_config_links(filter)
    ccall((:avfilter_config_links,libavfilter),Cint,(Ptr{AVFilterContext},),filter)
end

function avfilter_get_video_buffer_ref_from_arrays(data,linesize,perms::Integer,w::Integer,h::Integer,format::AVPixelFormat)
    ccall((:avfilter_get_video_buffer_ref_from_arrays,libavfilter),Ptr{AVFilterBufferRef},(Ptr{Ptr{UInt8}},Ptr{Cint},Cint,Cint,Cint,AVPixelFormat),data,linesize,perms,w,h,format)
end

function avfilter_get_audio_buffer_ref_from_arrays(data,linesize::Integer,perms::Integer,nb_samples::Integer,sample_fmt::AVSampleFormat,channel_layout::UInt64)
    ccall((:avfilter_get_audio_buffer_ref_from_arrays,libavfilter),Ptr{AVFilterBufferRef},(Ptr{Ptr{UInt8}},Cint,Cint,Cint,AVSampleFormat,UInt64),data,linesize,perms,nb_samples,sample_fmt,channel_layout)
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

function avfilter_next(prev)
    ccall((:avfilter_next,libavfilter),Ptr{AVFilter},(Ptr{AVFilter},),prev)
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

function avfilter_init_str(ctx,args)
    ccall((:avfilter_init_str,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{UInt8}),ctx,args)
end

function avfilter_init_dict(ctx,options)
    ccall((:avfilter_init_dict,libavfilter),Cint,(Ptr{AVFilterContext},Ref{Ptr{AVDictionary}}),ctx,options)
end

function avfilter_free(filter)
    ccall((:avfilter_free,libavfilter),Cvoid,(Ptr{AVFilterContext},),filter)
end

function avfilter_insert_filter(link,filt,filt_srcpad_idx::Integer,filt_dstpad_idx::Integer)
    ccall((:avfilter_insert_filter,libavfilter),Cint,(Ptr{AVFilterLink},Ptr{AVFilterContext},UInt32,UInt32),link,filt,filt_srcpad_idx,filt_dstpad_idx)
end

function avfilter_copy_frame_props(dst,src)
    ccall((:avfilter_copy_frame_props,libavfilter),Cint,(Ptr{AVFilterBufferRef},Ptr{AVFrame}),dst,src)
end

function avfilter_copy_buf_props(dst,src)
    ccall((:avfilter_copy_buf_props,libavfilter),Cint,(Ptr{AVFrame},Ptr{AVFilterBufferRef}),dst,src)
end

function avfilter_get_class()
    ccall((:avfilter_get_class,libavfilter),Ptr{AVClass},())
end

function avfilter_graph_alloc()
    ccall((:avfilter_graph_alloc,libavfilter),Ptr{AVFilterGraph},())
end

function avfilter_graph_alloc_filter(graph,filter,name)
    ccall((:avfilter_graph_alloc_filter,libavfilter),Ptr{AVFilterContext},(Ptr{AVFilterGraph},Ptr{AVFilter},Ptr{UInt8}),graph,filter,name)
end

function avfilter_graph_get_filter(graph,name)
    ccall((:avfilter_graph_get_filter,libavfilter),Ptr{AVFilterContext},(Ptr{AVFilterGraph},Ptr{UInt8}),graph,name)
end

function avfilter_graph_add_filter(graphctx,filter)
    ccall((:avfilter_graph_add_filter,libavfilter),Cint,(Ptr{AVFilterGraph},Ptr{AVFilterContext}),graphctx,filter)
end

function avfilter_graph_create_filter(filt_ctx,filt,name,args,opaque,graph_ctx)
    ccall((:avfilter_graph_create_filter,libavfilter),Cint,(Ptr{Ptr{AVFilterContext}},Ptr{AVFilter},Ptr{UInt8},Ptr{UInt8},Ptr{Cvoid},Ptr{AVFilterGraph}),filt_ctx,filt,name,args,opaque,graph_ctx)
end

function avfilter_graph_config(graphctx,log_ctx)
    ccall((:avfilter_graph_config,libavfilter),Cint,(Ptr{AVFilterGraph},Ptr{Cvoid}),graphctx,log_ctx)
end

function avfilter_graph_free(graph)
    ccall((:avfilter_graph_free,libavfilter),Cvoid,(Ptr{Ptr{AVFilterGraph}},),graph)
end

function avfilter_inout_alloc()
    ccall((:avfilter_inout_alloc,libavfilter),Ptr{AVFilterInOut},())
end

function avfilter_inout_free(inout)
    ccall((:avfilter_inout_free,libavfilter),Cvoid,(Ptr{Ptr{AVFilterInOut}},),inout)
end

function avfilter_graph_parse(graph,filters,inputs,outputs,log_ctx)
    ccall((:avfilter_graph_parse,libavfilter),Cint,(Ptr{AVFilterGraph},Ptr{UInt8},Ptr{AVFilterInOut},Ptr{AVFilterInOut},Ptr{Cvoid}),graph,filters,inputs,outputs,log_ctx)
end

function avfilter_graph_parse2(graph,filters,inputs,outputs)
    ccall((:avfilter_graph_parse2,libavfilter),Cint,(Ptr{AVFilterGraph},Ptr{UInt8},Ptr{Ptr{AVFilterInOut}},Ptr{Ptr{AVFilterInOut}}),graph,filters,inputs,outputs)
end
