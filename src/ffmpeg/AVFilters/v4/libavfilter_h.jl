
import Base.zero


export
    AV_PERM_READ,
    AV_PERM_WRITE,
    AV_PERM_PRESERVE,
    AV_PERM_REUSE,
    AV_PERM_REUSE2,
    AV_PERM_NEG_LINESIZES,
    AV_PERM_ALIGN,
    AVFILTER_ALIGN,
    AVFILTER_FLAG_DYNAMIC_INPUTS,
    AVFILTER_FLAG_DYNAMIC_OUTPUTS,
    AVFILTER_FLAG_SLICE_THREADS,
    AVFILTER_FLAG_SUPPORT_TIMELINE_GENERIC,
    AVFILTER_FLAG_SUPPORT_TIMELINE_INTERNAL,
    AVFILTER_FLAG_SUPPORT_TIMELINE,
    AVFILTER_THREAD_SLICE,
    AVFILTER_CMD_FLAG_ONE,
    AVFILTER_CMD_FLAG_FAST,
    AVFilterContext,
    AVFilterLink,
    AVFilterPad,
    AVFilterFormats,
    Array_8_Ptr,
    Array_8_Cint,
    AVFilterBuffer,
    AVFilterBufferRefAudioProps,
    AVFilterBufferRefVideoProps,
    AVFilterBufferRef,
    AVFilter,
    AVFilterInternal,
    AVFilterGraphInternal,
    AVFilterGraph,
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
    AV_BUFFERSRC_FLAG_NO_COPY,
    AV_BUFFERSRC_FLAG_PUSH,
    AV_BUFFERSRC_FLAG_KEEP_REF


const AV_PERM_READ = 0x01
const AV_PERM_WRITE = 0x02
const AV_PERM_PRESERVE = 0x04
const AV_PERM_REUSE = 0x08
const AV_PERM_REUSE2 = 0x10
const AV_PERM_NEG_LINESIZES = 0x20
const AV_PERM_ALIGN = 0x40
const AVFILTER_ALIGN = 16
const AVFILTER_FLAG_DYNAMIC_INPUTS = 1 << 0
const AVFILTER_FLAG_DYNAMIC_OUTPUTS = 1 << 1
const AVFILTER_FLAG_SLICE_THREADS = 1 << 2
const AVFILTER_FLAG_SUPPORT_TIMELINE_GENERIC = 1 << 16
const AVFILTER_FLAG_SUPPORT_TIMELINE_INTERNAL = 1 << 17
const AVFILTER_FLAG_SUPPORT_TIMELINE = AVFILTER_FLAG_SUPPORT_TIMELINE_GENERIC | AVFILTER_FLAG_SUPPORT_TIMELINE_INTERNAL
const AVFILTER_THREAD_SLICE = 1 << 0
const AVFILTER_CMD_FLAG_ONE = 1
const AVFILTER_CMD_FLAG_FAST = 2

typealias AVFilterContext AVFilterContext
typealias AVFilterLink AVFilterLink
typealias AVFilterPad AVFilterPad
typealias AVFilterFormats Void

immutable Array_8_Ptr
    d1::Ptr{UInt8}
    d2::Ptr{UInt8}
    d3::Ptr{UInt8}
    d4::Ptr{UInt8}
    d5::Ptr{UInt8}
    d6::Ptr{UInt8}
    d7::Ptr{UInt8}
    d8::Ptr{UInt8}
end

zero(::Type{Array_8_Ptr}) = Array_8_Ptr(fill(C_NULL,8)...)

immutable Array_8_Cint
    d1::Cint
    d2::Cint
    d3::Cint
    d4::Cint
    d5::Cint
    d6::Cint
    d7::Cint
    d8::Cint
end

zero(::Type{Array_8_Cint}) = Array_8_Cint(fill(zero(Cint),8)...)

immutable AVFilterBuffer
    data::Array_8_Ptr
    extended_data::Ptr{Ptr{UInt8}}
    linesize::Array_8_Cint
    priv::Ptr{Void}
    free::Ptr{Void}
    format::Cint
    w::Cint
    h::Cint
    refcount::UInt32
end

immutable AVFilterBufferRefAudioProps
    channel_layout::UInt64
    nb_samples::Cint
    sample_rate::Cint
    channels::Cint
end

immutable AVFilterBufferRefVideoProps
    w::Cint
    h::Cint
    sample_aspect_ratio::AVRational
    interlaced::Cint
    top_field_first::Cint
    pict_type::AVPictureType
    key_frame::Cint
    qp_table_linesize::Cint
    qp_table_size::Cint
    qp_table::Ptr{Int8}
end

immutable AVFilterBufferRef
    buf::Ptr{AVFilterBuffer}
    data::Array_8_Ptr
    extended_data::Ptr{Ptr{UInt8}}
    linesize::Array_8_Cint
    video::Ptr{AVFilterBufferRefVideoProps}
    audio::Ptr{AVFilterBufferRefAudioProps}
    pts::Int64
    pos::Int64
    format::Cint
    perms::Cint
    _type::AVMediaType
    metadata::Ptr{AVDictionary}
end

immutable AVFilter
    name::Ptr{UInt8}
    description::Ptr{UInt8}
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

typealias AVFilterInternal Void
typealias AVFilterGraphInternal Void

immutable AVFilterGraph
    av_class::Ptr{AVClass}
    filter_count_unused::UInt32
    filters::Ptr{Ptr{AVFilterContext}}
    scale_sws_opts::Ptr{UInt8}
    resample_lavr_opts::Ptr{UInt8}
    nb_filters::UInt32
    thread_type::Cint
    nb_threads::Cint
    internal::Ptr{AVFilterGraphInternal}
    opaque::Ptr{Void}
    execute::Ptr{avfilter_execute_func}
    aresample_swr_opts::Ptr{UInt8}
    sink_links::Ptr{Ptr{AVFilterLink}}
    sink_links_count::Cint
    disable_auto_convert::UInt32
end

# begin enum ANONYMOUS_1
typealias ANONYMOUS_1 Cint
const AVFILTER_AUTO_CONVERT_ALL = Int32(0)
const AVFILTER_AUTO_CONVERT_NONE = Int32(-1)
# end enum ANONYMOUS_1

immutable AVFilterInOut
    name::Ptr{UInt8}
    filter_ctx::Ptr{AVFilterContext}
    pad_idx::Cint
    next::Ptr{AVFilterInOut}
end

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
const AV_BUFFERSRC_FLAG_NO_CHECK_FORMAT = UInt32(1)
const AV_BUFFERSRC_FLAG_NO_COPY = UInt32(2)
const AV_BUFFERSRC_FLAG_PUSH = UInt32(4)
const AV_BUFFERSRC_FLAG_KEEP_REF = UInt32(8)
# end enum ANONYMOUS_2
