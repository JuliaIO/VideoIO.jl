# Julia wrapper for header: /opt/ffmpeg/include/libavutil/channel_layout.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_get_channel_layout,
    av_get_channel_layout_string,
    av_bprint_channel_layout,
    av_get_channel_layout_nb_channels,
    av_get_default_channel_layout,
    av_get_channel_layout_channel_index,
    av_channel_layout_extract_channel,
    av_get_channel_name,
    av_get_channel_description,
    av_get_standard_channel_layout


function av_get_channel_layout(name)
    ccall((:av_get_channel_layout,libavutil),Uint64,(Ptr{Uint8},),name)
end

function av_get_channel_layout_string(buf,buf_size::Integer,nb_channels::Integer,channel_layout::Uint64)
    ccall((:av_get_channel_layout_string,libavutil),Void,(Ptr{Uint8},Cint,Cint,Uint64),buf,buf_size,nb_channels,channel_layout)
end

function av_bprint_channel_layout(bp,nb_channels::Integer,channel_layout::Uint64)
    ccall((:av_bprint_channel_layout,libavutil),Void,(Ptr{AVBPrint},Cint,Uint64),bp,nb_channels,channel_layout)
end

function av_get_channel_layout_nb_channels(channel_layout::Uint64)
    ccall((:av_get_channel_layout_nb_channels,libavutil),Cint,(Uint64,),channel_layout)
end

function av_get_default_channel_layout(nb_channels::Integer)
    ccall((:av_get_default_channel_layout,libavutil),Int64,(Cint,),nb_channels)
end

function av_get_channel_layout_channel_index(channel_layout::Uint64,channel::Uint64)
    ccall((:av_get_channel_layout_channel_index,libavutil),Cint,(Uint64,Uint64),channel_layout,channel)
end

function av_channel_layout_extract_channel(channel_layout::Uint64,index::Integer)
    ccall((:av_channel_layout_extract_channel,libavutil),Uint64,(Uint64,Cint),channel_layout,index)
end

function av_get_channel_name(channel::Uint64)
    ccall((:av_get_channel_name,libavutil),Ptr{Uint8},(Uint64,),channel)
end

function av_get_channel_description(channel::Uint64)
    ccall((:av_get_channel_description,libavutil),Ptr{Uint8},(Uint64,),channel)
end

function av_get_standard_channel_layout(index::Integer,layout,name)
    ccall((:av_get_standard_channel_layout,libavutil),Cint,(Uint32,Ptr{Uint64},Ptr{Ptr{Uint8}}),index,layout,name)
end
