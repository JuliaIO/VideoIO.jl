# Julia wrapper for header: /usr/include/libavutil/channel_layout.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_get_channel_layout,
    av_get_channel_layout_string,
    av_get_channel_layout_nb_channels,
    av_get_default_channel_layout,
    av_get_channel_layout_channel_index,
    av_channel_layout_extract_channel,
    av_get_channel_name


function av_get_channel_layout(name)
    ccall((:av_get_channel_layout,libavutil),UInt64,(Ptr{UInt8},),name)
end

function av_get_channel_layout_string(buf,buf_size::Integer,nb_channels::Integer,channel_layout::UInt64)
    ccall((:av_get_channel_layout_string,libavutil),Cvoid,(Ptr{UInt8},Cint,Cint,UInt64),buf,buf_size,nb_channels,channel_layout)
end

function av_get_channel_layout_nb_channels(channel_layout::UInt64)
    ccall((:av_get_channel_layout_nb_channels,libavutil),Cint,(UInt64,),channel_layout)
end

function av_get_default_channel_layout(nb_channels::Integer)
    ccall((:av_get_default_channel_layout,libavutil),UInt64,(Cint,),nb_channels)
end

function av_get_channel_layout_channel_index(channel_layout::UInt64,channel::UInt64)
    ccall((:av_get_channel_layout_channel_index,libavutil),Cint,(UInt64,UInt64),channel_layout,channel)
end

function av_channel_layout_extract_channel(channel_layout::UInt64,index::Integer)
    ccall((:av_channel_layout_extract_channel,libavutil),UInt64,(UInt64,Cint),channel_layout,index)
end

function av_get_channel_name(channel::UInt64)
    ccall((:av_get_channel_name,libavutil),Ptr{UInt8},(UInt64,),channel)
end
