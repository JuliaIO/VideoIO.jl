# Utilities for working with pointers to nested C structs
const OptionsT = Union{AbstractDict{Symbol,<:Any},AbstractDict{Union{},Union{}},NamedTuple}

"""
    mutable struct NestedCStruct{T}

Wraps a pointer to a C struct, and acts like a double pointer to that memory.
"""
mutable struct NestedCStruct{T}
    data::RefValue{Ptr{T}}
end
NestedCStruct{T}(a::Ptr) where {T} = NestedCStruct{T}(Ref(a))
NestedCStruct{T}(a::Ptr{Nothing}) where {T} = NestedCStruct{T}(convert(Ptr{T}, a))
# Needed to resolve method ambiguity
NestedCStruct{Nothing}(a::Ptr{Nothing}) = NestedCStruct{Nothing}(Ref(a))
NestedCStruct(a::Ptr{T}) where {T} = NestedCStruct{T}(a)

unsafe_convert(::Type{Ptr{T}}, ap::NestedCStruct{T}) where {T} = getfield(ap, :data)[]
unsafe_convert(::Type{Ptr{Ptr{T}}}, ap::NestedCStruct{T}) where {T} = unsafe_convert(Ptr{Ptr{T}}, getfield(ap, :data))
unsafe_convert(::Type{Ptr{Ptr{Nothing}}}, ap::NestedCStruct{T}) where {T} =
    convert(Ptr{Ptr{Nothing}}, unsafe_convert(Ptr{Ptr{T}}, ap))
unsafe_convert(::Type{Ptr{Nothing}}, ap::NestedCStruct{T}) where {T} = convert(Ptr{Nothing}, unsafe_convert(Ptr{T}, ap))
# Following two methods are needed to resolve method ambiguity
unsafe_convert(::Type{Ptr{Nothing}}, ap::NestedCStruct{Nothing}) = getfield(ap, :data)[]
unsafe_convert(::Type{Ptr{Ptr{Nothing}}}, ap::NestedCStruct{Nothing}) =
    unsafe_convert(Ptr{Ptr{Nothing}}, getfield(ap, :data))

function check_ptr_valid(a::NestedCStruct{T}, args...) where {T}
    p = unsafe_convert(Ptr{T}, a)
    @preserve a check_ptr_valid(p, args...)
end

nested_wrap(x::Ptr{T}) where {T} = NestedCStruct(x)
nested_wrap(x) = x

@inline function getproperty(ap::NestedCStruct{T}, s::Symbol) where {T}
    p = unsafe_convert(Ptr{T}, ap)
    res = @preserve ap unsafe_load(field_ptr(p, s))
    return nested_wrap(res)
end

@inline function setproperty!(ap::NestedCStruct{T}, s::Symbol, x) where {T}
    p = unsafe_convert(Ptr{T}, ap)
    fp = field_ptr(p, s)
    @preserve ap unsafe_store!(fp, x)
end

@inline function getindex(ap::NestedCStruct{T}, i::Integer) where {T}
    p = unsafe_convert(Ptr{T}, ap)
    res = @preserve ap unsafe_load(p, i)
    return nested_wrap(res)
end

@inline function setindex!(ap::NestedCStruct{T}, i::Integer, x) where {T}
    p = unsafe_convert(Ptr{T}, ap)
    @preserve ap unsafe_store!(p, x, i)
end

@inline function unsafe_wrap(::Type{T}, ap::NestedCStruct{S}, i) where {S,T}
    p = unsafe_convert(Ptr{S}, ap)
    @preserve ap unsafe_wrap(T, p, i)
end

@inline function unsafe_copyto!(dest::Ptr{T}, src::NestedCStruct{S}, N) where {S,T}
    p = unsafe_convert(Ptr{S}, src)
    @preserve src unsafe_copyto!(dest, p, N)
end

@inline function unsafe_copyto!(dest::NestedCStruct{S}, src::Ptr{T}, N) where {S,T}
    p = unsafe_convert(Ptr{S}, dest)
    @preserve dest unsafe_copyto!(p, src, N)
end

@inline function field_ptr(::Type{S}, a::NestedCStruct{T}, field::Symbol, args...) where {S,T}
    p = unsafe_convert(Ptr{T}, a)
    @preserve a field_ptr(S, p, field, args...)
end

@inline function field_ptr(a::NestedCStruct{T}, field::Symbol, args...) where {S,T}
    p = unsafe_convert(Ptr{T}, a)
    @preserve a field_ptr(p, field, args...)
end

propertynames(ap::T) where {S,T<:NestedCStruct{S}} = (fieldnames(S)..., fieldnames(T)...)
"""
    @avptr(tname, tref, [allocf, deallocf])

Make a typealias `tname` to `NestedCStruct{tref}` that is intended to provide
easy and safe access of structs allocated by c libraries.

If the optional arguments `allocf` and `deallocf` are provided, then a
zero-argument constructor `tname()` will be generated which allocates the struct
by calling the zero-argument function `allocf`, registers a finalizer that calls
one-argument `deallocf` (which accepts either a single or double pointer to the
struct) for the newly allocated struct, and then wraps it in a new object of
type `tname`. The pointer will additionally be checked to ensure it is not
`C_NULL`, in which case an error will be thrown.
"""
macro avptr(tname, tref, args...)
    narg = length(args)
    if narg == 2
        allocf = args[1]
        deallocf = args[2]
        errmsg = "Could not allocate $tref"
        allocating_constructor = quote
            function $(esc(tname))()
                p = $(esc(allocf))()
                check_ptr_valid(p, false) || error($errmsg)
                obj = $(esc(tname))(p)
                finalizer($(esc(deallocf)), obj)
                return obj
            end
        end
    elseif narg != 0
        error("Use either two or four args, see documentation")
    else
        allocating_constructor = nothing
    end

    return quote
        const $(esc(tname)) = NestedCStruct{$(esc(tref))}
        # Optional allocating constructor
        $(allocating_constructor)
    end
end

@avptr AVFramePtr AVFrame av_frame_alloc av_frame_free
@avptr AVPacketPtr AVPacket av_packet_alloc av_packet_free
@avptr SwsContextPtr SwsContext sws_alloc_context sws_freeContext
@avptr AVIOContextPtr AVIOContext
@avptr AVStreamPtr AVStream
@avptr AVCodecPtr AVCodec

@avptr AVFormatContextPtr AVFormatContext avformat_alloc_context avformat_close_input

function output_AVFormatContextPtr(fname)
    dp = Ref(Ptr{AVFormatContext}())
    ret = avformat_alloc_output_context2(dp, C_NULL, C_NULL, fname)
    if ret != 0 || !check_ptr_valid(dp[], false)
        error("Could not allocate AVFormatContext")
    end
    obj = AVFormatContextPtr(dp)
    finalizer(avformat_free_context, obj)
    return obj
end

@avptr AVCodecContextPtr AVCodecContext

function AVCodecContextPtr(codec::Ptr{AVCodec})
    p = avcodec_alloc_context3(codec)
    check_ptr_valid(p, false) || error("Could not allocate AVCodecContext")
    obj = AVCodecContextPtr(p)
    finalizer(avcodec_free_context, obj)
    return obj
end

AVCodecContextPtr(codec::AVCodecPtr) = AVCodecContextPtr(unsafe_convert(Ptr{AVCodec}, codec))

function vio_dealloc_AVIOContextPtr(obj)
    if check_ptr_valid(obj, false)
        buff_ptr = field_ptr(obj, :buffer)
        av_freep(buff_ptr)
        avio_context_free(obj)
    end
end

function AVIOContextPtr(avio_ctx_buffer_size, opaque_p, read_p)
    avio_ctx_buffer = av_malloc(avio_ctx_buffer_size)
    if !check_ptr_valid(avio_ctx_buffer, false)
        error("Unable to allocate avio buffer")
    end
    p = avio_alloc_context(avio_ctx_buffer, avio_ctx_buffer_size, 0, opaque_p, read_p, C_NULL, C_NULL)
    if !check_ptr_valid(p, false)
        av_freep(Ref(avio_ctx_buffer))
        error("Unable to allocate AVIOContext")
    end
    obj = AVIOContextPtr(p)
    finalizer(vio_dealloc_AVIOContextPtr, obj)
    return obj
end

@inline function set_class_option(ptr::NestedCStruct{T}, key, val, search = AV_OPT_SEARCH_CHILDREN) where {T}
    ret = av_opt_set(ptr, string(key), string(val), search)
    return ret < 0 && error("Could not set class option $key to $val: got error $ret")
end

function set_class_options(ptr, options::OptionsT, args...)
    for (key, val) in pairs(options)
        set_class_option(ptr, key, val, args...)
    end
end

set_class_options(ptr, args...; kwargs...) = set_class_options(ptr, kwargs, args...)
