# Julia wrapper for header: /usr/local/include/libavfilter/buffersrc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersrc_buffer


function av_buffersrc_buffer(s,buf)
    ccall((:av_buffersrc_buffer,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFilterBufferRef}),s,buf)
end
