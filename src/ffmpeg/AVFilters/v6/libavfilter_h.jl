# Automatically generated using Clang.jl wrap_c, version 0.0.0

using Compat

export
    OBJC_NEW_PROPERTIES,
    AVFILTER_FLAG_DYNAMIC_INPUTS,
    AVFILTER_FLAG_DYNAMIC_OUTPUTS,
    AVFILTER_FLAG_SLICE_THREADS,
    AVFILTER_FLAG_SUPPORT_TIMELINE_GENERIC,
    AVFILTER_FLAG_SUPPORT_TIMELINE_INTERNAL,
    AVFILTER_FLAG_SUPPORT_TIMELINE,
    AVFILTER_THREAD_SLICE,
    AVFILTER_CMD_FLAG_ONE,
    AVFILTER_CMD_FLAG_FAST,
    AVFilterPad,
    AVFilter,
    AVFilterGraphInternal,
    AVFilterGraph,
    AVFilterInternal,
    AVFilterContext,
    AVFilterFormats,
    ANONYMOUS_1,
    AVFILTER_AUTO_CONVERT_ALL,
    AVFILTER_AUTO_CONVERT_NONE,
    AVFilterInOut,
    LIBAVFILTER_VERSION_MAJOR,
    LIBAVFILTER_VERSION_MINOR,
    LIBAVFILTER_VERSION_MICRO,
    LIBAVFILTER_BUILD,
    AV_BUFFERSINK_FLAG_PEEK,
    AV_BUFFERSINK_FLAG_NO_REQUEST,
    AVBufferSinkParams,
    AVABufferSinkParams,
    ANONYMOUS_2,
    AV_BUFFERSRC_FLAG_NO_CHECK_FORMAT,
    AV_BUFFERSRC_FLAG_PUSH,
    AV_BUFFERSRC_FLAG_KEEP_REF


const OBJC_NEW_PROPERTIES = 1
const AVFILTER_FLAG_DYNAMIC_INPUTS = 1 << 0
const AVFILTER_FLAG_DYNAMIC_OUTPUTS = 1 << 1
const AVFILTER_FLAG_SLICE_THREADS = 1 << 2
const AVFILTER_FLAG_SUPPORT_TIMELINE_GENERIC = 1 << 16
const AVFILTER_FLAG_SUPPORT_TIMELINE_INTERNAL = 1 << 17
const AVFILTER_FLAG_SUPPORT_TIMELINE = AVFILTER_FLAG_SUPPORT_TIMELINE_GENERIC | AVFILTER_FLAG_SUPPORT_TIMELINE_INTERNAL
const AVFILTER_THREAD_SLICE = 1 << 0
const AVFILTER_CMD_FLAG_ONE = 1
const AVFILTER_CMD_FLAG_FAST = 2

typealias AVFilterPad Void

immutable AVFilter
    name::Cstring
    description::Cstring
    inputs::Ptr{AVFilterPad}
    outputs::Ptr{AVFilterPad}
    priv_class::Ptr{AVClass}
    flags::Cint
    init::Ptr{Void}
    init_dict::Ptr{Void}
    uninit::Ptr{Void}
    query_formats::Ptr{Void}
    priv_size::Cint
    next::Ptr{AVFilter}
    process_command::Ptr{Void}
    init_opaque::Ptr{Void}
end

typealias AVFilterGraphInternal Void

immutable AVFilterGraph
    av_class::Ptr{AVClass}
    filters::Ptr{Ptr{AVFilterContext}}
    nb_filters::UInt32
    scale_sws_opts::Cstring
    resample_lavr_opts::Cstring
    thread_type::Cint
    nb_threads::Cint
    internal::Ptr{AVFilterGraphInternal}
    opaque::Ptr{Void}
    execute::Ptr{avfilter_execute_func}
    aresample_swr_opts::Cstring
    sink_links::Ptr{Ptr{AVFilterLink}}
    sink_links_count::Cint
    disable_auto_convert::UInt32
end

typealias AVFilterInternal Void

immutable AVFilterContext
    av_class::Ptr{AVClass}
    filter::Ptr{AVFilter}
    name::Cstring
    input_pads::Ptr{AVFilterPad}
    inputs::Ptr{Ptr{AVFilterLink}}
    nb_inputs::UInt32
    output_pads::Ptr{AVFilterPad}
    outputs::Ptr{Ptr{AVFilterLink}}
    nb_outputs::UInt32
    priv::Ptr{Void}
    graph::Ptr{AVFilterGraph}
    thread_type::Cint
    internal::Ptr{AVFilterInternal}
    command_queue::Ptr{AVFilterCommand}
    enable_str::Cstring
    enable::Ptr{Void}
    var_values::Ptr{Cdouble}
    is_disabled::Cint
end

typealias AVFilterFormats Void

# begin enum ANONYMOUS_1
typealias ANONYMOUS_1 Cint
const AVFILTER_AUTO_CONVERT_ALL = (Int32)(0)
const AVFILTER_AUTO_CONVERT_NONE = (Int32)(-1)
# end enum ANONYMOUS_1

immutable AVFilterInOut
    name::Cstring
    filter_ctx::Ptr{AVFilterContext}
    pad_idx::Cint
    next::Ptr{AVFilterInOut}
end

const LIBAVFILTER_VERSION_MAJOR = 6
const LIBAVFILTER_VERSION_MINOR = 31
const LIBAVFILTER_VERSION_MICRO = 100

# Skipping MacroDefinition: LIBAVFILTER_VERSION_INT AV_VERSION_INT ( LIBAVFILTER_VERSION_MAJOR , LIBAVFILTER_VERSION_MINOR , LIBAVFILTER_VERSION_MICRO )
# Skipping MacroDefinition: LIBAVFILTER_VERSION AV_VERSION ( LIBAVFILTER_VERSION_MAJOR , LIBAVFILTER_VERSION_MINOR , LIBAVFILTER_VERSION_MICRO )

const LIBAVFILTER_BUILD = LIBAVFILTER_VERSION_INT

# Skipping MacroDefinition: LIBAVFILTER_IDENT "Lavfi" AV_STRINGIFY ( LIBAVFILTER_VERSION )
# Skipping MacroDefinition: FF_API_OLD_FILTER_OPTS ( LIBAVFILTER_VERSION_MAJOR < 7 )
# Skipping MacroDefinition: FF_API_OLD_FILTER_OPTS_ERROR ( LIBAVFILTER_VERSION_MAJOR < 7 )
# Skipping MacroDefinition: FF_API_AVFILTER_OPEN ( LIBAVFILTER_VERSION_MAJOR < 7 )
# Skipping MacroDefinition: FF_API_AVFILTER_INIT_FILTER ( LIBAVFILTER_VERSION_MAJOR < 7 )
# Skipping MacroDefinition: FF_API_OLD_FILTER_REGISTER ( LIBAVFILTER_VERSION_MAJOR < 7 )
# Skipping MacroDefinition: FF_API_NOCONST_GET_NAME ( LIBAVFILTER_VERSION_MAJOR < 7 )

const AV_BUFFERSINK_FLAG_PEEK = 1
const AV_BUFFERSINK_FLAG_NO_REQUEST = 2

immutable AVBufferSinkParams
    pixel_fmts::Ptr{AVPixelFormat}
end

immutable AVABufferSinkParams
    sample_fmts::Ptr{AVSampleFormat}
    channel_layouts::Ptr{Int64}
    channel_counts::Ptr{Cint}
    all_channel_counts::Cint
    sample_rates::Ptr{Cint}
end

# begin enum ANONYMOUS_2
typealias ANONYMOUS_2 UInt32
const AV_BUFFERSRC_FLAG_NO_CHECK_FORMAT = (UInt32)(1)
const AV_BUFFERSRC_FLAG_PUSH = (UInt32)(4)
const AV_BUFFERSRC_FLAG_KEEP_REF = (UInt32)(8)
# end enum ANONYMOUS_2
