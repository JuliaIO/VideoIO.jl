
import Base.zero


export
    AV_PERM_READ,
    AV_PERM_WRITE,
    AV_PERM_PRESERVE,
    AV_PERM_REUSE,
    AV_PERM_REUSE2,
    AV_PERM_NEG_LINESIZES,
    AVFilterContext,
    AVFilterLink,
    AVFilterPad,
    Array_8_Ptr,
    Array_8_Cint,
    AVFilterBuffer,
    AVFilterBufferRefAudioProps,
    AVFilterBufferRefVideoProps,
    AVFilterBufferRef,
    AVFilterFormats,
    AVFilter,
    AVFilterGraph,
    AVFilterInOut


const AV_PERM_READ = 0x01
const AV_PERM_WRITE = 0x02
const AV_PERM_PRESERVE = 0x04
const AV_PERM_REUSE = 0x08
const AV_PERM_REUSE2 = 0x10
const AV_PERM_NEG_LINESIZES = 0x20

const AVFilterContext=AVFilterContext
const AVFilterLink=AVFilterLink
const AVFilterPad=AVFilterPad

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
    linesize::Array_8_Cint
    refcount::UInt32
    priv::Ptr{Void}
    free::Ptr{Void}
    format::Cint
    w::Cint
    h::Cint
end

struct AVFilterBufferRefAudioProps
    channel_layout::UInt64
    nb_samples::Cint
    size::Cint
    sample_rate::UInt32
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
    linesize::Array_8_Cint
    format::Cint
    pts::Int64
    pos::Int64
    perms::Cint
    _type::AVMediaType
    video::Ptr{AVFilterBufferRefVideoProps}
    audio::Ptr{AVFilterBufferRefAudioProps}
end

struct AVFilterFormats
    format_count::UInt32
    formats::Ptr{Cint}
    refcount::UInt32
    refs::Ptr{Ptr{Ptr{AVFilterFormats}}}
end

struct AVFilter
    name::Ptr{UInt8}
    priv_size::Cint
    init::Ptr{Void}
    uninit::Ptr{Void}
    query_formats::Ptr{Void}
    inputs::Ptr{AVFilterPad}
    outputs::Ptr{AVFilterPad}
    description::Ptr{UInt8}
end

struct AVFilterGraph
    filter_count::UInt32
    filters::Ptr{Ptr{AVFilterContext}}
    scale_sws_opts::Ptr{UInt8}
end

struct AVFilterInOut
    name::Ptr{UInt8}
    filter_ctx::Ptr{AVFilterContext}
    pad_idx::Cint
    next::Ptr{AVFilterInOut}
end
