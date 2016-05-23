# Julia wrapper for header: /usr/local/include/libavcodec/avdct.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    avcodec_dct_alloc,
    avcodec_dct_init,
    avcodec_dct_get_class


function avcodec_dct_alloc()
    ccall((:avcodec_dct_alloc,libavcodec),Ptr{AVDCT},())
end

function avcodec_dct_init(arg1)
    ccall((:avcodec_dct_init,libavcodec),Cint,(Ptr{AVDCT},),arg1)
end

function avcodec_dct_get_class()
    ccall((:avcodec_dct_get_class,libavcodec),Ptr{AVClass},())
end
