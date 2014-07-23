using BinDeps

@BinDeps.setup

deps = [
        libavutil = library_dependency("libavutil", aliases=[["libavutil.so.", "libavutil.ffmpeg.so.", "avutil-"].*["51" "52"]...])
        libavcodec = library_dependency("libavcodec", aliases=[["libavcodec.so.","libavcodec.ffmpeg.so.","avcodec-"].*["53" "54" "55"]...])
        libavformat = library_dependency("libavformat", aliases=[["libavformat.so.","libavformat.ffmpeg.so.","avformat-"].*["53" "54" "55"]...])
        libswscale = library_dependency("libswscale", aliases=[["libswscale.so.","libswscale.ffmpeg.so.","swscale-"].*["2"]...])
        libavfilter = library_dependency("libavfilter", aliases=[["libavfilter.so.","libavfilter.ffmpeg.so.","avfilter-"].*["2" "3" "4"]...])
        libavdevice = library_dependency("libavdevice", aliases=[["libavdevice.so.","libavdevice.ffmpeg.so.","avdevice-"].*["53" "54" "55"]...])
        libpostproc = library_dependency("libpostproc", aliases=[["libpostproc.so.","libpostproc.ffmpeg.so.","postproc-"].*["52"]...])
]

ffmpeg_libs = [libavutil, libavcodec, libavformat, libavfilter, libswscale, libavdevice, libpostproc]

if (have_avresample = dlopen_e("libavresample") != C_NULL)
    libavresample = library_dependency("libavresample", aliases=[["libavresample.so.","avresample-"].*["1"]...])
    push!(deps, libavresample)
end

if (have_swresample = dlopen_e("libswresample") != C_NULL)
    libswresample = library_dependency("libswresample", aliases=[["libswresample.so.","libswresample.ffmpeg.so.","swresample-"].*["0"]...])
    push!(deps, libswresample)
    push!(ffmpeg_libs, libswresample)
end

@windows_only begin
    provides(Binaries, URI("http://ffmpeg.zeranoe.com/builds/win$WORD_SIZE/shared/ffmpeg-2.2.3-win$WORD_SIZE-shared.7z"),
             ffmpeg_libs, 
             os = :Windows,
             unpacked_dir="ffmpeg-2.2.3-win$WORD_SIZE-shared/bin")
end

@osx_only begin
    if Pkg.installed("Homebrew") === nothing
	error("Homebrew package not installed, please run Pkg.add(\"Homebrew\")")
    end
    using Homebrew
    provides( Homebrew.HB, "ffmpeg-2.2.4", ffmpeg_libs, os = :Darwin )
end


# System Package Managers         
apt_packages = {
                "libavcodec53"          => libavcodec,
                "libavcodec54"          => libavcodec,
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
                "libpostproc52"         => libpostproc,
                "libswscale2"           => libswscale,

                ## Available from https://launchpad.net/~jon-severinsson/+archive/ubuntu/ffmpeg
                "libavcodec55-ffmpeg"   => libavcodec,
                "libavdevice55-ffmpeg"  => libavdevice,
                "libavfilter4-ffmpeg"   => libavfilter,
                "libavformat55-ffmpeg"  => libavformat,
                "libavutil52-ffmpeg"    => libavutil,
                "libpostproc52-ffmpeg"  => libpostproc,
                #"libswresample0-ffmpeg" => libswresample,
                "libswscale2-ffmpeg"    => libswscale,
                }

if have_swresample
    apt_packages["libswresample0-ffmpeg"] = libswresample
end

if have_avresample
    apt_packages["libavresample1"] = libavresample
end

provides(AptGet,
         apt_packages)

provides(Yum,
         {"ffmpeg-2.2.5" => ffmpeg_libs})

provides(Sources,
         URI("http://www.ffmpeg.org/releases/ffmpeg-2.2.5.tar.gz"), 
         ffmpeg_libs)

provides(BuildProcess, Autotools(configure_options=["--enable-gpl"]), ffmpeg_libs, os = :Unix)

@BinDeps.install
