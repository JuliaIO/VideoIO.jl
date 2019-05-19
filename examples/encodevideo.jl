# Based on https://www.ffmpeg.org/doxygen/trunk/encode_video_8c-example.html
using VideoIO, Printf

"""
encode(enc_ctx::Ptr{VideoIO.AVCodecs.AVCodecContext}, frame::AVFrame, pkt::AVPacket, output::String)

Append and encode frame to output.
"""
function encode(enc_ctx::Ptr{VideoIO.AVCodecContext},
    frame, pktptr::Ptr{VideoIO.AVPacket}, io::IO)
    ret = VideoIO.avcodec_send_frame(enc_ctx, frame)
    if ret < 0
        @show ret
        error("Error sending a frame for encoding")
    end

    while ret >= 0
        ret = VideoIO.avcodec_receive_packet(enc_ctx, pktptr)
        #if (ret == VideoIO.AVERROR(EAGAIN) || ret == VideoIO.AVERROR_EOF)
        if (ret == -35 || ret == -541478725)
             return
        elseif (ret < 0)
            error("Error $ret during encoding")
        end
        pkt = unsafe_load(pktptr)
        @sprintf("Write packet %3d (size=%5d)", pkt.pts, pkt.size)
        data = unsafe_load(pkt.data)
        write(io,data)
        VideoIO.av_packet_unref(pktptr)
    end
end

####
# Dummy video (vector of images)
video = Vector{Array{UInt8}}(undef,0)
for i = 1:100
    push!(video,rand(UInt8,150,200))
end

##
filename = "video.mp4"
codec_name = "libx264"

c = VideoIO.AVCodecContext[]

frame = [VideoIO.AVFrame()]
pkt = [VideoIO.AVPacket()]
endcode = UInt8[0, 0, 1, 0xb7]

codec = VideoIO.avcodec_find_encoder_by_name(codec_name)
if codec == C_NULL
    error("Codec '$codec_name' not found")
end

c = VideoIO.avcodec_alloc_context3(codec)
#c = Ptr{VideoIO.AVCodecContext}[VideoIO.avcodec_alloc_context3(codec)]
if c == C_NULL
    error("Could not allocate video codec context")
end

pktptr = VideoIO.av_packet_alloc()
#pkt = Ptr{VideoIO.AVPacket}[VideoIO.av_packet_alloc()]
if pktptr == C_NULL
    error("av_packet_alloc() error")
end

codecContext = unsafe_load(c)

# put sample parameters
codecContext.bit_rate = 400000
#resolution must be a multiple of two
codecContext.width = size(video[1],1)
codecContext.height = size(video[1],2)
# frames per second
codecContext.time_base = VideoIO.AVRational(1, 25)
codecContext.framerate = VideoIO.AVRational(25, 1)
#= emit one intra frame every ten frames
 * check frame pict_type before passing frame
 * to encoder, if frame->pict_type is AV_PICTURE_TYPE_I
 * then gop_size is ignored and the output of encoder
 * will always be I frame irrespective to gop_size
=#
codecContext.gop_size = 10
codecContext.max_b_frames = 1
codecContext.pix_fmt = VideoIO.AV_PIX_FMT_YUV420P

unsafe_store!(c, codecContext, 1)

codec_loaded = unsafe_load(codec)
if codec_loaded.id == VideoIO.AV_CODEC_ID_H264
    VideoIO.av_opt_set(codecContext.priv_data, "preset", "slow", 0)
end
# open it
ret = VideoIO.avcodec_open2(c, codec, C_NULL)
if ret == C_NULL
    error("Could not open codec: $(av_err2str(ret))")
end
f = open(filename,"w")
frameptr = VideoIO.av_frame_alloc()
if frameptr == C_NULL
    error("Could not allocate video frame")
end
frame = unsafe_load(frameptr)
frame.format = codecContext.pix_fmt
frame.width  = codecContext.width
frame.height = codecContext.height
unsafe_store!(frameptr,frame,1)

ret = VideoIO.av_frame_get_buffer(frameptr, 32)
if ret == C_NULL
    error("Could not allocate the video frame data")
end

i = 0
for image in video
    global i
    ret = VideoIO.av_frame_make_writable(frameptr)
    if ret == C_NULL
        error("av_frame_make_writable() error")
    end
    frame = unsafe_load(frameptr)
    #framedata = reinterpret(Ptr{UInt8}, [frame.data])

    for x = 1:length(image[:])
        unsafe_store!(frame.data[1],image[x],x)
    end
    #frame.data[1] = image[:]

    frame.pts = i
    unsafe_store!(frameptr,frame)
    encode(c, frameptr, pktptr, f)
    @show i
    i += 1
end

# flush the encoder
encode(c, C_NULL, pktptr, f);
# add sequence end code to have a real MPEG file
write(f,endcode)
close(f)
VideoIO.avcodec_free_context(c)
VideoIO.av_frame_free(frameptr)
VideoIO.av_packet_free(pktptr)
