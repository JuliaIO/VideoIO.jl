# Julia wrapper for header: /opt/ffmpeg/include/libavfilter/buffersrc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersrc_add_ref,
    av_buffersrc_get_nb_failed_requests,
    av_buffersrc_buffer,
    av_buffersrc_write_frame,
    av_buffersrc_add_frame,
    av_buffersrc_add_frame_flags


function av_buffersrc_add_ref(buffer_src,picref,flags::Integer)
    ccall((:av_buffersrc_add_ref,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFilterBufferRef},Cint),buffer_src,picref,flags)
end

function av_buffersrc_get_nb_failed_requests(buffer_src)
    ccall((:av_buffersrc_get_nb_failed_requests,libavfilter),Uint32,(Ptr{AVFilterContext},),buffer_src)
end

function av_buffersrc_buffer(ctx,buf)
    ccall((:av_buffersrc_buffer,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFilterBufferRef}),ctx,buf)
end

function av_buffersrc_write_frame(ctx,frame)
    ccall((:av_buffersrc_write_frame,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame}),ctx,frame)
end

function av_buffersrc_add_frame(ctx,frame)
    ccall((:av_buffersrc_add_frame,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame}),ctx,frame)
end

function av_buffersrc_add_frame_flags(buffer_src,frame,flags::Integer)
    ccall((:av_buffersrc_add_frame_flags,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame},Cint),buffer_src,frame,flags)
end
