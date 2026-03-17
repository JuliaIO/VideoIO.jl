export open_video_out, close_video_out!, get_codec_name

const _active_writers = IdDict{Any,Nothing}()
const _active_writers_lock = ReentrantLock()
const _shutdown_requested = Ref(false)

function _register_active_writer!(writer)
    lock(_active_writers_lock) do
        _shutdown_requested[] && error("VideoIO is shutting down; opening new writers is disabled")
        _active_writers[writer] = nothing
    end
    return writer
end

function _unregister_active_writer!(writer)
    lock(_active_writers_lock) do
        delete!(_active_writers, writer)
    end
    return nothing
end

"""
    shutdown!(; timeout_s = 2.0, poll_interval_s = 0.01) -> Bool

Request VideoIO shutdown and wait for active writers to close.
Returns `true` if all active writers drained before timeout, otherwise `false`.
"""
function shutdown!(; timeout_s::Real = 2.0, poll_interval_s::Real = 0.01)
    lock(_active_writers_lock) do
        _shutdown_requested[] = true
    end
    deadline = time() + timeout_s
    while true
        nactive = lock(_active_writers_lock) do
            length(_active_writers)
        end
        nactive == 0 && return true
        time() >= deadline && return false
        sleep(poll_interval_s)
    end
end

# Coerce unsupported element types to supported ones for encoding
_coerce_encoding_img(img::AbstractMatrix{<:RGBA}) = RGB.(img)
_coerce_encoding_img(img::AbstractMatrix) = img

# Find a hardware encoder for the given codec ID and device type.
# Returns C_NULL if no matching encoder is found.
function _vio_find_hw_encoder(codec_id, device_type)
    opaque = Ref{Ptr{Cvoid}}(C_NULL)
    while true
        codec_ptr = av_codec_iterate(opaque)
        codec_ptr == C_NULL && break
        av_codec_is_encoder(codec_ptr) == 0 && continue
        codec = AVCodecPtr(codec_ptr)
        codec.id != codec_id && continue
        i = Cint(0)
        while true
            cfg_ptr = avcodec_get_hw_config(codec_ptr, i)
            cfg_ptr == C_NULL && break
            cfg = unsafe_load(cfg_ptr)
            cfg.device_type == device_type && return codec_ptr
            i += Cint(1)
        end
    end
    return Ptr{AVCodec}(C_NULL)
end

mutable struct VideoWriter{T<:GraphType}
    format_context::AVFormatContextPtr
    codec_context::AVCodecContextPtr
    frame_graph::T
    packet::AVPacketPtr
    stream_index0::Int
    scanline_major::Bool
    next_index::Int
end

graph_input_frame(r::VideoWriter) = graph_input_frame(r.frame_graph)

graph_output_frame(r::VideoWriter) = graph_output_frame(r.frame_graph)

isopen(w::VideoWriter) = check_ptr_valid(w.format_context, false)

function encode_mux!(writer::VideoWriter, flush = false)
    pkt = writer.packet
    frame = graph_output_frame(writer)
    format_context = writer.format_context
    codec_context = writer.codec_context
    @preserve pkt frame writer format_context codec_context begin
        av_init_packet(pkt)
        if flush
            fret = avcodec_send_frame(codec_context, C_NULL)
        else
            fret = avcodec_send_frame(codec_context, frame)
        end
        if fret < 0 && !in(fret, [-Libc.EAGAIN, VIO_AVERROR_EOF])
            error("Error sending a frame for encoding: $(av_error_string(fret))")
        end

        pret = Cint(0)
        while pret >= 0
            pret = avcodec_receive_packet(codec_context, pkt)
            if pret == -Libc.EAGAIN || pret == VIO_AVERROR_EOF
                break
            elseif pret < 0
                error("Error during encoding: $(av_error_string(pret))")
            end
            if pkt.duration == 0
                codec_pts_duration = round(
                    Int,
                    1 / (
                        convert(Rational, codec_context.framerate) *
                        convert(Rational, codec_context.time_base)
                    ),
                )
                pkt.duration = codec_pts_duration
            end
            stream = format_context.streams[writer.stream_index0+1]
            av_packet_rescale_ts(pkt, codec_context.time_base, stream.time_base)
            pkt.stream_index = writer.stream_index0
            ret = av_interleaved_write_frame(format_context, pkt)
            # No packet_unref, av_interleaved_write_frame now owns packet.
            ret != 0 && error("Error muxing packet: $(av_error_string(ret))")
        end
        if !flush && fret == -Libc.EAGAIN && pret != VIO_AVERROR_EOF
            fret = avcodec_send_frame(codec_context, frame)
            if fret < 0 && fret != VIO_AVERROR_EOF
                error("Error sending a frame for encoding: $(av_error_string(fret))")
            end
        end
        return pret
    end
end

function prepare_video_frame!(writer::VideoWriter, img, index)
    frame_graph = writer.frame_graph
    dstframe = graph_output_frame(writer)
    srcframe = graph_input_frame(writer)
    @preserve dstframe srcframe frame_graph writer begin
        ret = av_frame_make_writable(dstframe)
        ret < 0 && error("av_frame_make_writable() error")
        dstframe.pts = index
        transfer_img_buf_to_frame!(srcframe, img, writer.scanline_major)
        return execute_graph!(writer)
    end
end

execute_graph!(writer::VideoWriter) = exec!(writer.frame_graph)

"""
    write(writer::VideoWriter, img)
    write(writer::VideoWriter, img, index)

Prepare frame `img` for encoding, encode it, mux it, and either cache it or
write it to the file described by `writer`. `img` must be the same size and
element type as the size and element type that was used to create `writer`.
If `index` is provided, it must start at zero and increment monotonically.
"""
function write(writer::VideoWriter, img, index::Int)
    isopen(writer) || error("VideoWriter is closed for writing")
    prepare_video_frame!(writer, _coerce_encoding_img(img), index)
    encode_mux!(writer)
    return writer.next_index = index + 1
end
write(writer::VideoWriter, img) = write(writer::VideoWriter, img, writer.next_index)

"""
    close_video_out!(writer::VideoWriter)

Write all frames cached in `writer` to the video container that it describes,
and then close the file. Once all frames in a video have been added to `writer`,
then it must be closed with this function to flush any cached frames to the file,
and then finally close the file and release resources associated with `writer`.
"""
function close_video_out!(writer::VideoWriter)
    try
        if check_ptr_valid(writer.format_context, false)
            encode_mux!(writer, true) # flush
            format_context = writer.format_context
            ret = @preserve format_context writer av_write_trailer(format_context)
            ret < 0 && error("Could not write trailer")
            if format_context.oformat.flags & AVFMT_NOFILE == 0
                pb_ptr = field_ptr(format_context, :pb)
                ret = @preserve writer avio_closep(pb_ptr)
                ret < 0 && error("Could not free AVIOContext")
            end
        end
    finally
        _unregister_active_writer!(writer)
        # Free allocated memory through finalizers
        writer.format_context = AVFormatContextPtr(C_NULL)
        writer.codec_context = AVCodecContextPtr(C_NULL)
        writer.frame_graph = null_graph(writer.frame_graph)
        writer.packet = AVPacketPtr(C_NULL)
        writer.stream_index0 = -1
    end
    return writer
end

function get_array_from_avarray(ptr::Union{Ptr{T},Ref{T},NestedCStruct{T}}, term; make_copy = true) where {T}
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
    return dst
end

function determine_best_encoding_format(target_pix_fmt, transfer_pix_fmt, codec, loss_flags = 0)
    if target_pix_fmt === nothing
        @preserve codec begin
            encoding_pix_fmt, losses =
                _vio_determine_best_pix_fmt(transfer_pix_fmt, codec.pix_fmts; loss_flags = loss_flags)
        end
    else
        @preserve codec begin
            codec_pix_fmts = get_array_from_avarray(codec.pix_fmts, AV_PIX_FMT_NONE; make_copy = false)
            codec_name = unsafe_string(codec.name)
            target_pix_fmt in codec_pix_fmts ||
                throw(ArgumentError("Pixel format $target_pix_fmt not compatible with codec $codec_name"))
        end
        encoding_pix_fmt = target_pix_fmt
    end
    return encoding_pix_fmt
end

# Return true when fmt is a packed-RGB/RGBA family format (AV_PIX_FMT_FLAG_RGB).
# Hardware encoders that accept SW input typically require YUV, not packed RGB.
function _vio_is_rgb_pix_fmt(fmt::Cint)
    desc_ptr = av_pix_fmt_desc_get(fmt)
    desc_ptr == C_NULL && return false
    desc = unsafe_load(desc_ptr)
    return (desc.flags & AV_PIX_FMT_FLAG_RGB) != 0
end

function create_encoding_frame_graph(
    transfer_pix_fmt,
    encoding_pix_fmt,
    width,
    height,
    transfer_colorspace_details,
    dst_color_primaries,
    dst_color_trc,
    dst_colorspace,
    dst_color_range,
    use_vio_gray_transform,
    swscale_options;
    sws_color_options::OptionsT = (;),
)
    if use_vio_gray_transform
        frame_graph = GrayTransform()
        set_basic_frame_properties!(frame_graph.srcframe, width, height, transfer_pix_fmt)
        bit_depth, padded_bits_per_pixel = pix_fmt_to_bits_per_pixel(encoding_pix_fmt)
        frame_graph.src_depth = frame_graph.dst_depth = bit_depth
        frame_graph.srcframe.color_range = transfer_colorspace_details.color_range
    elseif transfer_pix_fmt == encoding_pix_fmt
        frame_graph = AVFramePtr()
    else
        frame_graph = SwsTransform(
            width,
            height,
            transfer_pix_fmt,
            transfer_colorspace_details.color_primaries,
            transfer_colorspace_details.color_range,
            encoding_pix_fmt,
            dst_color_primaries,
            dst_color_range,
            sws_color_options,
            swscale_options,
        )
        set_basic_frame_properties!(frame_graph.srcframe, width, height, transfer_pix_fmt)
    end
    dstframe = graph_output_frame(frame_graph)
    dstframe.color_range = dst_color_range
    dstframe.colorspace = dst_colorspace
    dstframe.color_trc = dst_color_trc
    dstframe.color_primaries = dst_color_primaries
    set_basic_frame_properties!(dstframe, width, height, encoding_pix_fmt)
    return frame_graph
end

function maybe_configure_codec_context_colorspace_details!(codec_context, colorspace_details)
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
    return nothing
end

"""
    get_codec_name(writer) -> String

Get the name of the encoder used by `writer`.
"""
function get_codec_name(w::VideoWriter)
    if check_ptr_valid(w.codec_context, false) && check_ptr_valid(w.codec_context.codec, false)
        return unsafe_string(w.codec_context.codec.name)
    else
        return "None"
    end
end

function VideoWriter(
    filename::AbstractString,
    ::Type{T},
    sz::NTuple{2,Integer};
    codec_name::Union{AbstractString,Nothing} = nothing,
    framerate::Real = 24,
    scanline_major::Bool = false,
    container_options::OptionsT = (;),
    container_private_options::OptionsT = (;),
    encoder_options::OptionsT = (;),
    encoder_private_options::OptionsT = (;),
    swscale_options::OptionsT = (;),
    target_pix_fmt::Union{Nothing,Cint} = nothing,
    pix_fmt_loss_flags = 0,
    input_colorspace_details = nothing,
    allow_vio_gray_transform = true,
    sws_color_options::OptionsT = (;),
    thread_count::Union{Nothing,Int} = nothing,
    hwaccel::Union{Nothing,Symbol} = nothing,
) where {T}
    framerate > 0 || error("Framerate must be strictly positive")

    if haskey(encoder_options, :priv_data)
        throw(
            ArgumentError(
                """The field `priv_data` is no longer supported. Either reorganize as a flat NamedTuple or Dict,
e.g. `encoder_options=(color_range=2, crf=0, preset=\"medium\")` to rely on auto routing of generic and private
options, or pass the private options to `encoder_private_options` explicitly""",
            ),
        )
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
        transfer_colorspace_details =
            get(VIO_DEFAULT_TRANSFER_COLORSPACE_DETAILS, transfer_pix_fmt, VIO_DEFAULT_COLORSPACE_DETAILS)
    else
        transfer_colorspace_details = input_colorspace_details
    end

    format_context = output_AVFormatContextPtr(filename)
    device_type = hwaccel !== nothing ? _vio_parse_hwaccel(hwaccel) : nothing
    # default_codec: true only for the pure-SW path (no hwaccel, no explicit codec_name).
    # When hwaccel auto-selects an encoder we skip the avformat_query_codec check
    # because the HW encoder is chosen for the container's own default codec ID.
    default_codec = codec_name === nothing && hwaccel === nothing
    if hwaccel !== nothing && codec_name === nothing
        # Auto-select a hardware encoder matching the container's default codec ID
        sw_codec_enum = format_context.oformat.video_codec
        sw_codec_enum == AV_CODEC_ID_NONE && error("No default codec found")
        codec_p = _vio_find_hw_encoder(sw_codec_enum, device_type)
        check_ptr_valid(codec_p, false) || error(
            "No hardware encoder found for codec $(sw_codec_enum) on device ':$hwaccel'. " *
            "Available HW encoders: $(available_hw_encoders())",
        )
    elseif codec_name === nothing
        codec_enum = format_context.oformat.video_codec
        codec_enum == AV_CODEC_ID_NONE && error("No default codec found")
        codec_p = avcodec_find_encoder(codec_enum)
        check_ptr_valid(codec_p, false) || error("Default codec not found")
    else
        codec_p = avcodec_find_encoder_by_name(codec_name)
        check_ptr_valid(codec_p, false) || error("Codec '$codec_name' not found")
    end
    codec = AVCodecPtr(codec_p)
    if !check_ptr_valid(codec.pix_fmts, false)
        error("Codec has no supported pixel formats")
    end
    encoding_pix_fmt = determine_best_encoding_format(target_pix_fmt, transfer_pix_fmt, codec, pix_fmt_loss_flags)
    # Hardware encoders (videotoolbox, nvenc, vaapi …) accept SW-format input frames and
    # perform the RGB→YUV conversion internally, but they do NOT accept packed-RGB formats
    # (e.g. BGRA) even though those formats may appear in the codec's pix_fmts list.
    # avcodec_find_best_pix_fmt_of_list prefers BGRA over NV12 for RGB24 input because
    # BGRA has zero chroma subsampling loss.  When hwaccel is in use and the chosen format
    # is an RGB family format, re-select using NV12 as the source to obtain a YUV target.
    if hwaccel !== nothing && target_pix_fmt === nothing && _vio_is_rgb_pix_fmt(encoding_pix_fmt)
        yuv_fmt, _ = @preserve codec _vio_determine_best_pix_fmt(AV_PIX_FMT_NV12, codec.pix_fmts)
        yuv_fmt != AV_PIX_FMT_NONE && (encoding_pix_fmt = yuv_fmt)
    end
    if !default_codec
        ret = avformat_query_codec(format_context.oformat, codec.id, libffmpeg.FF_COMPLIANCE_NORMAL)
        ret == 1 || error("Format not compatible with codec $codec_name")
    end
    codec_context = AVCodecContextPtr(codec)
    codec_context.width = width
    codec_context.height = height
    framerate_rat = Rational(framerate)
    if !isfinite(framerate_rat) || framerate_rat <= 0
        throw(ArgumentError("Invalid framerate: $framerate. Framerate must be a positive finite number."))
    end
    target_timebase = 1 / framerate_rat
    codec_context.time_base = target_timebase
    codec_context.framerate = framerate_rat
    codec_context.pix_fmt = encoding_pix_fmt
    codec_context.thread_count = thread_count === nothing ? codec_context.thread_count : thread_count

    if format_context.oformat.flags & AVFMT_GLOBALHEADER != 0
        codec_context.flags |= AV_CODEC_FLAG_GLOBAL_HEADER
    end

    set_class_options(format_context, container_options)
    if check_ptr_valid(format_context.oformat.priv_class, false)
        set_class_options(format_context.priv_data, container_private_options)
    elseif !isempty(container_private_options)
        @warn "This container format does not support private options, and will be ignored"
    end
    set_class_options(codec_context, encoder_options)
    set_class_options(codec_context.priv_data, encoder_private_options)

    # Set up hardware acceleration context for encoding
    if hwaccel !== nothing
        # Query codec's hw_config for the requested device
        hw_method = UInt32(0)
        i = Cint(0)
        while true
            cfg_ptr = avcodec_get_hw_config(codec_p, i)
            cfg_ptr == C_NULL && break
            cfg = unsafe_load(cfg_ptr)
            if cfg.device_type == device_type
                hw_method = cfg.methods
                break
            end
            i += Cint(1)
        end

        # Only create hw_device_ctx when the codec advertises HW_DEVICE_CTX method
        # (e.g. NVENC, QSV).  VT encoders accept SW frames directly and don't
        # require an explicit device context.
        if (hw_method & AV_CODEC_HW_CONFIG_METHOD_HW_DEVICE_CTX) != 0
            hw_ctx_ref = Ref{Ptr{AVBufferRef}}(C_NULL)
            ret_hw = av_hwdevice_ctx_create(hw_ctx_ref, device_type, C_NULL, C_NULL, Cint(0))
            ret_hw < 0 && error("Failed to create '$hwaccel' HW device context for encoding — " *
                "hardware may not be present or driver not loaded. " *
                "Use `VideoIO.hwaccel_available(:$hwaccel)` to check before use.")
            codec_context.hw_device_ctx = av_buffer_ref(hw_ctx_ref[])
            av_buffer_unref(hw_ctx_ref)
        end
    end

    @debug "Opening codec" codec=unsafe_string(codec.name) codec_context.width codec_context.height codec_context.pix_fmt codec_context.colorspace codec_context.color_range

    ret = disable_sigint() do
        lock(VIO_LOCK) do
            avcodec_open2(codec_context, codec, C_NULL)
        end
    end
    if ret < 0
        codec_name_str = unsafe_string(codec.name)
        error("Could not open codec $codec_name_str: $(av_error_string(ret)) " *
              "(width=$(codec_context.width), height=$(codec_context.height), " *
              "pix_fmt=$(codec_context.pix_fmt), colorspace=$(codec_context.colorspace), " *
              "color_range=$(codec_context.color_range))")
    end

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
    ret = avformat_write_header(format_context, C_NULL)
    ret < 0 && error("Could not write header")

    use_vio_gray_transform =
        transfer_pix_fmt == encoding_pix_fmt &&
        allow_vio_gray_transform &&
        transfer_pix_fmt in VIO_GRAY_SCALE_TYPES &&
        transfer_colorspace_details.color_range != codec_context.color_range
    if !use_vio_gray_transform && transfer_pix_fmt == encoding_pix_fmt
        maybe_configure_codec_context_colorspace_details!(codec_context, transfer_colorspace_details)
    end
    frame_graph = create_encoding_frame_graph(
        transfer_pix_fmt,
        encoding_pix_fmt,
        width,
        height,
        transfer_colorspace_details,
        codec_context.color_primaries,
        codec_context.color_trc,
        codec_context.colorspace,
        codec_context.color_range,
        use_vio_gray_transform,
        swscale_options;
        sws_color_options = sws_color_options,
    )
    packet = AVPacketPtr()

    return VideoWriter(format_context, codec_context, frame_graph, packet, Int(stream_index0), scanline_major, 0)
end

VideoWriter(filename, img::AbstractMatrix; kwargs...) =
    VideoWriter(filename, img_params(_coerce_encoding_img(img))...; kwargs...)

# Allow bare Gray type to be used as shorthand for Gray{N0f8}
VideoWriter(filename::AbstractString, ::Type{Gray}, sz::NTuple{2,Integer}; kwargs...) =
    VideoWriter(filename, Gray{N0f8}, sz; kwargs...)

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
be the height, and the second width, unless keyword argument `scanline_major = true`, in which case the order is reversed. Both height and width must be even.
The element type `T` must be one of the supported element types, which is any
key of `VideoIO.VIO_DEF_ELTYPE_PIX_FMT_LU`, or instead the `Normed` or
`Unsigned` type for a corresponding `Gray` element type. The container type will
be inferred from `filename`.

Frames are encoded with [`write`](@ref), which must use frames with
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
  - `container_options::OptionsT = (;)`: A `NamedTuple` or `Dict{Symbol, Any}`
    of options for the container. Must correspond to option names and values
    accepted by [FFmpeg](https://ffmpeg.org/).
  - `container_private_options::OptionsT = (;)`: A `NamedTuple` or
    `Dict{Symbol, Any}` of private options for the container. Must correspond
    to private options names and values accepted by
    [FFmpeg](https://ffmpeg.org/) for the chosen container type.
  - `encoder_options::OptionsT = (;)`: A `NamedTuple` or `Dict{Symbol, Any}` of
    options for the encoder context. Must correspond to option names and values
    accepted by [FFmpeg](https://ffmpeg.org/).
  - `encoder_private_options::OptionsT = (;)`: A `NamedTuple` or
    `Dict{Symbol, Any}` of private options for the encoder context. Must
    correspond to private option names and values accepted by
    [FFmpeg](https://ffmpeg.org/) for the chosen codec specified by `codec_name`.
  - `swscale_options::OptionsT = (;)`: A `Namedtuple`, or `Dict{Symbol, Any}` of
    options for the swscale object used to perform color space scaling. Options
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
  - `sws_color_options::OptionsT = (;)`: Additional keyword arguments passed to
    [sws_setColorspaceDetails]
    (http://ffmpeg.org/doxygen/2.5/group__libsws.html#ga541bdffa8149f5f9203664f955faa040).
  - `thread_count::Union{Nothing, Int} = nothing`: The number of threads the codec is
    allowed to use, or `nothing` for default codec behavior. Defaults to `nothing`.
  - `hwaccel::Union{Nothing, Symbol} = nothing`: If set to a `Symbol` such as
    `:videotoolbox` (macOS), `:cuda` (NVIDIA), `:vaapi` (Linux/Intel), or `:qsv`,
    the corresponding FFmpeg hardware-accelerated encoder is automatically selected.
    When `codec_name` is also `nothing`, VideoIO picks the best hardware encoder for
    the container's default codec (e.g. `h264_videotoolbox` for `.mp4` on macOS).
    You can also combine `hwaccel` with an explicit `codec_name` to use a specific
    hardware encoder while still having the hardware device context created for you.
    Use `VideoIO.available_hw_encoders()` to list available hardware encoders.

See also: [`write`](@ref), [`close_video_out!`](@ref)
"""
function open_video_out(s::AbstractString, args...; kwargs...)
    writer = VideoWriter(s, args...; kwargs...)
    return _register_active_writer!(writer)
end

function open_video_out(f, s::AbstractString, args...; kwargs...)
    writer = open_video_out(s, args...; kwargs...)
    try
        f(writer)
    finally
        close_video_out!(writer)
    end
end

img_params(img::AbstractMatrix{T}) where {T} = (T, size(img))

"""
    save(filename::String, imgstack; ...)

Create a video container `filename` and encode the set of frames `imgstack` into
it. `imgstack` must be an iterable of matrices and each frame must have the same
dimensions and element type.

Encoding options, restrictions on frame size and element type, and other
details are described in [`open_video_out`](@ref). All keyword arguments are
passed to `open_video_out`.

See also: [`open_video_out`](@ref), [`write`](@ref),
[`close_video_out!`](@ref)
"""
function save(filename::String, imgstack; kwargs...)
    first_img = _coerce_encoding_img(first(imgstack))
    open_video_out(filename, first_img; kwargs...) do writer
        for img in imgstack
            write(writer, img)
        end
    end
    return nothing
end
