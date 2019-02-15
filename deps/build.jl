using BinaryProvider

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

#N.B. The FFMPEG binaries not sourced from BinaryProvider have libs in bin, so the BinaryProvider structure was conformed
libpath = joinpath(@__DIR__, "usr/bin")
                        
# These are the two binary objects we care about
products = Product[
    ExecutableProduct(prefix, "ffmpeg", :ffmpeg),
    ExecutableProduct(prefix, "ffprobe", :ffprobe),
    #ExecutableProduct(prefix, "ffplay", :ffplay),

    LibraryProduct(libpath, ["libavcodec","avcodec"], :libavcodec),
    LibraryProduct(libpath, ["libavformat","avformat"], :libavformat),
    LibraryProduct(libpath, ["libavutil","avutil"], :libavutil),
    LibraryProduct(libpath, ["libswscale","swscale"], :libswscale),
    LibraryProduct(libpath, ["libavfilter","avfilter"], :libavfilter),
    LibraryProduct(libpath, ["libavdevice","avdevice"], :libavdevice),
]

# Download binaries from hosted location
v = "4.1"
bin_prefix = "https://github.com/ianshmean/FFMPEG-tarballs/raw/master/$v/bin"
                    
download_info = Dict(
    #Linux(:aarch64, :glibc) => ("$bin_prefix/ffmpeg-$v-aarch64-linux-gnu.tar.gz", ""),
    #Linux(:armv7l, :glibc)  => ("$bin_prefix/ffmpeg-$v-arm-linux-gnueabihf.tar.gz", ""),
    #Linux(:powerpc64le, :glibc) => ("$bin_prefix/ffmpeg-$v-powerpc64le-linux-gnu.tar.gz", ""),
    #Linux(:i686, :glibc)    => ("$bin_prefix/ffmpeg-$v-i686-linux-gnu.tar.gz", ""),
    Linux(:x86_64, :glibc)  => ("$bin_prefix/ffmpeg-4.1-86_64-linux-gnu.tar.gz", "7d1199e95f8a81b6e3fa6fd6584ca6f419847f6d4f5a5dc83656cd46e84a51fb"),

    #Linux(:aarch64, :musl)  => ("$bin_prefix/ffmpeg-$v-aarch64-linux-musl.tar.gz", ""),
    #Linux(:armv7l, :musl)   => ("$bin_prefix/ffmpeg-$v-arm-linux-musleabihf.tar.gz", ""),
    #Linux(:i686, :musl)     => ("$bin_prefix/ffmpeg-$v-i686-linux-musl.tar.gz", ""),
    #Linux(:x86_64, :musl)   => ("$bin_prefix/ffmpeg-$v-x86_64-linux-musl.tar.gz", ""),

    #FreeBSD(:x86_64)        => ("$bin_prefix/ffmpeg-$v.x86_64-unknown-freebsd11.1.tar.gz", ""),
    MacOS(:x86_64)          => ("$bin_prefix/ffmpeg-$v-macos64-shared.tar.gz", "04849d77a027320e53ef2585bcf5b545e094b5c363d39d2b01dfd35ad337c390"),

    Windows(:i686)          => ("$bin_prefix/ffmpeg-$v-win32-shared.tar.gz", "3d6486189953a8f9af14190fdcf43a3216654ee0d64a741b6e108b7d8f7039e5"),
    Windows(:x86_64)        => ("$bin_prefix/ffmpeg-$v-win64-shared.tar.gz", "19191f33c2ffd437fde8d61cb65724d672389e4522716496829a4a7366a5bf76"),
)
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
