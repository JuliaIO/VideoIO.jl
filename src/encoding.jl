export open_video_out, append_encode_mux!, close_video_out!, get_codec_name

mutable struct VideoWriter{T<:GraphType}
    format_context::AVFormatContextPtr
    codec_context::AVCodecContextPtr
    frame_graph::T
    packet::AVPacketPtr
    stream_index0::Int
    scanline_major::Bool
end

graph_input_frame(r::VideoWriter) = graph_input_frame(r.frame_graph)

graph_output_frame(r::VideoWriter) = graph_output_frame(r.frame_graph)

isopen(w::VideoWriter) = check_ptr_valid(w.format_context, false)

function encode_mux!(writer::VideoWriter, flush = false)
    pkt = writer.packet
    av_init_packet(pkt)
    frame = graph_output_frame(writer)
    if flush
        fret = avcodec_send_frame(writer.codec_context, C_NULL)
    else
        fret = avcodec_send_frame(writer.codec_context, frame)
    end
    if fret < 0 && !in(fret, [-Libc.EAGAIN, VIO_AVERROR_EOF])
        error("Error $fret sending a frame for encoding")
    end

    pret = Cint(0)
    while pret >= 0
        pret = avcodec_receive_packet(writer.codec_context, pkt)
        if pret == -Libc.EAGAIN || pret == VIO_AVERROR_EOF
             break
        elseif pret < 0
            error("Error $pret during encoding")
        end
        if pkt.duration == 0
            codec_pts_duration = round(Int, 1 / (
                convert(Rational, writer.codec_context.framerate) *
                convert(Rational, writer.codec_context.time_base)))
            pkt.duration = codec_pts_duration
        end
        stream = writer.format_context.streams[writer.stream_index0 + 1]
        av_packet_rescale_ts(pkt, writer.codec_context.time_base, stream.time_base)
        pkt.stream_index = writer.stream_index0
        ret = av_interleaved_write_frame(writer.format_context, pkt)
        # No packet_unref, av_interleaved_write_frame now owns packet.
        ret != 0 && error("Error muxing packet")
    end
    if !flush && fret == -Libc.EAGAIN && pret != VIO_AVERROR_EOF
        fret = avcodec_send_frame(writer.codec_context, frame)
        if fret < 0 && fret != VIO_AVERROR_EOF
            error("Error $fret sending a frame for encoding")
        end
    end
    return pret
end

function prepare_video_frame!(writer, img, index)
    dstframe = graph_output_frame(writer)
    ret = av_frame_make_writable(dstframe)
    ret < 0 && error("av_frame_make_writable() error")
    dstframe.pts = index
    transfer_img_buf_to_frame!(graph_input_frame(writer), img,
                               writer.scanline_major)
    execute_graph!(writer)
end

execute_graph!(writer::VideoWriter) = exec!(writer.frame_graph)

function _append_encode_mux!(writer, img, index)
    prepare_video_frame!(writer, img, index)
    encode_mux!(writer)
end

"""
    append_encode_mux!(writer, img, index)

Prepare frame `img` for encoding, encode it, mux it, and either cache it or
write it to the file described by `writer`. Indices must start at zero, i.e. for
the first frame set `index = 0`, and subsequent calls increment `index` by one.
`img` must be the same size and element type as the size and element type that
was used to create `writer`.
"""
function append_encode_mux!(writer, img, index)
    isopen(writer) || error("VideoWriter is closed for writing")
    _append_encode_mux!(writer, img, index)
end

"""
    close_video_out!(writer)

Write all frames cached in `writer` to the video container that it describes,
and then close the file. Once all frames in a video have been added to `writer`,
then it must be closed with this function to flush any cached frames to the file,
and then finally close the file and release resources associated with `writer`.
"""
function close_video_out!(writer::VideoWriter)
    if check_ptr_valid(writer.format_context, false)
        encode_mux!(writer, true) # flush
        format_context = writer.format_context
        ret = av_write_trailer(format_context)
        ret < 0 && error("Could not write trailer")
        if format_context.oformat.flags & AVFMT_NOFILE == 0
            pb_ptr = field_ptr(format_context, :pb)
            ret = @preserve writer avio_closep(pb_ptr)
            ret < 0 && error("Could not free AVIOContext")
        end
    end
    # Free allocated memory through finalizers
    writer.format_context = AVFormatContextPtr(C_NULL)
    writer.codec_context = AVCodecContextPtr(C_NULL)
    writer.frame_graph = null_graph(writer.frame_graph)
    writer.packet = AVPacketPtr(C_NULL)
    writer.stream_index0 = -1
    writer
end

function get_array_from_avarray(ptr::Union{Ptr{T}, Ref{T}, NestedCStruct{T}},
                                term; make_copy = true) where T
    check_ptr_valid(ptr, false) || return Vector{T}()
    i = 1
    el = ptr[i]
    while el != term
        i += 1
        el = ptr[i]
    end
    len = i - 1
    if make_copy
        dst = Vector{T}(undef, len)
        unsafe_copyto!(dst, ptr, len)
    else
        dst = unsafe_wrap(Array, ptr, len)
    end
    dst
end

function determine_best_encoding_format(target_pix_fmt, transfer_pix_fmt,
                                        codec, loss_flags = 0)
    if target_pix_fmt === nothing
        @preserve codec begin
            encoding_pix_fmt, losses = _vio_determine_best_pix_fmt(
                transfer_pix_fmt, codec.pix_fmts; loss_flags = loss_flags
            )
        end
    else
        @preserve codec begin
            codec_pix_fmts = get_array_from_avarray(codec.pix_fmts,
                                                    AV_PIX_FMT_NONE;
                                                    make_copy = false)
            codec_name = unsafe_string(codec.name)
            target_pix_fmt in codec_pix_fmts || throw(ArgumentError(
                "Pixel format $target_pix_fmt not compatible with codec $codec_name"
            ))
        end
        encoding_pix_fmt = target_pix_fmt
    end
    encoding_pix_fmt
end

function create_encoding_frame_graph(transfer_pix_fmt, encoding_pix_fmt, width,
                                     height, transfer_colorspace_details,
                                     dst_color_primaries, dst_color_trc,
                                     dst_colorspace, dst_color_range,
                                     use_vio_gray_transform, swscale_settings;
                                     sws_color_details::SettingsT = (;))
    if use_vio_gray_transform
        frame_graph = GrayTransform()
        set_basic_frame_properties!(frame_graph.srcframe, width, height,
                                    transfer_pix_fmt)
        bit_depth, padded_bits_per_pixel =
            pix_fmt_to_bits_per_pixel(encoding_pix_fmt)
        frame_graph.src_depth = frame_graph.dst_depth = bit_depth
        frame_graph.srcframe.color_range =
            transfer_colorspace_details.color_range
    elseif transfer_pix_fmt == encoding_pix_fmt
        frame_graph = AVFramePtr()
    else
        frame_graph = SwsTransform(width, height, transfer_pix_fmt,
                                   transfer_colorspace_details.color_primaries,
                                   transfer_colorspace_details.color_range,
                                   encoding_pix_fmt, dst_color_primaries,
                                   dst_color_range, sws_color_details,
                                   swscale_settings)
        set_basic_frame_properties!(frame_graph.srcframe, width, height,
                                    transfer_pix_fmt)
    end
    dstframe = graph_output_frame(frame_graph)
    dstframe.color_range = dst_color_range
    dstframe.colorspace = dst_colorspace
    dstframe.color_trc = dst_color_trc
    dstframe.color_primaries = dst_color_primaries
    set_basic_frame_properties!(dstframe, width, height, encoding_pix_fmt)
    frame_graph
end

function maybe_configure_codec_context_colorspace_details!(codec_context,
                                                     colorspace_details)
    if codec_context.colorspace == AVCOL_SPC_UNSPECIFIED
        codec_context.colorspace = colorspace_details.colorspace
    end
    if codec_context.color_primaries == AVCOL_PRI_UNSPECIFIED
        codec_context.color_primaries = colorspace_details.color_primaries
    end
    if codec_context.color_trc == AVCOL_TRC_UNSPECIFIED
        codec_context.color_trc = colorspace_details.color_trc
    end
    if codec_context.color_range == AVCOL_RANGE_UNSPECIFIED
        codec_context.color_range = colorspace_details.color_range
    end
    nothing
end

"""
    get_codec_name(writer) -> String

Get the name of the encoder used by `writer`.
"""
function get_codec_name(w::VideoWriter)
    if check_ptr_valid(w.codec_context, false) &&
        check_ptr_valid(w.codec_context.codec, false)
        return unsafe_string(w.codec_context.codec.name)
    else
        return "None"
    end
end

function VideoWriter(filename::AbstractString, ::Type{T},
                     sz::NTuple{2, Integer};
                     codec_name::Union{AbstractString, Nothing} = nothing,
                     framerate::Real = 24,
                     scanline_major::Bool = false,
                     container_settings::SettingsT = (;),
                     container_private_settings::SettingsT = (;),
                     encoder_settings::SettingsT = (;),
                     encoder_private_settings::SettingsT = (;),
                     swscale_settings::SettingsT = (;),
                     target_pix_fmt::Union{Nothing, Cint} = nothing,
                     pix_fmt_loss_flags = 0,
                     input_colorspace_details = nothing,
                     allow_vio_gray_transform = true,
                     sws_color_details::SettingsT = (;)) where T
    framerate > 0 || error("Framerate must be strictly positive")

    if haskey(encoder_settings, :priv_data)
        throw(ArgumentError("""The field `priv_data` is no longer supported. Either reorganize as a flat NamedTuple or Dict,
        i.e. encoder_settings=(color_range=2, crf=\"0\", preset=\"medium\") to rely on auto routing of public and private
        settings, or pass the private settings to `encoder_private_settings` explicitly"""))
    end
    if !is_eltype_transfer_supported(T)
        throw(ArgumentError("Encoding arrays with eltype $T not yet supported"))
    end
    if scanline_major
        width, height = sz
    else
        height, width = sz
    end
    if isodd(width) || isodd(height)
        throw(ArgumentError("Encoding error: Frame dims must be a multiple of two"))
    end
    transfer_pix_fmt = get_transfer_pix_fmt(T)

    if input_colorspace_details === nothing
        transfer_colorspace_details = get(VIO_DEFAULT_TRANSFER_COLORSPACE_DETAILS,
                                          transfer_pix_fmt,
                                          VIO_DEFAULT_COLORSPACE_DETAILS)
    else
        transfer_colorspace_details = input_colorspace_details
    end

    format_context = output_AVFormatContextPtr(filename)
    default_codec = codec_name === nothing
    if default_codec
        codec_enum = format_context.oformat.video_codec
        codec_enum == AV_CODEC_ID_NONE && error("No default codec found")
        codec_p = avcodec_find_encoder(codec_enum)
        check_ptr_valid(codec_p, false) || error("Default codec not found")
    else
        codec_p = avcodec_find_encoder_by_name(codec_name)
        check_ptr_valid(codec_p, false) || error("Codec '$codec_name' not found")
    end
    codec = AVCodecPtr(codec_p)
    if ! check_ptr_valid(codec.pix_fmts, false)
        error("Codec has no supported pixel formats")
    end
    encoding_pix_fmt = determine_best_encoding_format(target_pix_fmt,
                                                      transfer_pix_fmt, codec,
                                                      pix_fmt_loss_flags)
    if ! default_codec
        ret = avformat_query_codec(format_context.oformat, codec.id,
                                   AVCodecs.FF_COMPLIANCE_NORMAL)
        ret == 1 || error("Format not compatible with codec $codec_name")
    end
    codec_context = AVCodecContextPtr(codec)
    codec_context.width = width
    codec_context.height = height
    framerate_rat = Rational(framerate)
    target_timebase = 1/framerate_rat
    codec_context.time_base = target_timebase
    codec_context.framerate = framerate_rat
    codec_context.pix_fmt = encoding_pix_fmt

    if format_context.oformat.flags & AVFMT_GLOBALHEADER != 0
        codec_context.flags |= AV_CODEC_FLAG_GLOBAL_HEADER
    end

    set_class_options(format_context, container_settings)
    if check_ptr_valid(format_context.oformat.priv_class, false)
        set_class_options(format_context.priv_data, container_private_settings)
    elseif !isempty(container_private_settings)
        @warn "This container format does not support private settings, and will be ignored"
    end
    set_class_options(codec_context, encoder_settings)
    set_class_options(codec_context.priv_data, encoder_private_settings)

    sigatomic_begin()
    lock(VIO_LOCK)
    ret = avcodec_open2(codec_context, codec, C_NULL)
    unlock(VIO_LOCK)
    sigatomic_end()
    ret < 0 && error("Could not open codec: Return code $(ret)")

    stream_p = avformat_new_stream(format_context, C_NULL)
    check_ptr_valid(stream_p, false) || error("Could not allocate output stream")
    stream = AVStreamPtr(stream_p)
    stream_index0 = stream.index
    stream.time_base = codec_context.time_base
    stream.avg_frame_rate = 1 / convert(Rational, stream.time_base)
    stream.r_frame_rate = stream.avg_frame_rate
    ret = avcodec_parameters_from_context(stream.codecpar, codec_context)
    ret < 0 && error("Could not set parameters of stream")

    if format_context.oformat.flags & AVFMT_NOFILE == 0
        pb_ptr = field_ptr(format_context, :pb)
        ret = @preserve format_context avio_open(pb_ptr, filename, AVIO_FLAG_WRITE)
        ret < 0 && error("Could not open file $filename for writing")
    end
    avformat_write_header(format_context, C_NULL)
    ret < 0 && error("Could not write header")

    use_vio_gray_transform = transfer_pix_fmt == encoding_pix_fmt &&
        allow_vio_gray_transform && transfer_pix_fmt in VIO_GRAY_SCALE_TYPES &&
        transfer_colorspace_details.color_range != codec_context.color_range
    if ! use_vio_gray_transform && transfer_pix_fmt == encoding_pix_fmt
        maybe_configure_codec_context_colorspace_details!(
            codec_context, transfer_colorspace_details
        )
    end
    frame_graph = create_encoding_frame_graph(transfer_pix_fmt,
                                              encoding_pix_fmt, width, height,
                                              transfer_colorspace_details,
                                              codec_context.color_primaries,
                                              codec_context.color_trc,
                                              codec_context.colorspace,
                                              codec_context.color_range,
                                              use_vio_gray_transform,
                                              swscale_settings;
                                              sws_color_details =
                                              sws_color_details)
    packet = AVPacketPtr()

    VideoWriter(format_context, codec_context, frame_graph, packet,
                Int(stream_index0), scanline_major)
end

VideoWriter(filename, img::AbstractMatrix{T}; kwargs...) where T =
    VideoWriter(filename, img_params(img)...; kwargs...)

"""
    open_video_out(filename, ::Type{T}, sz::NTuple{2, Integer};
                   <keyword arguments>) -> writer
    open_video_out(filename, first_img::Matrix; ...)
    open_video_out(f, ...; ...)

Open file `filename` and prepare to encode a video stream into it, returning
object `writer` that can be used to encode frames. The size and element type of
the video can either be specified by passing the first frame of the movie
`first_img`, which will not be encoded, or instead the element type `T` and
2-tuple size `sz`. If the size is explicitly specified, the first element will
be the height, and the second width, unless keyword argument `scanline_major =
true`, in which case the order is reversed. Both height and width must be even.
The element type `T` must be one of the supported element types, which is any
key of `VideoIO.VIO_DEF_ELTYPE_PIX_FMT_LU`, or instead the `Normed` or
`Unsigned` type for a corresponding `Gray` element type. The container type will
be inferred from `filename`.

Frames are encoded with[ `append_encode_mux!`](@ref), which must use frames with
the same size, element type, and obey the same value of `scanline_major`. The
video must be closed once all frames are encoded with
[`close_video_out!`](@ref).

If called with a function as the first argument, `f`, then the function will be
called with the writer object `writer` as its only argument. This `writer` object
will be closed once the call is complete, regardless of whether or not an error
occurred.

# Keyword arguments
- `codec_name::Union{AbstractString, Nothing} = nothing`: Name of the codec to
    use. Must be a name accepted by [FFmpeg](https://ffmpeg.org/), and
    compatible with the chosen container type, or `nothing`, in which case the
    codec will be automatically selected by FFmpeg based on the container.
- `framerate::Real = 24`: Framerate of the resulting video.
- `scanline_major::Bool = false`: If `false`, then Julia arrays are assumed to
    have frame height in the first dimension, and frame width on the second. If
    `true`, then pixels that adjacent to eachother in the same scanline (i.e.
    horizontal line of the video) are assumed to be adjacent to eachother in
    memory. `scanline_major = true` videos must be `StridedArray`s with unit
    stride in the first dimension. For normal arrays, this corresponds to a
    matrix where frame width is in the first dimension, and frame height is in
    the second.
- `container_settings::SettingsT = (;)`: A `NamedTuple` or `Dict{Symbol, Any}`
    of settings for the container. Must correspond to option names and values
    accepted by [FFmpeg](https://ffmpeg.org/).
- `container_private_settings::SettingsT = (;)`: A `NamedTuple` or
    `Dict{Symbol, Any}` of private settings for the container. Must correspond
    to private options names and values accepted by
    [FFmpeg](https://ffmpeg.org/) for the chosen container type.
- `encoder_settings::SettingsT = (;)`: A `NamedTuple` or `Dict{Symbol, Any}` of
    settings for the encoder context. Must correspond to option names and values
    accepted by [FFmpeg](https://ffmpeg.org/).
- `encoder_private_settings::SettingsT = (;)`: A `NamedTuple` or
    `Dict{Symbol, Any}` of private settings for the encoder context. Must
    correspond to private option names and values accepted by
    [FFmpeg](https://ffmpeg.org/) for the chosen codec specified by `codec_name`.
- `swscale_settings::SettingsT = (;)`: A `Namedtuple`, or `Dict{Symbol, Any}` of
    settings for the swscale object used to perform color space scaling. Options
    must correspond with options for FFmpeg's
    [scaler](https://ffmpeg.org/ffmpeg-all.html#Scaler-Options) filter.
- `target_pix_fmt::Union{Nothing, Cint} = nothing`: The pixel format that will
    be used to input data into the encoder. This can either by a
    `VideoIO.AV_PIX_FMT_*` value corresponding to a FFmpeg
    [`AVPixelFormat`]
    (https://ffmpeg.org/doxygen/4.1/pixfmt_8h.html#a9a8e335cf3be472042bc9f0cf80cd4c5),
    and must then be a format supported by the encoder, or instead `nothing`,
    in which case it will be chosen automatically by FFmpeg.
- `pix_fmt_loss_flags = 0`: Loss flags to control how encoding pixel format is
    chosen. Only valid if `target_pix_fmt = nothing`. Flags must correspond to
    FFmpeg
    [loss flags]
    (http://ffmpeg.org/doxygen/2.5/pixdesc_8h.html#a445e6541dde2408332c216b8d0accb2d).
- `input_colorspace_details = nothing`: Information about the color space
    of input Julia arrays. If `nothing`, then this will correspond to a
    best-effort interpretation of `Colors.jl` for the corresponding element type.
    To override these defaults, create a `VideoIO.VioColorspaceDetails` object
    using the appropriate `AVCOL_` definitions from FFmpeg, or use
    `VideoIO.VioColorspaceDetails()` to use the FFmpeg defaults. If data in the
    input Julia arrays is already in the mpeg color range, then set this to
    `VideoIO.VioColorspaceDetails()` to avoid additional scaling by `sws_scale`.
- `allow_vio_gray_transform = true`: Instead of using `sws_scale` for gray data,
    use a more accurate color space transformation implemented in `VideoIO` if
    `allow_vio_gray_transform = true`. Otherwise, use `sws_scale`.
- `sws_color_details::SettingsT = (;)`: Additional keyword arguments passed to
    [sws_setColorspaceDetails]
    (http://ffmpeg.org/doxygen/2.5/group__libsws.html#ga541bdffa8149f5f9203664f955faa040).

See also: [`append_encode_mux!`](@ref), [`close_video_out!`](@ref)
"""
open_video_out(s::AbstractString, args...; kwargs...) = VideoWriter(s, args...;
                                                                    kwargs...)

function open_video_out(f, s::AbstractString, args...; kwargs...)
    writer = open_video_out(s, args...; kwargs...)
    try
        f(writer)
    finally
        close_video_out!(writer)
    end
end

img_params(img::AbstractMatrix{T}) where T = (T, size(img))

"""
    save(filename::String, imgstack; ...)

Create a video container `filename` and encode the set of frames `imgstack` into
it. `imgstack` must be an iterable of matrices and each frame must have the same
dimensions and element type.

Encoding settings, restrictions on frame size and element type, and other
details are described in [`open_video_out`](@ref). All keyword arguments are
passed to `open_video_out`.

See also: [`open_video_out`](@ref), [`append_encode_mux!`](@ref),
[`close_video_out!`](@ref)
"""
function save(filename::String, imgstack; kwargs...)
    open_video_out(filename, first(imgstack); kwargs...) do writer
        for (i, img) in enumerate(imgstack)
            _append_encode_mux!(writer, img, i - 1)
        end
    end
    nothing
end
