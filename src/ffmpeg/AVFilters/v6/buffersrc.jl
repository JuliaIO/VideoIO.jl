# Julia wrapper for header: /usr/local/include/libavfilter/buffersrc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersrc_get_nb_failed_requests,
    av_buffersrc_write_frame,
    av_buffersrc_add_frame,
    av_buffersrc_add_frame_flags


function av_buffersrc_get_nb_failed_requests(buffer_src)
    ccall((:av_buffersrc_get_nb_failed_requests,libavfilter),UInt32,(Ptr{AVFilterContext},),buffer_src)
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
