# AVCapture

import Base: read, read!, show

export open, grab, retrieve, read, read!, close, AVCapture

import libAV.Format: 
    av_register_all, 
    avformat_open_input, 
    avformat_find_stream_info, 
    av_dump_format, 
    av_read_frame,
    avformat_close_input

import libAV.Codec: 
    avcodec_find_decoder, 
    avcodec_open2, 
    avpicture_get_size,
    avpicture_fill,
    avcodec_decode_video2, 
    av_free_packet,
    avcodec_close

import libAV.SWScale: 
    sws_getContext, 
    sws_scale


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
              transcode_interp=libAV.SWS_BILINEAR,
              target_pix_fmt=libAV.PIX_FMT_RGB24
              )
    av_register_all();

    apFormatContext = Ptr{AVFormatContext}[C_NULL]

    if avformat_open_input(pointer(apFormatContext),
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
        if jVideoStreamIdx == -1 && codec.codec_type == libAV.AVMEDIA_TYPE_VIDEO
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

    pFmtDesc = get_pix_fmt_descriptor_ptr(target_pix_fmt)
    bits_per_pixel = av_get_bits_per_pixel(pFmtDesc)

    if bits_per_pixel % 8 != 0
        error("Unsupported format (bits_per_pixel = $bits_per_pixel)")
    end

    N = int64(bits_per_pixel >> 3)
    target_buf = Array(Uint8, bits_per_pixel>>3, width, height)

    sws_context = sws_getContext(width, height, pix_fmt, 
                             width, height, target_pix_fmt,
                             libAV.SWS_BILINEAR, C_NULL, C_NULL, C_NULL)

    avpicture_fill(pointer(aTargetVideoFrame), pointer(target_buf), int32(target_pix_fmt), width, height)

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
                 int32(transcode_interp),
                 sws_context,
                 target_pix_fmt,
                 bits_per_pixel,
                 target_buf,
                 aTargetVideoFrame,
                 aFrameFinished,
                 true)
end

show(io::IO, c::AVCapture) = c.isopen ? show(io, "AVCapture(\"$(c.source)\", ...") : show(io, "AVCapture(...) (closed)")

# Grabs and decodes a frame
function grab(c::AVCapture)
    check_isopen(c)

    pFormatContext = c.apFormatContext[1]

    got_frame = false

    while (got_frame = (av_read_frame(pFormatContext, pointer(c.aPacket)) >= 0))
        packet = c.aPacket[1]
        if packet.stream_index == c.videoStreamIdx
            avcodec_decode_video2(c.pVideoCodecContext, 
                                  pointer(c.aVideoFrame), 
                                  pointer(c.aFrameFinished), 
                                  pointer(c.aPacket))

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

    pFmtDesc = get_pix_fmt_descriptor_ptr(c.target_pix_fmt)
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

    if pointer(buf) != c.aTargetVideoFrame[1].data.d1
        avpicture_fill(pointer(c.aTargetVideoFrame), 
                       pointer(buf), 
                       int32(c.target_pix_fmt), 
                       c.width, c.height)
    end

    sws_scale(c.transcode_context,
              pointer(c.aVideoFrame),
              pointer(c.aVideoFrame) + 4*sizeof(Ptr),
              zero(Int32),
              c.height,
              pointer(c.aTargetVideoFrame),
              pointer(c.aTargetVideoFrame) + 4*sizeof(Ptr))

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
        !retval && throw EOFError()
    end
    retrieve(c)
end


function read!(c::AVCapture, buf::Array{Uint8})
    if !bufsize_check(c, buf)
        error("Buffer is the wrong size for video image retrieval")
    end

    if !have_frame(c)
        retval = grab(c)
        !retval && throw EOFError()
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
        global retrieve!, read!
        retrieve!(c::AVCapture, img::Main.Images.Image) = retrieve!(c, Main.Images.data(img))
        read!(c::AVCapture, img::Main.Images.Image) = read!(c, Main.Images.data(img))
    end
end

