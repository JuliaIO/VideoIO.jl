# Julia wrapper for header: /usr/local/include/libavutil/frame.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_frame_alloc,
    av_frame_free,
    av_frame_ref,
    av_frame_clone,
    av_frame_unref,
    av_frame_move_ref,
    av_frame_get_buffer,
    av_frame_is_writable,
    av_frame_make_writable,
    av_frame_copy_props,
    av_frame_get_plane_buffer,
    av_frame_new_side_data,
    av_frame_get_side_data


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
