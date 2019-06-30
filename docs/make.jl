using Documenter, VideoIO

ENV["TRAVIS_PULL_REQUEST"] = "true"

makedocs(
    modules = [VideoIO],
    format = Documenter.HTML(
        assets = ["assets/favicon.ico"],
        analytics = "UA-143027902-2"),
    sitename="VideoIO.jl",
    pages    = Any[
        "Introduction"             => "index.md",
        "Reading Videos"           => "reading.md",
        "Writing Videos"           => "writing.md",
        "Low Level Functionality"  => "lowlevel.md",
        "Index"                    => "functionindex.md",
        ]
    )
deploydocs(
    repo = "github.com/JuliaIO/VideoIO.jl.git",
)
