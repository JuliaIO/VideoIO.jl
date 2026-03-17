using VideoIO

img = rand(UInt8, 64, 64)
outdir = mktempdir()

# Loop encoding on a background thread to keep the race window open
Threads.@spawn begin
    while true
        open_video_out(
            joinpath(outdir, "out.mp4"),
            img;
            framerate = 30,
            encoder_options = (color_range = 2, crf = 0, preset = "ultrafast"),
        ) do video_io
            for _ in 1:30
                VideoIO.write(video_io, rand(UInt8, 64, 64))
            end
        end
    end
end

# Hammer GC while the background thread is mid-encode to maximise finalizer races
for _ in 1:10
    sleep(0.2)
    GC.gc(true)
end
exit(0)
