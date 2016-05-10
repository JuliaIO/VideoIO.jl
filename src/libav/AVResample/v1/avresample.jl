# Julia wrapper for header: /usr/local/include/libavresample/avresample.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    #avresample_version,
    avresample_configuration,
    avresample_license,
    avresample_get_class,
    avresample_alloc_context,
    avresample_open,
    avresample_close,
    avresample_free,
    avresample_build_matrix,
    avresample_get_matrix,
    avresample_set_matrix,
    avresample_set_channel_mapping,
    avresample_set_compensation,
    avresample_convert,
    avresample_get_delay,
    avresample_available,
    avresample_read


function avresample_version()
    ccall((:avresample_version,libavresample),UInt32,())
end

function avresample_configuration()
    ccall((:avresample_configuration,libavresample),Ptr{UInt8},())
end

function avresample_license()
    ccall((:avresample_license,libavresample),Ptr{UInt8},())
end

function avresample_get_class()
    ccall((:avresample_get_class,libavresample),Ptr{AVClass},())
end

function avresample_alloc_context()
    ccall((:avresample_alloc_context,libavresample),Ptr{AVAudioResampleContext},())
end

function avresample_open(avr)
    ccall((:avresample_open,libavresample),Cint,(Ptr{AVAudioResampleContext},),avr)
end

function avresample_close(avr)
    ccall((:avresample_close,libavresample),Void,(Ptr{AVAudioResampleContext},),avr)
end

function avresample_free(avr)
    ccall((:avresample_free,libavresample),Void,(Ptr{Ptr{AVAudioResampleContext}},),avr)
end

function avresample_build_matrix(in_layout::UInt64,out_layout::UInt64,center_mix_level::Cdouble,surround_mix_level::Cdouble,lfe_mix_level::Cdouble,normalize::Integer,matrix,stride::Integer,matrix_encoding::AVMatrixEncoding)
    ccall((:avresample_build_matrix,libavresample),Cint,(UInt64,UInt64,Cdouble,Cdouble,Cdouble,Cint,Ptr{Cdouble},Cint,AVMatrixEncoding),in_layout,out_layout,center_mix_level,surround_mix_level,lfe_mix_level,normalize,matrix,stride,matrix_encoding)
end

function avresample_get_matrix(avr,matrix,stride::Integer)
    ccall((:avresample_get_matrix,libavresample),Cint,(Ptr{AVAudioResampleContext},Ptr{Cdouble},Cint),avr,matrix,stride)
end

function avresample_set_matrix(avr,matrix,stride::Integer)
    ccall((:avresample_set_matrix,libavresample),Cint,(Ptr{AVAudioResampleContext},Ptr{Cdouble},Cint),avr,matrix,stride)
end

function avresample_set_channel_mapping(avr,channel_map)
    ccall((:avresample_set_channel_mapping,libavresample),Cint,(Ptr{AVAudioResampleContext},Ptr{Cint}),avr,channel_map)
end

function avresample_set_compensation(avr,sample_delta::Integer,compensation_distance::Integer)
    ccall((:avresample_set_compensation,libavresample),Cint,(Ptr{AVAudioResampleContext},Cint,Cint),avr,sample_delta,compensation_distance)
end

function avresample_convert(avr,output,out_plane_size::Integer,out_samples::Integer,input,in_plane_size::Integer,in_samples::Integer)
    ccall((:avresample_convert,libavresample),Cint,(Ptr{AVAudioResampleContext},Ptr{Ptr{UInt8}},Cint,Cint,Ptr{Ptr{UInt8}},Cint,Cint),avr,output,out_plane_size,out_samples,input,in_plane_size,in_samples)
end

function avresample_get_delay(avr)
    ccall((:avresample_get_delay,libavresample),Cint,(Ptr{AVAudioResampleContext},),avr)
end

function avresample_available(avr)
    ccall((:avresample_available,libavresample),Cint,(Ptr{AVAudioResampleContext},),avr)
end

function avresample_read(avr,output,nb_samples::Integer)
    ccall((:avresample_read,libavresample),Cint,(Ptr{AVAudioResampleContext},Ptr{Ptr{UInt8}},Cint),avr,output,nb_samples)
end
