using Clang.Generators
using FFMPEG_jll
using Vulkan_Headers_jll
using LibGit2
include("rewriter.jl")

cd(@__DIR__)

# Ideally I could have loaded all headers, but it turns out to be too hard

include_dir = joinpath(FFMPEG_jll.artifact_dir, "include") |> normpath

vulkan_dir = joinpath(Vulkan_Headers_jll.artifact_dir, "include") |> normpath

if !isdir("vdpau")
    LibGit2.clone("https://gitlab.freedesktop.org/vdpau/libvdpau", joinpath(@__DIR__, "vdpau"))
end

vdpau_dir = joinpath(@__DIR__, "vdpau", "include")

options = load_options(joinpath(@__DIR__, "generate.toml"))

args = get_default_args()
push!(args, "-I$include_dir", "-isystem$vulkan_dir", "-isystem$vdpau_dir")

const module_names = [
    "libavcodec"
    "libavdevice"
    "libavfilter"
    "libavformat"
    "libavutil"
    "libswscale"
]

library_names = Dict{String,String}()
headers = String[]
for lib in module_names
    header_dir = joinpath(include_dir, lib)
    append!(headers, joinpath(header_dir, header) for header in readdir(header_dir) if endswith(header, ".h"))
    library_names[lib*".+"] = lib
end

options["general"]["library_names"] = library_names

ctx = create_context(headers, args, options)

@add_def time_t

build!(ctx, BUILDSTAGE_NO_PRINTING)
for node in ctx.dag.nodes
    for i in eachindex(node.exprs)
        node.exprs[i] = rewrite(node.exprs[i])
    end
end
build!(ctx, BUILDSTAGE_PRINTING_ONLY)
