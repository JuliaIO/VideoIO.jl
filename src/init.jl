## convenient way to get library information
using BinaryProvider

# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    println("Deps path: $depsjl_path")
    error("VideoIO not installed properly, run Pkg.build(\"VideoIO\"), restart Julia and try again")
end
include(depsjl_path)

include("version.jl")

av_load_path = joinpath(dirname(@__FILE__), "ffmpeg")
