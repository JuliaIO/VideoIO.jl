export encodevideo, encode!, prepareencoder, appendencode!, startencode!,
    finishencode!, mux, open_video_out, encode_mux!, append_encode_mux!,
    close_video_out!, encode_mux_video


# A struct collecting encoder objects for easy passing
mutable struct VideoEncoder{T<:GraphType}
    codec_name::String
    codec_context::AVCodecContextPtr
    stream_index0::Int
    frame_graph::T
    packet::AVPacketPtr
    scanline_major::Bool
end

mutable struct VideoWriter{T<:GraphType}
    format_context::AVFormatContextPtr
    codec_context::AVCodecContextPtr
    frame_graph::T
    packet::AVPacketPtr
    stream_index0::Int
    scanline_major::Bool
end

graph_input_frame(r::VideoEncoder) = graph_input_frame(r.frame_graph)
graph_input_frame(r::VideoWriter) = graph_input_frame(r.frame_graph)

graph_output_frame(r::VideoEncoder) = graph_output_frame(r.frame_graph)
graph_output_frame(r::VideoWriter) = graph_output_frame(r.frame_graph)

"""
    encode(encoder::VideoEncoder, io::IO)

Encode frame in memory
"""
function encode!(encoder::VideoEncoder, io::IO; flush=false)
    av_init_packet(encoder.packet)
    frame = graph_output_frame(encoder)
    if flush
        fret = avcodec_send_frame(encoder.codec_context, C_NULL)
    else
        fret = avcodec_send_frame(encoder.codec_context, frame)
    end
    if fret < 0 && !in(fret, [-Libc.EAGAIN, VIO_AVERROR_EOF])
        error("Error $fret sending a frame for encoding")
    end

    pret = Cint(0)
    while pret >= 0
        pret = avcodec_receive_packet(encoder.codec_context, encoder.packet)
        if pret == -Libc.EAGAIN || pret == VIO_AVERROR_EOF
             break
        elseif pret < 0
            error("Error $pret during encoding")
        end
        @debug println("Write packet $(encoder.packet.pts) (size=$(encoder.packet.size))")
        data = unsafe_wrap(Array, encoder.packet.data, encoder.packet.size)
        write(io, data)
        av_packet_unref(encoder.packet)
    end
    if !flush && fret == -Libc.EAGAIN && pret != VIO_AVERROR_EOF
        fret = avcodec_send_frame(encoder.codec_context, frame)
        if fret < 0 && fret != VIO_AVERROR_EOF
            error("Error $fret sending a frame for encoding")
        end
    end
    return pret
end

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

const AVCodecContextPropertiesDefault = [:priv_data => ("crf"=>"22","preset"=>"medium")]

@inline prop_present_and_equal(nt::NamedTuple, prop, val) =
    hasproperty(nt, prop) && getproperty(nt, prop) == val

function islossless(prop)
    for p in prop
        if p[1] == :priv_data
            for subp in p[2]
                if (subp[1] == "crf") && (subp[2] == "0")
                    return true
                end
            end
        end
    end
    return false
end

islossless(props::NamedTuple) = prop_present_and_equal(props, :crf, 0)

isfullcolorrange(props) = (findfirst(map(x->x == Pair(:color_range,2),props)) != nothing)

isfullcolorrange(props::NamedTuple) = prop_present_and_equal(props,
                                                             :color_range, 2)

lossless_colorrange_ok(props) = ! islossless(props) || isfullcolorrange(props)

function lossless_colorrange_check_warn(AVCodecContextProperties, codec_name,
                                        elt, nbit)
    if !lossless_colorrange_ok(AVCodecContextProperties)
        @warn """
Encoding output not lossless.
Lossless $(codec_name) encoding of $(elt) requires
:color_range=>2 within AVCodecContextProperties, to represent
full $(nbit)-bit pixel value range.
"""
    end
end

_pix_type_not_supported(::Type{T}, codec_name) where T = error(
    """
VideoIO: Encoding image element type $T with codec $codec_name not currently
supported
"""
)

function _determine_pix_fmt(::Type{T}, ::Type{S}, codec_name,
                            props) where {T<:UInt8, S}
    if codec_name in ["libx264", "h264_nvenc"]
        lossless_colorrange_check_warn(props, codec_name,
                                       T, 8)
    elseif codec_name != "libx264rgb"
        _pix_type_not_supported(S, codec_name)
    end
    get_transfer_pix_fmt(S)
end

function _determine_pix_fmt(::Type{T}, ::Type{S}, codec_name,
                            props) where {T<:UInt16, S}
    if codec_name == "libx264"
        lossless_colorrange_check_warn(props, codec_name,
                                       T, 10)
    else
        _pix_type_not_supported(S, codec_name)
    end
    get_transfer_pix_fmt(S)
end

function _determine_pix_fmt(::Type{T}, ::Type{S}, codec_name, props
                            ) where {T<:RGB{N0f8}, S}
    if codec_name == "libx264rgb"
        if !islossless(props)
            @warn """Codec libx264rgb has limited playback support. Given that
                selected encoding settings are not lossless (crf!=0), codec_name="libx264"
                will give better playback results"""
        end
    elseif codec_name in ["libx264", "h264_nvenc"]
        if islossless(props)
            @warn """Encoding output not lossless.
                libx264 does not support lossless RGB planes. RGB will be downsampled
                to lossy YUV420P. To encode lossless RGB use codec_name="libx264rgb" """
        end
    else
        _pix_type_not_supported(S, codec_name)
    end
    get_transfer_pix_fmt(S)
end

function _determine_pix_fmt(::Type{T}, ::Type{S}, codec_name, props
                            ) where {T<:RGB{N6f10}, S}
    if  codec_name in ["libx264", "h264_nvenc"]
        if islossless(props)
            @warn """Encoding output not lossless.
                libx264 does not support lossless RGB planes. RGB will be downsampled
                to lossy YUV420P. To encode lossless RGB use codec_name="libx264rgb" """
        end
    else
        _pix_type_not_supported(S, codec_name)
    end
    get_transfer_pix_fmt(S)
end

function _determine_pix_fmt(::Type{X}, ::Type{S}, codec_name, props
                            ) where {T, X<:Normed{T}, S}
    _determine_pix_fmt(T, S, codec_name, props)
end

function _determine_pix_fmt(::Type{X}, ::Type{S}, codec_name, props
                            ) where {T, X<:Gray{T}, S}
    _determine_pix_fmt(T, S, codec_name, props)
end

_determine_pix_fmt(::Type{T}, ::Type{S}, codec_name, ::Any) where {T, S} =
    _pix_type_not_supported(T, codec_name)

_determine_pix_fmt(::Type{T}, codec_name, props) where T =
    _determine_pix_fmt(T, T, codec_name, props)

"""
    VideoEncoder(firstimg; framerate=30,
                 AVCodecContextProperties = AVCodecContextPropertiesDefault,
                 codec_name::String="libx264")

Prepare encoder and return a `VideoEncoder` object. The dimensions and pixel
format of the video will be determined from `firstimg`. The number of rows of
`firstimg` determines the height of the frame, while the number of columns
determines the width.
"""
function VideoEncoder(firstimg; framerate=30,
                      AVCodecContextProperties = AVCodecContextPropertiesDefault,
                      codec_name::String = "libx264",
                      scanline_major::Bool = false,
                      target_pix_fmt::Union{Nothing, Cint} = nothing,
                      pix_fmt_loss_mask = 0,
                      scale_interpolation = SWS_BILINEAR,
                      allow_vio_gray_transform = true,
                      input_colorspace_details = nothing,
                      swscale_settings::SettingsT = (;),
                      sws_kwargs...)
    if scanline_major
        width, height = size(firstimg)
    else
        height, width = size(firstimg)
    end

    if isodd(width) || isodd(height)
        throw(ArgumentError("Encoding error: Image dims must be a multiple of two"))
    end

    elt = eltype(firstimg)
    transfer_pix_fmt = _determine_pix_fmt(elt, codec_name, AVCodecContextProperties)
    if input_colorspace_details === nothing
        transfer_colorspace_details = get(VIO_DEFAULT_TRANSFER_COLORSPACE_DETAILS,
                                          transfer_pix_fmt,
                                          VIO_DEFAULT_COLORSPACE_DETAILS)
    else
        transfer_colorspace_details = input_colorspace_details
    end
    framerate_rat = Rational(framerate)

    codec_p = avcodec_find_encoder_by_name(codec_name)
    check_ptr_valid(codec_p, false) || error("Codec '$codec_name' not found")
    codec = AVCodecPtr(codec_p)

    encoding_pix_fmt = determine_best_encoding_format(target_pix_fmt,
                                                      transfer_pix_fmt, codec,
                                                      pix_fmt_loss_mask)

    codec_context = AVCodecContextPtr(codec)
    codec_context.width = width
    codec_context.height = height
    codec_context.time_base = AVRational(1/framerate_rat)
    codec_context.framerate = AVRational(framerate_rat)
    codec_context.pix_fmt = encoding_pix_fmt

    priv_data_ptr = codec_context.priv_data
    for prop in AVCodecContextProperties
        if prop[1] == :priv_data
            for pd in prop[2]
                av_opt_set(priv_data_ptr, string(pd[1]), string(pd[2]),
                           AV_OPT_SEARCH_CHILDREN)
            end
        else
            setproperty!(codec_context, prop[1], prop[2])
        end
    end

    sigatomic_begin()
    lock(VIO_LOCK)
    ret = avcodec_open2(codec_context, codec, C_NULL)
    unlock(VIO_LOCK)
    sigatomic_end()
    ret < 0 && error("Could not open codec: Return code $(ret)")

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
                                              scale_interpolation,
                                              transfer_colorspace_details,
                                              codec_context.color_primaries,
                                              codec_context.color_trc,
                                              codec_context.colorspace,
                                              codec_context.color_range,
                                              use_vio_gray_transform,
                                              swscale_settings;
                                              sws_kwargs...)

    packet = AVPacketPtr()
    return VideoEncoder(codec_name, codec_context, -1, frame_graph,
                        packet, scanline_major)
end

"""
    prepareencoder(...)

See `VideoEncoder`.
"""
prepareencoder(args...; kwargs...) = VideoEncoder(args...; kwargs...)

function prepare_video_frame!(writer, img, index)
    dstframe = graph_output_frame(writer)
    ret = av_frame_make_writable(dstframe)
    ret < 0 && error("av_frame_make_writable() error")
    dstframe.pts = index
    transfer_img_buf_to_frame!(graph_input_frame(writer), img,
                               writer.scanline_major)
    execute_graph!(writer)
end

"""
    appendencode!(encoder::VideoEncoder, io::IO, img, index::Integer)

Send image object to ffmpeg encoder and encode. The rows of `img` must span the
vertical axis of the image, and the columns must span the horizontal axis.
"""
function appendencode!(encoder::VideoEncoder, io::IO, img, index::Integer)
    prepare_video_frame!(encoder, img, index)
    encode!(encoder, io)
end

execute_graph!(writer::VideoWriter) = exec!(writer.frame_graph)
execute_graph!(encoder::VideoEncoder) = exec!(encoder.frame_graph)

# Indices should start from zero
function append_encode_mux!(writer, img, index)
    prepare_video_frame!(writer, img, index)
    encode_mux!(writer)
end

"""
    finishencode!(encoder::VideoEncoder, io::IO)

End encoding by sending endencode package to ffmpeg, and close objects.
"""
function finishencode!(encoder::VideoEncoder, io::IO)
    encode!(encoder, io, flush=true) # flush the encoder
    write(io, UInt8[0, 0, 1, 0xb7]) # add sequence end code to have a real MPEG file
end

startencode!(io::IO) = write(io, 0x000001b3)

ffmpeg_framerate_string(fr::Real) = string(fr)
ffmpeg_framerate_string(fr::String) = fr
ffmpeg_framerate_string(fr::Rational) = "$(numerator(fr))/$(denominator(fr))"
ffmpeg_framerate_string(fr) = error("""
Framerate type not valid. Mux framerate should be a subtype of Real
(Integer, Float64, Rational etc.), or String
""")

"""
    mux(srcfilename,destfilename,framerate;silent=false,deletestream=true)

Multiplex stream file into video container. Deletes stream file by default.
"""
function mux(srcfilename, destfilename, framerate; silent=false, deletestream=true)
    fr_str = ffmpeg_framerate_string(framerate)
    muxout = FFMPEG.exe(`-y -framerate $fr_str -i $srcfilename -c copy $destfilename`, collect=true)
    filter!(x->!occursin.("Timestamps are unset in a packet for stream 0.",x),muxout) #known non-bug issue with h264
    if occursin("ffmpeg version ",muxout[1]) && occursin("video:",muxout[end])
        deletestream && rm("$srcfilename")
        !silent && (@info "Video file saved: $(pwd())/$destfilename")
        !silent && (@info muxout[end-1])
        !silent && (@info muxout[end])
    else
        @warn "Stream Muxing may have failed: $(pwd())/$srcfilename into $(pwd())/$destfilename"
        println.(muxout)
    end
end

function set_class_options(ptr; kwargs...)
    for (key, val) in kwargs
        set_class_option(ptr, key, val)
    end
end

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
                                        codec, loss_mask = 0)
    if target_pix_fmt === nothing
        @preserve codec begin
            encoding_pix_fmt, losses = _vio_determine_best_pix_fmt(
                transfer_pix_fmt, codec.pix_fmts; loss_mask = loss_mask
            )
        end
    else
        @preserve codec begin
            codec_pix_fmts = get_array_from_avarray(codec.pix_fmts,
                                                    AV_PIX_FMT_NONE;
                                                    make_copy = false)
            target_pix_fmt in codec_pix_fmts || throw(ArgumentError(
                "Pixel format $target_pix_fmt not compatible with codec $codec_name"
            ))
        end
        encoding_pix_fmt = target_pix_fmt
    end
    encoding_pix_fmt
end

function create_encoding_frame_graph(transfer_pix_fmt, encoding_pix_fmt, width,
                                     height, interp, transfer_colorspace_details,
                                     dst_color_primaries, dst_color_trc,
                                     dst_colorspace, dst_color_range,
                                     use_vio_gray_transform, swscale_settings;
                                     sws_kwargs...)
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
                                   encoding_pix_fmt, interp)
        inv_table = _vio_primaries_to_sws_table(
            transfer_colorspace_details.color_primaries
        )
        table = _vio_primaries_to_sws_table(dst_color_primaries)

        sws_update_color_details(frame_graph.sws_context; inv_table = inv_table,
                                 src_range =
                                 transfer_colorspace_details.color_range,
                                 table = table, dst_range = dst_color_range,
                                 sws_kwargs...)
        set_class_options(frame_graph.sws_context; swscale_settings...)
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

function VideoWriter(filename::AbstractString, ::Type{T},
                     sz::NTuple{2, Integer};
                     codec_name::Union{AbstractString, Nothing} = "libx264",
                     framerate::Real = 24,
                     scanline_major::Bool = false,
                     container_settings::SettingsT = (;),
                     container_private_settings::SettingsT = (;),
                     encoder_settings::SettingsT = (;),
                     encoder_private_settings::SettingsT = (;),
                     swscale_settings::SettingsT = (;),
                     target_pix_fmt::Union{Nothing, Cint} = nothing,
                     scale_interpolation = SWS_BILINEAR,
                     pix_fmt_loss_mask = 0,
                     input_colorspace_details = nothing,
                     allow_vio_gray_transform = true,
                     sws_kwargs...) where T
    framerate > 0 || error("Framerate must be strictly positive")
    if ! is_eltype_transfer_supported(T)
        throw(ArgumentError("Encoding arrays with eltype $T not yet supported"))
    end
    if scanline_major
        width, height = sz
    else
        height, width = sz
    end
    if isodd(width) || isodd(height)
        throw(ArgumentError("Encoding error: Image dims must be a multiple of two"))
    end
    transfer_pix_fmt = get_transfer_pix_fmt(T)

    if input_colorspace_details === nothing
        transfer_colorspace_details = get(VIO_DEFAULT_TRANSFER_COLORSPACE_DETAILS,
                                          transfer_pix_fmt,
                                          VIO_DEFAULT_COLORSPACE_DETAILS)
    else
        transfer_colorspace_details = input_colorspace_details
    end

    codec_p = avcodec_find_encoder_by_name(codec_name)
    check_ptr_valid(codec_p, false) || error("Codec '$codec_name' not found")
    codec = AVCodecPtr(codec_p)

    if ! check_ptr_valid(codec.pix_fmts, false)
        error("Codec has no supported pixel formats")
    end
    encoding_pix_fmt = determine_best_encoding_format(target_pix_fmt,
                                                      transfer_pix_fmt, codec,
                                                      pix_fmt_loss_mask)
    format_context = output_AVFormatContextPtr(filename)
    ret = avformat_query_codec(format_context.oformat, codec.id,
                               AVCodecs.FF_COMPLIANCE_NORMAL)
    ret == 1 || error("Format not compatible with codec $codec_name")

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

    set_class_options(format_context; container_settings...)
    if check_ptr_valid(format_context.oformat.priv_class, false)
        set_class_options(format_context.priv_data; container_private_settings...)
    elseif !isempty(container_private_settings)
        @warn "This container format does not support private settings, and will be ignored"
    end
    set_class_options(codec_context; encoder_settings...)
    set_class_options(codec_context.priv_data; encoder_private_settings...)

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
                                              scale_interpolation,
                                              transfer_colorspace_details,
                                              codec_context.color_primaries,
                                              codec_context.color_trc,
                                              codec_context.colorspace,
                                              codec_context.color_range,
                                              use_vio_gray_transform,
                                              swscale_settings;
                                              sws_kwargs...)
    packet = AVPacketPtr()

    VideoWriter(format_context, codec_context, frame_graph, packet,
                Int(stream_index0), scanline_major)
end

VideoWriter(filename, img::AbstractMatrix{T}; kwargs...) where T =
    VideoWriter(filename, img_params(img)...; kwargs...)

open_video_out(args...; kwargs...) = VideoWriter(args...; kwargs...)

img_params(img::AbstractMatrix{T}) where T = (T, size(img))

"""
    encodevideo(filename::String,imgstack::Array;
        AVCodecContextProperties = AVCodecContextPropertiesDefault,
        codec_name = "libx264",
        framerate = 24)

Encode image stack to video file and return filepath. The rows of each image in
`imgstack` must span the vertical axis of the image, and the columns must span
the horizontal axis.
"""
function encodevideo(filename::String,imgstack::Array;
                     AVCodecContextProperties = AVCodecContextPropertiesDefault,
                     codec_name = "libx264", framerate = 24, silent=false,
                     scanline_major = false, kwargs...)

    io = Base.open("temp.stream","w")
    startencode!(io)
    encoder = prepareencoder(imgstack[1]; codec_name = codec_name,
                             framerate = framerate,
                             AVCodecContextProperties = AVCodecContextProperties,
                             scanline_major = scanline_major, kwargs...)
    if !silent
        p = Progress(length(imgstack), 1)   # minimum update interval: 1 second
    end
    for (i, img) in enumerate(imgstack)
        appendencode!(encoder, io, img, i - 1)
        !silent && next!(p)
    end
    finishencode!(encoder, io)
    close(io)
    mux("temp.stream",filename,framerate,silent=silent)
    return filename
end

"""
    encode_mux_video(filename::String,imgstack::Array;
        AVCodecContextProperties = AVCodecContextPropertiesDefault,
        codec_name = "libx264",
        framerate = 24)

Encode image stack to video file and return filepath. The rows of each image in
`imgstack` must span the vertical axis of the image, and the columns must span
the horizontal axis.
"""
function encode_mux_video(filename::String, imgstack; kwargs...)
    writer = open_video_out(filename, first(imgstack); kwargs...)
    for (i, img) in enumerate(imgstack)
        append_encode_mux!(writer, img, i - 1)
    end
    close_video_out!(writer)
    nothing
end
