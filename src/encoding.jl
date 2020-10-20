
export encodevideo, encode!, prepareencoder, appendencode!, finishencode!, mux

# A struct collecting encoder objects for easy passing
mutable struct VideoEncoder
    codec_name::String
    apCodecContext::Array{Ptr{AVCodecContext}}
    apFrame::Array{Ptr{AVFrame}}
    apPacket::Array{Ptr{AVPacket}}
    pix_fmt::Integer
end

"""
    encode(encoder::VideoEncoder, io::IO)

Encode frame in memory
"""
function encode!(encoder::VideoEncoder, io::IO; flush=false)
    if flush
        ret = avcodec_send_frame(encoder.apCodecContext[1],C_NULL)
    else
        ret = avcodec_send_frame(encoder.apCodecContext[1],encoder.apFrame[1])
    end
    ret < 0 && error("Error $ret sending a frame for encoding")

    while ret >= 0
        ret = avcodec_receive_packet(encoder.apCodecContext[1], encoder.apPacket[1])
        if (ret == -35 || ret == -11 || ret == -541478725) # -35=EAGAIN or -11.  -541478725=AVERROR_EOF
             return
        elseif (ret < 0)
            error("Error $ret during encoding")
        end
        pkt = unsafe_load(encoder.apPacket[1])
        @debug println("Write packet $(pkt.pts) (size=$(pkt.size))")
        data = unsafe_wrap(Array,pkt.data,pkt.size)
        write(io,data)
        av_packet_unref(encoder.apPacket[1])
    end
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
    prepareencoder(firstimg;framerate=30,AVCodecContextProperties=[:priv_data => ("crf"=>"22","preset"=>"medium")],codec_name::String="libx264")

Prepare encoder and return AV objects.
"""
function prepareencoder(firstimg; framerate=30, AVCodecContextProperties=[:priv_data => ("crf"=>"22","preset"=>"medium")], codec_name::String="libx264")
    height = size(firstimg,1)
    width = size(firstimg,2)
    ((width % 2 !=0) || (height % 2 !=0)) && error("Encoding error: Image dims must be a multiple of two")

    codec = avcodec_find_encoder_by_name(codec_name)
    codec == C_NULL && error("Codec '$codec_name' not found")

    apCodecContext = Ptr{AVCodecContext}[avcodec_alloc_context3(codec)]
    apCodecContext == [C_NULL] && error("Could not allocate video codec context")

    apPacket = Ptr{AVPacket}[av_packet_alloc()]
    apPacket == [C_NULL] && error("av_packet_alloc() error")

    elt = eltype(firstimg)
    pix_fmt = _determine_pix_fmt(elt, codec_name, AVCodecContextProperties)

    av_setfield(apCodecContext[1],:width,width)
    av_setfield(apCodecContext[1],:height,height)
    framerate_rat = Rational(framerate)
    av_setfield(apCodecContext[1],:time_base,AVRational(1/framerate_rat))
    av_setfield(apCodecContext[1],:framerate,AVRational(framerate_rat))
    av_setfield(apCodecContext[1],:pix_fmt,pix_fmt)

    codecContext = unsafe_load(apCodecContext[1])
    for prop in AVCodecContextProperties
        if prop[1] == :priv_data
            for pd in prop[2]
                av_opt_set(codecContext.priv_data, string(pd[1]), string(pd[2]), AV_OPT_SEARCH_CHILDREN)
            end
        else
            av_setfield(apCodecContext[1],prop[1],prop[2])
        end
    end

    # open it
    ret = avcodec_open2(apCodecContext[1], codec, C_NULL)
    ret < 0 && error("Could not open codec: Return code $(ret)")

    apFrame = Ptr{VideoIO.AVFrame}[VideoIO.av_frame_alloc()]
    apFrame == [C_NULL] && error("Could not allocate video frame")

    av_setfield(apFrame[1],:format,pix_fmt)
    av_setfield(apFrame[1],:width,width)
    av_setfield(apFrame[1],:height,height)

    ret = av_frame_get_buffer(apFrame[1], 32)
    ret < 0 && error("Could not allocate the video frame data")

    return VideoEncoder(codec_name, apCodecContext, apFrame, apPacket, pix_fmt)
end

_unsupported_append_encode_type() = error("Array element type not supported")

function transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{UInt8})
    if pix_fmt == AV_PIX_FMT_GRAY8
        for r = 1:frame.height, c = 1:frame.width
            unsafe_store!(frame.data[1], img[r,c], ((r-1)*frame.linesize[1])+c)
        end
    elseif pix_fmt == AV_PIX_FMT_RGB24
        img_uint8 = repeat(PermutedDimsArray(img, (2,1))[:], inner = 3)
        unsafe_copyto!(frame.data[1], pointer(img_uint8), length(img_uint8))
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

function transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{UInt16})
    sample_el_size = 2
    if pix_fmt == AV_PIX_FMT_GRAY10LE
        for r in 1:frame.height
            line_offset = (r - 1) * frame.linesize[1]
            for c in 1:frame.width
                px_offset = line_offset + sample_el_size * (c - 1) + 1
                store_uint16_in_10le_frame!(frame.data[1], img[r, c], px_offset)
            end
        end
    else
        _unsupported_append_encode_type()
    end
end

transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{<:Normed}) =
    transfer_img_buf_to_frame!(frame, pix_fmt, rawview(img))

transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{<:Gray}) =
    transfer_img_buf_to_frame!(frame, pix_fmt, channelview(img))

function transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{RGB{N0f8}})
    if pix_fmt == AV_PIX_FMT_RGB24
        img_uint8 = PermutedDimsArray(rawview(channelview(img)),(1,3,2))[:]
        unsafe_copyto!(frame.data[1], pointer(img_uint8), length(img_uint8))
    elseif pix_fmt == AV_PIX_FMT_YUV420P
        for r = 1:frame.height, c = 1:frame.width
            px_luma = convert(YCbCr, img[r, c]).y
            unsafe_store!(frame.data[1], round(UInt8, px_luma),
                          ((r-1)*frame.linesize[1])+c)
        end
        img_half = restrict(img)
        for r = 1:div(frame.height, 2), c = 1:div(frame.width, 2)
            px_ycbcr = convert(YCbCr, img_half[r, c])
            unsafe_store!(frame.data[2], round(UInt8, px_ycbcr.cb),
                          ((r-1)*frame.linesize[2])+c)
            unsafe_store!(frame.data[3], round(UInt8, px_ycbcr.cr),
                          ((r-1)*frame.linesize[3])+c)
        end
    else
        _unsupported_append_encode_type()
    end
end

# convert from bt601 to bt709/bt2020 colorspace by multiplying by four
@inline bt601_to_bt709_codepoint(x) = round(UInt16, 4 * x)

function convert_store_bt601_codepoint!(data, x, line_offset, sample_el_size, c)
    px_cp = bt601_to_bt709_codepoint(x)
    px_offset = line_offset + sample_el_size * (c - 1) + 1
    store_uint16_in_10le_frame!(data, px_cp, px_offset)
end

function transfer_img_buf_to_frame!(frame, pix_fmt, img::AbstractArray{RGB{N6f10}})
    sample_el_size = 2
    if pix_fmt == AV_PIX_FMT_YUV420P10LE
        # Luma
        linesize_y = frame.linesize[1]
        for r in 1:frame.height
            line_offset = (r - 1) * linesize_y
            for c in 1:frame.width
                px_luma_601 = convert(YCbCr, img[r, c]).y
                convert_store_bt601_codepoint!(frame.data[1], px_luma_601,
                                               line_offset, sample_el_size, c)
            end
        end
        # Chroma
        img_half = restrict(img) # For 4:2:0 chroma downsampling, lossy
        half_width = div(frame.width, 2)
        linesize_cb = frame.linesize[2]
        linesize_cr = frame.linesize[3]
        for r in 1:div(frame.height, 2)
            line_offset_cb = (r - 1) * linesize_cb
            line_offset_cr = (r - 1) * linesize_cr
            for c in 1:half_width
                px_ycbcr = convert(YCbCr, img_half[r, c])
                convert_store_bt601_codepoint!(frame.data[2], px_ycbcr.cb,
                                               line_offset_cb, sample_el_size, c)
                convert_store_bt601_codepoint!(frame.data[3], px_ycbcr.cr,
                                               line_offset_cr, sample_el_size, c)
            end
        end
    else
        _unsupported_append_encode_type()
    end
end

# Fallback
transfer_img_buf_to_frame!(frame, pix_fmt, img) = _unsuported_append_encode_type()

"""
    appendencode!(encoder::VideoEncoder, io::IO, img, index::Integer)

Send image object to ffmpeg encoder and encode
"""
function appendencode!(encoder::VideoEncoder, io::IO, img, index::Integer)

    flush(stdout)
    ret = av_frame_make_writable(encoder.apFrame[1])
    ret < 0 && error("av_frame_make_writable() error")

    frame = unsafe_load(encoder.apFrame[1]) #grab data from c memory
    transfer_img_buf_to_frame!(frame, encoder.pix_fmt, img)
    av_setfield(encoder.apFrame[1],:pts,index)
    encode!(encoder, io)
end

"""
    finishencode!(encoder::VideoEncoder, io::IO)

End encoding by sending endencode package to ffmpeg, and close objects.
"""
function finishencode!(encoder::VideoEncoder, io::IO)
    encode!(encoder, io, flush=true) # flush the encoder
    write(io,UInt8[0, 0, 1, 0xb7]) # add sequence end code to have a real MPEG file
    avcodec_free_context(encoder.apCodecContext)
    av_frame_free(encoder.apFrame)
    av_packet_free(encoder.apPacket)
end

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

"""
    encodevideo(filename::String,imgstack::Array;
        AVCodecContextProperties = AVCodecContextPropertiesDefault,
        codec_name = "libx264",
        framerate = 24)

Encode image stack to video file and return filepath.

"""
function encodevideo(filename::String,imgstack::Array;
    AVCodecContextProperties = AVCodecContextPropertiesDefault,
    codec_name = "libx264",
    framerate = 24,
    silent=false)

    io = Base.open("temp.stream","w")
    encoder = prepareencoder(imgstack[1],codec_name=codec_name,framerate=framerate,AVCodecContextProperties=AVCodecContextProperties)
    !silent && (p = Progress(length(imgstack), 1))   # minimum update interval: 1 second
    index = 1
    for img in imgstack
        appendencode!(encoder, io, img, index)
        !silent && next!(p)
        index += 1
    end
    finishencode!(encoder, io)
    close(io)
    mux("temp.stream",filename,framerate,silent=silent)
    return filename
end
