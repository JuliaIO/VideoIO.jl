# Julia wrapper for header: /usr/include/libavutil/file.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_file_map,
    av_file_unmap


function av_file_map(filename,bufptr,size,log_offset::Integer,log_ctx)
    ccall((:av_file_map,libavutil),Cint,(Ptr{UInt8},Ptr{Ptr{UInt8}},Ptr{Csize_t},Cint,Ptr{Cvoid}),filename,bufptr,size,log_offset,log_ctx)
end

function av_file_unmap(bufptr,size::Csize_t)
    ccall((:av_file_unmap,libavutil),Cvoid,(Ptr{UInt8},Csize_t),bufptr,size)
end
