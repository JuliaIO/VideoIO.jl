# Julia wrapper for header: /usr/include/libavfilter/buffersink.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersink_get_frame_flags,
    av_buffersink_params_alloc,
    av_abuffersink_params_alloc,
    av_buffersink_set_frame_size,
    av_buffersink_get_type,
    av_buffersink_get_time_base,
    av_buffersink_get_format,
    av_buffersink_get_frame_rate,
    av_buffersink_get_w,
    av_buffersink_get_h,
    av_buffersink_get_sample_aspect_ratio,
    av_buffersink_get_channels,
    av_buffersink_get_channel_layout,
    av_buffersink_get_sample_rate,
    av_buffersink_get_hw_frames_ctx,
    av_buffersink_get_frame,
    av_buffersink_get_samples


function av_buffersink_get_frame_flags(ctx, frame, flags::Integer)
    ccall((:av_buffersink_get_frame_flags, libavfilter), Cint, (Ptr{AVFilterContext}, Ptr{AVFrame}, Cint), ctx, frame, flags)
end

function av_buffersink_params_alloc()
    ccall((:av_buffersink_params_alloc, libavfilter), Ptr{AVBufferSinkParams}, ())
end

function av_abuffersink_params_alloc()
    ccall((:av_abuffersink_params_alloc, libavfilter), Ptr{AVABufferSinkParams}, ())
end

function av_buffersink_set_frame_size(ctx, frame_size::Integer)
    ccall((:av_buffersink_set_frame_size, libavfilter), Cvoid, (Ptr{AVFilterContext}, UInt32), ctx, frame_size)
end

function av_buffersink_get_type(ctx)
    ccall((:av_buffersink_get_type, libavfilter), Cvoid, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_time_base(ctx)
    ccall((:av_buffersink_get_time_base, libavfilter), AVRational, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_format(ctx)
    ccall((:av_buffersink_get_format, libavfilter), Cint, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_frame_rate(ctx)
    ccall((:av_buffersink_get_frame_rate, libavfilter), AVRational, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_w(ctx)
    ccall((:av_buffersink_get_w, libavfilter), Cint, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_h(ctx)
    ccall((:av_buffersink_get_h, libavfilter), Cint, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_sample_aspect_ratio(ctx)
    ccall((:av_buffersink_get_sample_aspect_ratio, libavfilter), AVRational, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_channels(ctx)
    ccall((:av_buffersink_get_channels, libavfilter), Cint, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_channel_layout(ctx)
    ccall((:av_buffersink_get_channel_layout, libavfilter), UInt64, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_sample_rate(ctx)
    ccall((:av_buffersink_get_sample_rate, libavfilter), Cint, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_hw_frames_ctx(ctx)
    ccall((:av_buffersink_get_hw_frames_ctx, libavfilter), Ptr{AVBufferRef}, (Ptr{AVFilterContext},), ctx)
end

function av_buffersink_get_frame(ctx, frame)
    ccall((:av_buffersink_get_frame, libavfilter), Cint, (Ptr{AVFilterContext}, Ptr{AVFrame}), ctx, frame)
end

function av_buffersink_get_samples(ctx, frame, nb_samples::Integer)
    ccall((:av_buffersink_get_samples, libavfilter), Cint, (Ptr{AVFilterContext}, Ptr{AVFrame}, Cint), ctx, frame, nb_samples)
end
