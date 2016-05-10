# Fail fast if we need args
if !isinteractive() && length(ARGS) < 1
    error("Please provide an input video.")
end

import Images
import ImageView
import VideoIO

function show_vid(sample_file)
    VideoIO.av_register_all();

    apFormatCtx = Ptr{VideoIO.AVFormatContext}[C_NULL]

    if VideoIO.avformat_open_input(apFormatCtx,
                              sample_file,
                              C_NULL,
                              C_NULL)    != 0
        error("Could not open file $sample_file")
    end
    pFormatCtx = apFormatCtx[1]

    if VideoIO.avformat_find_stream_info(pFormatCtx, C_NULL) < 0
        error("Couldn't find stream information")
    end

    VideoIO.av_dump_format(pFormatCtx, 0, sample_file, 0);

    formatCtx = unsafe_load(pFormatCtx);

    streams = VideoIO.AVStream[]
    codecCtxs = VideoIO.AVCodecContext[]

    videoStream = -1
    cVideoStream = -1
    framerate = 30.0

    # Load streams, codec_contexts
    for i = 1:formatCtx.nb_streams
        pStream = unsafe_load(formatCtx.streams,i)
        stream = unsafe_load(pStream)
        push!(streams, stream)
        codec = unsafe_load(stream.codec)
        push!(codecCtxs, codec)
        if videoStream == -1 && codec.codec_type == VideoIO.AVMEDIA_TYPE_VIDEO
            videoStream = i
            cVideoStream = i-1  # C index, for later comparison
            framerate = codec.time_base.den / codec.time_base.num
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
    pCodec=VideoIO.avcodec_find_decoder(codecCtx.codec_id)

    if pCodec == C_NULL
        error("Unsupported Video Codec")
    end

    if VideoIO.avcodec_open2(pCodecCtx, pCodec, C_NULL) < 0
        error("Could not open codec")
    end

    aFrame = [VideoIO.AVFrame()]
    aFrameRGB = [VideoIO.AVFrame()]

    # pFmtDesc = get_pix_fmt_descriptor_ptr(VideoIO.PIX_FMT_RGB24)
    # bits_per_pixel = VideoIO.av_get_bits_per_pixel(pFmtDesc)
    # buffer = Array(UInt8, bits_per_pixel>>3, codecCtx.width, codecCtx.height)

    numBytes = VideoIO.avpicture_get_size(VideoIO.PIX_FMT_RGB24, width, height);
    rgb_buffer = Array(UInt8, 3, width, height)

    sws_ctx = VideoIO.sws_getContext(width, height, pix_fmt, 
                                width, height, VideoIO.PIX_FMT_RGB24,
                                VideoIO.SWS_BILINEAR, C_NULL, C_NULL, C_NULL)

    VideoIO.avpicture_fill(aFrameRGB, rgb_buffer, VideoIO.PIX_FMT_RGB24, width, height)
    apRGBData     = reinterpret(Ptr{UInt8}, [aFrameRGB[1].data])
    apRGBLinesize = reinterpret(Cint,       [aFrameRGB[1].linesize])

    aPacket = [VideoIO.AVPacket()]

    aFrameFinished = Int32[0]
    
    i = 0
    first = true
    while VideoIO.av_read_frame(pFormatCtx, aPacket) >= 0
        packet = aPacket[1]
        if packet.stream_index == cVideoStream
            VideoIO.avcodec_decode_video2(pCodecCtx, aFrame, aFrameFinished, aPacket)

            frameFinished = aFrameFinished[1]
            if frameFinished > 0

                #i%10 == 0 && 
                println("finished frame $i")

                apData     = reinterpret(Ptr{UInt8}, [aFrame[1].data])
                apLinesize = reinterpret(Cint,       [aFrame[1].linesize])

                # println(apRGBData)
                # println(apRGBLinesize)
                # println(pointer(rgb_buffer))
                # println()

                VideoIO.sws_scale(sws_ctx, 
                             apData,
                             apLinesize,
                             zero(Int32),
                             height,
                             apRGBData,
                             apRGBLinesize)

                # println(rgb_buffer[1:20])
                
                img = Images.Image(rgb_buffer, {"colordim" => 1, "colorspace" => "RGB", "spatialorder" => ["x", "y"]})

                if first
                    first = false
                    (canvas, _) = ImageView.view(img)
                else
                    ImageView.view(canvas, img)
                end
                sleep(1/framerate)

                i += 1
            end
        end
        VideoIO.av_free_packet(aPacket)
    end

    VideoIO.av_free_packet(aPacket)
    VideoIO.avcodec_close(pCodecCtx)
    VideoIO.avformat_close_input(apFormatCtx)
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
