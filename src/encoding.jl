using ColorTypes, ProgressMeter, FixedPointNumbers, ImageTransformations

export encodevideo, encode!, prepareencoder, appendencode!, finishencode!, mux

# A struct collecting encoder objects for easy passing
mutable struct VideoEncoder
    codec_name::String
    pcodeccontext::Array{Ptr{VideoIO.AVCodecContext}}
    pframe::Array{Ptr{VideoIO.AVFrame}}
    ppkt::Array{Ptr{VideoIO.AVPacket}}
    pix_fmt::Integer
end

"""
encode(enc_ctx::Ptr{VideoIO.AVCodecContext}, pktptr::Ptr{VideoIO.AVPacket}, io::IO)

Encode frame in memory
"""
function encode!(encoder::VideoEncoder, io::IO; flush=false)
    if flush
        ret = avcodec_send_frame(encoder.pcodeccontext[1],C_NULL)
    else
        ret = avcodec_send_frame(encoder.pcodeccontext[1],encoder.pframe[1])
    end
    ret < 0 && error("Error $ret sending a frame for encoding")

    while ret >= 0
        ret = avcodec_receive_packet(encoder.pcodeccontext[1], encoder.ppkt[1])
        if (ret == -35 || ret == -541478725) # -35=EAGAIN -541478725=AVERROR_EOF
             return
        elseif (ret < 0)
            error("Error $ret during encoding")
        end
        pkt = unsafe_load(encoder.ppkt[1])
        @debug println("Write packet $(pkt.pts) (size=$(pkt.size))")
        data = unsafe_wrap(Array,pkt.data,pkt.size)
        write(io,data)
        VideoIO.av_packet_unref(encoder.ppkt[1])
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

"""
prepareencoder(firstimg,codec_name,framerate,AVCodecContextProperties)

Prepare encoder and return AV objects.
"""
function prepareencoder(firstimg,codec_name,framerate,AVCodecContextProperties)
    width = size(firstimg,1)
    height = size(firstimg,2)
    ((width % 2 !=0) || (height % 2 !=0)) && error("Encoding error: Image dims must be a multiple of two")

    codec = avcodec_find_encoder_by_name(codec_name)
    codec == C_NULL && error("Codec '$codec_name' not found")

    codeccontextptr = Ptr{VideoIO.AVCodecContext}[VideoIO.avcodec_alloc_context3(codec)]
    codeccontextptr == [C_NULL] && error("Could not allocate video codec context")

    pktptr = Ptr{VideoIO.AVPacket}[VideoIO.av_packet_alloc()]
    pktptr == [C_NULL] && error("av_packet_alloc() error")

    if eltype(firstimg) == UInt8
        pix_fmt = VideoIO.AV_PIX_FMT_GRAY8
    elseif eltype(firstimg) == Gray{N0f8}
            pix_fmt = VideoIO.AV_PIX_FMT_GRAY8
    elseif eltype(firstimg) == RGB{N0f8} && (codec_name == "libx264rgb")
        if !islossless(AVCodecContextProperties)
            @warn """Codec libx264rgb has limited playback support. Given that
            selected encoding settings are not lossless (crf!=0), codec_name="libx264"
            will give better results"""
        end
        pix_fmt = VideoIO.AV_PIX_FMT_RGB24
    elseif eltype(firstimg) == RGB{N0f8} && (codec_name == "libx264")
        if islossless(AVCodecContextProperties)
            @warn """Lossless encoding is selected (crf=0), however libx264 does
            not support lossless RGB planes. RGB will be downsampled to lossy YUV420P.
            To encode lossless RGB use codec_name="libx264rgb" """
        end
        pix_fmt = VideoIO.AV_PIX_FMT_YUV420P
    else
        error("VideoIO: Encoding image element type $(eltype(imgstack[1])) with
        codec $codec_name not currently supported")
    end

    codecContext = unsafe_load(codeccontextptr[1])
    codecContext.width = width
    codecContext.height = height
    codecContext.time_base = VideoIO.AVRational(1, framerate) # frames per second
    codecContext.framerate = VideoIO.AVRational(framerate, 1)
    codecContext.pix_fmt = pix_fmt
    unsafe_store!(codeccontextptr[1], codecContext)

    codec_loaded = unsafe_load(codec)
    for prop in AVCodecContextProperties
        if prop[1] == :priv_data
            for pd in prop[2]
                VideoIO.av_opt_set(codecContext.priv_data, string(pd[1]), string(pd[2]), VideoIO.AV_OPT_SEARCH_CHILDREN)
            end
        else
            setproperty!(codecContext, prop[1], prop[2])
        end
    end

    # open it
    ret = VideoIO.avcodec_open2(codeccontextptr[1], codec, C_NULL)
    ret < 0 && error("Could not open codec: Return code $(ret)")

    frameptr = Ptr{VideoIO.AVFrame}[VideoIO.av_frame_alloc()]
    frameptr == [C_NULL] && error("Could not allocate video frame")
    frame = unsafe_load(frameptr[1])
    frame.format = codecContext.pix_fmt
    frame.width  = codecContext.width
    frame.height = codecContext.height
    unsafe_store!(frameptr[1],frame)

    ret = VideoIO.av_frame_get_buffer(frameptr[1], 32)
    ret < 0 && error("Could not allocate the video frame data")

    return VideoEncoder(codec_name, codeccontextptr, frameptr, pktptr, pix_fmt)
end

"""
appendencode(io::IO, img, index::Integer,
    codeccontextptr::Array{Ptr{VideoIO.AVCodecContext}},
    frameptr::Array{Ptr{VideoIO.AVFrame}},
    pktptr::Array{Ptr{VideoIO.AVPacket}},
    pix_fmt::Integer)

Send image object to ffmpeg encoder and encode
"""
function appendencode!(encoder::VideoEncoder, io::IO, img, index::Integer)

    flush(stdout)

    ret = VideoIO.av_frame_make_writable(encoder.pframe[1])
    ret < 0 && error("av_frame_make_writable() error")

    frame = unsafe_load(encoder.pframe[1]) #grab data from c memory

    img_eltype = eltype(img)

    if (img_eltype == UInt8) && (encoder.pix_fmt == VideoIO.AV_PIX_FMT_GRAY8)
        framedata_1 = unsafe_load(frame.data[1])
        for y = 1:frame.height, x = 1:frame.width
            unsafe_store!(frame.data[1], img[x,y], ((y-1)*frame.linesize[1])+x)
        end
    elseif (img_eltype  == Gray{N0f8}) && (encoder.pix_fmt == VideoIO.AV_PIX_FMT_GRAY8)
        img_uint8 = reinterpret(UInt8,img)
        for y = 1:frame.height, x = 1:frame.width
            unsafe_store!(frame.data[1], img_uint8[x,y], ((y-1)*frame.linesize[1])+x)
        end
    elseif (img_eltype  == RGB{N0f8}) && (encoder.pix_fmt == VideoIO.AV_PIX_FMT_RGB24)
        img_uint8 = reinterpret(UInt8, img)
        unsafe_copyto!(frame.data[1], pointer(img_uint8), length(img_uint8))
    elseif (img_eltype  == RGB{N0f8}) && (encoder.pix_fmt == VideoIO.AV_PIX_FMT_YUV420P)
        img_YCbCr = convert.(YCbCr{Float64}, img)
        img_YCbCr_half = convert.(YCbCr{Float64}, restrict(img))
        for y = 1:frame.height, x = 1:frame.width
            unsafe_store!(frame.data[1], round(UInt8,img_YCbCr[x,y].y), ((y-1)*frame.linesize[1])+x)
        end
        for y = 1:Int64(frame.height/2), x = 1:Int64(frame.width/2)
            unsafe_store!(frame.data[2], round(UInt8,img_YCbCr_half[x,y].cb), ((y-1)*frame.linesize[2])+x)
            unsafe_store!(frame.data[3], round(UInt8,img_YCbCr_half[x,y].cr), ((y-1)*frame.linesize[3])+x)
        end
    else
        error("Array element type not supported")
    end
    frame.pts = index
    unsafe_store!(encoder.pframe[1], frame) #pass data back to c memory
    encode!(encoder, io)
end

"""
function finishencode(io, codeccontextptr, frameptr, pktptr)

End encoding by sending endencode package to ffmpeg, and close objects.
"""
function finishencode!(encoder::VideoEncoder, io)
    encode!(encoder, io, flush=true) # flush the encoder
    write(io,UInt8[0, 0, 1, 0xb7]) # add sequence end code to have a real MPEG file
    VideoIO.avcodec_free_context(encoder.pcodeccontext)
    VideoIO.av_frame_free(encoder.pframe)
    VideoIO.av_packet_free(encoder.ppkt)
end

"""
mux(srcfilename,destfilename,framerate)

Multiplex stream object into video container.
"""
function mux(srcfilename,destfilename,framerate)
    muxout = VideoIO.collectexecoutput(`$(VideoIO.ffmpeg) -y -framerate $framerate -i $srcfilename -c copy $destfilename`)
    filter!(x->!occursin.("Timestamps are unset in a packet for stream 0.",x),muxout)
    if occursin("ffmpeg version ",muxout[1]) && occursin("video:",muxout[end])
        rm("$srcfilename")
        @info "Video file saved: $(pwd())/$destfilename"
        @info muxout[end-1]
        @info muxout[end]
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

Encode image stack to video file

"""
function encodevideo(filename::String,imgstack::Array;
    AVCodecContextProperties = AVCodecContextPropertiesDefault,
    codec_name = "libx264",
    framerate = 24)

    io = Base.open("temp.stream","w")
    encoder = prepareencoder(imgstack[1],codec_name,framerate,AVCodecContextProperties)
    p = Progress(length(imgstack), 1)   # minimum update interval: 1 second
    index = 1
    for img in imgstack
        appendencode!(encoder, io, img, index)
        next!(p)
        index += 1
    end
    finishencode!(encoder, io)
    close(io)
    mux("temp.stream",filename,framerate)
end
