# Julia wrapper for header: /usr/local/include/libavutil/samplefmt.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_get_sample_fmt_name,
    av_get_sample_fmt,
    av_get_packed_sample_fmt,
    av_get_planar_sample_fmt,
    av_get_sample_fmt_string,
    av_get_bytes_per_sample,
    av_sample_fmt_is_planar,
    av_samples_get_buffer_size,
    av_samples_fill_arrays,
    av_samples_alloc,
    av_samples_copy,
    av_samples_set_silence


function av_get_sample_fmt_name(sample_fmt::AVSampleFormat)
    ccall((:av_get_sample_fmt_name,libavutil),Ptr{Uint8},(AVSampleFormat,),sample_fmt)
end

function av_get_sample_fmt(name)
    ccall((:av_get_sample_fmt,libavutil),Cint,(Ptr{Uint8},),name)
end

function av_get_packed_sample_fmt(sample_fmt::AVSampleFormat)
    ccall((:av_get_packed_sample_fmt,libavutil),Cint,(AVSampleFormat,),sample_fmt)
end

function av_get_planar_sample_fmt(sample_fmt::AVSampleFormat)
    ccall((:av_get_planar_sample_fmt,libavutil),Cint,(AVSampleFormat,),sample_fmt)
end

function av_get_sample_fmt_string(buf,buf_size::Integer,sample_fmt::AVSampleFormat)
    ccall((:av_get_sample_fmt_string,libavutil),Ptr{Uint8},(Ptr{Uint8},Cint,AVSampleFormat),buf,buf_size,sample_fmt)
end

function av_get_bytes_per_sample(sample_fmt::AVSampleFormat)
    ccall((:av_get_bytes_per_sample,libavutil),Cint,(AVSampleFormat,),sample_fmt)
end

function av_sample_fmt_is_planar(sample_fmt::AVSampleFormat)
    ccall((:av_sample_fmt_is_planar,libavutil),Cint,(AVSampleFormat,),sample_fmt)
end

function av_samples_get_buffer_size(linesize,nb_channels::Integer,nb_samples::Integer,sample_fmt::AVSampleFormat,align::Integer)
    ccall((:av_samples_get_buffer_size,libavutil),Cint,(Ptr{Cint},Cint,Cint,AVSampleFormat,Cint),linesize,nb_channels,nb_samples,sample_fmt,align)
end

function av_samples_fill_arrays(audio_data,linesize,buf,nb_channels::Integer,nb_samples::Integer,sample_fmt::AVSampleFormat,align::Integer)
    ccall((:av_samples_fill_arrays,libavutil),Cint,(Ptr{Ptr{Uint8}},Ptr{Cint},Ptr{Uint8},Cint,Cint,AVSampleFormat,Cint),audio_data,linesize,buf,nb_channels,nb_samples,sample_fmt,align)
end

function av_samples_alloc(audio_data,linesize,nb_channels::Integer,nb_samples::Integer,sample_fmt::AVSampleFormat,align::Integer)
    ccall((:av_samples_alloc,libavutil),Cint,(Ptr{Ptr{Uint8}},Ptr{Cint},Cint,Cint,AVSampleFormat,Cint),audio_data,linesize,nb_channels,nb_samples,sample_fmt,align)
end

function av_samples_copy(dst,src,dst_offset::Integer,src_offset::Integer,nb_samples::Integer,nb_channels::Integer,sample_fmt::AVSampleFormat)
    ccall((:av_samples_copy,libavutil),Cint,(Ptr{Ptr{Uint8}},Ptr{Ptr{Uint8}},Cint,Cint,Cint,Cint,AVSampleFormat),dst,src,dst_offset,src_offset,nb_samples,nb_channels,sample_fmt)
end

function av_samples_set_silence(audio_data,offset::Integer,nb_samples::Integer,nb_channels::Integer,sample_fmt::AVSampleFormat)
    ccall((:av_samples_set_silence,libavutil),Cint,(Ptr{Ptr{Uint8}},Cint,Cint,Cint,AVSampleFormat),audio_data,offset,nb_samples,nb_channels,sample_fmt)
end
