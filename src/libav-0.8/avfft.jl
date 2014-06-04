# Julia wrapper for header: /usr/include/libavcodec/avfft.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_fft_init(_nbits::Integer,_inverse::Integer)
    nbits = int32(_nbits)
    inverse = int32(_inverse)
    ccall((:av_fft_init,libavcodec),Ptr{FFTContext},(Cint,Cint),nbits,inverse)
end
function av_fft_permute(_s::Ptr,_z::Ptr)
    s = convert(Ptr{FFTContext},_s)
    z = convert(Ptr{FFTComplex},_z)
    ccall((:av_fft_permute,libavcodec),Void,(Ptr{FFTContext},Ptr{FFTComplex}),s,z)
end
function av_fft_calc(_s::Ptr,_z::Ptr)
    s = convert(Ptr{FFTContext},_s)
    z = convert(Ptr{FFTComplex},_z)
    ccall((:av_fft_calc,libavcodec),Void,(Ptr{FFTContext},Ptr{FFTComplex}),s,z)
end
function av_fft_end(_s::Ptr)
    s = convert(Ptr{FFTContext},_s)
    ccall((:av_fft_end,libavcodec),Void,(Ptr{FFTContext},),s)
end
function av_mdct_init(_nbits::Integer,_inverse::Integer,scale::Cdouble)
    nbits = int32(_nbits)
    inverse = int32(_inverse)
    ccall((:av_mdct_init,libavcodec),Ptr{FFTContext},(Cint,Cint,Cdouble),nbits,inverse,scale)
end
function av_imdct_calc(_s::Ptr,_output::Ptr,_input::Ptr)
    s = convert(Ptr{FFTContext},_s)
    output = convert(Ptr{FFTSample},_output)
    input = convert(Ptr{FFTSample},_input)
    ccall((:av_imdct_calc,libavcodec),Void,(Ptr{FFTContext},Ptr{FFTSample},Ptr{FFTSample}),s,output,input)
end
function av_imdct_half(_s::Ptr,_output::Ptr,_input::Ptr)
    s = convert(Ptr{FFTContext},_s)
    output = convert(Ptr{FFTSample},_output)
    input = convert(Ptr{FFTSample},_input)
    ccall((:av_imdct_half,libavcodec),Void,(Ptr{FFTContext},Ptr{FFTSample},Ptr{FFTSample}),s,output,input)
end
function av_mdct_calc(_s::Ptr,_output::Ptr,_input::Ptr)
    s = convert(Ptr{FFTContext},_s)
    output = convert(Ptr{FFTSample},_output)
    input = convert(Ptr{FFTSample},_input)
    ccall((:av_mdct_calc,libavcodec),Void,(Ptr{FFTContext},Ptr{FFTSample},Ptr{FFTSample}),s,output,input)
end
function av_mdct_end(_s::Ptr)
    s = convert(Ptr{FFTContext},_s)
    ccall((:av_mdct_end,libavcodec),Void,(Ptr{FFTContext},),s)
end
function av_rdft_init(_nbits::Integer,trans::RDFTransformType)
    nbits = int32(_nbits)
    ccall((:av_rdft_init,libavcodec),Ptr{RDFTContext},(Cint,RDFTransformType),nbits,trans)
end
function av_rdft_calc(_s::Ptr,_data::Ptr)
    s = convert(Ptr{RDFTContext},_s)
    data = convert(Ptr{FFTSample},_data)
    ccall((:av_rdft_calc,libavcodec),Void,(Ptr{RDFTContext},Ptr{FFTSample}),s,data)
end
function av_rdft_end(_s::Ptr)
    s = convert(Ptr{RDFTContext},_s)
    ccall((:av_rdft_end,libavcodec),Void,(Ptr{RDFTContext},),s)
end
function av_dct_init(_nbits::Integer,_type::DCTTransformType)
    nbits = int32(_nbits)
    ccall((:av_dct_init,libavcodec),Ptr{DCTContext},(Cint,DCTTransformType),nbits,_type)
end
function av_dct_calc(_s::Ptr,_data::Ptr)
    s = convert(Ptr{DCTContext},_s)
    data = convert(Ptr{FFTSample},_data)
    ccall((:av_dct_calc,libavcodec),Void,(Ptr{DCTContext},Ptr{FFTSample}),s,data)
end
function av_dct_end(_s::Ptr)
    s = convert(Ptr{DCTContext},_s)
    ccall((:av_dct_end,libavcodec),Void,(Ptr{DCTContext},),s)
end
