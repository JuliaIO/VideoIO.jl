using BinDeps

@BinDeps.setup

group = library_group("libav")

libavcodec = library_dependency("libavcodec", aliases=[["libavcodec-ffmpeg.so.","libavcodec.","libavcodec.so.","libavcodec.ffmpeg.so.","avcodec-"].*["53" "54" "55" "56" "57" "58"]...], group = group)
libavformat = library_dependency("libavformat", aliases=[["libavformat-ffmpeg.so.","libavformat.","libavformat.so.","libavformat.ffmpeg.so.","avformat-"].*["53" "54" "55" "56" "57" "58"]...], group = group)
libavutil = library_dependency("libavutil", aliases=[["libavutil-ffmpeg.so.", "libavutil.","libavutil.so.", "libavutil.ffmpeg.so.", "avutil-"].*["51" "52" "54" "55" "56"]...], group = group)
libswscale = library_dependency("libswscale", aliases=[["libswscale-ffmpeg.so.","libswscale.","libswscale.so.","libswscale.ffmpeg.so.","swscale-"].*["2" "3" "4" "5"]...], group = group)
libavfilter = library_dependency("libavfilter", aliases=[["libavfilter-ffmpeg.so.","libavfilter.","libavfilter.so.","libavfilter.ffmpeg.so.","avfilter-"].*["2" "3" "4" "5" "6" "7"]...], group = group)
libavdevice = library_dependency("libavdevice", aliases=[["libavdevice-ffmpeg.so.","libavdevice.","libavdevice.so.","libavdevice.ffmpeg.so.","avdevice-"].*["53" "54" "55" "56" "57" "58"]...], group = group)

deps = [libavcodec, libavformat, libavutil, libswscale, libavfilter, libavdevice]
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

if Sys.iswindows()
    provides(Binaries, URI("http://ffmpeg.zeranoe.com/builds/win$(Sys.WORD_SIZE)/shared/ffmpeg-4.1-win$(Sys.WORD_SIZE)-shared.zip"),
             libav_libs,
             os = :Windows,
             unpacked_dir="ffmpeg-4.1-win$(Sys.WORD_SIZE)-shared/bin")
end

if Sys.isapple()
    using Homebrew
    provides( Homebrew.HB, "ffmpeg", libav_libs, os = :Darwin )
end


# System Package Managers
apt_packages = Dict(
    "libavcodec-extra-53"   => libavcodec,
    "libavcodec53"          => libavcodec,
    "libavcodec-extra-54"   => libavcodec,
    "libavcodec54"          => libavcodec,
    "libavcodec-extra-55"   => libavcodec,
    "libavcodec55"          => libavcodec,
    "libavcodec-extra-56"   => libavcodec,
    "libavcodec56"          => libavcodec,
    "libavcodec-extra-57"   => libavcodec,
    "libavcodec57"          => libavcodec,
    "libavcodec-extra-58"   => libavcodec,
    "libavcodec58"          => libavcodec,
    "libavdevice53"         => libavdevice,
    "libavdevice54"         => libavdevice,
    "libavdevice55"         => libavdevice,
    "libavdevice56"         => libavdevice,
    "libavdevice57"         => libavdevice,
    "libavdevice58"         => libavdevice,
    "libavfilter2"          => libavfilter,
    "libavfilter3"          => libavfilter,
    "libavfilter4"          => libavfilter,
    "libavfilter5"          => libavfilter,
    "libavfilter6"          => libavfilter,
    "libavfilter7"          => libavfilter,
    "libavformat53"         => libavformat,
    "libavformat54"         => libavformat,
    "libavformat55"         => libavformat,
    "libavformat56"         => libavformat,
    "libavformat57"         => libavformat,
    "libavformat58"         => libavformat,
    #"libavresample1"        => libavresample,
    "libavutil51"           => libavutil,
    "libavutil52"           => libavutil,
    "libavutil53"           => libavutil,
    "libavutil54"           => libavutil,
    "libavutil55"           => libavutil,
    "libavutil56"           => libavutil,
    "libswscale2"           => libswscale,
    "libswscale3"           => libswscale,
    "libswscale4"           => libswscale,
    "libswscale5"           => libswscale,

    ## Available from https://launchpad.net/~jon-severinsson/+archive/ubuntu/ffmpeg
    "libavcodec55-ffmpeg"   => libavcodec,
    "libavdevice55-ffmpeg"  => libavdevice,
    "libavfilter4-ffmpeg"   => libavfilter,
    "libavformat55-ffmpeg"  => libavformat,
    "libavutil52-ffmpeg"    => libavutil,
    #"libswresample0-ffmpeg" => libswresample,
    "libswscale2-ffmpeg"    => libswscale,
    # ffmpeg is again available in standard packages as of ubuntu 15.04
    "libavcodec-ffmpeg56"   => libavcodec,
    "libavdevice-ffmpeg56"  => libavdevice,
    "libavfilter-ffmpeg5"   => libavfilter,
    "libavformat-ffmpeg56"  => libavformat,
    "libavutil-ffmpeg54"    => libavutil,
    "libswscale-ffmpeg3"    => libswscale,
    #"libavresample-ffmpeg2" => libavresample,
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
         Dict("ffmpeg" => libav_libs))

provides(Pacman,
         Dict("ffmpeg" => libav_libs))

provides(Sources,
         URI("http://www.ffmpeg.org/releases/ffmpeg-4.1.tar.gz"),
         libav_libs)

provides(BuildProcess, Autotools(configure_options=["--enable-gpl"]), libav_libs, os = :Unix)

@BinDeps.install Dict(
    :libavcodec => :libavcodec,
    :libavformat => :libavformat,
    :libavutil => :libavutil,
    :libswscale => :libswscale,
    :libavfilter => :libavfilter,
    :libavdevice => :libavdevice
)
