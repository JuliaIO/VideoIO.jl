# Julia wrapper for header: /usr/include/libavutil/audioconvert.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_get_channel_layout(_name::Union(Ptr,ByteString))
    name = convert(Ptr{Uint8},_name)
    ccall((:av_get_channel_layout,libavutil),Uint64,(Ptr{Uint8},),name)
end
function av_get_channel_layout_string(_buf::Union(Ptr,ByteString),_buf_size::Integer,_nb_channels::Integer,channel_layout::Uint64)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    nb_channels = int32(_nb_channels)
    ccall((:av_get_channel_layout_string,libavutil),Void,(Ptr{Uint8},Cint,Cint,Uint64),buf,buf_size,nb_channels,channel_layout)
end
function av_get_channel_layout_nb_channels(channel_layout::Uint64)
    ccall((:av_get_channel_layout_nb_channels,libavutil),Cint,(Uint64,),channel_layout)
end
