# AVIcodec_type
import Base: read, read!, show, close, eof, isopen, seek, seekstart

export read, read!, pump, openvideo, opencamera, playvideo, viewcam, play, gettime
export skipframe, skipframes, counttotalframes

abstract type StreamContext end

const ReaderBitTypes = Union{UInt8, UInt16}
const ReaderNormedTypes = Normed{T} where T<: ReaderBitTypes
const ReaderGrayTypes = Gray{T} where T<: ReaderNormedTypes
const ReaderRgbTypes = RGB{T} where T<:ReaderNormedTypes
const ReaderElTypes = Union{ReaderGrayTypes, ReaderRgbTypes}
const PermutedArray{T,N,perm,iperm,AA <: Array} =
    Base.PermutedDimsArrays.PermutedDimsArray{T,N,perm,iperm,AA}
const VidArray{T,N} = Union{Array{T,N},PermutedArray{T,N}}

const VIDEOIO_ALIGN = 32

convert(::Type{Rational{T}}, r::AVRational) where T = Rational{T}(r.num, r.den)
convert(::Type{Rational}, r::AVRational) = Rational(r.num, r.den)
convert(::Type{AVRational}, r::Rational) = AVRational(numerator(r), denominator(r))

# TODO: move this to Base
# NOTE: pointer adjacency will NOT correspond with normal indexing
Base.unsafe_convert(::Type{Ptr{T}}, A::PermutedArray{T}) where {T} =
    Base.unsafe_convert(Ptr{T}, parent(A))

# An audio-visual input stream/file
mutable struct AVInput{I}
    io::I
    format_context::AVFormatContextPtr
    avio_context::AVIOContextPtr
    avio_ctx_buffer_size::UInt
    packet::AVPacketPtr

    unknown_indices::Vector{Int}
    video_indices::Vector{Int}
    audio_indices::Vector{Int}
    data_indices::Vector{Int}
    subtitle_indices::Vector{Int}
    attachment_indices::Vector{Int}

    listening::Set{Int}
    stream_contexts::Dict{Int, StreamContext}

    isopen::Bool
    finished::Bool
end


function show(io::IO, avin::AVInput)
    println(io, "AVInput(", avin.io, ", ...), with")
    (len = length(avin.video_indices))      > 0 && println(io, "  $len video stream(s)")
    (len = length(avin.audio_indices))      > 0 && println(io, "  $len audio stream(s)")
    (len = length(avin.data_indices))       > 0 && println(io, "  $len data stream(s)")
    (len = length(avin.subtitle_indices))   > 0 && println(io, "  $len subtitle stream(s)")
    (len = length(avin.attachment_indices)) > 0 && println(io, "  $len attachment stream(s)")
    (len = length(avin.unknown_indices))    > 0 && println(io, "  $len unknown stream(s)")
end

mutable struct VideoTranscodeContext
    sws_context::SwsContextPtr

    transcode_interp::Cint
    target_pix_fmt::Cint
    target_bits_per_pixel::Int
    width::Int
    height::Int

    destframe::AVFramePtr
end

const TRANSCODE = true
const NO_TRANSCODE = false

mutable struct VideoReader{transcode, I} <: StreamContext
    avin::AVInput{I}

    stream_index0::Int
    codec_context::AVCodecContextPtr
    pVideoCodec::Ptr{AVCodec}
    srcframe::AVFramePtr
    frame_ready::Bool

    format::Cint
    width::Cint
    height::Cint
    framerate::Rational{Cint}
    aspect_ratio::Rational{Cint}

    frame_queue::Vector{Vector{UInt8}}
    transcodeContext::VideoTranscodeContext

    flush::Bool
    finished::Bool
end

show(io::IO, vr::VideoReader) = print(io, "VideoReader(...)")

function iterate(r::VideoReader, state = 0)
    eof(r) && return
    return read(r), state + 1
end

is_finished(r::VideoReader) = r.finished

IteratorSize(::Type{<:VideoReader}) = Base.SizeUnknown()

IteratorEltype(::Type{<:VideoReader}) = Base.EltypeUnknown()

# Pump input for data
function pump(avin::AVInput)
    while avin.isopen && !avin.finished
        sigatomic_begin()
        ret = av_read_frame(avin.format_context, avin.packet)
        sigatomic_end()
        if ret < 0
            avin.finished = true
            break
        end
        stream_index = avin.packet.stream_index
        if stream_index in avin.listening
            # Decode the packet, and check if the frame is complete
            r = avin.stream_contexts[stream_index]
            decode(r, avin.packet)
            av_packet_unref(avin.packet)

            # If the frame is complete, we're done
            have_frame(r) && return Int(stream_index)
        else
            # If we're not listening to this stream, skip it
            av_packet_unref(avin.packet)
        end
    end
    if avin.finished
        for (stream_index, r) in pairs(avin.stream_contexts)
            if !r.finished
                decode(r, C_NULL) # Flush packet
                r.flush = true
                have_frame(r) && return stream_index
            end
        end
    end
    return -1
end

pump(r::StreamContext) = pump(r.avin)

function pump_until_frame(r, err = false)
    while !have_frame(r)
        idx = pump(r.avin)
        idx == r.stream_index0 && break
        if idx == -1
            err ? throw(EOFError()) : return false
        end
    end
    return true
end

# This will point to _read_packet, but is set in __init__()
const read_packet = Ref{Ptr{Cvoid}}(C_NULL)

function _read_packet(pavin::Ptr{AVInput}, pbuf::Ptr{UInt8}, buf_size::Cint)
    avin = unsafe_pointer_to_objref(pavin)
    out = unsafe_wrap(Array, pbuf, (buf_size,))
    convert(Cint, readbytes!(avin.io, out))
end

function open_avinput(avin::AVInput, io::IO, input_format=C_NULL, options=C_NULL)

    !isreadable(io) && error("IO not readable")

    # These allow control over how much of the stream to consume when
    # determining the stream type
    # TODO: Change these defaults if necessary, or allow user to set
    #av_opt_set(avin.format_context "probesize", "100000000", 0)
    #av_opt_set(avin.format_context, "analyzeduration", "1000000", 0)

    # Allocate the io buffer used by AVIOContext
    # Must be done with av_malloc, because it could be reallocated
    avio_context = unsafe_AVIOContextPtr(avin)
    avin.avio_context = avio_context
    avin.format_context.pb = avio_context

    # "Open" the input
    ret = avformat_open_input(avin.format_context, C_NULL, input_format, options)
    if ret != 0
        error("Unable to open input")
    end

    nothing
end

function open_avinput(avin::AVInput, source::AbstractString,
                      input_format=C_NULL, options=C_NULL)
    ret = avformat_open_input(avin.format_context, source, input_format, options)
    ret != 0 && error("Could not open $source")
    nothing
end

function AVInput(
        source::T, input_format=C_NULL, options=C_NULL;
        avio_ctx_buffer_size=4096 # recommended value by FFMPEG documentation
    ) where T <: Union{IO,AbstractString}

    # Register all codecs and formats

    packet = AVPacketPtr()
    format_context = AVFormatContextPtr()
    avio_context = AVIOContextPtr(Ptr{AVIOContext}(C_NULL))

    # Allocate this object (needed to pass into AVIOContext in open_avinput)
    avin = AVInput{T}(source, format_context, avio_context,
                      avio_ctx_buffer_size, packet,
                      [Int[] for i = 1:6]..., Set(Int[]),
                      Dict{Int, StreamContext}(), false, false)

    # Set up the format context and open the input, based on the type of source
    open_avinput(avin, source, input_format, options)
    avin.isopen = true

    # Get the stream information
    ret = avformat_find_stream_info(avin.format_context, C_NULL)
    ret < 0 && error("Unable to find stream information")

    for i = 1:format_context.nb_streams
        codec_type = format_context.streams[i].codecpar.codec_type
        target_array = codec_type == AVMEDIA_TYPE_VIDEO      ? avin.video_indices      :
                       codec_type == AVMEDIA_TYPE_AUDIO      ? avin.audio_indices      :
                       codec_type == AVMEDIA_TYPE_DATA       ? avin.data_indices       :
                       codec_type == AVMEDIA_TYPE_SUBTITLE   ? avin.data_indices       :
                       codec_type == AVMEDIA_TYPE_ATTACHMENT ? avin.attachment_indices :
                                                               avin.unknown_indices
        push!(target_array, i - 1)
        # Set the stream to discard all packets. Individual StreamContexts can
        # re-enable streams.
        format_context.streams[i].discard = AVDISCARD_ALL
    end
    avin
end

is_pixel_type_supported(pxfmt) = pxfmt in Set([AV_PIX_FMT_GRAY8,
                                               AV_PIX_FMT_GRAY10LE,
                                               AV_PIX_FMT_RGB24,
                                               AV_PIX_FMT_GBRP10LE])

get_stream(avin::AVInput, stream_index0) = avin.format_context.streams[stream_index0 + 1]
get_stream(r::VideoReader) = get_stream(r.avin, r.stream_index0)

function VideoReader(avin::AVInput{I}, video_stream=1;
                     transcode::Bool=true,
                     transcode_interpolation=SWS_BILINEAR,
                     target_format=AV_PIX_FMT_RGB24) where I
    if transcode && !is_pixel_type_supported(target_format)
        error("Unsupported pixel format $target_format")
    end

    1 <= video_stream <= length(avin.video_indices) || error("video stream $video_stream not found")

    stream_index0 = avin.video_indices[video_stream]

    # Find decoder
    stream = get_stream(avin, stream_index0)
    pVideoCodec = avcodec_find_decoder(stream.codecpar.codec_id)
    check_ptr_valid(pVideoCodec, false) || error("Failed to find decoder")

    # Tell the demuxer to retain packets from this stream
    stream.discard = AVDISCARD_DEFAULT

    # Create decoder context
    codec_context = AVCodecContextPtr(pVideoCodec) # Allocates
    # Transfer parameters to decoder context
    ret = avcodec_parameters_to_context(codec_context, stream.codecpar)
    ret < 0 && error("Could not copy the codec parameters to the decoder")
    pix_fmt = codec_context.pix_fmt
    pix_fmt < 0 && error("Unknown pixel format")

    # Open the decoder
    sigatomic_begin()
    lock(VIDEOIO_LOCK)
    ret = avcodec_open2(codec_context, pVideoCodec, C_NULL)
    unlock(VIDEOIO_LOCK)
    sigatomic_end()
    ret < 0 && error("Could not open codec")

    # Set up transcoding
    # TODO: this should be optional
    pFmtDesc = av_pix_fmt_desc_get(target_format)
    check_ptr_valid(pFmtDesc, false) || error("Unknown pixel format $target_format")

    width, height = codec_context.width, codec_context.height

    destframe = AVFramePtr()
    destframe.format = target_format
    destframe.width = width
    destframe.height = height
    av_frame_get_buffer(destframe, 0) # Allocate picture buffers
    bits_per_pixel = av_get_padded_bits_per_pixel(pFmtDesc)

    sws_context = SwsContextPtr(width, height, pix_fmt, target_format,
                                transcode_interpolation)
    transcodeContext = VideoTranscodeContext(sws_context,
                                             transcode_interpolation,
                                             target_format, bits_per_pixel,
                                             width, height, destframe)
    srcframe = AVFramePtr()

    framerate = codec_context.time_base.den // codec_context.time_base.num
    aspect_num = codec_context.sample_aspect_ratio.num
    aspect_den = codec_context.sample_aspect_ratio.den
    aspect_ratio = (aspect_den == 0) ? Cint(0) // Cint(1) :
        aspect_num // aspect_den

    vr = VideoReader{transcode, I}(avin,

                                   stream_index0,
                                   codec_context,
                                   pVideoCodec,
                                   srcframe,
                                   false,

                                   pix_fmt,
                                   width,
                                   height,
                                   framerate,
                                   aspect_ratio,

                                   Vector{UInt8}[],
                                   transcodeContext,
                                   false,
                                   false)

    push!(avin.listening, stream_index0)
    avin.stream_contexts[stream_index0] = vr
    vr
end

VideoReader(s::T, args...; kwargs...) where {T <: Union{IO,AbstractString}} =
    VideoReader(AVInput(s), args...; kwargs... )

# Does not check input size, meant for internal use only
function stash_source_planes!(imgbuf, r::VideoReader, align = VIDEOIO_ALIGN)
    frame = r.srcframe
    av_image_copy_to_buffer(imgbuf, length(imgbuf), Ref(frame.data),
                            Ref(frame.linesize), r.format, r.width, r.height,
                            VIDEOIO_ALIGN)
    return imgbuf
end

stash_source_planes(r, align = VIDEOIO_ALIGN) =
    stash_source_planes!(Vector{UInt8}(undef, out_bytes_size(r, align)), r, align)

function unpack_stashed_planes!(r::VideoReader, imgbuf)
    frame = r.srcframe
    av_make_writable(frame)
    av_image_fill_arrays(frame.data, frame.linesize, imgbuf,
                         r.format, r.width, r.height, VIDEOIO_ALIGN)
    return r
end

check_send_packet_return(r) = (r < 0 && r != -Libc.EAGAIN) && error("Could not send packet")

function decode(r::VideoReader, packet)
    # Do we already have a complete frame that hasn't been consumed?
    r.finished && return
    if have_decoded_frame(r)
        push!(r.frame_queue, stash_source_places(r))
        reset_frame_flag!(r)
    end
    if !r.flush
        pret = avcodec_send_packet(r.codec_context, packet)
        check_send_packet_return(pret)
    end
    fret = avcodec_receive_frame(r.codec_context, r.srcframe)
    if fret == 0
        r.frame_ready = true
    elseif fret == VIO_AVERROR_EOF
        r.finished = true
    elseif fret != -Libc.EAGAIN
        error("Decoding error $fret")
    end
    if !r.finished && !r.flush && pret == -Libc.EAGAIN
        pret2 = avcodec_send_packet(r.codec_context, packet)
        check_send_packet_return(pret2)
    end
    return
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
                                    ::Any)
    target_format = frame.format
    if target_format == AV_PIX_FMT_GBRP10LE
        bytes_per_sample = 2
        width = frame.width
        height = frame.height
        size(buf) == (width, height) || error("buffer wrong size")
        ls = frame.linesize
        @inbounds linesizes = ntuple(i -> ls[i], 3)
        @inbounds for r in 1:height
            line_offsets = (r - 1) .* linesizes
            @simd ivdep for c in 1:width
                col_pos = (c - 1) * bytes_per_sample + 1
                line_poss = line_offsets .+ col_pos
                rg = load_n6f10_from_le_bytes(frame.data[1], line_poss[1])
                rb = load_n6f10_from_le_bytes(frame.data[2], line_poss[2])
                rr = load_n6f10_from_le_bytes(frame.data[3], line_poss[3])
                buf[c, r] = RGB{N6f10}(rr, rg, rb) # scanline-major!
            end
        end
    else
        unsupported_retrieval_format(target_format)
    end
    buf
end

transfer_frame_to_img_buf!(buf::PermutedDimsArray, frame, bytes_per_sample) =
    transfer_frame_to_img_buf!(parent(buf), frame, bytes_per_sample)

function drop_frame!(r::VideoReader)
    if isempty(r.frame_queue)
        have_decoded_frame(r) && reset_frame_flag!(r)
    else
        if r.frame_ready
            push!(r.frame_queue, stash_source_planes(r))
            reset_frame_flag!(r)
        end
        popfirst!(r.frame_queue)
    end
    r
end

function drop_frames!(r::VideoReader)
    empty!(r.frame_queue)
    reset_frame_flag!(r)
end

n_queued_frames(r::VideoReader) = length(r.frame_queue) + r.frame_ready

# Converts a grabbed frame to the correct format (RGB by default)
function retrieve!(r::VideoReader{TRANSCODE}, buf::VidArray{T}
                   ) where T <: ReaderElTypes
    if !out_img_size_check(r, buf)
        error("Buffer is the wrong size")
    end

    pump_until_frame(r)

    # Get the oldest frame stored by VideoReader

    # If we have an unprocessed frames in the queue
    if !isempty(r.frame_queue)
        # But also a decoded frame
        if have_decoded_frame(r)
            # Then move the decoded frame to the back of the queue
            push!(r.frame_queue, stash_source_planes(r))
        end
        unpack_stashed_planes!(r, popfirst!(r.frame_queue))
        r.frame_ready = true
    end

    # Do colorspace scaling

    t = r.transcodeContext
    src_ptr = unsafe_convert(Ptr{AVFrame}, r.srcframe)
    GC.@preserve r begin
        # t is preserved if r is preserved, hopefully? A little confusing.
        src_data_ptr = field_ptr(src_ptr, :data)
        src_linesize_ptr = field_ptr(src_ptr, :linesize)
        dest_ptr = unsafe_convert(Ptr{AVFrame}, t.destframe)
        dest_data_ptr = field_ptr(dest_ptr, :data)
        dest_linesize_ptr = field_ptr(dest_ptr, :linesize)

        sigatomic_begin()
        ret = sws_scale(t.sws_context, src_data_ptr, src_linesize_ptr,
                        0, r.height, dest_data_ptr, dest_linesize_ptr)
        sigatomic_end()
    end

    # Transfer frame data to output buffer
    bytes_per_pixel, nrem = divrem(t.target_bits_per_pixel, 8)
    nrem > 0 && error("Unsupported pixel size")

    transfer_frame_to_img_buf!(buf, t.destframe, bytes_per_pixel)

    # Mark frame as done, and tell FFMPEG that we are no longer using its picture
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

Return the next frame from `r`. See `read!`.
"""
read(r::VideoReader) = retrieve(r)

"""
    read!(r::VideoReader, buf::Union{PermutedArray{T,N}, Array{T,N}}) where T<:ReaderElTypes

Read a frame from `r` into array `buf`, which can either be a regular array or a
permuted view of a regular array. `buf` must be scanline-major, meaning that
adjacent pixels on the same horizontal line of the video frame are also adjacent
in memory.
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
    sz = av_image_get_buffer_size(fmt, width, height, align)
    sz < 0 && error("Could not determine the buffer size")
    sz
end
out_bytes_size(r, args...) =
    out_bytes_size(out_frame_format(r), out_frame_size(r)..., args...)

out_bytes_size_check(buf, r) = sizeof(buf) == out_bytes_size(r)

have_decoded_frame(r) = r.frame_ready # TODO: make sure the last frame was made available
have_frame(r::StreamContext) = !isempty(r.frame_queue) || have_decoded_frame(r)
have_frame(avin::AVInput) = mapreduce(have_frame, |, values(avin.stream_contexts), init = false)

function reset_frame_flag!(r::VideoReader)
    av_frame_unref(r.srcframe)
    r.frame_ready = false
end

seconds_to_timestamp(s, time_base::Rational) = round(Int, s / time_base)
seconds_to_timestamp(s, time_base::AVRational) = seconds_to_timestamp(s, convert(Rational, time_base))

get_video_stream_index(s::VideoReader) =
    findfirst(x -> x == s.stream_index0, s.avin.video_indices)

"""
    gettime(s::VideoReader)

Return timestamp of current position in seconds.
"""
function gettime(s::VideoReader)
    # No frame has been read
    t = position(s)
    t == nothing && return 0.0
    return Float64(t)
end

# To be called for all stream contexts following a seek of AVInput
function reset_file_position_information!(r::VideoReader)
    avcodec_flush_buffers(r.codec_context)
    drop_frames!(r)
    r.flush = false
    r.finished = false
end

get_frame_presentation_time(stream, frame) =
    convert(Rational, stream.time_base) * convert(Rational, frame.pts)

function get_frame_period_timebase(r::VideoReader)
    # This is probably not valid for many codecs, frame period in timebase
    # units
    stream = get_stream(s)
    time_base = convert(Rational, stream.time_base)
    time_base == 0 && return nothing
    frame_rate = convert(Rational, av_stream_get_r_frame_rate(stream))
    frame_period_timebase = round(Int64,  1 / (frame_rate * time_base))
    frame_period_timebase
end

"""
    seek(r::VideoReader, seconds::AbstractFloat, seconds_min::AbstractFloat=-1.0,
         seconds_max::AbstractFloat=-1.0, forward::Bool=false)

Seek through VideoReader object.
    """
function seek(r::VideoReader, seconds::Number)
    !isopen(r) && throw(ErrorException("Video input stream is not open!"))
    video_stream_idx = get_video_stream_index(r)
    seek(r.avin, seconds, video_stream_idx)
    return r
end

function seek_trim(r::VideoReader, seconds::Number)
    stream = get_stream(r)
    time_base = convert(Rational, stream.time_base)
    time_base == 0 && error("No time base")
    target_pts = seconds_to_timestamp(seconds, time_base)
    frame_rate = convert(Rational, av_stream_get_r_frame_rate(stream))
    frame_period_timebase = round(Int64,  1 / (frame_rate * time_base))
    gotframe = pump_until_frame(r, false)
    # If advancing another frame would still leave us before the target
    while gotframe && r.srcframe.pts != AV_NOPTS_VALUE &&
          r.srcframe.pts + frame_period_timebase <= target_pts
        drop_frame!(r)
        gotframe = pump_until_frame(r, false)
    end
end

"""
    seek(s::VideoReader, seconds::AbstractFloat, video_stream::Integer=1)

Seek through AVInput object.
"""
function seek(avin::AVInput{T}, seconds::Number, video_stream::Integer=1) where T <: AbstractString
    stream_index0 = avin.video_indices[video_stream]
    stream = get_stream(avin, stream_index0)
    time_base = convert(Rational, stream.time_base)
    time_base == 0 && error("No time base for stream")
    pts = seconds_to_timestamp(seconds, time_base)
    ret = avformat_seek_file(avin.format_context, stream_index0, typemin(Int),
                             pts, typemax(Int), 0)
    ret < 0 && throw(ErrorException("Could not seek in stream"))
    avin.finished = false
    for r in values(avin.stream_contexts)
        reset_file_position_information!(r)
        seek_trim(r, seconds)
    end
    return avin
end
"""
    seekstart(s::VideoReader)

Seek to start of VideoReader object.
"""
seekstart(s::VideoReader, args...) = seek(s, 0, args...)

"""
    seekstart(avin::AVInput{T}, video_stream_index=1) where T <: AbstractString

Seek to start of AVInput object.
"""
seekstart(avin::AVInput{<:AbstractString}, args...) = seek(avin, 0, args...)

seekstart(avin::AVInput{<:IO}, args...) =
    throw(ErrorException("Sorry, Seeking is not supported from IO streams"))

"""
    skipframe(s::VideoReader; throwEOF=true)

Skip the next frame. If End of File is reached, EOFError thrown if throwEOF=true.
Otherwise returns true if EOF reached, false otherwise.
"""
function skipframe(s::VideoReader; throwEOF=true)
    gotframe = pump_until_frame(s, throwEOF)
    gotframe && drop_frame!(s)
    return !gotframe
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
    allfinished = mapreduce(is_finished, &, values(avin.stream_contexts),
                            init = true)
    allfinished && return true
    got_frame = pump(avin) != -1
    return !got_frame
end

eof(r::VideoReader) = eof(r.avin)

close(r::VideoReader) = close(r.avin)

# Free AVIOContext object when done
function close(avin::AVInput)
    !avin.isopen && return
    avin.isopen = false

    empty!(avin.stream_contexts)
    if check_ptr_valid(avin.format_context, false)
        # Replace the existing object in avin with a null pointer. The finalizer
        # for AVFormatContextPtr will close it and clean up its memory
        sigatomic_begin()
        avin.format_context = AVFormatContextPtr(Ptr{AVFormatContext}(C_NULL))
        sigatomic_end()
    end

    if check_ptr_valid(avin.avio_context, false)
        # Replace the existing object in avin with a null pointer. The finalizer
        # will close it and clean up its memory
        sigatomic_begin()
        avin.avio_context = AVIOContextPtr(Ptr{AVIOContext}(C_NULL))
        sigatomic_end()
    end
end

function position(r::VideoReader)
    # this field is not indended for public use, should we be using it?
    last_pts = r.codec_context.pts_correction_last_pts
    # At the beginning, or just seeked
    last_pts == AV_NOPTS_VALUE && return nothing
        # Try to figure out the time of the oldest frame in the queue
    stream = get_stream(r)
    time_base = convert(Rational, stream.time_base)
    time_base == 0 && return nothing
    nqueued = n_queued_frames(r)
    nqueued == 0 && return last_pts * time_base
    frame_rate = convert(Rational, av_stream_get_r_frame_rate(stream))
    last_returned_pts = last_pts - round(Int, nqueued / (frame_rate * time_base))
    return last_returned_pts * time_base
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
