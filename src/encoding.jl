using ColorTypes, ProgressMeter, FixedPointNumbers, ImageTransformations, ImageCore

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

"""
prepareencoder(firstimg,codec_name,framerate,AVCodecContextProperties)

Prepare encoder and return AV objects.
"""
function prepareencoder(firstimg,codec_name,framerate,AVCodecContextProperties)
    height = size(firstimg,1)
    width = size(firstimg,2)
    ((width % 2 !=0) || (height % 2 !=0)) && error("Encoding error: Image dims must be a multiple of two")

    codec = avcodec_find_encoder_by_name(codec_name)
    codec == C_NULL && error("Codec '$codec_name' not found")

    apCodecContext = Ptr{AVCodecContext}[avcodec_alloc_context3(codec)]
    apCodecContext == [C_NULL] && error("Could not allocate video codec context")

    apPacket = Ptr{AVPacket}[av_packet_alloc()]
    apPacket == [C_NULL] && error("av_packet_alloc() error")

    if eltype(firstimg) == UInt8 && (codec_name == "libx264")
        if islossless(AVCodecContextProperties)
            if !isfullcolorrange(AVCodecContextProperties)
                @warn """Encoding output not lossless.
                Lossless libx264 encoding of UInt8 requires
                :color_range=>2 within AVCodecContextProperties, to represent
                full 8-bit pixel value range."""
            end
        end
        pix_fmt = AV_PIX_FMT_GRAY8
    elseif eltype(firstimg) == Gray{N0f8} && (codec_name == "libx264")
        if islossless(AVCodecContextProperties)
            if !isfullcolorrange(AVCodecContextProperties)
                @warn """Encoding output not lossless.
                Lossless libx264 encoding of Gray{N0f8} requires
                :color_range=>2 within AVCodecContextProperties, to represent
                full 8-bit pixel value range."""
            end
        end
        pix_fmt = AV_PIX_FMT_GRAY8
    elseif eltype(firstimg) == Gray{N0f8} && (codec_name == "libx264rgb")
        pix_fmt = AV_PIX_FMT_RGB24
    elseif eltype(firstimg) == RGB{N0f8} && (codec_name == "libx264rgb")
        if !islossless(AVCodecContextProperties)
            @warn """Codec libx264rgb has limited playback support. Given that
            selected encoding settings are not lossless (crf!=0), codec_name="libx264"
            will give better playback results"""
        end
        pix_fmt = AV_PIX_FMT_RGB24
    elseif eltype(firstimg) == RGB{N0f8} && (codec_name == "libx264")
        if islossless(AVCodecContextProperties)
            @warn """Encoding output not lossless.
            libx264 does not support lossless RGB planes. RGB will be downsampled
            to lossy YUV420P. To encode lossless RGB use codec_name="libx264rgb" """
        end
        pix_fmt = AV_PIX_FMT_YUV420P
    else
        error("VideoIO: Encoding image element type $(eltype(firstimg)) with
        codec $codec_name not currently supported")
    end

    av_setfield(apCodecContext[1],:width,width)
    av_setfield(apCodecContext[1],:height,height)
    av_setfield(apCodecContext[1],:time_base,AVRational(1, framerate))
    av_setfield(apCodecContext[1],:framerate,AVRational(framerate, 1))
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

"""
appendencode(encoder::VideoEncoder, io::IO, img, index::Integer)

Send image object to ffmpeg encoder and encode
"""
function appendencode!(encoder::VideoEncoder, io::IO, img, index::Integer)

    flush(stdout)
    ret = av_frame_make_writable(encoder.apFrame[1])
    ret < 0 && error("av_frame_make_writable() error")

    frame = unsafe_load(encoder.apFrame[1]) #grab data from c memory
    img_eltype = eltype(img)

    if (img_eltype == UInt8) && (encoder.pix_fmt == AV_PIX_FMT_GRAY8)
        for r = 1:frame.height, c = 1:frame.width
            unsafe_store!(frame.data[1], img[r,c], ((r-1)*frame.linesize[1])+c)
        end
    elseif (img_eltype == Gray{N0f8}) && (encoder.pix_fmt == AV_PIX_FMT_GRAY8)
        img_uint8 = rawview(channelview(img))
        for r = 1:frame.height, c = 1:frame.width
            unsafe_store!(frame.data[1], img_uint8[r,c], ((r-1)*frame.linesize[1])+c)
        end
    elseif (img_eltype == Gray{N0f8}) && (encoder.pix_fmt == AV_PIX_FMT_RGB24)
        img_uint8 = repeat(PermutedDimsArray(rawview(channelview(img)),(2,1))[:],inner=3)
        unsafe_copyto!(frame.data[1], pointer(img_uint8), length(img_uint8))
    elseif (img_eltype  == RGB{N0f8}) && (encoder.pix_fmt == AV_PIX_FMT_RGB24)
        img_uint8 = PermutedDimsArray(rawview(channelview(img)),(1,3,2))[:]
        unsafe_copyto!(frame.data[1], pointer(img_uint8), length(img_uint8))
    elseif (img_eltype  == RGB{N0f8}) && (encoder.pix_fmt == AV_PIX_FMT_YUV420P)
        img_YCbCr = convert.(YCbCr{Float64}, img)
        img_YCbCr_half = convert.(YCbCr{Float64}, restrict(img))
        for r = 1:frame.height, c = 1:frame.width
            unsafe_store!(frame.data[1], round(UInt8,img_YCbCr[r,c].y), ((r-1)*frame.linesize[1])+c)
        end
        for r = 1:Int64(frame.height/2), c = 1:Int64(frame.width/2)
            unsafe_store!(frame.data[2], round(UInt8,img_YCbCr_half[r,c].cb), ((r-1)*frame.linesize[2])+c)
            unsafe_store!(frame.data[3], round(UInt8,img_YCbCr_half[r,c].cr), ((r-1)*frame.linesize[3])+c)
        end
    else
        error("Array element type not supported")
    end
    av_setfield(encoder.apFrame[1],:pts,index)
    encode!(encoder, io)
end

"""
function finishencode(encoder::VideoEncoder, io::IO)

End encoding by sending endencode package to ffmpeg, and close objects.
"""
function finishencode!(encoder::VideoEncoder, io::IO)
    encode!(encoder, io, flush=true) # flush the encoder
    write(io,UInt8[0, 0, 1, 0xb7]) # add sequence end code to have a real MPEG file
    avcodec_free_context(encoder.apCodecContext)
    av_frame_free(encoder.apFrame)
    av_packet_free(encoder.apPacket)
end

"""
mux(srcfilename,destfilename,framerate;silent=false)

Multiplex stream object into video container.
"""
function mux(srcfilename,destfilename,framerate;silent=false)
    withenv(execenv) do
        muxout = collectexecoutput(`$(ffmpeg) -y -framerate $framerate -i $srcfilename -c copy $destfilename`)
        filter!(x->!occursin.("Timestamps are unset in a packet for stream 0.",x),muxout) #known non-bug issue with h264
        if occursin("ffmpeg version ",muxout[1]) && occursin("video:",muxout[end])
            rm("$srcfilename")
            !silent && (@info "Video file saved: $(pwd())/$destfilename")
            !silent && (@info muxout[end-1])
            !silent && (@info muxout[end])
        else
            @warn "Stream Muxing may have failed: $(pwd())/$srcfilename into $(pwd())/$destfilename"
            println.(muxout)
        end
    end
end

"""
encodevideo(filename::String,imgstack::Array;
    AVCodecContextProperties = AVCodecContextPropertiesDefault,
    codec_name = "libx264",
    framerate = 24)

Encode image stack to video file

"""
function encodevideo(filename::String,imgstack::Array;
    AVCodecContextProperties = AVCodecContextPropertiesDefault,
    codec_name = "libx264",
    framerate = 24,
    silent=false)

    io = Base.open("temp.stream","w")
    encoder = prepareencoder(imgstack[1],codec_name,framerate,AVCodecContextProperties)
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
end
