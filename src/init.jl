
using FFMPEG

const av_load_path = joinpath(dirname(@__FILE__), "ffmpeg")

const avcodec_dir    = joinpath(av_load_path, "AVCodecs",   "v$(FFMPEG._avcodec_version().major)")
const avformat_dir   = joinpath(av_load_path, "AVFormat",   "v$(FFMPEG._avformat_version().major)")
const avutil_dir     = joinpath(av_load_path, "AVUtil",     "v$(FFMPEG._avutil_version().major)")
const swscale_dir    = joinpath(av_load_path, "SWScale",    "v$(FFMPEG._swscale_version().major)")
const avdevice_dir   = joinpath(av_load_path, "AVDevice",   "v$(FFMPEG._avdevice_version().major)")
const avfilter_dir   = joinpath(av_load_path, "AVFilters",  "v$(FFMPEG._avfilter_version().major)")
#const avresample_dir = joinpath(av_load_path, "AVResample", "v$(_avresample_version().major)")
#const swresample_dir = joinpath(av_load_path, "SWResample", "v$(_swresample_version().major)")

