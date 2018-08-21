
import Base.zero


export
    AV_PERM_READ,
    AV_PERM_WRITE,
    AV_PERM_PRESERVE,
    AV_PERM_REUSE,
    AV_PERM_REUSE2,
    AV_PERM_NEG_LINESIZES,
    AVFILTER_FLAG_DYNAMIC_INPUTS,
    AVFILTER_FLAG_DYNAMIC_OUTPUTS,
    AVFILTER_FLAG_SLICE_THREADS,
    AVFILTER_THREAD_SLICE,
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
    AVFilterInOut


const AV_PERM_READ = 0x01
const AV_PERM_WRITE = 0x02
const AV_PERM_PRESERVE = 0x04
const AV_PERM_REUSE = 0x08
const AV_PERM_REUSE2 = 0x10
const AV_PERM_NEG_LINESIZES = 0x20
const AVFILTER_FLAG_DYNAMIC_INPUTS = 1 << 0
const AVFILTER_FLAG_DYNAMIC_OUTPUTS = 1 << 1
const AVFILTER_FLAG_SLICE_THREADS = 1 << 2
const AVFILTER_THREAD_SLICE = 1 << 0

const AVFilterContext=AVFilterContext
const AVFilterLink=AVFilterLink
const AVFilterPad=AVFilterPad
const AVFilterFormats=Void

struct Array_8_Ptr
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

struct Array_8_Cint
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

struct AVFilterBuffer
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

struct AVFilterBufferRefAudioProps
    channel_layout::UInt64
    nb_samples::Cint
    sample_rate::Cint
    planar::Cint
end

struct AVFilterBufferRefVideoProps
    w::Cint
    h::Cint
    pixel_aspect::AVRational
    interlaced::Cint
    top_field_first::Cint
    pict_type::AVPictureType
    key_frame::Cint
end

struct AVFilterBufferRef
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
end

struct AVFilter
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
end

const AVFilterInternal=Void
const AVFilterGraphInternal=Void

struct AVFilterGraph
    av_class::Ptr{AVClass}
    filter_count::UInt32
    filters::Ptr{Ptr{AVFilterContext}}
    scale_sws_opts::Ptr{UInt8}
    resample_lavr_opts::Ptr{UInt8}
    nb_filters::UInt32
    thread_type::Cint
    nb_threads::Cint
    internal::Ptr{AVFilterGraphInternal}
    opaque::Ptr{Void}
    execute::Ptr{avfilter_execute_func}
end

struct AVFilterInOut
    name::Ptr{UInt8}
    filter_ctx::Ptr{AVFilterContext}
    pad_idx::Cint
    next::Ptr{AVFilterInOut}
end
