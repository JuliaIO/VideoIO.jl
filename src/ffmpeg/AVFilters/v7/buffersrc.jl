# Julia wrapper for header: /usr/include/libavfilter/buffersrc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersrc_get_nb_failed_requests,
    av_buffersrc_parameters_alloc,
    av_buffersrc_parameters_set,
    av_buffersrc_write_frame,
    av_buffersrc_add_frame,
    av_buffersrc_add_frame_flags,
    av_buffersrc_close


function av_buffersrc_get_nb_failed_requests(buffer_src)
    ccall((:av_buffersrc_get_nb_failed_requests, libavfilter), UInt32, (Ptr{AVFilterContext},), buffer_src)
end

function av_buffersrc_parameters_alloc()
    ccall((:av_buffersrc_parameters_alloc, libavfilter), Ptr{AVBufferSrcParameters}, ())
end

function av_buffersrc_parameters_set(ctx, param)
    ccall((:av_buffersrc_parameters_set, libavfilter), Cint, (Ptr{AVFilterContext}, Ptr{AVBufferSrcParameters}), ctx, param)
end

function av_buffersrc_write_frame(ctx, frame)
    ccall((:av_buffersrc_write_frame, libavfilter), Cint, (Ptr{AVFilterContext}, Ptr{AVFrame}), ctx, frame)
end

function av_buffersrc_add_frame(ctx, frame)
    ccall((:av_buffersrc_add_frame, libavfilter), Cint, (Ptr{AVFilterContext}, Ptr{AVFrame}), ctx, frame)
end

function av_buffersrc_add_frame_flags(buffer_src, frame, flags::Integer)
    ccall((:av_buffersrc_add_frame_flags, libavfilter), Cint, (Ptr{AVFilterContext}, Ptr{AVFrame}, Cint), buffer_src, frame, flags)
end

function av_buffersrc_close(ctx, pts::Int64, flags::Integer)
    ccall((:av_buffersrc_close, libavfilter), Cint, (Ptr{AVFilterContext}, Int64, UInt32), ctx, pts, flags)
end
