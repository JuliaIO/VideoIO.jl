# Julia wrapper for header: /usr/local/include/libavutil/audioconvert.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_get_channel_layout,
    av_get_channel_layout_string,
    av_get_channel_layout_nb_channels


function av_get_channel_layout(name)
    ccall((:av_get_channel_layout,libavutil),Uint64,(Ptr{Uint8},),name)
end

function av_get_channel_layout_string(buf,buf_size::Integer,nb_channels::Integer,channel_layout::Uint64)
    ccall((:av_get_channel_layout_string,libavutil),Void,(Ptr{Uint8},Cint,Cint,Uint64),buf,buf_size,nb_channels,channel_layout)
end

function av_get_channel_layout_nb_channels(channel_layout::Uint64)
    ccall((:av_get_channel_layout_nb_channels,libavutil),Cint,(Uint64,),channel_layout)
end
