# Julia wrapper for header: /usr/include/libavcodec/adts_parser.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_adts_header_parse


function av_adts_header_parse(buf, samples, frames)
    ccall((:av_adts_header_parse, libavcodec), Cint, (Ptr{UInt8}, Ptr{UInt32}, Ptr{UInt8}), buf, samples, frames)
end
