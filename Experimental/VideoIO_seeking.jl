
## Very early days - NOT working!

function seek_frame (I::AVInput, start_time::Int64)

    pFormatContext = I.apFormatContext[1]
    stream_index = cint(-1)
    fps = get_option(I, "frame_rate")
    seek_ts = int64(parsefloat(fps)*start_time)

    flags = AVSEEK_FLAG_BACKWARD

    if (av_seek_frame(pFormatContext,stream_index,seek_ts,flags) < 0)
        error("Failed to seek Video")
    end
end
