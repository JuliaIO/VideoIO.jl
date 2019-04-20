if Sys.islinux()
    # FFMPEG binaries not currently available for linux, so we resort to the BinDeps method
    include("build-linux.jl")
else
    include("build-notlinux.jl")
end