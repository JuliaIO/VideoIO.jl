include("libavutil_h.jl")

#include("audio_fifo.jl")
#include("avutil.jl")
#include("buffer.jl")
#include("channel_layout.jl")
#include("dict.jl")
#include("display.jl")
#include("downmix_info.jl")
#include("fifo.jl")
#include("file.jl")
include("frame.jl")
#include("hash.jl")
#include("imgutils.jl")
include("log.jl")
include("mem.jl")
include("opt.jl")
include("pixdesc.jl")
#include("rational.jl")
#include("samplefmt.jl")
#include("stereo3d.jl")
#include("threadmessage.jl")
#include("timecode.jl")
#include("xtea.jl")

export AVFramePtr

const AV_NOPTS_VALUE  =  reinterpret(Int64, 0x8000000000000000)

type AVFramePtr
    p::Ptr{AVFrame}

    function AVFramePtr()
        Base.sigatomic_begin()
        av_frame_ptr = new(av_frame_alloc());
        Base.sigatomic_end()
        finalizer(av_frame_ptr, free_frame)

        return av_frame_ptr
    end
end

function free_frame(ptr::AVFramePtr)
    if ptr.p == C_NULL return end

    Base.sigatomic_begin()
    av_frame_free(Ref(ptr.p))
    # av_frame_unref(ptr.p)
    # av_freep(Ref(ptr.p))
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
