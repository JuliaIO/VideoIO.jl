# Julia wrapper for header: /usr/local/include/libavcodec/vorbis_parser.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_vorbis_parse_init,
    av_vorbis_parse_free,
    av_vorbis_parse_frame_flags,
    av_vorbis_parse_frame,
    av_vorbis_parse_reset


function av_vorbis_parse_init(extradata,extradata_size::Integer)
    ccall((:av_vorbis_parse_init,libavcodec),Ptr{AVVorbisParseContext},(Ptr{UInt8},Cint),extradata,extradata_size)
end

function av_vorbis_parse_free(s)
    ccall((:av_vorbis_parse_free,libavcodec),Cvoid,(Ptr{Ptr{AVVorbisParseContext}},),s)
end

function av_vorbis_parse_frame_flags(s,buf,buf_size::Integer,flags)
    ccall((:av_vorbis_parse_frame_flags,libavcodec),Cint,(Ptr{AVVorbisParseContext},Ptr{UInt8},Cint,Ptr{Cint}),s,buf,buf_size,flags)
end

function av_vorbis_parse_frame(s,buf,buf_size::Integer)
    ccall((:av_vorbis_parse_frame,libavcodec),Cint,(Ptr{AVVorbisParseContext},Ptr{UInt8},Cint),s,buf,buf_size)
end

function av_vorbis_parse_reset(s)
    ccall((:av_vorbis_parse_reset,libavcodec),Cvoid,(Ptr{AVVorbisParseContext},),s)
end
