# AVCapture

import Base: read, read!, show, close, eof

export grab, retrieve, read, read!, AVCapture

type AVCapture
    source::ASCIIString
    apFormatContext::Vector{Ptr{AVFormatContext}}
    streams::Vector{AVStream}
    aPacket::Vector{AVPacket}      # Reusable packet

    videoStreamIdx::Int
    pVideoCodecContext::Ptr{AVCodecContext}
    pVideoCodec::Ptr{AVCodec}
    aVideoFrame::Vector{AVFrame}   # Reusable frame

    width::Cint
    height::Cint
    pix_fmt::Cint

    # TODO: may belong elsewhere
    transcode::Bool
    transcode_interp::Cint
    transcode_context::Ptr{SwsContext}
    target_pix_fmt::Cint
    target_bits_per_pixel::Int
    target_buf::Array{Uint8}
    aTargetVideoFrame::Vector{AVFrame}
    apTargetDataBuffers::Vector{Ptr{Uint8}}
    apTargetLineSizes::Vector{Cint}
    
    aFrameFinished::Vector{Int32}
    
    # audioStream::Int
    # pAudioCodecContext::Ptr{AVCodecContext}
    # pAudioCodec::Ptr{AVCodec}

    isopen::Bool

end

AVCapture(source::String) = open(source)


have_frame(c::AVCapture) = c.isopen && c.aFrameFinished[1] > 0
reset_frame_flag!(c::AVCapture) = (c.aFrameFinished[1] = 0)
bufsize_check(c::AVCapture, buf::Array{Uint8}) = (length(buf) == avpicture_get_size(c.target_pix_fmt, c.width, c.height))
check_isopen(c::AVCapture) = !c.isopen && error("AVCapture $(c.source) not open")


function open(source::String;
              transcode::Bool=true,
              transcode_interpolation=AV.SWS_BILINEAR,
              target_pix_fmt=AV.PIX_FMT_RGB24
              )
    av_register_all();

    apFormatContext = Ptr{AVFormatContext}[C_NULL]

    if avformat_open_input(apFormatContext,
                           source,
                           C_NULL,
                           C_NULL)    != 0
        error("Could not open file $source")
    end
    pFormatContext = apFormatContext[1]

    if avformat_find_stream_info(pFormatContext, C_NULL) < 0
        error("Couldn't find stream information")
    end

    #av_dump_format(pFormatContext, 0, source, 0);

    formatContext = unsafe_load(pFormatContext);

    streams = AVStream[]
    codecContexts = AVCodecContext[]

    jVideoStreamIdx = -1

    # Load streams, codec_contexts
    for i = 1:formatContext.nb_streams
        pStream = unsafe_load(formatContext.streams,i)
        stream = unsafe_load(pStream)
        push!(streams, stream)
        codec = unsafe_load(stream.codec)
        push!(codecContexts, codec)
        if jVideoStreamIdx == -1 && codec.codec_type == AV.AVMEDIA_TYPE_VIDEO
            jVideoStreamIdx = i
        end
    end

    if jVideoStreamIdx == -1
        error("Didn't find a video stream")
    end
    
    # Get a pointer to the codec context for the video stream
    pVideoCodecContext = streams[jVideoStreamIdx].codec
    codecContext = codecContexts[jVideoStreamIdx]

    width, height = codecContext.width, codecContext.height
    pix_fmt = codecContext.pix_fmt

    # Find the decoder for the video stream
    pVideoCodec=avcodec_find_decoder(codecContext.codec_id)

    if pVideoCodec == C_NULL
        error("Unsupported Video Codec")
    end

    if avcodec_open2(pVideoCodecContext, pVideoCodec, C_NULL) < 0
        error("Could not open codec")
    end

    aVideoFrame = [AVFrame()]
    aTargetVideoFrame = [AVFrame()]

    pFmtDesc = av_pix_fmt_desc_get(target_pix_fmt)
    bits_per_pixel = av_get_bits_per_pixel(pFmtDesc)

    if bits_per_pixel % 8 != 0
        error("Unsupported format (bits_per_pixel = $bits_per_pixel)")
    end

    N = int64(bits_per_pixel >> 3)
    target_buf = Array(Uint8, bits_per_pixel>>3, width, height)

    sws_context = sws_getContext(width, height, pix_fmt, 
                                 width, height, target_pix_fmt,
                                 transcode_interpolation, C_NULL, C_NULL, C_NULL)

    avpicture_fill(pointer(aTargetVideoFrame), target_buf, target_pix_fmt, width, height)
    apTargetDataBuffers = reinterpret(Ptr{Uint8}, [aTargetVideoFrame[1].data])
    apTargetLineSizes   = reinterpret(Cint,       [aTargetVideoFrame[1].linesize])

    aPacket = [AVPacket()]

    aFrameFinished = Int32[0]

    AVCapture(source,
              apFormatContext,
              streams,
              aPacket,
              jVideoStreamIdx-1, # Store the C video stream index
              pVideoCodecContext,
              pVideoCodec,
              aVideoFrame,
              width,
              height,
              pix_fmt,
              transcode,
              int32(transcode_interpolation),
              sws_context,
              target_pix_fmt,
              bits_per_pixel,
              target_buf,
              aTargetVideoFrame,
              apTargetDataBuffers,
              apTargetLineSizes,
              aFrameFinished,
              true)
end

show(io::IO, c::AVCapture) = c.isopen ? print(io, "AVCapture(\"$(c.source)\", ...)") : print(io, "AVCapture(...) (closed)")

# Grabs and decodes a frame
function grab(c::AVCapture)
    check_isopen(c)

    pFormatContext = c.apFormatContext[1]

    got_frame = false

    while (got_frame = (av_read_frame(pFormatContext, pointer(c.aPacket)) >= 0))
        packet = c.aPacket[1]
        if packet.stream_index == c.videoStreamIdx
            avcodec_decode_video2(c.pVideoCodecContext,
                                  c.aVideoFrame,
                                  c.aFrameFinished,
                                  c.aPacket)

            have_frame(c) && (av_free_packet(pointer(c.aPacket)); break)
        end
        av_free_packet(pointer(c.aPacket))
    end

    return got_frame
end

# Converts a grabbed frame to the correct format (RGB by default)
function retrieve(c::AVCapture)
    check_isopen(c)

    if !have_frame(c)
        error("No frame available for retrieval")
    end

    pFmtDesc = av_pix_fmt_desc_get(c.target_pix_fmt)
    bits_per_pixel = av_get_bits_per_pixel(pFmtDesc)

    if bits_per_pixel % 8 != 0
        error("Unsupported video retrieval format")
    end

    if bits_per_pixel == 8
        buf = Array(Uint8, c.width, c.height)
    else
        buf = Array(Uint8, bits_per_pixel>>3, c.width, c.height)
    end

    retrieve!(c, buf)
end


# Converts a grabbed frame to the correct format (RGB by default)
function retrieve!(c::AVCapture, buf::Array{Uint8})
    check_isopen(c)

    if !bufsize_check(c, buf)
        error("Buffer is the wrong size for video image retrieval")
    end

    if !have_frame(c)
        error("No frame available for retrieval")
    end

    if pointer(buf) != c.apTargetDataBuffers[1]
        avpicture_fill(pointer(c.aTargetVideoFrame),
                       buf,
                       c.target_pix_fmt,
                       c.width, c.height)
        c.apTargetDataBuffers = reinterpret(Ptr{Uint8}, [c.aTargetVideoFrame[1].data])
        c.apTargetLineSizes   = reinterpret(Cint,       [c.aTargetVideoFrame[1].linesize])

    end

    apSourceDataBuffers = reinterpret(Ptr{Uint8}, [c.aVideoFrame[1].data])
    apSourceLineSizes   = reinterpret(Cint,       [c.aVideoFrame[1].linesize])

    Base.sigatomic_begin()
    sws_scale(c.transcode_context,
              apSourceDataBuffers,
              apSourceLineSizes,
              zero(Int32),
              c.height,
              c.apTargetDataBuffers,
              c.apTargetLineSizes)
    Base.sigatomic_end()

    reset_frame_flag!(c)

    return buf
end

function eof(c::AVCapture)
    !c.isopen && return true
    have_frame(c) && return false
    got_frame = grab(c)
    return !got_frame
end

function read(c::AVCapture)
    if !have_frame(c)
        retval = grab(c)
        !retval && throw(EOFError())
    end
    retrieve(c)
end


function read!(c::AVCapture, buf::Array{Uint8})
    if !bufsize_check(c, buf)
        error("Buffer is the wrong size for video image retrieval")
    end

    if !have_frame(c)
        retval = grab(c)
        !retval && throw(EOFError())
    end
    retrieve!(c, buf)
end

function close(c::AVCapture)
    !c.isopen && return

    avcodec_close(c.pCodecContext)
    avformat_close_input(pointer(c.apFormatContext))
    c.isopen = False
    return
end


try
    if isa(Main.Images, Module)
        # Define read and retrieve for Images
        global retrieve, retrieve!, read!, read
        for r in [:read, :retrieve]
            r! = symbol("$(r)!")

            @eval begin
                # read!, retrieve!
                $r!(c::AVCapture, img::Main.Images.Image) = $r!(c, Main.Images.data(img))

                # read, retrieve
                function $r(c::AVCapture, ::Type{Main.Images.Image}, colorspace="RGB", colordim=1, spatialorder=["x","y"])
                    img = $r(c::AVCapture)
                    Main.Images.Image(img, 
                                      colorspace=colorspace, 
                                      colordim=colordim, 
                                      spatialorder=spatialorder)
                end
            end
        end
    end
end

