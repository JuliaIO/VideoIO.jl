using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

# These are the two binary objects we care about
products = Product[
    ExecutableProduct(prefix, "ffmpeg", :ffmpeg),
    ExecutableProduct(prefix, "ffprobe", :ffprobe),
    #ExecutableProduct(prefix, "ffplay", :ffplay),

    LibraryProduct(prefix, ["libavcodec","avcodec"], :libavcodec),
    LibraryProduct(prefix, ["libavformat","avformat"], :libavformat),
    LibraryProduct(prefix, ["libavutil","avutil"], :libavutil),
    LibraryProduct(prefix, ["libswscale","swscale"], :libswscale),
    LibraryProduct(prefix, ["libavfilter","avfilter"], :libavfilter),
    LibraryProduct(prefix, ["libavdevice","avdevice"], :libavdevice),
]

# Download binaries from hosted location
v = "4.1"
bin_prefix = "https://github.com/ianshmean/FFMPEG-tarballs/raw/master/$v/bin"

download_info = Dict(
    #Linux(:aarch64, :glibc) => ("$bin_prefix/ffmpeg-$v-aarch64-linux-gnu.tar.gz", ""),
    #Linux(:armv7l, :glibc)  => ("$bin_prefix/ffmpeg-$v-arm-linux-gnueabihf.tar.gz", ""),
    #Linux(:powerpc64le, :glibc) => ("$bin_prefix/ffmpeg-$v-powerpc64le-linux-gnu.tar.gz", ""),
    Linux(:i686, :glibc)    => ("$bin_prefix/FFMPEG.v4.1.0.i686-linux-gnu.tar.gz", "490fa758cd50ce0c93f14f7ccbf2e36bf43b6ffbd8b579fa5a4ecd684273e98a"),                   
    Linux(:x86_64, :glibc)  => ("$bin_prefix/FFMPEG.v4.1.0.x86_64-linux-gnu.tar.gz", "b64de49de3a87105774958f6796a0411b43acce6b4e53c76e42b6ffb6a481182"),
                        
    #Linux(:x86_64, :glibc)  => ("$bin_prefix/ffmpeg-$v-86_64-linux-gnu-full.tar.gz", "683249e7450a18a13f7a896b4abd6b92abff77ddeb3640ad10fe48bb7723f4fc"),

    #Linux(:aarch64, :musl)  => ("$bin_prefix/ffmpeg-$v-aarch64-linux-musl.tar.gz", ""),
    #Linux(:armv7l, :musl)   => ("$bin_prefix/ffmpeg-$v-arm-linux-musleabihf.tar.gz", ""),
    #Linux(:i686, :musl)     => ("$bin_prefix/ffmpeg-$v-i686-linux-musl.tar.gz", ""),
    #Linux(:x86_64, :musl)   => ("$bin_prefix/ffmpeg-$v-x86_64-linux-musl.tar.gz", ""),

    #FreeBSD(:x86_64)        => ("$bin_prefix/ffmpeg-$v.x86_64-unknown-freebsd11.1.tar.gz", ""),
    #MacOS(:x86_64)          => ("$bin_prefix/ffmpeg-$v-macos64-shared.tar.gz", "04849d77a027320e53ef2585bcf5b545e094b5c363d39d2b01dfd35ad337c390"),

    #Windows(:i686)          => ("$bin_prefix/ffmpeg-$v-win32-shared.tar.gz", "3d6486189953a8f9af14190fdcf43a3216654ee0d64a741b6e108b7d8f7039e5"),
    #Windows(:x86_64)        => ("$bin_prefix/ffmpeg-$v-win64-shared.tar.gz", "19191f33c2ffd437fde8d61cb65724d672389e4522716496829a4a7366a5bf76"),
)
dependencies = [
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Bzip2-v1.0.6-0/build_Bzip2.v1.0.6.jl",
    "https://github.com/ianshmean/ZlibBuilder/releases/download/v1.2.11/build_Zlib.v1.2.11.jl",
    "https://github.com/SimonDanisch/FDKBuilder/releases/download/0.1.6/build_libfdk.v0.1.6.jl",
    "https://github.com/SimonDanisch/FribidiBuilder/releases/download/0.14.0/build_fribidi.v0.14.0.jl",
    "https://github.com/JuliaGraphics/FreeTypeBuilder/releases/download/v2.9.1-4/build_FreeType2.v2.10.0.jl",
    "https://github.com/JuliaIO/LibassBuilder/releases/download/v0.14.0-2/build_libass.v0.14.0.jl",
    
    "https://github.com/JuliaIO/LAMEBuilder/releases/download/v3.100.0-2/build_liblame.v3.100.0.jl",
    
    "https://github.com/JuliaIO/OggBuilder/releases/download/v1.3.3-7/build_Ogg.v1.3.3.jl",
    "https://github.com/JuliaIO/LibVorbisBuilder/releases/download/v1.3.6-2/build_libvorbis.v1.3.6.jl",

    "https://github.com/JuliaIO/LibVPXBuilder/releases/download/v1.8.0/build_LibVPX.v1.8.0.jl",
    "https://github.com/JuliaIO/x264Builder/releases/download/v2019.5.25-static/build_x264Builder.v2019.5.25.jl",
    "https://github.com/JuliaIO/x265Builder/releases/download/v3.0.0-static/build_x265Builder.v3.0.0.jl",

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
    try
        # Download and install binaries
        url, tarball_hash = choose_download(download_info)
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    catch e
        if typeof(e) <: ArgumentError || typeof(e) <: MethodError
            error("Your platform $(Sys.MACHINE) is not supported by this package!")
        else
            rethrow(e)
        end
    end

    # Finally, write out a deps.jl file
    write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
end
