# Julia wrapper for header: /usr/include/libavfilter/avfiltergraph.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    avfilter_graph_alloc,
    avfilter_graph_get_filter,
    avfilter_graph_add_filter,
    avfilter_graph_create_filter,
    avfilter_graph_config,
    avfilter_graph_free,
    avfilter_inout_alloc,
    avfilter_inout_free,
    avfilter_graph_parse,
    avfilter_graph_parse2


function avfilter_graph_alloc()
    ccall((:avfilter_graph_alloc,libavfilter),Ptr{AVFilterGraph},())
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
