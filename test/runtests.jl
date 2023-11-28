using Test
using ColorTypes: RGB, Gray, N0f8, red, green, blue
using ColorVectorSpace: ColorVectorSpace
using FileIO, ImageCore, Dates, Statistics, StatsBase
using Profile

using FFMPEG: FFMPEG

using VideoIO: VideoIO

const testdir = dirname(@__FILE__)
const videodir = VideoIO.TestVideos.videodir
const tempvidname = "testvideo.mp4"
const tempvidpath = joinpath(tempdir(), tempvidname)
const required_accuracy = 0.07

# VideoIO.TestVideos.available()
VideoIO.TestVideos.download_all()

include("utils.jl") # Testing utility functions

memory_profiling = get(ENV, "VIDEOIO_MEMPROFILE", "false") === "true" && Base.thisminor(Base.VERSION) >= v"1.9"
start_time = time()

@memory_profile

@testset "VideoIO" verbose = true begin
    include("avptr.jl")
    @memory_profile
    include("reading.jl")
    @memory_profile
    include("writing.jl")
    @memory_profile
    include("accuracy.jl")
    @memory_profile

    GC.gc()
    rm(tempvidpath, force = true)

    include("bugs.jl")
    @memory_profile
end
#VideoIO.TestVideos.remove_all()
