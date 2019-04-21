# Julia wrapper for header: /usr/local/include/libavfilter/avfilter.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    avfilter_version,
    avfilter_configuration,
    avfilter_license,
    avfilter_pad_count,
    avfilter_pad_get_name,
    avfilter_pad_get_type,
    avfilter_link,
    avfilter_link_free,
    avfilter_link_get_channels,
    avfilter_link_set_closed,
    avfilter_config_links,
    avfilter_process_command,
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
    avfilter_get_class,
    avfilter_graph_alloc,
    avfilter_graph_alloc_filter,
    avfilter_graph_get_filter,
    avfilter_graph_add_filter,
    avfilter_graph_create_filter,
    avfilter_graph_set_auto_convert,
    avfilter_graph_config,
    avfilter_graph_free,
    avfilter_inout_alloc,
    avfilter_inout_free,
    avfilter_graph_parse,
    avfilter_graph_parse_ptr,
    avfilter_graph_parse2,
    avfilter_graph_send_command,
    avfilter_graph_queue_command,
    avfilter_graph_dump,
    avfilter_graph_request_oldest


function avfilter_version()
    ccall((:avfilter_version,libavfilter),UInt32,())
end

function avfilter_configuration()
    ccall((:avfilter_configuration,libavfilter),Cstring,())
end

function avfilter_license()
    ccall((:avfilter_license,libavfilter),Cstring,())
end

function avfilter_pad_count(pads)
    ccall((:avfilter_pad_count,libavfilter),Cint,(Ptr{AVFilterPad},),pads)
end

function avfilter_pad_get_name(pads,pad_idx::Integer)
    ccall((:avfilter_pad_get_name,libavfilter),Cstring,(Ptr{AVFilterPad},Cint),pads,pad_idx)
end

function avfilter_pad_get_type(pads,pad_idx::Integer)
    ccall((:avfilter_pad_get_type,libavfilter),Cint,(Ptr{AVFilterPad},Cint),pads,pad_idx)
end

function avfilter_link(src,srcpad::Integer,dst,dstpad::Integer)
    ccall((:avfilter_link,libavfilter),Cint,(Ptr{AVFilterContext},UInt32,Ptr{AVFilterContext},UInt32),src,srcpad,dst,dstpad)
end

function avfilter_link_free(link)
    ccall((:avfilter_link_free,libavfilter),Cvoid,(Ptr{Ptr{AVFilterLink}},),link)
end

function avfilter_link_get_channels(link)
    ccall((:avfilter_link_get_channels,libavfilter),Cint,(Ptr{AVFilterLink},),link)
end

function avfilter_link_set_closed(link,closed::Integer)
    ccall((:avfilter_link_set_closed,libavfilter),Cvoid,(Ptr{AVFilterLink},Cint),link,closed)
end

function avfilter_config_links(filter)
    ccall((:avfilter_config_links,libavfilter),Cint,(Ptr{AVFilterContext},),filter)
end

function avfilter_process_command(filter,cmd,arg,res,res_len::Integer,flags::Integer)
    ccall((:avfilter_process_command,libavfilter),Cint,(Ptr{AVFilterContext},Cstring,Cstring,Cstring,Cint,Cint),filter,cmd,arg,res,res_len,flags)
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
    ccall((:avfilter_get_by_name,libavfilter),Ptr{AVFilter},(Cstring,),name)
end

function avfilter_next(prev)
    ccall((:avfilter_next,libavfilter),Ptr{AVFilter},(Ptr{AVFilter},),prev)
end

function av_filter_next(filter)
    ccall((:av_filter_next,libavfilter),Ptr{Ptr{AVFilter}},(Ptr{Ptr{AVFilter}},),filter)
end

function avfilter_open(filter_ctx,filter,inst_name)
    ccall((:avfilter_open,libavfilter),Cint,(Ptr{Ptr{AVFilterContext}},Ptr{AVFilter},Cstring),filter_ctx,filter,inst_name)
end

function avfilter_init_filter(filter,args,opaque)
    ccall((:avfilter_init_filter,libavfilter),Cint,(Ptr{AVFilterContext},Cstring,Ptr{Cvoid}),filter,args,opaque)
end

function avfilter_init_str(ctx,args)
    ccall((:avfilter_init_str,libavfilter),Cint,(Ptr{AVFilterContext},Cstring),ctx,args)
end

function avfilter_init_dict(ctx,options)
    ccall((:avfilter_init_dict,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Ptr{AVDictionary}}),ctx,options)
end

function avfilter_free(filter)
    ccall((:avfilter_free,libavfilter),Cvoid,(Ptr{AVFilterContext},),filter)
end

function avfilter_insert_filter(link,filt,filt_srcpad_idx::Integer,filt_dstpad_idx::Integer)
    ccall((:avfilter_insert_filter,libavfilter),Cint,(Ptr{AVFilterLink},Ptr{AVFilterContext},UInt32,UInt32),link,filt,filt_srcpad_idx,filt_dstpad_idx)
end

function avfilter_get_class()
    ccall((:avfilter_get_class,libavfilter),Ptr{AVClass},())
end

function avfilter_graph_alloc()
    ccall((:avfilter_graph_alloc,libavfilter),Ptr{AVFilterGraph},())
end

function avfilter_graph_alloc_filter(graph,filter,name)
    ccall((:avfilter_graph_alloc_filter,libavfilter),Ptr{AVFilterContext},(Ptr{AVFilterGraph},Ptr{AVFilter},Cstring),graph,filter,name)
end

function avfilter_graph_get_filter(graph,name)
    ccall((:avfilter_graph_get_filter,libavfilter),Ptr{AVFilterContext},(Ptr{AVFilterGraph},Cstring),graph,name)
end

function avfilter_graph_add_filter(graphctx,filter)
    ccall((:avfilter_graph_add_filter,libavfilter),Cint,(Ptr{AVFilterGraph},Ptr{AVFilterContext}),graphctx,filter)
end

function avfilter_graph_create_filter(filt_ctx,filt,name,args,opaque,graph_ctx)
    ccall((:avfilter_graph_create_filter,libavfilter),Cint,(Ptr{Ptr{AVFilterContext}},Ptr{AVFilter},Cstring,Cstring,Ptr{Cvoid},Ptr{AVFilterGraph}),filt_ctx,filt,name,args,opaque,graph_ctx)
end

function avfilter_graph_set_auto_convert(graph,flags::Integer)
    ccall((:avfilter_graph_set_auto_convert,libavfilter),Cvoid,(Ptr{AVFilterGraph},UInt32),graph,flags)
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
    ccall((:avfilter_graph_parse,libavfilter),Cint,(Ptr{AVFilterGraph},Cstring,Ptr{AVFilterInOut},Ptr{AVFilterInOut},Ptr{Cvoid}),graph,filters,inputs,outputs,log_ctx)
end

function avfilter_graph_parse_ptr(graph,filters,inputs,outputs,log_ctx)
    ccall((:avfilter_graph_parse_ptr,libavfilter),Cint,(Ptr{AVFilterGraph},Cstring,Ptr{Ptr{AVFilterInOut}},Ptr{Ptr{AVFilterInOut}},Ptr{Cvoid}),graph,filters,inputs,outputs,log_ctx)
end

function avfilter_graph_parse2(graph,filters,inputs,outputs)
    ccall((:avfilter_graph_parse2,libavfilter),Cint,(Ptr{AVFilterGraph},Cstring,Ptr{Ptr{AVFilterInOut}},Ptr{Ptr{AVFilterInOut}}),graph,filters,inputs,outputs)
end

function avfilter_graph_send_command(graph,target,cmd,arg,res,res_len::Integer,flags::Integer)
    ccall((:avfilter_graph_send_command,libavfilter),Cint,(Ptr{AVFilterGraph},Cstring,Cstring,Cstring,Cstring,Cint,Cint),graph,target,cmd,arg,res,res_len,flags)
end

function avfilter_graph_queue_command(graph,target,cmd,arg,flags::Integer,ts::Cdouble)
    ccall((:avfilter_graph_queue_command,libavfilter),Cint,(Ptr{AVFilterGraph},Cstring,Cstring,Cstring,Cint,Cdouble),graph,target,cmd,arg,flags,ts)
end

function avfilter_graph_dump(graph,options)
    ccall((:avfilter_graph_dump,libavfilter),Cstring,(Ptr{AVFilterGraph},Cstring),graph,options)
end

function avfilter_graph_request_oldest(graph)
    ccall((:avfilter_graph_request_oldest,libavfilter),Cint,(Ptr{AVFilterGraph},),graph)
end
