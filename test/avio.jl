using Test
using ColorTypes: RGB, Gray, N0f8, red, green, blue
import ColorVectorSpace
using FileIO, ImageCore, Dates, Statistics, StatsBase

import FFMPEG

import VideoIO

const testdir = dirname(@__FILE__)
const videodir = joinpath(testdir, "..", "videos")
const tempvidname = "testvideo.mp4"
const tempvidpath = joinpath(tempdir(), tempvidname)
const required_accuracy = 0.07

VideoIO.TestVideos.available()
VideoIO.TestVideos.download_all()

include("utils.jl") # Testing utility functions

include("avptr.jl")
include("reading.jl")
include("writing.jl")
include("accuracy.jl")

GC.gc()
rm(tempvidpath, force = true)

include("bugs.jl")

#VideoIO.TestVideos.remove_all()
