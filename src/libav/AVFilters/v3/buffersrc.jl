# Julia wrapper for header: /usr/include/libavfilter/buffersrc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersrc_buffer,
    av_buffersrc_write_frame


function av_buffersrc_buffer(s,buf)
    ccall((:av_buffersrc_buffer,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFilterBufferRef}),s,buf)
end

function av_buffersrc_write_frame(s,frame)
    ccall((:av_buffersrc_write_frame,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame}),s,frame)
end
