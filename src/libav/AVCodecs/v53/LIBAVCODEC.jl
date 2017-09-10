include("libavcodec_h.jl")

include("avcodec.jl")

export AVFramePtr

const AV_NOPTS_VALUE  =  reinterpret(Int64, 0x8000000000000000)

type AVFramePtr
    p::Ptr{AVFrame}

    function AVFramePtr()
        Base.sigatomic_begin()
        av_frame_ptr = new(avcodec_alloc_frame());
        Base.sigatomic_end()
        finalizer(av_frame_ptr, free_frame)

        return av_frame_ptr
    end
end

function free_frame(ptr::AVFramePtr)
    if ptr.p == C_NULL return end

    Base.sigatomic_begin()
    # av_frame_unref(ptr.p)
    av_free(ptr.p)
    ptr.p = C_NULL
    Base.sigatomic_end()
end

function Base.convert(::Type{Ptr{AVFrame}}, ptr::AVFramePtr)
    return ptr.p
end

function Base.unsafe_convert(::Type{Ptr{AVFrame}}, ptr::AVFramePtr)
    return ptr.p
end

function Base.unsafe_load(ptr::AVFramePtr)
    return unsafe_load(ptr.p)
end
