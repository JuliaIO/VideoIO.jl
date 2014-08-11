# convenient way to get library information
using BinDeps

# export avcodec_dir, avformat_dir, avutil_dir, swscale_dir, avdevice_dir, avfilter_dir, avresample_dir, swresample_dir, postproc_dir,
#        avcodec_version, avformat_version, avutil_version, swscale_version, avdevice_version, avfilter_version, avresample_version, swresample_version, postproc_version,
#        libavcodec, libavformat, libavutil, libswscale, libavdevice, libavfilter, libavresample, libswresample, libpostproc

if !isdefined(:libavcodec)
    @BinDeps.load_dependencies
end

if !isdefined(:ffmpeg_or_libav)
    include("version.jl")
end

av_load_path = joinpath(Pkg.dir("VideoIO"), "src", ffmpeg_or_libav)
!(av_load_path in LOAD_PATH) && unshift!(LOAD_PATH, av_load_path)



