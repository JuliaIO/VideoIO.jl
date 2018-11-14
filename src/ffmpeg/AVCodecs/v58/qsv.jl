# Julia wrapper for header: /usr/include/libavcodec/qsv.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_qsv_alloc_context


function av_qsv_alloc_context()
    ccall((:av_qsv_alloc_context, libavcodec), Ptr{AVQSVContext}, ())
end
