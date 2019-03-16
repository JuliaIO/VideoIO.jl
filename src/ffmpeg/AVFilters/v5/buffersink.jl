# Julia wrapper for header: /usr/local/ffmpeg/2.4/include/libavfilter/buffersink.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersink_get_buffer_ref,
    av_buffersink_poll_frame,
    av_buffersink_read,
    av_buffersink_read_samples,
    av_buffersink_get_frame_flags,
    av_buffersink_params_alloc,
    av_abuffersink_params_alloc,
    av_buffersink_set_frame_size,
    av_buffersink_get_frame_rate,
    av_buffersink_get_frame,
    av_buffersink_get_samples


function av_buffersink_get_buffer_ref(buffer_sink,bufref,flags::Integer)
    ccall((:av_buffersink_get_buffer_ref,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Ptr{AVFilterBufferRef}},Cint),buffer_sink,bufref,flags)
end

function av_buffersink_poll_frame(ctx)
    ccall((:av_buffersink_poll_frame,libavfilter),Cint,(Ptr{AVFilterContext},),ctx)
end

function av_buffersink_read(ctx,buf)
    ccall((:av_buffersink_read,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Ptr{AVFilterBufferRef}}),ctx,buf)
end

function av_buffersink_read_samples(ctx,buf,nb_samples::Integer)
    ccall((:av_buffersink_read_samples,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Ptr{AVFilterBufferRef}},Cint),ctx,buf,nb_samples)
end

function av_buffersink_get_frame_flags(ctx,frame,flags::Integer)
    ccall((:av_buffersink_get_frame_flags,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame},Cint),ctx,frame,flags)
end

function av_buffersink_params_alloc()
    ccall((:av_buffersink_params_alloc,libavfilter),Ptr{AVBufferSinkParams},())
end

function av_abuffersink_params_alloc()
    ccall((:av_abuffersink_params_alloc,libavfilter),Ptr{AVABufferSinkParams},())
end

function av_buffersink_set_frame_size(ctx,frame_size::Integer)
    ccall((:av_buffersink_set_frame_size,libavfilter),Cvoid,(Ptr{AVFilterContext},UInt32),ctx,frame_size)
end

function av_buffersink_get_frame_rate(ctx)
    ccall((:av_buffersink_get_frame_rate,libavfilter),AVRational,(Ptr{AVFilterContext},),ctx)
end

function av_buffersink_get_frame(ctx,frame)
    ccall((:av_buffersink_get_frame,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame}),ctx,frame)
end

function av_buffersink_get_samples(ctx,frame,nb_samples::Integer)
    ccall((:av_buffersink_get_samples,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame},Cint),ctx,frame,nb_samples)
end
