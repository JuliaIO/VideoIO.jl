using Documenter, VideoIO

makedocs(
    modules = [VideoIO],
    format = Documenter.HTML(
        assets = ["assets/favicon.ico"],
        analytics = "UA-143027902-2",
        canonical = "https://juliaio.github.io/VideoIO.jl/stable/",
    ),
    sitename = "VideoIO.jl",
    pages = Any[
        "Introduction"=>"index.md",
        "Reading Videos"=>"reading.md",
        "Writing Videos"=>"writing.md",
        "Utilities"=>"utilities.md",
        "Low Level Functionality"=>"lowlevel.md",
        "FFmpeg Reference"=>"ffmpeg_reference.md",
        "Index"=>"functionindex.md",
    ],
    warnonly = :missing_docs,
)
deploydocs(repo = "github.com/JuliaIO/VideoIO.jl.git", push_preview = true)
