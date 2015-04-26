using BinDeps
using Compat

@BinDeps.setup

group = library_group("libav")

deps = [
    libavcodec = library_dependency("libavcodec", aliases=[["libavcodec.","libavcodec.so.","libavcodec.ffmpeg.so.","avcodec-"].*["53" "54" "55"]...], group = group)
    libavformat = library_dependency("libavformat", aliases=[["libavformat.","libavformat.so.","libavformat.ffmpeg.so.","avformat-"].*["53" "54" "55"]...], group = group)
    libavutil = library_dependency("libavutil", aliases=[["libavutil.","libavutil.so.", "libavutil.ffmpeg.so.", "avutil-"].*["51" "52"]...], group = group)
    libswscale = library_dependency("libswscale", aliases=[["libswscale.","libswscale.so.","libswscale.ffmpeg.so.","swscale-"].*["2"]...], group = group)
    libavfilter = library_dependency("libavfilter", aliases=[["libavfilter.","libavfilter.so.","libavfilter.ffmpeg.so.","avfilter-"].*["2" "3" "4"]...], group = group)
    libavdevice = library_dependency("libavdevice", aliases=[["libavdevice.","libavdevice.so.","libavdevice.ffmpeg.so.","avdevice-"].*["53" "54" "55"]...], group = group)
]

libav_libs = [libavutil, libavcodec, libavformat, libavfilter, libswscale, libavdevice]

# if (have_avresample = dlopen_e("libavresample") != C_NULL)
#     libavresample = library_dependency("libavresample", aliases=[["libavresample.so.","avresample-"].*["1"]...], group = group)
#     push!(deps, libavresample)
# end

# if (have_swresample = dlopen_e("libswresample") != C_NULL)
#     libswresample = library_dependency("libswresample", aliases=[["libswresample.so.","libswresample.ffmpeg.so.","swresample-"].*["0"]...], group = group)
#     push!(deps, libswresample)
#     push!(libav_libs, libswresample)
# end

@windows_only begin
    provides(Binaries, URI("http://ffmpeg.zeranoe.com/builds/win$WORD_SIZE/shared/ffmpeg-2.2.3-win$WORD_SIZE-shared.7z"),
             libav_libs, 
             os = :Windows,
             unpacked_dir="ffmpeg-2.2.3-win$WORD_SIZE-shared/bin")
end

@osx_only begin
    using Homebrew
    provides( Homebrew.HB, "ffmpeg", libav_libs, os = :Darwin )
end


# System Package Managers         
apt_packages = @compat Dict(
    "libavcodec-extra-53"   => libavcodec,
    "libavcodec53"          => libavcodec,
    "libavcodec-extra-54"   => libavcodec,
    "libavcodec54"          => libavcodec,
    "libavcodec-extra-55"   => libavcodec,
    "libavcodec55"          => libavcodec,
    "libavdevice53"         => libavdevice,
    "libavfilter2"          => libavfilter,
    "libavfilter3"          => libavfilter,
    "libavfilter4"          => libavfilter,
    "libavformat53"         => libavformat,
    "libavformat54"         => libavformat,
    "libavformat55"         => libavformat,
    #"libavresample1"        => libavresample,
    "libavutil51"           => libavutil,
    "libavutil52"           => libavutil,
    "libswscale2"           => libswscale,

    ## Available from https://launchpad.net/~jon-severinsson/+archive/ubuntu/ffmpeg
    "libavcodec55-ffmpeg"   => libavcodec,
    "libavdevice55-ffmpeg"  => libavdevice,
    "libavfilter4-ffmpeg"   => libavfilter,
    "libavformat55-ffmpeg"  => libavformat,
    "libavutil52-ffmpeg"    => libavutil,
    #"libswresample0-ffmpeg" => libswresample,
    "libswscale2-ffmpeg"    => libswscale,
)

#if have_swresample
#    apt_packages["libswresample0-ffmpeg"] = libswresample
#end

#if have_avresample
#    apt_packages["libavresample1"] = libavresample
#end

provides(AptGet,
         apt_packages)

provides(Yum,
         @compat Dict("ffmpeg" => libav_libs))

provides(Pacman,
         @compat Dict("ffmpeg" => libav_libs))


provides(Sources,
         URI("http://www.ffmpeg.org/releases/ffmpeg-2.3.2.tar.gz"), 
         libav_libs)

provides(BuildProcess, Autotools(configure_options=["--enable-gpl"]), libav_libs, os = :Unix)

@BinDeps.install @compat Dict(
    :libavcodec => :libavcodec,
    :libavformat => :libavformat,
    :libavutil => :libavutil,
    :libswscale => :libswscale,
    :libavfilter => :libavfilter,
    :libavdevice => :libavdevice
)
