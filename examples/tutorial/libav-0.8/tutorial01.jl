# Fail fast if we need args
if !isinteractive() && length(ARGS) < 1
    error("Please provide an input video.")
end

using AV
import AV.Format: 
    av_register_all, 
    avformat_open_input, 
    avformat_find_stream_info, 
    av_dump_format, 
    av_read_frame,
    avformat_close_input

import AV.Codec: 
    avcodec_find_decoder, 
    avcodec_open2, 
    avpicture_get_size,
    avpicture_fill,
    avcodec_decode_video2, 
    av_free_packet,
    avcodec_close

import AV.SWScale: 
    sws_getContext, 
    sws_scale

import Images
import ImageView


function show_vid(sample_file)
    av_register_all();

    apFormatCtx = Ptr{AVFormatContext}[C_NULL]

    if avformat_open_input(pointer(apFormatCtx),
                           sample_file,
                           C_NULL,
                           C_NULL)    != 0
        error("Could not open file $sample_file")
    end
    pFormatCtx = apFormatCtx[1]

    if avformat_find_stream_info(pFormatCtx, C_NULL) < 0
        error("Couldn't find stream information")
    end

    av_dump_format(pFormatCtx, 0, sample_file, 0);

    formatCtx = unsafe_load(pFormatCtx);

    streams = AVStream[]
    codecCtxs = AVCodecContext[]

    videoStream = -1
    cVideoStream = -1

    # Load streams, codec_contexts
    for i = 1:formatCtx.nb_streams
        pStream = unsafe_load(formatCtx.streams,i)
        stream = unsafe_load(pStream)
        push!(streams, stream)
        codec = unsafe_load(stream.codec)
        push!(codecCtxs, codec)
        if videoStream == -1 && codec.codec_type == AV.AVMEDIA_TYPE_VIDEO
            videoStream = i
            cVideoStream = i-1  # C index, for later comparison
        end
    end

    if videoStream == -1
        error("Didn't find a video stream")
    end
    
    # Get a pointer to the codec context for the video stream
    pCodecCtx = streams[videoStream].codec
    codecCtx = codecCtxs[videoStream]

    width, height = codecCtx.width, codecCtx.height
    pix_fmt = codecCtx.pix_fmt

    # Find the decoder for the video stream
    pCodec=avcodec_find_decoder(codecCtx.codec_id)

    if pCodec == C_NULL
        error("Unsupported Video Codec")
    end

    if avcodec_open2(pCodecCtx, pCodec, C_NULL) < 0
        error("Could not open codec")
    end

    aFrame = [AVFrame()]
    aFrameRGB = [AVFrame()]

    # pFmtDesc = get_pix_fmt_descriptor_ptr(AV.PIX_FMT_RGB24)
    # bits_per_pixel = av_get_bits_per_pixel(pFmtDesc)
    # buffer = Array(Uint8, bits_per_pixel>>3, codecCtx.width, codecCtx.height)

    numBytes = avpicture_get_size(AV.PIX_FMT_RGB24, width, height);
    rgb_buffer = Array(Uint8, 3, width, height)

    sws_ctx = sws_getContext(width, height, pix_fmt, 
                             width, height, AV.PIX_FMT_RGB24,
                             AV.SWS_BILINEAR, C_NULL, C_NULL, C_NULL)

    avpicture_fill(pointer(aFrameRGB), pointer(rgb_buffer), int32(AV.PIX_FMT_RGB24), width, height)

    aPacket = [AVPacket()]

    aFrameFinished = Int32[0]

    i = 0
    first = true
    while av_read_frame(pFormatCtx, pointer(aPacket)) >= 0
        packet = aPacket[1]
        if packet.stream_index == cVideoStream
            avcodec_decode_video2(pCodecCtx, pointer(aFrame), pointer(aFrameFinished), pointer(aPacket))

            frameFinished = aFrameFinished[1]
            if frameFinished > 0

                # i%10 == 0 && println("finished frame $i")

                sws_scale(sws_ctx, 
                          pointer(aFrame),
                          pointer(aFrame) + 4*sizeof(Ptr),
                          zero(Int32),
                          height,
                          pointer(aFrameRGB),
                          pointer(aFrameRGB) + 4*sizeof(Ptr))

                img = Images.Image(rgb_buffer, {"colordim" => 1, "colorspace" => "RGB", "spatialorder" => ["x", "y"]})

                if first
                    first = false
                    (canvas, _) = ImageView.display(img)
                else
                    ImageView.display(canvas, img)
                end

                i += 1
            end
        end
        av_free_packet(pointer(aPacket))
    end

    av_free_packet(pointer(aPacket))
    avcodec_close(pCodecCtx)
    avformat_close_input(pointer(apFormatCtx))
end

function main(args)
    if length(args) < 1
        error("Please provide an input video.")
    end

    for arg in args
        show_vid(arg)
    end
end

if !isinteractive()
    main(ARGS)
end
