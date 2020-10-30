export encodevideo, encode!, prepareencoder, appendencode!, startencode!, finishencode!, mux

const SettingsT = Union{AbstractDict{Symbol, <:Any},
                        AbstractDict{Union{}, Union{}},
                        NamedTuple}

# A struct collecting encoder objects for easy passing
mutable struct VideoEncoder
    codec_name::String
    codec_context::AVCodecContextPtr
    format_context::AVFormatContextPtr
    stream_index0::Int
    frame::AVFramePtr
    packet::AVPacketPtr
    pix_fmt::Cint
    scanline_major::Bool
end

mutable struct VideoWriter
    format_context::AVFormatContextPtr
    codec_context::AVCodecContextPtr
    frame::AVFramePtr
    packet::AVPacketPtr
    stream_index0::Int
    scanline_major::Bool
end

"""
    encode(encoder::VideoEncoder, io::IO)

Encode frame in memory
"""
function encode!(encoder::VideoEncoder, io::IO; flush=false)
    av_init_packet(encoder.packet)
    if flush
        fret = avcodec_send_frame(encoder.codec_context, C_NULL)
    else
        fret = avcodec_send_frame(encoder.codec_context, encoder.frame)
    end
    if fret < 0 && !in(fret, [-Libc.EAGAIN, VIO_AVERROR_EOF])
        error("Error $fret sending a frame for encoding")
    end

    pret = Cint(0)
    while pret >= 0
        pret = avcodec_receive_packet(encoder.codec_context, encoder.packet)
        @show encoder.packet.pts, encoder.packet.dts, encoder.packet.duration
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
        fret = avcodec_send_frame(encoder.codec_context, encoder.frame)
        if fret < 0 && fret != VIO_AVERROR_EOF
            error("Error $fret sending a frame for encoding")
        end
    end
    return pret
end

function encode_mux!(writer::VideoWriter, flush = false)
    pkt = writer.packet
    if flush
        fret = avcodec_send_frame(writer.codec_context, C_NULL)
    else
        fret = avcodec_send_frame(writer.codec_context, writer.frame)
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
        if writer.packet.duration == 0
            codec_pts_duration = round(Int, 1 / (
                convert(Rational, writer.codec_context.framerate) *
                convert(Rational, writer.codec_context.time_base)))
            writer.packet.duration = codec_pts_duration
        end
        stream = writer.format_context.streams[writer.stream_index0 + 1]
        av_packet_rescale_ts(pkt, writer.codec_context.time_base, stream.time_base)
        pkt.stream_index = writer.stream_index0
        ret = av_interleaved_write_frame(writer.format_context, pkt)
        # No packet_unref, av_interleaved_write_frame now owns packet.
        ret != 0 && error("Error muxing packet")
    end
    if !flush && fret == -Libc.EAGAIN && pret != VIO_AVERROR_EOF
        fret = avcodec_send_frame(writer.codec_context, writer.frame)
        if fret < 0 && fret != VIO_AVERROR_EOF
            error("Error $fret sending a frame for encoding")
        end
    end
    return pret
end

const AVCodecContextPropertiesDefault =[:priv_data => ("crf"=>"22","preset"=>"medium")]

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

isfullcolorrange(props) = (findfirst(map(x->x == Pair(:color_range,2),props)) != nothing)

lossless_colorrange_ok(AVCodecContextProperties) =
    ! islossless(AVCodecContextProperties) ||
    isfullcolorrange(AVCodecContextProperties)

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
        pix_fmt = AV_PIX_FMT_GRAY8
    elseif codec_name == "libx264rgb"
        pix_fmt = AV_PIX_FMT_RGB24
    else
        _pix_type_not_supported(S, codec_name)
    end
    pix_fmt
end

function _determine_pix_fmt(::Type{T}, ::Type{S}, codec_name,
                            props) where {T<:UInt16, S}
    if codec_name == "libx264"
        lossless_colorrange_check_warn(props, codec_name,
                                       T, 10)
        pix_fmt = AV_PIX_FMT_GRAY10LE
    else
        _pix_type_not_supported(S, codec_name)
    end
    pix_fmt
end

function _determine_pix_fmt(::Type{T}, ::Type{S}, codec_name, props
                            ) where {T<:RGB{N0f8}, S}
    if codec_name == "libx264rgb"
        if !islossless(props)
            @warn """Codec libx264rgb has limited playback support. Given that
                selected encoding settings are not lossless (crf!=0), codec_name="libx264"
                will give better playback results"""
        end
        pix_fmt = AV_PIX_FMT_RGB24
    elseif codec_name in ["libx264", "h264_nvenc"]
        if islossless(props)
            @warn """Encoding output not lossless.
                libx264 does not support lossless RGB planes. RGB will be downsampled
                to lossy YUV420P. To encode lossless RGB use codec_name="libx264rgb" """
        end
        pix_fmt = AV_PIX_FMT_YUV420P
    else
        _pix_type_not_supported(S, codec_name)
    end
    pix_fmt
end

function _determine_pix_fmt(::Type{T}, ::Type{S}, codec_name, props
                            ) where {T<:RGB{N6f10}, S}
    if  codec_name in ["libx264", "h264_nvenc"]
        if islossless(props)
            @warn """Encoding output not lossless.
                libx264 does not support lossless RGB planes. RGB will be downsampled
                to lossy YUV420P. To encode lossless RGB use codec_name="libx264rgb" """
        end
        pix_fmt = AV_PIX_FMT_YUV420P10LE
    else
        _pix_type_not_supported(S, codec_name)
    end
    pix_fmt
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
    prepareencoder(firstimg; framerate=30,
                   AVCodecContextProperties = AVCodecContextPropertiesDefault,
                   codec_name::String="libx264")

Prepare encoder and return a `VideoEncoder` object. The dimensions and pixel
format of the video will be determined from `firstimg`. The number of rows of
`firstimg` determines the height of the frame, while the number of columns
determines the width.
"""
function prepareencoder(firstimg; framerate=30,
                        AVCodecContextProperties = AVCodecContextPropertiesDefault,
                        #color_range::Int = 1,
                        codec_name::String = "libx264",
                        scanline_major::Bool = false, gop = 12)
    if scanline_major
        width, height = size(firstimg)
    else
        height, width = size(firstimg)
    end

    ((width % 2 !=0) || (height % 2 !=0)) && error("Encoding error: Image dims must be a multiple of two")

    elt = eltype(firstimg)
    pix_fmt = _determine_pix_fmt(elt, codec_name, AVCodecContextProperties)
    framerate_rat = Rational(framerate)

    codec = avcodec_find_encoder_by_name(codec_name)
    check_ptr_valid(codec, flase) || error("Codec '$codec_name' not found")

    codec_context = AVCodecContextPtr(codec)
    codec_context.width = width
    codec_context.height = height
    codec_context.time_base = AVRational(1/framerate_rat)
    codec_context.framerate = AVRational(framerate_rat)
    codec_context.pix_fmt = pix_fmt
    codec_context.gop_size = gop
    # codec_context.max_b_frames = -1
    codec_context.flags |= AV_CODEC_FLAG_GLOBAL_HEADER

    priv_data_ptr = codec_context.priv_data
    for prop in AVCodecContextProperties
        if prop[1] == :priv_data
            for pd in prop[2]
                av_opt_set(priv_data_ptr, string(pd[1]), string(pd[2]),
                           AV_OPT_SEARCH_CHILDREN)
            end
        else
            av_setfield(codec_context,prop[1],prop[2])
        end
    end

    sigatomic_begin()
    lock(VIDEOIO_LOCK)
    ret = avcodec_open2(codec_context, codec, C_NULL)
    unlock(VIDEOIO_LOCK)
    sigatomic_end()
    ret < 0 && error("Could not open codec: Return code $(ret)")

    frame = AVFramePtr()
    frame.format = pix_fmt
    frame.width = width
    frame.height = height
    # frame.color_range = color_range == 1 ? AVCOL_RANGE_MPEG : AVCOL_RANGE_JPEG

    format_context = AVFormatContextPtr(Ptr{AVFormatContext}())

    ret = av_frame_get_buffer(frame, 0)
    ret < 0 && error("Could not allocate the video frame data")

    packet = AVPacketPtr()
    return VideoEncoder(codec_name, codec_context, format_context, -1, frame,
                        packet, pix_fmt, scanline_major)
end

_unsupported_append_encode_type() = error("Array element type not supported")

function transfer_img_bytes_to_frame_plane!(data_ptr, img_ptr, px_width,
                                            px_height, data_linesize,
                                            bytes_per_sample = 1)
    img_line_nbytes = px_width * bytes_per_sample
    @inbounds for r = 1:px_height
        data_line_ptr = data_ptr + (r-1) * data_linesize
        img_line_ptr = img_ptr + (r-1) * img_line_nbytes
        unsafe_copyto!(data_line_ptr, img_line_ptr, img_line_nbytes)
    end
end

function make_into_sl_col_mat(img::AbstractVector{Union{RGB, <:Unsigned}}, width, height)
    img_mat = reshape(img, (height, width))
    PermutedDimsArray(img_mat, (2, 1))
end
make_into_sl_col_mat(img::AbstractMatrix{Union{RGB, <:Unsigned}}, args...) =
    PermutedDimsArray(img, (2, 1))

function transfer_sl_col_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{UInt8})
    pix_fmt == AV_PIX_FMT_RGB24 || _unsupported_append_encode_type()
    width = frame.width
    height = frame.height
    ls = frame.linesize[1]
    data_p = frame.data[1]
    @inbounds for r = 1:height
        line_offset = (r-1) * ls
        for c = 1:width
            val = img[c, r]
            row_offset = line_offset + c
            for s in 0:2
                GC.@preserve frame unsafe_store!(data_p, val,
                                                 row_offset + s)
            end
        end
    end
end

function transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{UInt8},
                                    scanline_major)
    if pix_fmt == AV_PIX_FMT_GRAY8
        width = frame.width
        height = frame.height
        ls = frame.linesize[1]
        data_p = frame.data[1]
        if scanline_major
            img_p = pointer(img)
            GC.@preserve frame img transfer_img_bytes_to_frame_plane!(data_p,
                                                                      img_p,
                                                                      width,
                                                                      height,
                                                                      ls)
        else
            @inbounds for r = 1:height
                line_offset = (r-1) * ls
                for c = 1:width
                    GC.@preserve frame unsafe_store!(data_p, img[r,c], line_offset + c)
                end
            end
        end
    elseif pix_fmt == AV_PIX_FMT_RGB24
        if scanline_major
            transfer_sl_col_img_buf_to_frame!(frame, pix_fmt, img)
        else
            img_sl_col_mat = make_into_sl_col_mat(img)
            transfer_sl_col_img_buf_to_frame!(frame, pix_fmt, img_sl_col_mat)
        end
    else
        _unsupported_append_encode_type()
    end
end

@inline function bytes_of_uint16(x::UInt16)
    msb = convert(UInt8, (x & 0xFF00) >> 8)
    lsb = convert(UInt8, x & 0x00FF)
    msb, lsb
end

@inline function store_uint16_in_10le_frame!(data, x, px_offset)
    msb, lsb = bytes_of_uint16(x)
    unsafe_store!(data, lsb, px_offset)
    unsafe_store!(data, msb, px_offset + 1)
end

function transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{UInt16}, scanline_major)
    bytes_per_sample = 2
    if pix_fmt == AV_PIX_FMT_GRAY10LE
        width = frame.width
        height = frame.height
        ls = frame.linesize[1]
        datap = frame.data[1]
        if scanline_major
            if ENDIAN_BOM != 0x04030201
                error("Writing scanline_major AV_PIX_FMT_GRAY10LE on
                        big-endian machines not yet supported, use scanline_major = false")
            end
            img_p = pointer(reinterpret(UInt8, img))
            GC.@preserve frame img transfer_img_bytes_to_frame_plane!(datap,
                                                                      img_p,
                                                                      width,
                                                                      height,
                                                                      ls,
                                                                      bytes_per_sample)
        else
            @inbounds for r in 1:height
                line_offset = (r - 1) * ls
                for c in 1:width
                    px_offset = line_offset + bytes_per_sample * (c - 1) + 1
                    GC.@preserve frame store_uint16_in_10le_frame!(datap,
                                                                   img[r, c],
                                                                   px_offset)
                end
            end
        end
    else
        _unsupported_append_encode_type()
    end
end

transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{<:Normed}, args...) =
    transfer_img_buf_to_frame!(frame, pix_fmt, rawview(img), args...)

transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{<:Gray}, args...) =
    transfer_img_buf_to_frame!(frame, pix_fmt, channelview(img), args...)

function transfer_sl_col_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{RGB{N0f8}})
    pix_fmt == AV_PIX_FMT_YUV420P || _unsupported_append_encode_type()
    width = frame.width
    height = frame.height
    lss = frame.linesize
    fdata = frame.data
    @inbounds for r = 1:height
        line_offset = (r-1)*lss[1]
        for c = 1:width
            px_luma = convert(YCbCr, img[c, r]).y
            unsafe_store!(fdata[1], round(UInt8, px_luma), line_offset+c)
        end
    end
    img_half = restrict(img)
    @inbounds for r = 1:div(height, 2)
        line_offset_cb = (r-1)*lss[2]
        line_offset_cr = (r-1)*lss[3]
        for c = 1:div(width, 2)
            px_ycbcr = convert(YCbCr, img_half[c, r])
            unsafe_store!(fdata[2], round(UInt8, px_ycbcr.cb), line_offset_cb+c)
            unsafe_store!(fdata[3], round(UInt8, px_ycbcr.cr), line_offset_cr+c)
        end
    end
end


function transfer_img_buf_to_frame!(frame, pix_fmt,
                                    img::AbstractMatrix{RGB{N0f8}}, scanline_major)
    if pix_fmt == AV_PIX_FMT_RGB24
        width = frame.width
        height = frame.height
        lss = frame.linesize
        fdata = frame.data
        nbyte_per_pixel = 3
        if scanline_major
            data_p = fdata[1]
            img_p = pointer(img)
            GC.@preserve frame img transfer_img_bytes_to_frame_plane!(data_p,
                                                                      img_p,
                                                                      width,
                                                                      height,
                                                                      lss[1],
                                                                      bytes_per_pixel)
        else
            @inbounds for h in 1:height
                line_offset = (h - 1) * lss[1]
                for w in 1:width
                    px_offset = line_offset + (w - 1) * nbyte_per_pixel + 1
                    unsafe_store!(fdata[1], reinterpret(img[h, w].r), px_offset)
                    unsafe_store!(fdata[1], reinterpret(img[h, w].g), px_offset + 1)
                    unsafe_store!(fdata[1], reinterpret(img[h, w].b), px_offset + 2)
                end
            end
        end
    elseif pix_fmt == AV_PIX_FMT_YUV420P
        if scanline_major
            transfer_sl_col_img_buf_to_frame!(frame, pix_fmt, img)
        else
            img_sl_col_mat = make_into_sl_col_mat(img)
            transfer_sl_col_img_buf_to_frame!(frame, pix_fmt, img_sl_col_mat)
        end
    else
        _unsupported_append_encode_type()
    end
end

# convert from bt601 to bt709/bt2020 colorspace by multiplying by four
@inline bt601_to_bt709_codepoint(x) = round(UInt16, 4 * x)

function convert_store_bt601_codepoint!(data, x, line_offset, bytes_per_sample, c)
    px_cp = bt601_to_bt709_codepoint(x)
    px_offset = line_offset + bytes_per_sample * (c - 1) + 1
    store_uint16_in_10le_frame!(data, px_cp, px_offset)
end

function transfer_sl_col_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{RGB{N6f10}})
    pix_fmt == AV_PIX_FMT_YUV420P10LE || _unsupported_append_encode_type()
    bytes_per_sample = 2
    # Luma
    fdata = frame.data
    linesize_y = frame.linesize[1]
    width = frame.width
    height = frame.height
    for r in 1:height
        line_offset = (r - 1) * linesize_y
        for c in 1:width
            px_luma_601 = convert(YCbCr, img[c, r]).y
            convert_store_bt601_codepoint!(fdata[1], px_luma_601,
                                           line_offset, bytes_per_sample, c)
        end
    end
    # Chroma
    img_half = restrict(img) # For 4:2:0 chroma downsampling, lossy
    half_width = div(width, 2)
    linesize_cb = frame.linesize[2]
    linesize_cr = frame.linesize[3]
    @inbounds for r in 1:div(height, 2)
        line_offset_cb = (r - 1) * linesize_cb
        line_offset_cr = (r - 1) * linesize_cr
        for c in 1:half_width
            px_ycbcr = convert(YCbCr, img_half[c, r])
            convert_store_bt601_codepoint!(fdata[2], px_ycbcr.cb,
                                           line_offset_cb, bytes_per_sample, c)
            convert_store_bt601_codepoint!(fdata[3], px_ycbcr.cr,
                                           line_offset_cr, bytes_per_sample, c)
        end
    end
end

function transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{RGB{N6f10}}, scanline_major)
    if scanline_major
        transfer_sl_col_img_buf_to_frame!(frame, pix_fmt, img)
    else
        img_sl_col_mat = img_sl_col_mat = make_into_sl_col_mat(img)
        transfer_sl_col_img_buf_to_frame!(frame, pix_fmt, img_sl_col_mat)
    end
end

# Fallback
transfer_img_buf_to_frame!(frame, pix_fmt, img) = _unsuported_append_encode_type()

"""
    appendencode!(encoder::VideoEncoder, io::IO, img, index::Integer)

Send image object to ffmpeg encoder and encode. The rows of `img` must span the
vertical axis of the image, and the columns must span the horizontal axis.
"""
function appendencode!(encoder::VideoEncoder, io::IO, img, index::Integer)
    ret = av_frame_make_writable(encoder.frame)
    ret < 0 && error("av_frame_make_writable() error")

    transfer_img_buf_to_frame!(encoder.frame, encoder.pix_fmt, img,
                               encoder.scanline_major)
    encoder.frame.pts = index
    encode!(encoder, io)
end


# Indices should start from zero
function append_encode_mux!(writer, img, index)
    ret = av_frame_make_writable(writer.frame)
    ret < 0 && error("av_frame_make_writable() error")
    writer.frame.pts = index
    transfer_img_buf_to_frame!(writer.frame, writer.frame.format, img,
                               writer.scanline_major)
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
ffmpeg_framerate_string(fr) = error("Framerate type not valid. Mux framerate should be a subtype of Real (Integer, Float64, Rational etc.), or String")

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

@inline function set_class_option(ptr::NestedCStruct{T}, key, val) where T
    ret = av_opt_set(ptr, string(key), string(val), AV_OPT_SEARCH_CHILDREN)
    ret < 0 && error("Could not set class option $key to $val: got error $ret")
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
            ret = GC.@preserve writer avio_closep(pb_ptr)
            ret < 0 && error("Could not free AVIOContext")
        end
    end
    # Free allocated memory through finalizers
    writer.format_context = AVFormatContextPtr(C_NULL)
    writer.codec_context = AVCodecContextPtr(C_NULL)
    writer.frame = AVFramePtr(C_NULL)
    writer.packet = AVPacketPtr(C_NULL)
    writer.stream_index0 = -1
    writer
end

function open_video_out!(filename::AbstractString, ::Type{T},
                         sz::NTuple{2, Integer};
                         codec_name::Union{AbstractString, Nothing} = "libx264",
                         framerate::Real = 24,
                         scanline_major::Bool = false,
                         encoder_settings::SettingsT = (;),
                         encoder_private_settings::SettingsT = (;),
                         format_settings::SettingsT = (;)) where T
    framerate > 0 || error("Framerate must be strictly positive")
    if scanline_major
        width, height = sz
    else
        height, width = sz
    end
    ((width % 2 !=0) || (height % 2 !=0)) && error("Encoding error: Image dims must be a multiple of two")
    pix_fmt = _determine_pix_fmt(T, codec_name, encoder_settings)

    format_context = output_AVFormatContextPtr(filename)

    codec_p = avcodec_find_encoder_by_name(codec_name)
    check_ptr_valid(codec_p, false) || error("Codec '$codec_name' not found")
    codec = AVCodecPtr(codec_p)

    ret = avformat_query_codec(format_context.oformat, codec.id,
                               AVCodecs.FF_COMPLIANCE_NORMAL)
    ret != 1 && error("Format not compatible with encoder")

    codec_context = AVCodecContextPtr(codec)
    codec_context.width = width
    codec_context.height = height
    framerate_rat = Rational(framerate)
    target_timebase = 1/framerate_rat
    codec_context.time_base = target_timebase
    codec_context.framerate = framerate_rat
    codec_context.pix_fmt = pix_fmt

    if format_context.oformat.flags & AVFMT_GLOBALHEADER != 0
        codec_context.flags |= AV_CODEC_FLAG_GLOBAL_HEADER
    end

    set_class_options(codec_context; encoder_settings...)
    set_class_options(codec_context.priv_data; encoder_private_settings...)

    sigatomic_begin()
    lock(VIDEOIO_LOCK)
    ret = avcodec_open2(codec_context, codec, C_NULL)
    unlock(VIDEOIO_LOCK)
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
        ret = GC.@preserve format_context avio_open(pb_ptr, filename, AVIO_FLAG_WRITE)
        ret < 0 && error("Could not open file $filename for writing")
    end
    avformat_write_header(format_context, C_NULL)
    ret < 0 && error("Could not write header")

    frame = AVFramePtr()
    frame.format = pix_fmt
    frame.width = width
    frame.height = height
    # frame.color_range = color_range == 1 ? AVCOL_RANGE_MPEG : AVCOL_RANGE_JPEG

    ret = av_frame_get_buffer(frame, 0)
    ret < 0 && error("Could not allocate the video frame data")

    packet = AVPacketPtr()

    VideoWriter(format_context, codec_context, frame, packet, stream_index0,
                scanline_major)
end

open_video_out!(filename, img::AbstractMatrix{T}; kwargs...) where T =
    open_video_out!(filename, T, size(img); kwargs...)

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
                     scanline_major = false)

    io = Base.open("temp.stream","w")
    startencode!(io)
    encoder = prepareencoder(imgstack[1], codec_name = codec_name,
                             framerate = framerate,
                             AVCodecContextProperties = AVCodecContextProperties,
                             scanline_major = scanline_major)
    if !silent
        p = Progress(length(imgstack), 1)   # minimum update interval: 1 second
    end
    for (i, img) in enumerate(imgstack)
        appendencode!(encoder, io, img, i)
        !silent && next!(p)
    end
    finishencode!(encoder, io)
    close(io)
    mux("temp.stream",filename,framerate,silent=silent)
    return filename
end

"""
    encodevideo_mux(filename::String,imgstack::Array;
        AVCodecContextProperties = AVCodecContextPropertiesDefault,
        codec_name = "libx264",
        framerate = 24)

Encode image stack to video file and return filepath. The rows of each image in
`imgstack` must span the vertical axis of the image, and the columns must span
the horizontal axis.
"""
function encode_video_mux(filename::String, imgstack; kwargs...)
    writer = open_video_out!(filename, first(imgstack); kwargs...)
    for (i, img) in enumerate(imgstack)
        append_encode_mux!(writer, img, i - 1)
    end
    encode_mux!(writer, true)
    close_video_out!(writer)
    return filename
end
