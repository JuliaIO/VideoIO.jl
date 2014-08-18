
av_version(v) = VersionNumber(v>>16,(v>>8)&0xff,v&0xff)

have_avcodec()    = dlopen_e(libavcodec)    != C_NULL
have_avformat()   = dlopen_e(libavformat)   != C_NULL
have_avutil()     = dlopen_e(libavutil)     != C_NULL
have_swscale()    = dlopen_e(libswscale)    != C_NULL
have_avdevice()   = dlopen_e(libavdevice)   != C_NULL
have_avfilter()   = dlopen_e(libavfilter)   != C_NULL
have_avresample() = isdefined(:libavresample) && dlopen_e(libavresample) != C_NULL
have_swresample() = isdefined(:libswresample) && dlopen_e(libswresample) != C_NULL

avcodec_version()    = have_avcodec()    ? av_version(ccall((:avcodec_version,    libavcodec),    Uint32, ())) : v"0"
avformat_version()   = have_avformat()   ? av_version(ccall((:avformat_version,   libavformat),   Uint32, ())) : v"0"
avutil_version()     = have_avutil()     ? av_version(ccall((:avutil_version,     libavutil),     Uint32, ())) : v"0"
swscale_version()    = have_swscale()    ? av_version(ccall((:swscale_version,    libswscale),    Uint32, ())) : v"0"
avdevice_version()   = have_avdevice()   ? av_version(ccall((:avdevice_version,   libavdevice),   Uint32, ())) : v"0"
avfilter_version()   = have_avfilter()   ? av_version(ccall((:avfilter_version,   libavfilter),   Uint32, ())) : v"0"
avresample_version() = have_avresample() ? av_version(ccall((:avresample_version, libavresample), Uint32, ())) : v"0"
swresample_version() = have_swresample() ? av_version(ccall((:swresample_version, libswresample), Uint32, ())) : v"0"

ffmpeg_or_libav = avutil_version().patch >= 100 ? "ffmpeg" : "libav"

avcodec_dir    = joinpath(Pkg.dir("VideoIO"), "src", ffmpeg_or_libav, "AVCodecs",   "v$(avcodec_version().major)")
avformat_dir   = joinpath(Pkg.dir("VideoIO"), "src", ffmpeg_or_libav, "AVFormat",   "v$(avformat_version().major)")
avutil_dir     = joinpath(Pkg.dir("VideoIO"), "src", ffmpeg_or_libav, "AVUtil",     "v$(avutil_version().major)")
swscale_dir    = joinpath(Pkg.dir("VideoIO"), "src", ffmpeg_or_libav, "SWScale",    "v$(swscale_version().major)")
avdevice_dir   = joinpath(Pkg.dir("VideoIO"), "src", ffmpeg_or_libav, "AVDevice",   "v$(avdevice_version().major)")
avfilter_dir   = joinpath(Pkg.dir("VideoIO"), "src", ffmpeg_or_libav, "AVFilters",  "v$(avfilter_version().major)")
avresample_dir = joinpath(Pkg.dir("VideoIO"), "src", ffmpeg_or_libav, "AVResample", "v$(avresample_version().major)")
swresample_dir = joinpath(Pkg.dir("VideoIO"), "src", ffmpeg_or_libav, "SWResample", "v$(swresample_version().major)")

function versioninfo()
    println("Using $ffmpeg_or_libav")
    println("AVCodecs version $(avcodec_version())")
    println("AVFormat version $(avformat_version())")
    println("AVUtil version $(avutil_version())")
    println("SWScale version $(swscale_version())")
    println("AVDevice version $(avdevice_version())")
    println("AVFilters version $(avfilter_version())")
    println("AVResample version $(avresample_version())")
    println("SWResample version $(swresample_version())")
    println("PostProc version $(postproc_version())")
end
