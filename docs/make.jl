using Documenter, VideoIO

makedocs(
    modules = [VideoIO],
    format = Documenter.HTML(
        assets = ["assets/favicon.ico"],
        analytics = "UA-143027902-2"),
    sitename="VideoIO.jl",
    canonical = "https://juliaio.github.io/VideoIO.jl/stable/",
    pages    = Any[
        "Introduction"             => "index.md",
        "Reading Videos"           => "reading.md",
        "Writing Videos"           => "writing.md",
        "Utilities"                => "utilities.md",
        "Low Level Functionality"  => "lowlevel.md",
        "Index"                    => "functionindex.md",
        ]
    )
deploydocs(
    repo = "github.com/JuliaIO/VideoIO.jl.git",
)
