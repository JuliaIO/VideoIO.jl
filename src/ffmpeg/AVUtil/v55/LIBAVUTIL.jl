include("libavutil_h.jl")

#include("aes_ctr.jl")
#include("audio_fifo.jl")
#include("avutil.jl")
#include("buffer.jl")
#include("camellia.jl")
#include("cast5.jl")
#include("channel_layout.jl")
#include("des.jl")
#include("dict.jl")
#include("display.jl")
#include("downmix_info.jl")
#include("fifo.jl")
#include("file.jl")
include("frame.jl")
#include("hash.jl")
#include("imgutils.jl")
include("log.jl")
#include("mastering_display_metadata.jl")
include("mem.jl")
#include("motion_vector.jl")
#include("opencl.jl")
#include("opt.jl")
include("pixdesc.jl")
#include("pixelutils.jl")
#include("pixfmt.jl")
#include("rational.jl")
#include("rc4.jl")
#include("replaygain.jl")
#include("samplefmt.jl")
#include("stereo3d.jl")
#include("tea.jl")
#include("threadmessage.jl")
#include("timecode.jl")
#include("tree.jl")
#include("twofish.jl")
#include("version.jl")
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
    av_frame_unref(ptr.p)
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
