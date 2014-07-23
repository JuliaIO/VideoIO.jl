# Julia wrapper for header: /usr/include/libavfilter/buffersink.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_buffersink_read,
    av_buffersink_read_samples


function av_buffersink_read(ctx,buf)
    ccall((:av_buffersink_read,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Ptr{AVFilterBufferRef}}),ctx,buf)
end

function av_buffersink_read_samples(ctx,buf,nb_samples::Integer)
    ccall((:av_buffersink_read_samples,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Ptr{AVFilterBufferRef}},Cint),ctx,buf,nb_samples)
end
