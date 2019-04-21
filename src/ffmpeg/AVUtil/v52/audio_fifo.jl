# Julia wrapper for header: /opt/ffmpeg/include/libavutil/audio_fifo.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_audio_fifo_free,
    av_audio_fifo_alloc,
    av_audio_fifo_realloc,
    av_audio_fifo_write,
    av_audio_fifo_read,
    av_audio_fifo_drain,
    av_audio_fifo_reset,
    av_audio_fifo_size,
    av_audio_fifo_space


function av_audio_fifo_free(af)
    ccall((:av_audio_fifo_free,libavutil),Cvoid,(Ptr{AVAudioFifo},),af)
end

function av_audio_fifo_alloc(sample_fmt::AVSampleFormat,channels::Integer,nb_samples::Integer)
    ccall((:av_audio_fifo_alloc,libavutil),Ptr{AVAudioFifo},(AVSampleFormat,Cint,Cint),sample_fmt,channels,nb_samples)
end

function av_audio_fifo_realloc(af,nb_samples::Integer)
    ccall((:av_audio_fifo_realloc,libavutil),Cint,(Ptr{AVAudioFifo},Cint),af,nb_samples)
end

function av_audio_fifo_write(af,data,nb_samples::Integer)
    ccall((:av_audio_fifo_write,libavutil),Cint,(Ptr{AVAudioFifo},Ptr{Ptr{Cvoid}},Cint),af,data,nb_samples)
end

function av_audio_fifo_read(af,data,nb_samples::Integer)
    ccall((:av_audio_fifo_read,libavutil),Cint,(Ptr{AVAudioFifo},Ptr{Ptr{Cvoid}},Cint),af,data,nb_samples)
end

function av_audio_fifo_drain(af,nb_samples::Integer)
    ccall((:av_audio_fifo_drain,libavutil),Cint,(Ptr{AVAudioFifo},Cint),af,nb_samples)
end

function av_audio_fifo_reset(af)
    ccall((:av_audio_fifo_reset,libavutil),Cvoid,(Ptr{AVAudioFifo},),af)
end

function av_audio_fifo_size(af)
    ccall((:av_audio_fifo_size,libavutil),Cint,(Ptr{AVAudioFifo},),af)
end

function av_audio_fifo_space(af)
    ccall((:av_audio_fifo_space,libavutil),Cint,(Ptr{AVAudioFifo},),af)
end
