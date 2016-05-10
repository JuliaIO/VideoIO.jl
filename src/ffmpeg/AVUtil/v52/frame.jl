# Julia wrapper for header: /opt/ffmpeg/include/libavutil/frame.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_frame_get_best_effort_timestamp,
    av_frame_set_best_effort_timestamp,
    av_frame_get_pkt_duration,
    av_frame_set_pkt_duration,
    av_frame_get_pkt_pos,
    av_frame_set_pkt_pos,
    av_frame_get_channel_layout,
    av_frame_set_channel_layout,
    av_frame_get_channels,
    av_frame_set_channels,
    av_frame_get_sample_rate,
    av_frame_set_sample_rate,
    av_frame_get_metadata,
    av_frame_set_metadata,
    av_frame_get_decode_error_flags,
    av_frame_set_decode_error_flags,
    av_frame_get_pkt_size,
    av_frame_set_pkt_size,
    avpriv_frame_get_metadatap,
    av_frame_get_qp_table,
    av_frame_set_qp_table,
    av_frame_get_colorspace,
    av_frame_set_colorspace,
    av_frame_get_color_range,
    av_frame_set_color_range,
    av_get_colorspace_name,
    av_frame_alloc,
    av_frame_free,
    av_frame_ref,
    av_frame_clone,
    av_frame_unref,
    av_frame_move_ref,
    av_frame_get_buffer,
    av_frame_is_writable,
    av_frame_make_writable,
    av_frame_copy,
    av_frame_copy_props,
    av_frame_get_plane_buffer,
    av_frame_new_side_data,
    av_frame_get_side_data,
    av_frame_remove_side_data


function av_frame_get_best_effort_timestamp(frame)
    ccall((:av_frame_get_best_effort_timestamp,libavutil),Int64,(Ptr{AVFrame},),frame)
end

function av_frame_set_best_effort_timestamp(frame,val::Int64)
    ccall((:av_frame_set_best_effort_timestamp,libavutil),Void,(Ptr{AVFrame},Int64),frame,val)
end

function av_frame_get_pkt_duration(frame)
    ccall((:av_frame_get_pkt_duration,libavutil),Int64,(Ptr{AVFrame},),frame)
end

function av_frame_set_pkt_duration(frame,val::Int64)
    ccall((:av_frame_set_pkt_duration,libavutil),Void,(Ptr{AVFrame},Int64),frame,val)
end

function av_frame_get_pkt_pos(frame)
    ccall((:av_frame_get_pkt_pos,libavutil),Int64,(Ptr{AVFrame},),frame)
end

function av_frame_set_pkt_pos(frame,val::Int64)
    ccall((:av_frame_set_pkt_pos,libavutil),Void,(Ptr{AVFrame},Int64),frame,val)
end

function av_frame_get_channel_layout(frame)
    ccall((:av_frame_get_channel_layout,libavutil),Int64,(Ptr{AVFrame},),frame)
end

function av_frame_set_channel_layout(frame,val::Int64)
    ccall((:av_frame_set_channel_layout,libavutil),Void,(Ptr{AVFrame},Int64),frame,val)
end

function av_frame_get_channels(frame)
    ccall((:av_frame_get_channels,libavutil),Cint,(Ptr{AVFrame},),frame)
end

function av_frame_set_channels(frame,val::Integer)
    ccall((:av_frame_set_channels,libavutil),Void,(Ptr{AVFrame},Cint),frame,val)
end

function av_frame_get_sample_rate(frame)
    ccall((:av_frame_get_sample_rate,libavutil),Cint,(Ptr{AVFrame},),frame)
end

function av_frame_set_sample_rate(frame,val::Integer)
    ccall((:av_frame_set_sample_rate,libavutil),Void,(Ptr{AVFrame},Cint),frame,val)
end

function av_frame_get_metadata(frame)
    ccall((:av_frame_get_metadata,libavutil),Ptr{AVDictionary},(Ptr{AVFrame},),frame)
end

function av_frame_set_metadata(frame,val)
    ccall((:av_frame_set_metadata,libavutil),Void,(Ptr{AVFrame},Ptr{AVDictionary}),frame,val)
end

function av_frame_get_decode_error_flags(frame)
    ccall((:av_frame_get_decode_error_flags,libavutil),Cint,(Ptr{AVFrame},),frame)
end

function av_frame_set_decode_error_flags(frame,val::Integer)
    ccall((:av_frame_set_decode_error_flags,libavutil),Void,(Ptr{AVFrame},Cint),frame,val)
end

function av_frame_get_pkt_size(frame)
    ccall((:av_frame_get_pkt_size,libavutil),Cint,(Ptr{AVFrame},),frame)
end

function av_frame_set_pkt_size(frame,val::Integer)
    ccall((:av_frame_set_pkt_size,libavutil),Void,(Ptr{AVFrame},Cint),frame,val)
end

function avpriv_frame_get_metadatap(frame)
    ccall((:avpriv_frame_get_metadatap,libavutil),Ptr{Ptr{AVDictionary}},(Ptr{AVFrame},),frame)
end

function av_frame_get_qp_table(f,stride,_type)
    ccall((:av_frame_get_qp_table,libavutil),Ptr{Int8},(Ptr{AVFrame},Ptr{Cint},Ptr{Cint}),f,stride,_type)
end

function av_frame_set_qp_table(f,buf,stride::Integer,_type::Integer)
    ccall((:av_frame_set_qp_table,libavutil),Cint,(Ptr{AVFrame},Ptr{AVBufferRef},Cint,Cint),f,buf,stride,_type)
end

function av_frame_get_colorspace(frame)
    ccall((:av_frame_get_colorspace,libavutil),Cint,(Ptr{AVFrame},),frame)
end

function av_frame_set_colorspace(frame,val::AVColorSpace)
    ccall((:av_frame_set_colorspace,libavutil),Void,(Ptr{AVFrame},AVColorSpace),frame,val)
end

function av_frame_get_color_range(frame)
    ccall((:av_frame_get_color_range,libavutil),Cint,(Ptr{AVFrame},),frame)
end

function av_frame_set_color_range(frame,val::AVColorRange)
    ccall((:av_frame_set_color_range,libavutil),Void,(Ptr{AVFrame},AVColorRange),frame,val)
end

function av_get_colorspace_name(val::AVColorSpace)
    ccall((:av_get_colorspace_name,libavutil),Ptr{UInt8},(AVColorSpace,),val)
end

function av_frame_alloc()
    ccall((:av_frame_alloc,libavutil),Ptr{AVFrame},())
end

function av_frame_free(frame)
    ccall((:av_frame_free,libavutil),Void,(Ptr{Ptr{AVFrame}},),frame)
end

function av_frame_ref(dst,src)
    ccall((:av_frame_ref,libavutil),Cint,(Ptr{AVFrame},Ptr{AVFrame}),dst,src)
end

function av_frame_clone(src)
    ccall((:av_frame_clone,libavutil),Ptr{AVFrame},(Ptr{AVFrame},),src)
end

function av_frame_unref(frame)
    ccall((:av_frame_unref,libavutil),Void,(Ptr{AVFrame},),frame)
end

function av_frame_move_ref(dst,src)
    ccall((:av_frame_move_ref,libavutil),Void,(Ptr{AVFrame},Ptr{AVFrame}),dst,src)
end

function av_frame_get_buffer(frame,align::Integer)
    ccall((:av_frame_get_buffer,libavutil),Cint,(Ptr{AVFrame},Cint),frame,align)
end

function av_frame_is_writable(frame)
    ccall((:av_frame_is_writable,libavutil),Cint,(Ptr{AVFrame},),frame)
end

function av_frame_make_writable(frame)
    ccall((:av_frame_make_writable,libavutil),Cint,(Ptr{AVFrame},),frame)
end

function av_frame_copy(dst,src)
    ccall((:av_frame_copy,libavutil),Cint,(Ptr{AVFrame},Ptr{AVFrame}),dst,src)
end

function av_frame_copy_props(dst,src)
    ccall((:av_frame_copy_props,libavutil),Cint,(Ptr{AVFrame},Ptr{AVFrame}),dst,src)
end

function av_frame_get_plane_buffer(frame,plane::Integer)
    ccall((:av_frame_get_plane_buffer,libavutil),Ptr{AVBufferRef},(Ptr{AVFrame},Cint),frame,plane)
end

function av_frame_new_side_data(frame,_type::AVFrameSideDataType,size::Integer)
    ccall((:av_frame_new_side_data,libavutil),Ptr{AVFrameSideData},(Ptr{AVFrame},AVFrameSideDataType,Cint),frame,_type,size)
end

function av_frame_get_side_data(frame,_type::AVFrameSideDataType)
    ccall((:av_frame_get_side_data,libavutil),Ptr{AVFrameSideData},(Ptr{AVFrame},AVFrameSideDataType),frame,_type)
end

function av_frame_remove_side_data(frame,_type::AVFrameSideDataType)
    ccall((:av_frame_remove_side_data,libavutil),Void,(Ptr{AVFrame},AVFrameSideDataType),frame,_type)
end
