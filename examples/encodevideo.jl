# Based on https://www.ffmpeg.org/doxygen/trunk/encode_video_8c-example.html
#=
 * Copyright (c) 2001 Fabrice Bellard
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
=#

using VideoIO, Printf

"""
encode(enc_ctx::Ptr{VideoIO.AVCodecContext}, frame, pktptr::Ptr{VideoIO.AVPacket}, io::IO)

Append and encode frame to output.
"""
function encode(enc_ctx::Ptr{VideoIO.AVCodecContext},
    frame, pktptr::Ptr{VideoIO.AVPacket}, io::IO)
    ret = VideoIO.avcodec_send_frame(enc_ctx, frame)
    if ret < 0
        error("Error $ret sending a frame for encoding")
    end

    while ret >= 0
        ret = VideoIO.avcodec_receive_packet(enc_ctx, pktptr)
        if (ret == -35 || ret == -541478725) # -35=EAGAIN -541478725=AVERROR_EOF
             return
        elseif (ret < 0)
            error("Error $ret during encoding")
        end
        pkt = unsafe_load(pktptr)
        println("Write packet $(pkt.pts) (size=$(pkt.size))")
        data = unsafe_wrap(Array,pkt.data,pkt.size)
        write(io,data)
        VideoIO.av_packet_unref(pktptr)
    end
end

filename = "video.h264"
codec_name = "libx264"

c = VideoIO.AVCodecContext[]

endcode = UInt8[0, 0, 1, 0xb7]

codec = VideoIO.avcodec_find_encoder_by_name(codec_name)
if codec == C_NULL
    error("Codec '$codec_name' not found")
end

c = Ptr{VideoIO.AVCodecContext}[VideoIO.avcodec_alloc_context3(codec)]
if c == [C_NULL]
    error("Could not allocate video codec context")
end

pktptr = Ptr{VideoIO.AVPacket}[VideoIO.av_packet_alloc()]
if pktptr == [C_NULL]
    error("av_packet_alloc() error")
end

codecContext = unsafe_load(c[1])

# put sample parameters
codecContext.bit_rate = 400000
#resolution must be a multiple of two
codecContext.width = 352
codecContext.height = 288
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

unsafe_store!(c[1], codecContext)

codec_loaded = unsafe_load(codec)
if codec_loaded.id == VideoIO.AV_CODEC_ID_H264
    VideoIO.av_opt_set(codecContext.priv_data, "preset", "slow", 0)
end
# open it
ret = VideoIO.avcodec_open2(c[1], codec, C_NULL)
if ret < 0
    error("Could not open codec: $(av_err2str(ret))")
end
f = open(filename,"w")
frameptr = Ptr{VideoIO.AVFrame}[VideoIO.av_frame_alloc()]
if frameptr == [C_NULL]
    error("Could not allocate video frame")
end
frame = unsafe_load(frameptr[1])
frame.format = codecContext.pix_fmt
frame.width  = codecContext.width
frame.height = codecContext.height
unsafe_store!(frameptr[1],frame)

ret = VideoIO.av_frame_get_buffer(frameptr[1], 32)
if ret < 0
    error("Could not allocate the video frame data")
end

# frame_fields = map(x->fieldname(VideoIO.AVUtil.AVFrame,x),1:fieldcount(VideoIO.AVUtil.AVFrame))
# pos_data = findfirst(fields.==:data)

for i = 0:240
    flush(stdout)

    ret = VideoIO.av_frame_make_writable(frameptr[1])
    if ret < 0
        error("av_frame_make_writable() error")
    end

    #im_YCbCr = convert.(YCbCr{Float64}, image)

    frame = unsafe_load(frameptr[1]) #grab data from c memory
    framedata_1 = unsafe_wrap(Array,frame.data[1],Int64(frame.height*frame.width),own=false)
    framedata_2 = unsafe_wrap(Array,frame.data[2],Int64((frame.height*frame.width)/2),own=false)
    framedata_3 = unsafe_wrap(Array,frame.data[3],Int64((frame.height*frame.width)/2),own=false)

    for y = 1:frame.height
        for x = 1:frame.width
            #framedata_1[((y-1)*frame.linesize[1])+(x)] = UInt8(clamp(0,255,x + y + i * 3))
            framedata_1[((y-1)*frame.linesize[1])+x] = rand(UInt8)
        end
    end
    for y = 1:Int64(frame.height/2)
        for x = 1:Int64(frame.width/2)
            # framedata_2[((y-1)*frame.linesize[2])+(x)] = UInt8(clamp(0,255,128 + y + i * 2))
            # framedata_3[((y-1)*frame.linesize[3])+(x)] = UInt8(clamp(0,255,64 + x + i * 5))
            framedata_2[((y-1)*frame.linesize[2])+x] = rand(UInt8)
            framedata_3[((y-1)*frame.linesize[3])+x] = rand(UInt8)
        end
    end

    frame.pts = i
    unsafe_store!(frameptr[1],frame) #pass data back to c memory

    encode(c[1], frameptr[1], pktptr[1], f)
    println(i)
end

# flush the encoder
encode(c[1], C_NULL, pktptr[1], f);
# add sequence end code to have a real MPEG file
write(f,endcode)
close(f)

VideoIO.avcodec_free_context(c)
VideoIO.av_frame_free(frameptr)
VideoIO.av_packet_free(pktptr)
