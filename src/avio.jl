# AVIcodec_type
import Base: read, read!, show, close, eof, isopen, seek, seekstart

export read, read!, read_raw, read_raw!, pump, openvideo, opencamera, playvideo,
    viewcam, play, gettime, skipframe, skipframes, counttotalframes,
    raw_frame_size, out_frame_size, raw_pixel_format, out_bytes_size,
    out_frame_eltype

const ReaderBitTypes = Union{UInt8, UInt16}
const ReaderNormedTypes = Normed{T} where T<: ReaderBitTypes
const ReaderGrayTypes = Gray{T} where T<: ReaderNormedTypes
const ReaderRgbTypes = RGB{T} where T<:ReaderNormedTypes
const ReaderElTypes = Union{ReaderGrayTypes, ReaderRgbTypes, ReaderNormedTypes,
                            ReaderBitTypes}
const PermutedArray{T,N,perm,iperm,AA <: StridedArray} =
    Base.PermutedDimsArrays.PermutedDimsArray{T,N,perm,iperm,AA}
const VidArray{T,N} = Union{StridedArray{T,N},PermutedArray{T,N}}

const VidRawBuff = StridedArray{UInt8}

const VIO_ALIGN = 32

abstract type StreamContext end

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

const TRANSCODE = true
const NO_TRANSCODE = false

mutable struct VideoReader{transcode, T<:GraphType, I} <: StreamContext
    avin::AVInput{I}
    stream_index0::Int

    codec_context::AVCodecContextPtr

    frame_queue::Vector{Vector{UInt8}}
    frame_graph::T
    graph_input_occupied::Bool
    bits_per_result_pixel::Int

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

convert(::Type{Rational{T}}, r::AVRational) where T = Rational{T}(r.num, r.den)
convert(::Type{Rational}, r::AVRational) = Rational(r.num, r.den)
convert(::Type{AVRational}, r::Rational) = AVRational(numerator(r), denominator(r))

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
            frame_is_queued(r) && return Int(stream_index)
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
                frame_is_queued(r) && return stream_index
            end
        end
    end
    return -1
end

pump(r::StreamContext) = pump(r.avin)

function pump_until_frame(r, err = false)
    while !frame_is_queued(r)
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

function _read_packet(avin_ptr::Ptr, pbuf::Ptr{UInt8}, buf_size::Cint)
    avin = unsafe_pointer_to_objref(avin_ptr)
    out = unsafe_wrap(Array, pbuf, (buf_size,))
    convert(Cint, readbytes!(avin.io, out))
end

function AVIOContextPtr(avin::AVInput{<:IO})
    avin_ptr = pointer_from_objref(avin)
    AVIOContextPtr(avin.avio_ctx_buffer_size, avin_ptr, read_packet[])
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
    avio_context = AVIOContextPtr(avin)
    avin.avio_context = avio_context
    avin.format_context.pb = @preserve avio_context unsafe_convert(Ptr{AVIOContext}, avio_context)

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
    avio_context = AVIOContextPtr(C_NULL)

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

get_stream(avin::AVInput, stream_index0) = avin.format_context.streams[stream_index0 + 1]
get_stream(r::VideoReader) = get_stream(r.avin, r.stream_index0)

function VideoReader(avin::AVInput{I}, video_stream = 1;
                     transcode::Bool = true,
                     target_format::Union{Nothing, Cint} = nothing,
                     pix_fmt_loss_flags = 0,
                     target_colorspace_details = nothing,
                     allow_vio_gray_transform = true,
                     swscale_settings::SettingsT = (;),
                     sws_color_details::SettingsT = (;)) where I
    bad_px_type = transcode && target_format !== nothing &&
        !is_pixel_type_supported(target_format)
    bad_px_type && error("Unsupported pixel format $target_format")

    1 <= video_stream <= length(avin.video_indices) ||
        error("video stream $video_stream not found")

    stream_index0 = avin.video_indices[video_stream]

    # Find decoder
    stream = get_stream(avin, stream_index0)
    codec = avcodec_find_decoder(stream.codecpar.codec_id)
    check_ptr_valid(codec, false) || error("Failed to find decoder")

    # Tell the demuxer to retain packets from this stream
    stream.discard = AVDISCARD_DEFAULT

    # Create decoder context
    codec_context = AVCodecContextPtr(codec) # Allocates
    # Transfer parameters to decoder context
    ret = avcodec_parameters_to_context(codec_context, stream.codecpar)
    ret < 0 && error("Could not copy the codec parameters to the decoder")
    codec_context.pix_fmt < 0 && error("Unknown pixel format")

    # Open the decoder
    sigatomic_begin()
    lock(VIO_LOCK)
    ret = avcodec_open2(codec_context, codec, C_NULL)
    unlock(VIO_LOCK)
    sigatomic_end()
    ret < 0 && error("Could not open codec")

    if target_format === nothing # automatically determine format
        dst_pix_fmt, pix_fmt_loss = _vio_determine_best_pix_fmt(
            codec_context.pix_fmt; loss_flags = pix_fmt_loss_flags
        )
    else
        dst_pix_fmt = target_format
    end

    if target_colorspace_details === nothing
        colorspace_details = get(VIO_DEFAULT_TRANSFER_COLORSPACE_DETAILS,
                                 dst_pix_fmt,
                                 VIO_DEFAULT_COLORSPACE_DETAILS)
    else
        colorspace_details = target_colorspace_details
    end
    bit_depth, padded_bits_per_pixel = pix_fmt_to_bits_per_pixel(dst_pix_fmt)
    width = codec_context.width
    height = codec_context.height

    use_vio_gray_transform = transcode &&
        codec_context.pix_fmt == dst_pix_fmt && allow_vio_gray_transform &&
        dst_pix_fmt in VIO_GRAY_SCALE_TYPES &&
        colorspace_details.color_range != codec_context.color_range
    if use_vio_gray_transform
        frame_graph = GrayTransform()
        set_basic_frame_properties!(frame_graph.dstframe, width, height,
                                    dst_pix_fmt)
        frame_graph.src_depth = frame_graph.dst_depth = bits_per_pixel
        frame_graph.dstframe.color_range = colorspace_details.color_range
    elseif ! transcode || codec_context.pix_fmt == dst_pix_fmt
        frame_graph = AVFramePtr()
    else
        frame_graph = SwsTransform(width, height, codec_context.pix_fmt,
                                   codec_context.color_primaries,
                                   codec_context.color_range, dst_pix_fmt,
                                   colorspace_details.color_primaries,
                                   colorspace_details.color_range,
                                   sws_color_details, swscale_settings)
        set_basic_frame_properties!(frame_graph.dstframe, width, height,
                                    dst_pix_fmt)
    end

    vr = VideoReader{transcode, typeof(frame_graph), I}(avin, stream_index0,
                                                        codec_context,
                                                        Vector{UInt8}[],
                                                        frame_graph, false,
                                                        padded_bits_per_pixel,
                                                        false, false)

    push!(avin.listening, stream_index0)
    avin.stream_contexts[stream_index0] = vr

    vr
end

VideoReader(s::Union{IO, AbstractString}, args...; kwargs...) =
    VideoReader(AVInput(s), args...; kwargs... )

# a convenience function for getting the aspect ratio
function aspect_ratio(f::VideoReader)
    aspect_num = f.codec_context.sample_aspect_ratio.num
    aspect_den = f.codec_context.sample_aspect_ratio.den
    aspect_ratio = (aspect_den == 0) ? Cint(0) // Cint(1) :
        aspect_num // aspect_den
    # if the stored aspect ratio is nonsense then we default to one. OBS, this
    # might still be wrong for some videos and an unnecessary test for most
    if iszero(aspect_ratio) || isnan(aspect_ratio) || isinf(aspect_ratio)
        fixed_aspect = 1//1
    else
        fixed_aspect = aspect_ratio
    end
    fixed_aspect
end

framerate(f::VideoReader) =
    f.codec_context.time_base.den // f.codec_context.time_base.num


# Does not check input size, meant for internal use only
function stash_graph_input!(imgbuf, r::VideoReader, align = VIO_ALIGN)
    frame = graph_input_frame(r)
    av_image_copy_to_buffer(imgbuf, length(imgbuf), Ref(frame.data),
                            Ref(frame.linesize), r.codec_context.pix_fmt,
                            r.codec_context.width, r.codec_context.height,
                            align)
    return imgbuf
end

stash_graph_input(r, align = VIO_ALIGN) =
    stash_graph_input!(Vector{UInt8}(undef, out_bytes_size(r, align)), r, align)

function unpack_stashed_planes!(r::VideoReader, imgbuf)
    frame = graph_input_frame(r)
    av_make_writable(frame)
    av_image_fill_arrays(frame, frame.linesize, imgbuf, r.codec_context.pix_fmt,
                         r.codec_context.width, r.codec_context.height,
                         VIO_ALIGN)
    return r
end

check_send_packet_return(r) = (r < 0 && r != -Libc.EAGAIN) && error("Could not send packet")

function decode(r::VideoReader, packet)
    # Do we already have a complete frame that hasn't been consumed?
    r.finished && return
    if graph_blocked(r)
        push!(r.frame_queue, stash_graph_input(r))
        remove_graph_input!(r)
    end
    if !r.flush
        pret = avcodec_send_packet(r.codec_context, packet)
        check_send_packet_return(pret)
    end
    fret = avcodec_receive_frame(r.codec_context, graph_input_frame(r))
    if fret == 0
        r.graph_input_occupied = true
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

graph_input_frame(r::VideoReader) = graph_input_frame(r.frame_graph)
graph_output_frame(r::VideoReader) = graph_output_frame(r.frame_graph)

unsupported_retrieval_format(fmt) = error("Unsupported format $(fmt)")

function drop_frame!(r::VideoReader)
    if isempty(r.frame_queue)
        graph_blocked(r) && remove_graph_input!(r)
    else
        if r.graph_input_occupied
            push!(r.frame_queue, stash_graph_input(r))
            remove_graph_input!(r)
        end
        popfirst!(r.frame_queue)
    end
    r
end

function drop_frames!(r::VideoReader)
    empty!(r.frame_queue)
    remove_graph_input!(r)
end

n_queued_frames(r::VideoReader) = length(r.frame_queue) + r.graph_input_occupied

function fill_graph_input!(r::VideoReader)
    pump_until_frame(r)

    # Get the oldest frame stored by VideoReader

    # If we have an unprocessed frames in the queue
    if !isempty(r.frame_queue)
        # But also a decoded frame
        if graph_blocked(r)
            # Then move the decoded frame to the back of the queue
            push!(r.frame_queue, stash_graph_input(r))
        end
        unpack_stashed_planes!(r, popfirst!(r.frame_queue))
        r.graph_input_occupied = true
    end
end

execute_graph!(r::VideoReader) = exec!(r.frame_graph)

function transfer_graph_output!(buf, r::VideoReader)
    bytes_per_pixel, nrem = divrem(r.bits_per_result_pixel, 8)
    nrem > 0 && error("Unsupported pixel size")
    transfer_frame_to_img_buf!(buf, graph_output_frame(r), bytes_per_pixel)
end

# Converts a grabbed frame to the correct format (RGB by default)
function _retrieve!(r::VideoReader, buf)
    fill_graph_input!(r)
    execute_graph!(r)
    transfer_graph_output!(buf, r)
    remove_graph_input!(r)
    return buf
end

function retrieve!(r::VideoReader{TRANSCODE}, buf::VidArray{T}
                   ) where T <: ReaderElTypes
    if !out_img_check(r, buf)
        throw(ArgumentError("Buffer is the wrong size, element type, or stride"))
    end
    _retrieve!(r, buf)
end

function _retrieve_raw!(r, buf::VidRawBuff, align = VIO_ALIGN)
    fill_graph_input!(r)
    stash_graph_input!(buf, r, align)
    remove_graph_input!(r)
    return buf
end

function retrieve_raw!(r, buf::VidRawBuff, align = VIO_ALIGN)
    if !raw_buff_check(buf, r, align)
        throw(ArgumentError("Buffer is the wrong size or stride"))
    end
    _retrieve_raw!(r, buf, align)
end

# Converts a grabbed frame to the correct format (RGB by default)
# TODO: type stability?
function retrieve(r::VideoReader{TRANSCODE}) # true=transcode
    pix_fmt = out_frame_format(r)
    if !is_pixel_type_supported(pix_fmt)
        unsupported_retrieveal_format(pix_fmt)
    end
    elt = VIO_PIX_FMT_DEF_ELTYPE_LU[pix_fmt]
    width, height = out_frame_size(r)
    buf = PermutedDimsArray(Matrix{elt}(undef, width, height), (2, 1))

    _retrieve!(r, buf)
end

retrieve!(r::VideoReader{NO_TRANSCODE}, buf::VidRawBuff, args...) =
    retrieve_raw!(r, buf, args...)

function retrieve_raw(r::VideoReader, align = VIO_ALIGN)
    imgbuf = Vector{UInt8}(undef, out_bytes_size(r, align))
    retrieve_raw!(r, imgbuf, align)
    imgbuf, align
end

retrieve(r::VideoReader{NO_TRANSCODE}, align::Integer = 1) =
    retrieve_raw(r, align)[1]

# Utility functions

open(filename::AbstractString) = AVInput(filename) # not exported

"""
    openvideo(file[, video_stream = 1]; <keyword arguments>) -> reader
    openvideo(f, ...)

Open `file` and create an object to read and decode video stream number
`video_stream`. `file` can either be a `AVInput` created by `VideoIO.open`,
the name of a file as an `AbstractString`, or instead an `IO` object. However,
support for `IO` objects is incomplete, and does not currently work with common
video containers such as `*.mp4` files.

Frames can be read from the `reader` with `read` or `read!`, or alternatively by
using the iterator interface provided for `reader`. To close the `reader`,
simply use `close`. Seeking within the reader can be accomplished using `seek`,
`seekstart`. Frames can be skipped with `skipframe`, or `skipframes`. The
current time in the video stream can be accessed with `gettime`. Details about
the frame dimension can be found with `out_frame_size`. The total number of
frames can be found with `counttotalframes`.

If called with a single argument function as the first argument, the `reader`
will be passed to the function, and will be closed once the call returns whether
or not an error occurred.

The decoder settings and conversion to Julia arrays is controlled by the keyword
arguments listed below.

# Keyword arguments
- `transcode::Bool = true`: Determines whether decoded frames are transferred
    into a Julia matrix with easily interpretable element type, or instead
    returned as raw byte buffers.
- `target_format::Union{Nothing, Cint} = nothing`: Determines the target pixel
    format that decoded frames will be transformed into before being transferred
    to an output array. This can either by a `VideoIO.AV_PIX_FMT_*` value
    corresponding to a FFmpeg
    [`AVPixelFormat`]
    (https://ffmpeg.org/doxygen/4.1/pixfmt_8h.html#a9a8e335cf3be472042bc9f0cf80cd4c5),
    and must then also be a format supported by the VideoIO, or instead
    `nothing`, in which case the format will be automatically chosen by FFmpeg.
    This list of currently supported pixel formats, and the matrix element type
    that each pixel format corresponds with, are elements of
    `VideoIO.VIO_PIX_FMT_DEF_ELTYPE_LU`.
- `pix_fmt_loss_flags = 0`: Loss flags to control how transfer pixel format is
    chosen. Only valid if `target_format = nothing`. Flags must correspond to
    FFmpeg
    [loss flags]
    (http://ffmpeg.org/doxygen/2.5/pixdesc_8h.html#a445e6541dde2408332c216b8d0accb2d).
- `target_colorspace_details = nothing`: Information about the color space
    of output Julia arrays. If `nothing`, then this will correspond to a
    best-effort interpretation of `Colors.jl` for the corresponding element
    type. To override these defaults, create a `VideoIO.VioColorspaceDetails`
    object using the appropriate `AVCOL_` definitions from FFmpeg, or use
    `VideoIO.VioColorspaceDetails()` to use the FFmpeg defaults. To avoid
    rescaling limited color range data (mpeg) to full color range output (jpeg),
    then set this to `VideoIO.VioColorspaceDetails()` to avoid additional
    scaling by `sws_scale`.
- `allow_vio_gray_transform = true`: Instead of using `sws_scale` for gray data,
    use a more accurate color space transformation implemented in `VideoIO` if
    `allow_vio_gray_gransform = true`. Otherwise, use `sws_scale`.
- `swscale_settings::SettingsT = (;)`: A `Namedtuple`, or `Dict{Symbol, Any}` of
    settings for the swscale object used to perform color space scaling. Options
    must correspond with options for FFmpeg's
    [scaler](https://ffmpeg.org/ffmpeg-all.html#Scaler-Options) filter.
- `sws_color_details::SettingsT = (;)`: Additional keyword arguments passed to
    [sws_setColorspaceDetails]
    (http://ffmpeg.org/doxygen/2.5/group__libsws.html#ga541bdffa8149f5f9203664f955faa040).
"""
openvideo(s::Union{IO, AbstractString, AVInput}, args...; kwargs...) =
    VideoReader(s, args...; kwargs...)

function openvideo(f, args...; kwargs...)
    r = openvideo(args...; kwargs...)
    try
        f(r)
    finally
        close(r)
    end
end

"""
    read(reader::VideoReader) -> frame::PermutedDimsArray{Matrix{T}}

Allocate a matrix `frame` and fill it with the next video frame from `reader`,
advancing the video stream. For details about the frame matrix, see `read!`.
"""
read(r::VideoReader, args...) = retrieve(r, args...)

"""
    read_raw(reader::VideoReader[, align = VideoIO.VIO_ALIGN]) ->
        (buff::Vector{UInt8}, align::Int)

Allocate a `Vector{UInt8}` and return the bytes and scanline memory alignment of
the next untransformed frame of `reader`, advancing the video stream.
"""
read_raw(r::VideoReader, args...) = retrieve_raw(r, args...)

"""
    read!(reader::VideoReader, buf::Union{PermutedArray{T,N}, Array{T,N}}) where T<:ReaderElTypes

Read a frame from `reader` into array `buf`, which can either be a regular array
or a permuted view of a regular array, and advance the video stream. `buf` must
be scanline-major, meaning that adjacent pixels on the same horizontal line of
the video frame are also adjacent in memory. The element type of `buf` must be
one of the supported element types, any key of
`VideoIO.VIO_DEF_ELTYPE_PIX_FMT_LU`, and must match the pixel format chosen when
`reader` was created. For any supported `Gray` element type, VideoIO will also
support the corresponding `Normed` or `Unsigned` element types as well. The size
of `buf` must correspond to the size of `out_frame_size`. If `buf` is a regular
array, then frame width must correspond to the number of rows of `buf`, and
conversely if `buf` is a `PermutedDimsArray` view, frame width must correspond
to the number of columns in the view.
"""
read!(r::VideoReader, buf::AbstractArray{T}) where {T <: ReaderElTypes} =
    retrieve!(r, buf)

"""
    read_raw!(reader, buf[, align = VideoIO.VIO_ALIGN])

Read the next frame in the video stream described by `reader`, and transfer the
untransformed bytes into `buf`, which has scanline memory alignment `align`.
`buf` must be `out_bytes_size` long.
"""
read_raw!(r::VideoReader, buf, args...) = retrieve_raw!(r, buf, args...)

isopen(avin::AVInput{I}) where {I <: IO} = isopen(avin.io)
isopen(avin::AVInput) = avin.isopen
isopen(r::VideoReader) = isopen(r.avin)

"""
    raw_frame_size(reader) -> (width, height)

Return the dimensions of the raw frames returned by `reader`.
"""
raw_frame_size(r::VideoReader) = (r.codec_context.width, r.codec_context.height)

"""
    out_frame_size(reader) -> (width, height)

Return frame dimensions, `(width, height)` of frames returned by `read(reader)`.
`read` will return frames as `PermutedDimsArray` views of Julia matrices with
the frame height spanning the rows of the matrix, and frame width spanning the
columns. The underlying array has the opposite orientation.
"""
function out_frame_size end

out_frame_size(r::VideoReader{<:Any, AVFramePtr}) = raw_frame_size(r)
out_frame_size(t::SwsTransform) = (t.dstframe.width, t.dstframe.height)
out_frame_size(r::VideoReader{TRANSCODE, SwsTransform}) =
    out_frame_size(r.frame_graph)

"""
    raw_pixel_format(reader) -> Cint

Return the pixel format for frames of `reader`. The return value will be a
`Cint` corresponding to `VideoIO.AV_PIX_FMT_*`, which corresponds to a
[`AVPixelFormat`]
(https://ffmpeg.org/doxygen/4.1/pixfmt_8h.html#a9a8e335cf3be472042bc9f0cf80cd4c5).
This will determine the format of byte arrays returned by `read_raw`, and
`read_raw!`.
"""
raw_pixel_format(r::VideoReader) = r.codec_context.pix_fmt

out_frame_format(r::VideoReader{<:Any, AVFramePtr}) = raw_pixel_format(r)
out_frame_format(t::SwsTransform) = t.dstframe.format
out_frame_format(t::GrayTransform) = t.dstframe.format
out_frame_format(r::VideoReader{TRANSCODE, SwsTransform}) = out_frame_format(r.frame_graph)
out_frame_format(r::VideoReader{TRANSCODE, GrayTransform}) = out_frame_format(r.frame_graph)

"""
    out_frame_eltype(reader) -> T

Return the Julia eltype `T` of matrices returned by `read(reader)`.
"""
out_frame_eltype(r::VideoReader) = VIO_PIX_FMT_DEF_ELTYPE_LU[out_frame_format(r)]

out_img_size_check(r, buf) = all(size(buf) .>= out_frame_size(r))
out_img_size_check(r, buf::PermutedDimsArray) = out_img_size_check(r, parent(buf))

out_img_eltype_check(::Type{T}, p) where T <: UInt8 = p == AV_PIX_FMT_GRAY8
out_img_eltype_check(::Type{T}, p) where T <: UInt16 = p == AV_PIX_FMT_GRAY10LE
out_img_eltype_check(::Type{X}, p) where {T, X <: Normed{T}} =
    out_img_eltype_check(T, p)
out_img_eltype_check(::Type{X}, p) where {T, X <: Gray{T}} =
    out_img_eltype_check(T, p)
out_img_eltype_check(::Type{T}, p) where T<:RGB{N0f8} = p == AV_PIX_FMT_RGB24
out_img_eltype_check(::Type{T}, p) where T<:RGB{N6f10} = p == AV_PIX_FMT_GBRP10LE

out_img_eltype_check(fmt::Integer, ::AbstractArray{T}) where T =
    out_img_eltype_check(T, fmt)
out_img_eltype_check(r, buf) = out_img_eltype_check(out_frame_format(r), buf)

stride_check(buf) = stride(buf, 1) == 1
stride_check(buf::PermutedDimsArray) = stride_check(parent(buf))

out_img_check(r, buf) = out_img_size_check(r, buf) &
    out_img_eltype_check(r, buf) & stride_check(buf)

"""
    out_bytes_size(reader[, align = VideoIO.VIO_ALIGN])

Return the number required to store the raw frame data for frames of `reader`
with memory alignment for each scanline `align`. Input bye buffers to
`read_raw!` must be this length.
"""
function out_bytes_size end

function out_bytes_size(fmt, width, height, align = VIO_ALIGN)
    align > 0 || throw(ArgumentError("align must be greater than zero"))
    sz = av_image_get_buffer_size(fmt, width, height, align)
    sz < 0 && error("Could not determine the buffer size")
    sz
end
out_bytes_size(r, args...) =
    out_bytes_size(raw_pixel_format(r), out_frame_size(r)..., args...)

out_bytes_size_check(buf, r, args...) = sizeof(buf) == out_bytes_size(r, args...)

raw_buff_check(buf, r, args...) = out_bytes_size_check(buf, r, args...) &
    stride_check(buf)

graph_blocked(r) = r.graph_input_occupied # TODO: make sure the last frame was made available
frame_is_queued(r::StreamContext) = !isempty(r.frame_queue) || graph_blocked(r)
frame_is_queued(avin::AVInput) = mapreduce(frame_is_queued, |, values(avin.stream_contexts), init = false)

function remove_graph_input!(r::VideoReader)
    av_frame_unref(graph_input_frame(r))
    r.graph_input_occupied = false
end

seconds_to_timestamp(s, time_base::Rational) = round(Int, s / time_base)
seconds_to_timestamp(s, time_base::AVRational) = seconds_to_timestamp(s, convert(Rational, time_base))

get_video_stream_index(s::VideoReader) =
    findfirst(x -> x == s.stream_index0, s.avin.video_indices)

"""
    gettime(s::VideoReader)

Return timestamp of the last returned frame, if available. Else, return `0.0`.
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
    seek(reader::VideoReader, seconds)

Seeks into the parent `AVInput` using this video stream's index. See [`seek`]
for `AVInput`.
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

    frame = graph_input_frame(r)
    while gotframe && frame.pts != AV_NOPTS_VALUE &&
          frame.pts + frame_period_timebase <= target_pts
        drop_frame!(r)
        gotframe = pump_until_frame(r, false)
    end
end

"""
    seek(avin::AVInput, seconds::AbstractFloat, video_stream::Integer=1)

Seek through the container format `avin` so that the next frame returned by
the stream indicated by `video_stream` will have a timestamp greater than or
equal to `seconds`.
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
    seekstart(reader::VideoReader)

Seek to time zero of the parent `AVInput` using `reader`'s stream index. See
`seekstart` for `AVInput` objects.
"""
seekstart(s::VideoReader, args...) = seek(s, 0, args...)

"""
    seekstart(avin::AVInput{T}, video_stream_index=1) where T <: AbstractString

Seek to time zero of AVInput object.
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
    skipframes(s::VideoReader, n::Int; throwEOF=true) -> n

Skip the next `n` frames. If End of File is reached and `throwEOF=true`,
a `EOFError` will be thrown. Returns the number of frames that were skipped.
"""
function skipframes(s::VideoReader, n::Int; throwEOF=true)
    for i in 1:n
        skipframe(s, throwEOF=throwEOF) && return i - 1
    end
    return n
end

"""
    counttotalframes(reader) -> n::Int

Count the total number of frames in the video by seeking to start, skipping
through each frame, and seeking back to the start.

For a faster alternative, try `get_number_frames`.
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
    frame_is_queued(avin) && return false
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
    avin.isopen || return
    avin.isopen = false

    empty!(avin.stream_contexts)
    empty!(avin.listening)
    if check_ptr_valid(avin.format_context, false)
        # Replace the existing object in avin with a null pointer. The finalizer
        # for AVFormatContextPtr will close it and clean up its memory
        sigatomic_begin()
        avformat_close_input(avin.format_context) # This is also done in the finalizer,
        # but closing the input here means users won't have to wait for the GC to run
        # before trying to remove the file
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
    nothing
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
