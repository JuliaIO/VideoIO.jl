# Julia wrapper for header: /usr/local/include/libavfilter/buffersink.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersink_read,
    av_buffersink_read_samples,
    av_buffersink_get_frame,
    av_buffersink_get_samples


function av_buffersink_read(ctx,buf)
    ccall((:av_buffersink_read,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Ptr{AVFilterBufferRef}}),ctx,buf)
end

function av_buffersink_read_samples(ctx,buf,nb_samples::Integer)
    ccall((:av_buffersink_read_samples,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Ptr{AVFilterBufferRef}},Cint),ctx,buf,nb_samples)
end

function av_buffersink_get_frame(ctx,frame)
    ccall((:av_buffersink_get_frame,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame}),ctx,frame)
end

function av_buffersink_get_samples(ctx,frame,nb_samples::Integer)
    ccall((:av_buffersink_get_samples,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFrame},Cint),ctx,frame,nb_samples)
end
