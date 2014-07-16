# Julia wrapper for header: /usr/local/include/libavfilter/buffersrc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersrc_buffer,
    av_buffersrc_write_frame,
    av_buffersrc_add_frame


function av_buffersrc_buffer(ctx,buf)
    ccall((:av_buffersrc_buffer,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFilterBufferRef}),ctx,buf)
end

function av_buffersrc_write_frame(ctx,frame)
    ccall((:av_buffersrc_write_frame,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame}),ctx,frame)
end

function av_buffersrc_add_frame(ctx,frame)
    ccall((:av_buffersrc_add_frame,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame}),ctx,frame)
end
