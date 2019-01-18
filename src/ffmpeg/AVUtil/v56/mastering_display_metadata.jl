# Julia wrapper for header: /usr/include/libavutil/mastering_display_metadata.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_mastering_display_metadata_alloc,
    av_mastering_display_metadata_create_side_data,
    av_content_light_metadata_alloc,
    av_content_light_metadata_create_side_data


function av_mastering_display_metadata_alloc()
    ccall((:av_mastering_display_metadata_alloc, libavutil), Ptr{AVMasteringDisplayMetadata}, ())
end

function av_mastering_display_metadata_create_side_data(frame)
    ccall((:av_mastering_display_metadata_create_side_data, libavutil), Ptr{AVMasteringDisplayMetadata}, (Ptr{AVFrame},), frame)
end

function av_content_light_metadata_alloc(size)
    ccall((:av_content_light_metadata_alloc, libavutil), Ptr{AVContentLightMetadata}, (Ptr{Csize_t},), size)
end

function av_content_light_metadata_create_side_data(frame)
    ccall((:av_content_light_metadata_create_side_data, libavutil), Ptr{AVContentLightMetadata}, (Ptr{AVFrame},), frame)
end
