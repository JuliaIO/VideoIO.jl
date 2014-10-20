# Julia wrapper for header: /usr/local/ffmpeg/2.4/include/libavfilter/asrc_abuffer.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_asrc_buffer_add_samples,
    av_asrc_buffer_add_buffer,
    av_asrc_buffer_add_audio_buffer_ref


function av_asrc_buffer_add_samples(abuffersrc,data,linesize,nb_samples::Integer,sample_rate::Integer,sample_fmt::Integer,ch_layout::Int64,planar::Integer,pts::Int64,flags::Integer)
    ccall((:av_asrc_buffer_add_samples,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Ptr{Uint8}},Ptr{Cint},Cint,Cint,Cint,Int64,Cint,Int64,Cint),abuffersrc,data,linesize,nb_samples,sample_rate,sample_fmt,ch_layout,planar,pts,flags)
end

function av_asrc_buffer_add_buffer(abuffersrc,buf,buf_size::Integer,sample_rate::Integer,sample_fmt::Integer,ch_layout::Int64,planar::Integer,pts::Int64,flags::Integer)
    ccall((:av_asrc_buffer_add_buffer,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{Uint8},Cint,Cint,Cint,Int64,Cint,Int64,Cint),abuffersrc,buf,buf_size,sample_rate,sample_fmt,ch_layout,planar,pts,flags)
end

function av_asrc_buffer_add_audio_buffer_ref(abuffersrc,samplesref,flags::Integer)
    ccall((:av_asrc_buffer_add_audio_buffer_ref,libavfilter),Cint,(Ptr{AVFilterContext},Ptr{AVFilterBufferRef},Cint),abuffersrc,samplesref,flags)
end
