# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    unix,
    linux,
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
    AV_BUFFERSINK_FLAG_PEEK,
    AV_BUFFERSINK_FLAG_NO_REQUEST,
    AVBufferSinkParams,
    AVABufferSinkParams,
    ANONYMOUS_2,
    AV_BUFFERSRC_FLAG_NO_CHECK_FORMAT,
    AV_BUFFERSRC_FLAG_PUSH,
    AV_BUFFERSRC_FLAG_KEEP_REF,
    AVBufferSrcParameters,
    LIBAVFILTER_VERSION_MAJOR,
    LIBAVFILTER_VERSION_MINOR,
    LIBAVFILTER_VERSION_MICRO,
    LIBAVFILTER_BUILD


const unix = 1
const linux = 1
const AVFILTER_FLAG_DYNAMIC_INPUTS = 1 << 0
const AVFILTER_FLAG_DYNAMIC_OUTPUTS = 1 << 1
const AVFILTER_FLAG_SLICE_THREADS = 1 << 2
const AVFILTER_FLAG_SUPPORT_TIMELINE_GENERIC = 1 << 16
const AVFILTER_FLAG_SUPPORT_TIMELINE_INTERNAL = 1 << 17
const AVFILTER_FLAG_SUPPORT_TIMELINE = AVFILTER_FLAG_SUPPORT_TIMELINE_GENERIC | AVFILTER_FLAG_SUPPORT_TIMELINE_INTERNAL
const AVFILTER_THREAD_SLICE = 1 << 0
const AVFILTER_CMD_FLAG_ONE = 1
const AVFILTER_CMD_FLAG_FAST = 2

struct AVFilterPad
end

struct AVFilter
    name::Cstring
    description::Cstring
    inputs::Ptr{AVFilterPad}
    outputs::Ptr{AVFilterPad}
    priv_class::Ptr{AVClass}
    flags::Cint
    preinit::Ptr{Cvoid}
    init::Ptr{Cvoid}
    init_dict::Ptr{Cvoid}
    uninit::Ptr{Cvoid}
    query_formats::Ptr{Cvoid}
    priv_size::Cint
    flags_internal::Cint
    next::Ptr{AVFilter}
    process_command::Ptr{Cvoid}
    init_opaque::Ptr{Cvoid}
    activate::Ptr{Cvoid}
end

struct AVFilterGraphInternal
end

struct AVFilterGraph
    av_class::Ptr{AVClass}
    filters::Ptr{Ptr{AVFilterContext}}
    nb_filters::UInt32
    scale_sws_opts::Cstring
    resample_lavr_opts::Cstring
    thread_type::Cint
    nb_threads::Cint
    internal::Ptr{AVFilterGraphInternal}
    opaque::Ptr{Cvoid}
    execute::Ptr{avfilter_execute_func}
    aresample_swr_opts::Cstring
    sink_links::Ptr{Ptr{AVFilterLink}}
    sink_links_count::Cint
    disable_auto_convert::UInt32
end

struct AVFilterInternal
end

struct AVFilterContext
    av_class::Ptr{AVClass}
    filter::Ptr{AVFilter}
    name::Cstring
    input_pads::Ptr{AVFilterPad}
    inputs::Ptr{Ptr{AVFilterLink}}
    nb_inputs::UInt32
    output_pads::Ptr{AVFilterPad}
    outputs::Ptr{Ptr{AVFilterLink}}
    nb_outputs::UInt32
    priv::Ptr{Cvoid}
    graph::Ptr{AVFilterGraph}
    thread_type::Cint
    internal::Ptr{AVFilterInternal}
    command_queue::Ptr{AVFilterCommand}
    enable_str::Cstring
    enable::Ptr{Cvoid}
    var_values::Ptr{Cdouble}
    is_disabled::Cint
    hw_device_ctx::Ptr{AVBufferRef}
    nb_threads::Cint
    ready::UInt32
    extra_hw_frames::Cint
end

struct AVFilterFormats
end

# begin enum ANONYMOUS_1
const ANONYMOUS_1 = Cint
const AVFILTER_AUTO_CONVERT_ALL = 0 |> Int32
const AVFILTER_AUTO_CONVERT_NONE = -1 |> Int32
# end enum ANONYMOUS_1

struct AVFilterInOut
    name::Cstring
    filter_ctx::Ptr{AVFilterContext}
    pad_idx::Cint
    next::Ptr{AVFilterInOut}
end

const AV_BUFFERSINK_FLAG_PEEK = 1
const AV_BUFFERSINK_FLAG_NO_REQUEST = 2

struct AVBufferSinkParams
    pixel_fmts::Ptr{AVPixelFormat}
end

struct AVABufferSinkParams
    sample_fmts::Ptr{AVSampleFormat}
    channel_layouts::Ptr{Int64}
    channel_counts::Ptr{Cint}
    all_channel_counts::Cint
    sample_rates::Ptr{Cint}
end

# begin enum ANONYMOUS_2
const ANONYMOUS_2 = UInt32
const AV_BUFFERSRC_FLAG_NO_CHECK_FORMAT = 1 |> UInt32
const AV_BUFFERSRC_FLAG_PUSH = 4 |> UInt32
const AV_BUFFERSRC_FLAG_KEEP_REF = 8 |> UInt32
# end enum ANONYMOUS_2

struct AVBufferSrcParameters
    format::Cint
    time_base::AVRational
    width::Cint
    height::Cint
    sample_aspect_ratio::AVRational
    frame_rate::AVRational
    hw_frames_ctx::Ptr{AVBufferRef}
    sample_rate::Cint
    channel_layout::UInt64
end

const LIBAVFILTER_VERSION_MAJOR = 7
const LIBAVFILTER_VERSION_MINOR = 40
const LIBAVFILTER_VERSION_MICRO = 101

# Skipping MacroDefinition: LIBAVFILTER_VERSION_INT AV_VERSION_INT ( LIBAVFILTER_VERSION_MAJOR , LIBAVFILTER_VERSION_MINOR , LIBAVFILTER_VERSION_MICRO )
# Skipping MacroDefinition: LIBAVFILTER_VERSION AV_VERSION ( LIBAVFILTER_VERSION_MAJOR , LIBAVFILTER_VERSION_MINOR , LIBAVFILTER_VERSION_MICRO )

const LIBAVFILTER_BUILD = LIBAVFILTER_VERSION_INT

# Skipping MacroDefinition: LIBAVFILTER_IDENT "Lavfi" AV_STRINGIFY ( LIBAVFILTER_VERSION )
# Skipping MacroDefinition: FF_API_OLD_FILTER_OPTS_ERROR ( LIBAVFILTER_VERSION_MAJOR < 8 )
# Skipping MacroDefinition: FF_API_LAVR_OPTS ( LIBAVFILTER_VERSION_MAJOR < 8 )
# Skipping MacroDefinition: FF_API_FILTER_GET_SET ( LIBAVFILTER_VERSION_MAJOR < 8 )
# Skipping MacroDefinition: FF_API_NEXT ( LIBAVFILTER_VERSION_MAJOR < 8 )
