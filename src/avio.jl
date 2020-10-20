# AVIO

import Base: read, read!, show, close, eof, isopen, seek, seekstart

export read, read!, pump, openvideo, opencamera, playvideo, viewcam, play, gettime
export skipframe, skipframes, counttotalframes

abstract type AVPtr{T} end

get_doubleptr(p::AVPtr) = getfield(p, :doubleptr)
get_ptr(a::AVPtr) = get_doubleptr(a)[]

function check_ptr_valid(p::Ptr, err::Bool = true)
    valid = p != Ptr{Cvoid}()
    err && !valid && error("Invalid pointer")
    valid
end

function get_valid_ptr(a::AVPtr)
    p = get_ptr(a)
    check_ptr_valid(p)
    p
end

@inline unsafe_field_ptr(::Type{S}, a::AVPtr, s::Symbol) where S =
    unsafe_field_ptr(S, get_valid_ptr(a), s)

@inline unsafe_field_ptr(a::AVPtr, s) = unsafe_field_ptr(get_valid_ptr(a), s)

@inline getproperty(ap::AVPtr, s::Symbol) = unsafe_load(unsafe_field_ptr(ap, s))

@inline setproperty!(ap::AVPtr, s::Symbol, x) = unsafe_store!(unsafe_field_ptr(ap, s), x)

mutable struct AVFramePtr <: AVPtr{AVFrame}
    doubleptr::Ref{Ptr{AVFrame}} # Double pointer
    function AVFramePtr()
        p = av_frame_alloc()
        check_ptr_valid(p, false) || error("Could not allocate AVFrame")
        frame = new(Ref(p))
        finalizer(x -> av_frame_free(get_doubleptr(x)), frame)
        frame
    end
end

mutable struct StreamInfo
    stream_index0::Int             # zero-based
    pStream::Ptr{AVStream}
    stream::AVStream
    codec_ctx::AVCodecContext
end

abstract type StreamContext end

const ReaderBitTypes = Union{UInt8, UInt16}
const ReaderNormedTypes = Normed{T} where T<: ReaderBitTypes
const ReaderGrayTypes = Gray{T} where T<: ReaderNormedTypes
const ReaderRgbTypes = RGB{T} where T<:ReaderNormedTypes
const ReaderElTypes = Union{ReaderGrayTypes, ReaderRgbTypes}
const PermutedArray{T,N,perm,iperm,AA <: Array} = Base.PermutedDimsArrays.PermutedDimsArray{T,N,perm,iperm,AA}
const VidArray{T,N} = Union{Array{T,N},PermutedArray{T,N}}

const VIDEOIO_ALIGN = 32

# TODO: move this to Base
Base.unsafe_convert(::Type{Ptr{T}}, A::PermutedArray{T}) where {T} = Base.unsafe_convert(Ptr{T}, parent(A))

# An audio-visual input stream/file
mutable struct AVInput{I}
    io::I
    apFormatContext::Vector{Ptr{AVFormatContext}}
    apAVIOContext::Vector{Ptr{AVIOContext}}
    avio_ctx_buffer_size::UInt
    aPacket::Vector{AVPacket}           # Reusable packet

    unknown_info::Vector{StreamInfo}
    video_info::Vector{StreamInfo}
    audio_info::Vector{StreamInfo}
    data_info::Vector{StreamInfo}
    subtitle_info::Vector{StreamInfo}
    attachment_info::Vector{StreamInfo}

    listening::Set{Int}
    stream_contexts::Array{StreamContext}

    isopen::Bool
end


function show(io::IO, avin::AVInput)
    println(io, "AVInput(", avin.io, ", ...), with")
    (len = length(avin.video_info))      > 0 && println(io, "  $len video stream(s)")
    (len = length(avin.audio_info))      > 0 && println(io, "  $len audio stream(s)")
    (len = length(avin.data_info))       > 0 && println(io, "  $len data stream(s)")
    (len = length(avin.subtitle_info))   > 0 && println(io, "  $len subtitle stream(s)")
    (len = length(avin.attachment_info)) > 0 && println(io, "  $len attachment stream(s)")
    (len = length(avin.unknown_info))    > 0 && println(io, "  $len unknown stream(s)")
end

mutable struct VideoTranscodeContext
    transcode_context::Ptr{SwsContext}

    transcode_interp::Cint
    target_pix_fmt::Cint
    target_bits_per_pixel::Int
    width::Int
    height::Int

    destframe::AVFramePtr
end

const TRANSCODE = true
const NO_TRANSCODE = false

mutable struct VideoReader{transcode} <: StreamContext
    avin::AVInput
    stream_info::StreamInfo

    stream_index0::Int
    pVideoCodecContext::Ptr{AVCodecContext}
    pVideoCodec::Ptr{AVCodec}
    srcframe::AVFramePtr
    aFrameFinished::Vector{Int32}

    format::Cint
    width::Cint
    height::Cint
    framerate::Rational{Cint}
    aspect_ratio::Rational{Cint}

    frame_queue::Vector{Vector{UInt8}}
    transcodeContext::VideoTranscodeContext
end

show(io::IO, vr::VideoReader) = print(io, "VideoReader(...)")

function iterate(r::VideoReader, state = 0)
    eof(r) && return
    return read(r), state + 1
end

IteratorSize(::Type{<:VideoReader}) = Base.SizeUnknown()

IteratorEltype(::Type{<:VideoReader}) = Base.EltypeUnknown()

# Pump input for data
function pump(c::AVInput)
    pFormatContext = c.apFormatContext[1]

    while true
        !c.isopen && break

        Base.sigtomic_begin()
        av_read_frame(pFormatContext, pointer(c.aPacket)) < 0 && break
        Base.sigatomic_end()

        packet = c.aPacket[1]
        stream_index = packet.stream_index

        # If we're not listening to this stream, skip it
        if stream_index in c.listening
            # Decode the packet, and check if the frame is complete
            frameFinished = decode_packet(c.stream_contexts[stream_index + 1],
                                          c.aPacket)
            av_packet_unref(pointer(c.aPacket))

            # If the frame is complete, we're done
            frameFinished && return stream_index
        else
            av_packet_unref(pointer(c.aPacket))
        end
    end

    return -1
end

pump(r::StreamContext) = pump(r.avin)

function pump_until_frame(r)
    while !have_frame(r)
        idx = pump(r.avin)
        idx == r.stream_index0 && break
        idx == -1 && throw(EOFError())
    end
end

function _read_packet(pavin::Ptr{AVInput}, pbuf::Ptr{UInt8}, buf_size::Cint)
    avin = unsafe_pointer_to_objref(pavin)
    out = unsafe_wrap(Array, pbuf, (buf_size,))
    convert(Cint, readbytes!(avin.io, out))
end

# This will point to _read_packet, but is set in __init__()
const read_packet = Ref{Ptr{Cvoid}}(C_NULL)


function open_avinput(avin::AVInput, io::IO, input_format=C_NULL, options=C_NULL)

    !isreadable(io) && error("IO not readable")

    # These allow control over how much of the stream to consume when
    # determining the stream type
    # TODO: Change these defaults if necessary, or allow user to set
    #av_opt_set(avin.apFormatContext[1], "probesize", "100000000", 0)
    #av_opt_set(avin.apFormatContext[1], "analyzeduration", "1000000", 0)

    # Allocate the io buffer used by AVIOContext
    # Must be done with av_malloc, because it could be reallocated
    if (avio_ctx_buffer = av_malloc(avin.avio_ctx_buffer_size)) == C_NULL
        error("unable to allocate AVIOContext buffer (out of memory)")
    end

    # Allocate AVIOContext
    if (avin.apAVIOContext[1] = avio_alloc_context(avio_ctx_buffer, avin.avio_ctx_buffer_size,
                                                   0, pointer_from_objref(avin),
                                                   read_packet[], C_NULL, C_NULL)) == C_NULL
        abuffer = [avio_ctx_buffer]
        av_freep(abuffer)
        error("Unable to allocate AVIOContext (out of memory)")
    end

    # pFormatContext->pb = pAVIOContext
    av_setfield(avin.apFormatContext[1], :pb, avin.apAVIOContext[1])

    # "Open" the input
    if avformat_open_input(avin.apFormatContext, C_NULL, input_format, options) != 0
        error("Unable to open input")
    end

    nothing
end

function open_avinput(
        avin::AVInput, source::AbstractString,
        input_format=C_NULL, options=C_NULL
    )
    if avformat_open_input(
            avin.apFormatContext,
           source,
           input_format,
           options
        ) != 0

        error("Could not open $source")
    end

    nothing
end

function AVInput(
        source::T, input_format=C_NULL, options=C_NULL;
        avio_ctx_buffer_size=65536
    ) where T <: Union{IO,AbstractString}

    # Register all codecs and formats

    aPacket = [AVPacket()]
    apFormatContext = Ptr{AVFormatContext}[avformat_alloc_context()]
    apAVIOContext = Ptr{AVIOContext}[C_NULL]

    # Allocate this object (needed to pass into AVIOContext in open_avinput)
    avin = AVInput{T}(source, apFormatContext, apAVIOContext, avio_ctx_buffer_size,
                      aPacket, [StreamInfo[] for i = 1:6]..., Set(Int[]), StreamContext[], false)

    # Make sure we deallocate everything on exit
    finalizer(close, avin)

    # Set up the format context and open the input, based on the type of source
    open_avinput(avin, source, input_format, options)
    avin.isopen = true
    # Get the stream information
    if avformat_find_stream_info(avin.apFormatContext[1], C_NULL) < 0
        error("Unable to find stream information")
    end

    # Load streams, codec_contexts
    formatContext = unsafe_load(avin.apFormatContext[1]);

    for i = 1:formatContext.nb_streams
        pStream = unsafe_load(formatContext.streams, i)
        stream = unsafe_load(pStream)
        codec_ctx = unsafe_load(stream.codec)
        codec_type = codec_ctx.codec_type

        stream_info = StreamInfo(i - 1, pStream, stream, codec_ctx)

        if codec_type == AVMEDIA_TYPE_VIDEO
            push!(avin.video_info, stream_info)
        elseif codec_type == AVMEDIA_TYPE_AUDIO
            push!(avin.audio_info, stream_info)
        elseif codec_type == AVMEDIA_TYPE_DATA
            push!(avin.data_info, stream_info)
        elseif codec_type == AVMEDIA_TYPE_SUBTITLE
            push!(avin.subtitle_info, stream_info)
        elseif codec_type == AVMEDIA_TYPE_ATTACHMENT
            push!(avin.attachment_info, stream_info)
        elseif codec_type == AVMEDIA_TYPE_UNKNOWN
            push!(avin.unknown_info, stream_info)
        end
    end

    resize!(avin.stream_contexts, formatContext.nb_streams)

    avin
end

is_pixel_type_supported(pxfmt) = pxfmt in [AV_PIX_FMT_GRAY8, AV_PIX_FMT_GRAY10LE,
                                           AV_PIX_FMT_RGB24, AV_PIX_FMT_GBRP10LE]

function VideoReader(avin::AVInput, video_stream=1;
                     transcode::Bool=true,
                     transcode_interpolation=SWS_BILINEAR,
                     target_format=AV_PIX_FMT_RGB24)

    1 <= video_stream <= length(avin.video_info) || error("video stream $video_stream not found")

    stream_info = avin.video_info[video_stream]

    # Get basic stream info
    pVideoCodecContext = stream_info.stream.codec
    codecContext = stream_info.codec_ctx

    width, height = codecContext.width, codecContext.height
    pix_fmt = codecContext.pix_fmt
    pix_fmt < 0 && error("Unknown pixel format")

    framerate = codecContext.time_base.den // codecContext.time_base.num

    aspect_num = codecContext.sample_aspect_ratio.num
    aspect_den = codecContext.sample_aspect_ratio.den
    aspect_ratio = (aspect_den == 0) ? Cint(0) // Cint(1) : aspect_num // aspect_den

    # Find the decoder for the video stream
    pVideoCodec = avcodec_find_decoder(codecContext.codec_id)
    pVideoCodec == C_NULL && error("Unsupported Video Codec")

    # Open the decoder
    ret = avcodec_open2(pVideoCodecContext, pVideoCodec, C_NULL)
    ret < 0 && error("Could not open codec")

    aFrameFinished = Int32[0]

    # Set up transcoding
    # TODO: this should be optional
    pFmtDesc = av_pix_fmt_desc_get(target_format)
    check_ptr_valid(pFmtDesc, false) || error("Unknown pixel format $target_format")
    bits_per_pixel = av_get_padded_bits_per_pixel(pFmtDesc)

    if transcode && !is_pixel_type_supported(target_format)
        error("Unsupported pixel format $target_format")
    end

    sws_context = sws_getContext(width, height, pix_fmt,
                                 width, height, target_format,
                                 transcode_interpolation, C_NULL, C_NULL, C_NULL)

    destframe = AVFramePtr()
    destframe.format = target_format
    destframe.width = width
    destframe.height = height
    av_frame_get_buffer(get_ptr(destframe), 0) # Allocate picture buffers

    transcodeContext = VideoTranscodeContext(sws_context,
                                             transcode_interpolation,
                                             target_format,
                                             bits_per_pixel,
                                             width,
                                             height,
                                             destframe)
    srcframe = AVFramePtr()
    vr = VideoReader{transcode}(avin,
                                stream_info,

                                stream_info.stream_index0,
                                pVideoCodecContext,
                                pVideoCodec,
                                srcframe,
                                aFrameFinished,

                                pix_fmt,
                                width,
                                height,
                                framerate,
                                aspect_ratio,

                                Vector{UInt8}[],
                                transcodeContext)

    idx0 = stream_info.stream_index0
    push!(avin.listening, idx0)
    avin.stream_contexts[idx0 + 1] = vr

    vr
end

VideoReader(s::T, args...; kwargs...) where {T <: Union{IO,AbstractString}} =
    VideoReader(AVInput(s), args...; kwargs... )

# Does not check input size, meant for internal use only
function stash_source_planes!(imgbuf, r::VideoReader, align = VIDEOIO_ALIGN)
    frame = r.srcframe[1]
    av_image_copy_to_buffer(imgbuf, sz, Ref(frame.data), Ref(frame.linesize),
                            r.format, r.width, r.height, VIDEOIO_ALIGN)
    return imgbuf
end

stash_source_planes(r, align = VIDEOIO_ALIGN) =
    stash_source_planes!(Vector{UInt8}(undef, out_bytes_size(r, align)), r, align)

function unpack_stashed_planes!(r::VideoReader, imgbuf)
    frame = r.srcframe[1]
    av_image_fill_arrays(Ref(frame.data), Ref(frame.linesize), imgbuf,
                         r.format, r.width, r.height, VIDEOIO_ALIGN)
    return r
end

function decode_packet(r::VideoReader, aPacket)
    # Do we already have a complete frame that hasn't been consumed?
    if have_decoded_frame(r)
        push!(r.frame_queue, stash_source_places(r))
        reset_frame_flag!(r)
    end

    ret = avcodec_decode_video2(r.pVideoCodecContext, get_ptr(r.srcframe),
                                r.aFrameFinished, aPacket)
    ret < 0 && error("Could not decode video frame")

    return have_decoded_frame(r)
end

# Converts a grabbed frame to the correct format (RGB by default)
# TODO: type stability?
function retrieve(r::VideoReader{TRANSCODE}) # true=transcode
    pump_until_frame(r)
    t = r.transcodeContext
    pxfmt = t.target_pix_fmt
    if !is_pixel_type_supported(pxfmt)
        unsupported_retrieveal_format(pxfmt)
    end

    elt = pxfmt == AV_PIX_FMT_GRAY8    ? Gray{N0f8 } :
          pxfmt == AV_PIX_FMT_GRAY10LE ? Gray{N6f10} :
          pxfmt == AV_PIX_FMT_RGB24    ? RGB{ N0f8 } :
                                         RGB{ N6f10}
    buf = PermutedDimsArray(Matrix{elt}(undef, r.width, r.height), (2, 1))

    retrieve!(r, buf)
end

function retrieve(r::VideoReader{NO_TRANSCODE}) # false=don't transcode
    pump_until_frame(r)
    imgbuf = Vector{UInt8}(undef, out_bytes_size(r))
    retrieve!(r, imgbuf)
end

unsupported_retrieval_format(fmt) = error("Unsupported format $(fmt)")

# Transfer bytes from AVFrame to buffer
function _transfer_frame_bytes_to_img_buf!(buf::AbstractArray{UInt8}, frame,
                                           bytes_per_pixel)
    width = frame.width
    height = frame.height
    ip = frame.data[1]
    op = pointer(buf)
    out_linesize = width * bytes_per_pixel
    for h in 1:height
        out_line_p = op + (h - 1) * out_linesize
        in_line_p = ip + (h - 1) * frame.linesize[1]
        unsafe_copyto!(out_line_p, in_line_p, out_linesize)
    end
    buf
end

# Read a 8 bit monochrome frame
function transfer_frame_to_img_buf!(buf::AbstractArray{UInt8}, frame,
                                    bytes_per_pixel)
    target_format = frame.format
    if target_format == AV_PIX_FMT_GRAY8
        _transfer_frame_bytes_to_img_buf!(buf, frame, bytes_per_pixel)
    else
        unsupported_retrieval_format(target_format)
    end
    buf
end

# Read a 10 bit monochrome frame
function transfer_frame_to_img_buf!(buf::AbstractArray{UInt16}, frame,
                                    bytes_per_pixel)
    target_format = frame.format
    if target_format == AV_PIX_FMT_GRAY10LE
        if ENDIAN_BOM != 0x04030201
            error("Reading AV_PIX_FMT_GRAY10LE on big-endian machines not yet supported")
        end
        _transfer_frame_bytes_to_img_buf!(reinterpret(UInt8, buf), frame, bytes_per_pixel)
    else
        unsupported_retrieval_format(target_format)
    end
    buf
end

transfer_frame_to_img_buf!(buf::AbstractArray{X}, args...) where {T, X<:Normed{T}} =
    transfer_frame_to_img_buf!(reinterpret(T, buf), args...)

transfer_frame_to_img_buf!(buf::AbstractArray{<:Gray}, args...) =
    transfer_frame_to_img_buf!(channelview(buf), args...)

# Read a 8 bit RGB frame
function transfer_frame_to_img_buf!(buf::AbstractArray{RGB{N0f8}}, frame,
                                    bytes_per_pixel)
    target_format = frame.format
    if target_format == AV_PIX_FMT_RGB24
        _transfer_frame_bytes_to_img_buf!(reinterpret(UInt8, buf), frame,
                                          bytes_per_pixel)
    else
        unsupported_retrieval_format(target_format)
    end
    buf
end

@inline uint16_from_bytes(msb, lsb) = (convert(UInt16, msb) << 8) | lsb

function load_uint16_from_le_bytes(data, pos)
    lsb = unsafe_load(data, pos)
    msb = unsafe_load(data, pos + 1)
    uint16_from_bytes(msb, lsb)
end

load_n6f10_from_le_bytes(data, pos) =
    reinterpret(N6f10, load_uint16_from_le_bytes(data, pos))

# Read a 10 bit RGB frame
function transfer_frame_to_img_buf!(buf::AbstractArray{RGB{N6f10}}, frame,
                                    bytes_per_sample)
    target_format = frame.format
    if target_format == AV_PIX_FMT_GBRP10LE
        # Need to use a temporary buffer, linebuff, to store rgb values
        # because currently VideoIO accepts input buffers that are scanline-major
        # but where the first index is either the position within the scanline,
        # or instead the number of the scanline. This makes directly indexing
        # into the buffer impossible.
        width = frame.width
        height = frame.height
        linebuff = Vector{RGB{N6f10}}(undef, width)
        linesizes = frame.linesize[1:3]
        @inbounds for r in 1:height
            line_offsets = (r - 1) .* linesizes
            for c in 1:width
                col_pos = (c - 1) * bytes_per_sample + 1
                line_poss = line_offsets .+ col_pos
                rg = load_n6f10_from_le_bytes(frame.data[1], line_poss[1])
                rb = load_n6f10_from_le_bytes(frame.data[2], line_poss[2])
                rr = load_n6f10_from_le_bytes(frame.data[3], line_poss[3])
                linebuff[c] = RGB{N6f10}(rr, rg, rb)
            end
            output_pos = (r - 1) * width + 1
            unsafe_copyto!(buf, output_pos, linebuff, 1, width)
        end
    else
        unsupported_retrieval_format(target_format)
    end
    buf
end

# Converts a grabbed frame to the correct format (RGB by default)
function retrieve!(r::VideoReader{TRANSCODE}, buf::VidArray{T}
                   ) where T <: ReaderElTypes
    if !out_img_size_check(r, buf)
        error("Buffer is the wrong size")
    end

    pump_until_frame(r)

    # If we have an unprocessed frames in the queue
    if !isempty(r.frame_queue)
        # But also a decoded frame
        if have_decoded_frame(r)
            # Then move the decoded frame to the back of the queue
            push!(r.frame_queue, stash_source_planes(r))
        end
        unpack_stashed_planes!(r, popfirst!(r.frame_queue))
        r.aFrameFinished[1] = 1
    end

    t = r.transcodeContext

    srcframe = r.srcframe
    destframe = t.destframe
    src_data_ptr = unsafe_field_ptr(srcframe, :data)
    src_linesize_ptr = unsafe_field_ptr(srcframe, :linesize)
    dest_data_ptr = unsafe_field_ptr(destframe, :data)
    dest_linesize_ptr = unsafe_field_ptr(destframe, :linesize)
    Base.sigatomic_begin()
    ret = sws_scale(t.transcode_context, src_data_ptr,
                    src_linesize_ptr, zero(Cint), r.height,
                    dest_data_ptr, dest_linesize_ptr)
    Base.sigatomic_end()

    bytes_per_pixel, nrem = divrem(t.target_bits_per_pixel, 8)
    nrem > 0 && error("Unsupported pixel size")

    transfer_frame_to_img_buf!(buf, destframe, bytes_per_pixel)

    reset_frame_flag!(r)

    return buf
end

function retrieve!(r::VideoReader{NO_TRANSCODE}, buf::VidArray{T}
                   ) where T <: ReaderElTypes
    out_bytes_size_check(buf, r) || error("Buffer is the wrong size")
    pump_until_frame(r)
    stash_source_planes!(buf, r)
end

# Utility functions

open(filename::AbstractString) = AVInput(filename) # not exported

"""
    r = openvideo(filename)
    r = openvideo(stream)

Open a video file or stream and return a `VideoReader` object `r`.
"""
openvideo(args...; kwargs...) = VideoReader(args...; kwargs...)

"""
    frame = read(r::VideoReader)

Return the next frame from `r`.
"""
read(r::VideoReader) = retrieve(r)

"""
    read!(r::VideoReader, buf::Union{PermutedArray{T,N}, Array{T,N}}) where T<:ReaderElTypes

Read a frame from `r` into array `buf`, which can either be a regular array or a
permuted view of a regular array.
"""
read!(r::VideoReader, buf::AbstractArray{T}) where {T <: ReaderElTypes} =
    retrieve!(r, buf)

isopen(avin::AVInput{I}) where {I <: IO} = isopen(avin.io)
isopen(avin::AVInput) = avin.isopen
isopen(r::VideoReader) = isopen(r.avin)

out_frame_size(r::VideoReader{NO_TRANSCODE}) = (r.width, r.height)
out_frame_size(t::VideoTranscodeContext) = (t.width, t.height)
out_frame_size(r::VideoReader{TRANSCODE}) = out_frame_size(r.transcodeContext)

out_frame_format(r::VideoReader{NO_TRANSCODE}) = r.format
out_frame_format(t::VideoTranscodeContext) = t.target_pix_fmt
out_frame_format(r::VideoReader{TRANSCODE}) = out_frame_format(r.transcodeContext)

out_img_size_check(r, buf) = size(buf) == out_frame_size(r)
out_img_size_check(r, buf::PermutedDimsArray) = out_img_size_check(r, parent(buf))

out_img_eltype_check(::Type{T}, p) where T <: UInt8 = p == AV_PIX_FMT_GRAY8
out_img_eltype_check(::Type{T}, p) where T <: UInt16 = p == AV_PIX_FMT_GRAY10LE
out_img_eltype_check(::Type{X}, p) where {T, X <: Normed{T}} = out_img_eltype_check(T, p)
out_img_eltype_check(::Type{X}, p) where {T, X <: Gray{T}} = out_img_eltype_check(T, p)
out_img_eltype_check(::Type{T}, p) where T<:RGB{N0f8} = p == AV_PIX_FMT_RGB24
out_img_eltype_check(::Type{T}, p) where T<:RGB{N6f10} = p == AV_PIX_FMT_GBRP10LE

out_img_eltype_check(fmt::Integer, ::AbstractArray{T}) where T = out_img_eltype_check(T, r)
out_img_eltype_check(r, buf) = out_img_eltype_check(out_frame_format(r), buf)

out_img_check(r, buf) = out_img_size_check(r, buf) && out_img_eltype_check(r, buf)

function out_bytes_size(fmt, width, height, align = VIDEOIO_ALIGN)
    sz = av_image_get_buffer_size(r.format, r.width, r.height, VIDEOIO_ALIGN)
    sz < 0 && error("Could not determine the buffer size")
    sz
end
out_bytes_size(r, args...) =
    out_bytes_size(out_frame_format(r), out_frame_size(r)..., args...)

out_bytes_size_check(buf, r) = sizeof(buf) == out_bytes_size(r)

have_decoded_frame(r) = r.aFrameFinished[1] > 0  # TODO: make sure the last frame was made available
have_frame(r::StreamContext) = !isempty(r.frame_queue) || have_decoded_frame(r)
have_frame(avin::AVInput) = any(Bool[have_frame(avin.stream_contexts[i + 1]) for i in avin.listening])

reset_frame_flag!(r) = (r.aFrameFinished[1] = 0)

function seconds_to_timestamp(s::Float64, time_base::AVRational)
    return round(Int64, floor(s *  convert(Float64, time_base.den) / convert(Float64, time_base.num)))
end

get_stream_index(s::VideoReader) =
    findfirst(x -> x.stream_index0 == s.stream_index0, s.avin.video_info)

"""
    gettime(s::VideoReader)

Return timestamp of current position in seconds.
"""
function gettime(s::VideoReader)
    # No frame has been read
    s.srcframe.format < 0 && return 0.0
    video_stream_idx = get_stream_index(s)
    time_base = s.avin.video_info[video_stream_idx].stream.time_base
    frameindex = s.srcframe.pkt_dts   #av_frame_get_best_effort_timestamp(s.srcframe)
    return frameindex * (time_base.num/time_base.den)
end

"""
    seek(s::VideoReader, seconds::AbstractFloat, seconds_min::AbstractFloat=-1.0,
         seconds_max::AbstractFloat=-1.0, forward::Bool=false)

Seek through VideoReader object.
"""
function seek(s::VideoReader, seconds::AbstractFloat,
              seconds_min::AbstractFloat=-1.0,  seconds_max::AbstractFloat=-1.0,
              forward::Bool=false)
    !isopen(s) && throw(ErrorException("Video input stream is not open!"))
    video_stream_idx = get_stream_index(s)
    fc = s.avin.apFormatContext[1]

    pCodecContext = s.pVideoCodecContext # AVCodecContext

    seek(s.avin, seconds, seconds_min, seconds_max, video_stream_idx, forward)
    avcodec_flush_buffers(pCodecContext)

    stream_info = s.avin.video_info[video_stream_idx]
    stream = stream_info.stream
    first_dts = stream.first_dts

    actualTimestamp = s.srcframe.pkt_dts   #av_frame_get_best_effort_timestamp(s.srcframe)
    dts = first_dts + seconds_to_timestamp(seconds, stream.time_base)

    pStream = stream_info.pStream
    frame_rate = av_stream_get_r_frame_rate(pStream)
    frameskip = round(Int64, (stream.time_base.den / stream.time_base.num) / (frame_rate.num / frame_rate.den))

    while actualTimestamp < (dts - frameskip)
        pump_until_frame(s)
        reset_frame_flag!(s)
        actualTimestamp = s.srcframe.pkt_dts   #av_frame_get_best_effort_timestamp(s.srcframe)
    end
    return(s)
end

"""
    seek(s::VideoReader, seconds::AbstractFloat, seconds_min::AbstractFloat=-1.0,  seconds_max::AbstractFloat=-1.0, video_stream::Integer=1, forward::Bool=false)

Seek through AVInput object.
"""
function seek(avin::AVInput{T}, seconds::AbstractFloat,
              seconds_min::AbstractFloat=-1.0,  seconds_max::AbstractFloat=-1.0,
              video_stream::Integer=1, forward::Bool=false) where T <: AbstractString

    #Using 10 seconds before and after the desired timestamp, since the seek function
    #seek to the nearest keyframe, and 10 seconds is the longest GOP length seen in
    #practical usage.
    max_interval = 10.0

    # AVFormatContext
    fc = avin.apFormatContext[1]

    # Get stream information
    stream_info = avin.video_info[video_stream]
    seek_stream_index = stream_info.stream_index0
    stream = stream_info.stream
    first_dts = stream.first_dts
    time_base = stream.time_base

    if first_dts == AV_NOPTS_VALUE
        throw(ErrorException("Unable to seek (no DTS value received from container)."))
    end

    #Timestamp calculations
    if seconds_min < 0
        seconds_min = max(seconds - max_interval, 0.0)
    end

    if seconds_max < 0
        seconds_max = seconds + max_interval
    end

    dts = first_dts + seconds_to_timestamp(seconds, time_base)
    min_dts = first_dts + seconds_to_timestamp(seconds_min, time_base)
    #max_dts = first_dts + seconds_to_timestamp(seconds_max, time_base)

    flags = AVSEEK_FLAG_ANY
    if !forward
        flags = AVSEEK_FLAG_BACKWARD
    end

    # Seek
    ret = avformat_seek_file(fc, seek_stream_index, min_dts, dts, dts, flags)
    ret < 0 && throw(ErrorException("Could not seek in stream"))

    return avin
end
"""
    seekstart(s::VideoReader)

Seek to start of VideoReader object.
"""
function seekstart(s::VideoReader)
    return seek(s, 0.0, 0.0, 0.0, false)
end

"""
    seekstart(avin::AVInput{T}, video_stream=1) where T <: AbstractString

Seek to start of AVInput object.
"""
function seekstart(avin::AVInput{T}, video_stream=1) where T <: AbstractString
    return seek(avin, 0.0, 0.0, 0.0, video_stream, false)
end

## This doesn't work...
#seekstart{T<:IO}(avin::AVInput{T}, video_stream = 1) = seekstart(avin.io)
seekstart(avin::AVInput{T}, video_stream=1) where {T <: IO} = throw(ErrorException("Sorry, Seeking is not supported from IO streams"))

"""
    skipframe(s::VideoReader; throwEOF=true)

Skip the next frame. If End of File is reached, EOFError thrown if throwEOF=true.
Otherwise returns true if EOF reached, false otherwise.
"""
function skipframe(s::VideoReader; throwEOF=true)
    while !have_frame(s)
        idx = pump(s.avin)
        idx == s.stream_index0 && break
        if idx == -1
            throwEOF && throw(EOFError())
            return true
        end
    end
    reset_frame_flag!(s)
    return false
end

"""
    skipframes(s::VideoReader, n::Int)

Skip the next `n` frames. If End of File is reached, EOFError to be thrown.
With `throwEOF = true` the number of frames that were skipped to be returned without error.
"""
function skipframes(s::VideoReader, n::Int; throwEOF=true)
    for _ in 1:n
        skipframe(s, throwEOF=throwEOF) && return n
    end
end

"""
    counttotalframes(s::VideoReader)

Count the total number of frames in the video by seeking to start, skipping through
each frame, and seeking back to the start.
"""
function counttotalframes(s::VideoReader)
    seekstart(s)
    n = 0
    while true
        skipframe(s, throwEOF = false) && break
        n += 1
    end
    seekstart(s)
    return n
end

function eof(avin::AVInput)
    !isopen(avin) && return true
    have_frame(avin) && return false
    got_frame = (pump(avin) != -1)
    return !got_frame
end

function eof(avin::AVInput{I}) where I <: IO
    !isopen(avin) && return true
    have_frame(avin) && return false
    return eof(avin.io)::Bool
end

eof(r::VideoReader) = eof(r.avin)

close(r::VideoReader) = close(r.avin)
function _close(r::VideoReader)
    sws_freeContext(r.transcodeContext.transcode_context)
    avcodec_close(r.pVideoCodecContext)
end

# Free AVIOContext object when done
function close(avin::AVInput)
    Base.sigatomic_begin()
    isopen = avin.isopen
    avin.isopen = false
    Base.sigatomic_end()

    !isopen && return

    for i in avin.listening
        _close(avin.stream_contexts[i + 1])
    end

    # Fix for segmentation fault issue #44
    empty!(avin.listening)
    empty!(avin.stream_contexts)

    Base.sigatomic_begin()
    if avin.apFormatContext[1] != C_NULL
        avformat_close_input(avin.apFormatContext)
    end
    Base.sigatomic_end()

    Base.sigatomic_begin()
    if avin.apAVIOContext[1] != C_NULL
        p = av_pointer_to_field(avin.apAVIOContext[1], :buffer)
        p != C_NULL && av_freep(p)
        av_freep(avin.apAVIOContext)
    end
    Base.sigatomic_end()
end


### Camera Functions

# These are set in __init__()
const DEFAULT_CAMERA_FORMAT = Ref{Any}()
const CAMERA_DEVICES = String[]
const DEFAULT_CAMERA_DEVICE = Ref{String}()
const DEFAULT_CAMERA_OPTIONS = AVDict()

function get_camera_devices(ffmpeg, idev, idev_name)
    camera_devices = String[]

    read_vid_devs = false
    lines = FFMPEG.exe(`-list_devices true -f $idev -i $idev_name`,collect=true)

    for line in lines
        if occursin("video devices",line)
            read_vid_devs = true
            continue
        elseif occursin("audio devices",line) || occursin("exit", line) || occursin("error", line)
            read_vid_devs = false
            continue
        end

        if read_vid_devs
            m = match(r"""\[.*"(.*)".?""", line)
            if m != nothing
                push!(camera_devices, m.captures[1])
            end

            # Alternative format (TODO: could be combined with the regex above)
            m = match(r"""\[.*\] \[[0-9]\] (.*)""", line)
            if m != nothing
                push!(camera_devices, m.captures[1])
            end
        end
    end

    return camera_devices
end

function opencamera(
        device=DEFAULT_CAMERA_DEVICE[],
        format=DEFAULT_CAMERA_FORMAT[],
        options = DEFAULT_CAMERA_OPTIONS,
        args...;
        kwargs...
    )
    camera = AVInput(device, format, options)
    VideoReader(camera, args...; kwargs...)
end
