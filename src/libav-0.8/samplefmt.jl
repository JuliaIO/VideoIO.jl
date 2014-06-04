# Julia wrapper for header: /usr/include/libavutil/samplefmt.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_get_sample_fmt_name(sample_fmt::AVSampleFormat)
    ccall((:av_get_sample_fmt_name,libavutil),Ptr{Uint8},(AVSampleFormat,),sample_fmt)
end
function av_get_sample_fmt(_name::Union(Ptr,ByteString))
    name = convert(Ptr{Uint8},_name)
    ccall((:av_get_sample_fmt,libavutil),Cint,(Ptr{Uint8},),name)
end
function av_get_sample_fmt_string(_buf::Union(Ptr,ByteString),_buf_size::Integer,sample_fmt::AVSampleFormat)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    ccall((:av_get_sample_fmt_string,libavutil),Ptr{Uint8},(Ptr{Uint8},Cint,AVSampleFormat),buf,buf_size,sample_fmt)
end
function av_get_bits_per_sample_fmt(sample_fmt::AVSampleFormat)
    ccall((:av_get_bits_per_sample_fmt,libavutil),Cint,(AVSampleFormat,),sample_fmt)
end
function av_get_bytes_per_sample(sample_fmt::AVSampleFormat)
    ccall((:av_get_bytes_per_sample,libavutil),Cint,(AVSampleFormat,),sample_fmt)
end
function av_sample_fmt_is_planar(sample_fmt::AVSampleFormat)
    ccall((:av_sample_fmt_is_planar,libavutil),Cint,(AVSampleFormat,),sample_fmt)
end
function av_samples_get_buffer_size(_linesize::Ptr,_nb_channels::Integer,_nb_samples::Integer,sample_fmt::AVSampleFormat,_align::Integer)
    linesize = convert(Ptr{Cint},_linesize)
    nb_channels = int32(_nb_channels)
    nb_samples = int32(_nb_samples)
    align = int32(_align)
    ccall((:av_samples_get_buffer_size,libavutil),Cint,(Ptr{Cint},Cint,Cint,AVSampleFormat,Cint),linesize,nb_channels,nb_samples,sample_fmt,align)
end
function av_samples_fill_arrays(_audio_data::Ptr,_linesize::Ptr,_buf::Union(Ptr,ByteString),_nb_channels::Integer,_nb_samples::Integer,sample_fmt::AVSampleFormat,_align::Integer)
    audio_data = convert(Ptr{Ptr{Uint8}},_audio_data)
    linesize = convert(Ptr{Cint},_linesize)
    buf = convert(Ptr{Uint8},_buf)
    nb_channels = int32(_nb_channels)
    nb_samples = int32(_nb_samples)
    align = int32(_align)
    ccall((:av_samples_fill_arrays,libavutil),Cint,(Ptr{Ptr{Uint8}},Ptr{Cint},Ptr{Uint8},Cint,Cint,AVSampleFormat,Cint),audio_data,linesize,buf,nb_channels,nb_samples,sample_fmt,align)
end
function av_samples_alloc(_audio_data::Ptr,_linesize::Ptr,_nb_channels::Integer,_nb_samples::Integer,sample_fmt::AVSampleFormat,_align::Integer)
    audio_data = convert(Ptr{Ptr{Uint8}},_audio_data)
    linesize = convert(Ptr{Cint},_linesize)
    nb_channels = int32(_nb_channels)
    nb_samples = int32(_nb_samples)
    align = int32(_align)
    ccall((:av_samples_alloc,libavutil),Cint,(Ptr{Ptr{Uint8}},Ptr{Cint},Cint,Cint,AVSampleFormat,Cint),audio_data,linesize,nb_channels,nb_samples,sample_fmt,align)
end
