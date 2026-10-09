using VideoIO

function main()
    img = rand(UInt8, 64, 64)
    outdir = mktempdir()

    # Warm compilation so the task below reaches the codec-open lock promptly.
    warmup = open_video_out(joinpath(outdir, "warmup.mp4"), img)
    close_video_out!(warmup)

    lock(VideoIO.VIO_LOCK)
    writer_task = Threads.@spawn open_video_out(joinpath(outdir, "blocked.mp4"), img)
    drained = false
    try
        while !istaskstarted(writer_task)
            yield()
        end
        sleep(0.1)
        drained = VideoIO.shutdown!(; timeout_s = 0.05, poll_interval_s = 0.001)
    finally
        unlock(VideoIO.VIO_LOCK)
    end

    writer = fetch(writer_task)
    close_video_out!(writer)
    drained && error("shutdown! returned true while a writer was still opening")
    return nothing
end

main()
