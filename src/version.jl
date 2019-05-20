av_version(v) = VersionNumber(v>>16,(v>>8)&0xff,v&0xff)

have_avcodec()    = Libdl.dlopen_e(libavcodec)    != C_NULL
have_avformat()   = Libdl.dlopen_e(libavformat)   != C_NULL
have_avutil()     = Libdl.dlopen_e(libavutil)     != C_NULL
have_swscale()    = Libdl.dlopen_e(libswscale)    != C_NULL
have_avdevice()   = Libdl.dlopen_e(libavdevice)   != C_NULL
have_avfilter()   = Libdl.dlopen_e(libavfilter)   != C_NULL
#have_avresample() = @isdefined(libavresample) && Libdl.dlopen_e(libavresample) != C_NULL
#have_swresample() = @isdefined(libswresample) && Libdl.dlopen_e(libswresample) != C_NULL

_avcodec_version()    = have_avcodec()    ? av_version(ccall((:avcodec_version,    libavcodec),    UInt32, ())) : v"0"
_avformat_version()   = have_avformat()   ? av_version(ccall((:avformat_version,   libavformat),   UInt32, ())) : v"0"
_avutil_version()     = have_avutil()     ? av_version(ccall((:avutil_version,     libavutil),     UInt32, ())) : v"0"
_swscale_version()    = have_swscale()    ? av_version(ccall((:swscale_version,    libswscale),    UInt32, ())) : v"0"
_avdevice_version()   = have_avdevice()   ? av_version(ccall((:avdevice_version,   libavdevice),   UInt32, ())) : v"0"
_avfilter_version()   = have_avfilter()   ? av_version(ccall((:avfilter_version,   libavfilter),   UInt32, ())) : v"0"
#_avresample_version() = have_avresample() ? av_version(ccall((:avresample_version, libavresample), UInt32, ())) : v"0"
#_swresample_version() = have_swresample() ? av_version(ccall((:swresample_version, libswresample), UInt32, ())) : v"0"

avcodec_dir    = joinpath(dirname(@__FILE__), "ffmpeg", "AVCodecs",   "v$(_avcodec_version().major)")
avformat_dir   = joinpath(dirname(@__FILE__), "ffmpeg", "AVFormat",   "v$(_avformat_version().major)")
avutil_dir     = joinpath(dirname(@__FILE__), "ffmpeg", "AVUtil",     "v$(_avutil_version().major)")
swscale_dir    = joinpath(dirname(@__FILE__), "ffmpeg", "SWScale",    "v$(_swscale_version().major)")
avdevice_dir   = joinpath(dirname(@__FILE__), "ffmpeg", "AVDevice",   "v$(_avdevice_version().major)")
avfilter_dir   = joinpath(dirname(@__FILE__), "ffmpeg", "AVFilters",  "v$(_avfilter_version().major)")
#avresample_dir = joinpath(dirname(@__FILE__), "ffmpeg", "AVResample", "v$(_avresample_version().major)")
#swresample_dir = joinpath(dirname(@__FILE__), "ffmpeg", "SWResample", "v$(_swresample_version().major)")

function versioninfo()
    println("Using ffmpeg")
    println("AVCodecs version $(_avcodec_version())")
    println("AVFormat version $(_avformat_version())")
    println("AVUtil version $(_avutil_version())")
    println("SWScale version $(_swscale_version())")
    println("AVDevice version $(_avdevice_version())")
    println("AVFilters version $(_avfilter_version())")
    #println("AVResample version $(_avresample_version())")
    #println("SWResample version $(_swresample_version())")
end
