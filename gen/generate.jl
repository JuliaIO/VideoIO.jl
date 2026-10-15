using Clang.Generators
using FFMPEG_jll
using Vulkan_Headers_jll
using OpenCL_Headers_jll
using LibGit2
using Pkg.Artifacts, Base.BinaryPlatforms
include("rewriter.jl")

cd(@__DIR__)

# Ideally I could have loaded all headers, but it turns out to be too hard

include_dir = joinpath(FFMPEG_jll.artifact_dir, "include") |> normpath

vulkan_dir = joinpath(Vulkan_Headers_jll.artifact_dir, "include") |> normpath

if !isdir("vdpau")
    LibGit2.clone("https://gitlab.freedesktop.org/vdpau/libvdpau", joinpath(@__DIR__, "vdpau"))
end

vdpau_dir = joinpath(@__DIR__, "vdpau", "include")

opencl_dir = joinpath(OpenCL_Headers_jll.artifact_dir, "include") |> normpath

# libva is Linux-only, so take its headers from the Linux artifact whatever the host platform
libva_pkg = Base.PkgId(Base.UUID("9a156e7d-b971-5f62-b2c9-67348b8fb97c"), "libva_jll")
libva_toml = joinpath(dirname(dirname(Base.locate_package(libva_pkg))), "Artifacts.toml")

options = load_options(joinpath(@__DIR__, "generate.toml"))
# One bindings file per FFmpeg major version, since struct layouts and enum values change between them
options["general"]["output_file_path"] = "../lib/libffmpeg_$(pkgversion(FFMPEG_jll).major).jl"

# Parse for Linux on any host: some headers pick different includes on macOS (e.g. OpenCL)
args = get_default_args("x86_64-linux-gnu")
libva_dir = joinpath(ensure_artifact_installed("libva", libva_toml; platform = Platform("x86_64", "linux")), "include")
push!(args, "-I$include_dir", "-isystem$vulkan_dir", "-isystem$vdpau_dir", "-isystem$opencl_dir", "-isystem$libva_dir")

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
