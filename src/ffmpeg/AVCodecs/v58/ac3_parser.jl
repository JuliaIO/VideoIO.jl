# Julia wrapper for header: /usr/include/libavcodec/ac3_parser.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_ac3_parse_header


function av_ac3_parse_header(buf, size::Csize_t, bitstream_id, frame_size)
    ccall((:av_ac3_parse_header, libavcodec), Cint, (Ptr{UInt8}, Csize_t, Ptr{UInt8}, Ptr{UInt16}), buf, size, bitstream_id, frame_size)
end
