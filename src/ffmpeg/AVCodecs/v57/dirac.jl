# Julia wrapper for header: /usr/local/include/libavcodec/dirac.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_dirac_parse_sequence_header


function av_dirac_parse_sequence_header(dsh,buf,buf_size::Csize_t,log_ctx)
    ccall((:av_dirac_parse_sequence_header,libavcodec),Cint,(Ptr{Ptr{AVDiracSeqHeader}},Ptr{UInt8},Csize_t,Ptr{Cvoid}),dsh,buf,buf_size,log_ctx)
end
