# Julia wrapper for header: /opt/ffmpeg/include/libavutil/downmix_info.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_downmix_info_update_side_data


function av_downmix_info_update_side_data(frame)
    ccall((:av_downmix_info_update_side_data,libavutil),Ptr{AVDownmixInfo},(Ptr{AVFrame},),frame)
end
