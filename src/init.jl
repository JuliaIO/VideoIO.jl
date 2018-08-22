# convenient way to get library information
using BinDeps

# export avcodec_dir, avformat_dir, avutil_dir, swscale_dir, avdevice_dir, avfilter_dir, avresample_dir, swresample_dir,
#        avcodec_version, avformat_version, avutil_version, swscale_version, avdevice_version, avfilter_version, avresample_version, swresample_version,
#        libavcodec, libavformat, libavutil, libswscale, libavdevice, libavfilter, libavresample, libswresample,

if !@isdefined(libavcodec)
    include("../deps/deps.jl")
end

INSTALL_ROOT = realpath(joinpath(splitdir(libavcodec)[1], ".."))

if !@isdefined(ffmpeg_or_libav)
    include("version.jl")
end

av_load_path = joinpath(dirname(@__FILE__), ffmpeg_or_libav)
