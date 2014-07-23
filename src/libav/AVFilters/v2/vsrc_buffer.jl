# Julia wrapper for header: /usr/local/include/libavfilter/vsrc_buffer.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_vsrc_buffer_add_frame


function av_vsrc_buffer_add_frame(buffer_filter,frame,pts::Int64,pixel_aspect::AVRational)
    ccall((:av_vsrc_buffer_add_frame,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame},Int64,AVRational),buffer_filter,frame,pts,pixel_aspect)
end
