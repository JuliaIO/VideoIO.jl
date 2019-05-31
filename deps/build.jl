using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

# These are the two binary objects we care about
products = Product[
    ExecutableProduct(prefix, "ffmpeg", :ffmpeg),
    ExecutableProduct(prefix, "ffprobe", :ffprobe),
    ExecutableProduct(prefix, "x264", :x264),
    ExecutableProduct(prefix, "x265", :x265),                    

    LibraryProduct(prefix, ["libavcodec","avcodec"], :libavcodec),
    LibraryProduct(prefix, ["libavformat","avformat"], :libavformat),
    LibraryProduct(prefix, ["libavutil","avutil"], :libavutil),
    LibraryProduct(prefix, ["libswscale","swscale"], :libswscale),
    LibraryProduct(prefix, ["libavfilter","avfilter"], :libavfilter),
    LibraryProduct(prefix, ["libavdevice","avdevice"], :libavdevice),
]

dependencies = [
    "https://github.com/ianshmean/Bzip2Builder/releases/download/v1.0.6-2/build_Bzip2.v1.0.6.jl",
    #"https://github.com/JuliaPackaging/Yggdrasil/releases/download/Bzip2-v1.0.6-0/build_Bzip2.v1.0.6.jl",

    "https://github.com/ianshmean/ZlibBuilder/releases/download/v1.2.11/build_Zlib.v1.2.11.jl",
    "https://github.com/SimonDanisch/FDKBuilder/releases/download/0.1.6/build_libfdk.v0.1.6.jl",
    "https://github.com/SimonDanisch/FribidiBuilder/releases/download/0.14.0/build_fribidi.v0.14.0.jl",
    "https://github.com/JuliaGraphics/FreeTypeBuilder/releases/download/v2.9.1-4/build_FreeType2.v2.10.0.jl",
    "https://github.com/JuliaIO/LibassBuilder/releases/download/v0.14.0-2/build_libass.v0.14.0.jl",
    
    "https://github.com/JuliaIO/LAMEBuilder/releases/download/v3.100.0-2/build_liblame.v3.100.0.jl",
    
    "https://github.com/JuliaIO/OggBuilder/releases/download/v1.3.3-7/build_Ogg.v1.3.3.jl",
    "https://github.com/JuliaIO/LibVorbisBuilder/releases/download/v1.3.6-2/build_libvorbis.v1.3.6.jl",
                        
    "buildmod_LibVPX.v1.8.0.jl",
    #"https://github.com/JuliaIO/LibVPXBuilder/releases/download/v1.8.0/build_LibVPX.v1.8.0.jl",
    "https://github.com/JuliaIO/x264Builder/releases/download/v2019.5.25-static/build_x264Builder.v2019.5.25.jl",
    "https://github.com/JuliaIO/x265Builder/releases/download/v3.0.0-static/build_x265Builder.v3.0.0.jl",
    
    "buildmod_FFMPEG.v4.1.0.jl"
    #"https://github.com/JuliaIO/FFMPEGBuilder/releases/download/v4.1.0/build_FFMPEG.v4.1.0.jl"
]
                    


for dependency in dependencies
    file = joinpath(@__DIR__, basename(dependency))
    isfile(file) || download(dependency, file)
    # it's a bit faster to run the build in an anonymous module instead of
    # starting a new julia process

    # Build the dependencies
    Mod = @eval module Anon end
    Mod.include(file)
end

# First, check to see if we're all satisfied
if any(!satisfied(p; verbose=verbose) for p in products)
    # Finally, write out a deps.jl file
    write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
end
