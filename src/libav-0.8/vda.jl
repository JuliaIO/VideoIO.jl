# Julia wrapper for header: /usr/include/libavcodec/vda.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function ff_vda_create_decoder(_vda_ctx::Ptr,_extradata::Union(Ptr,ByteString),_extradata_size::Integer)
    vda_ctx = convert(Ptr{vda_context},_vda_ctx)
    extradata = convert(Ptr{Uint8},_extradata)
    extradata_size = int32(_extradata_size)
    ccall((:ff_vda_create_decoder,libavcodec),Cint,(Ptr{vda_context},Ptr{Uint8},Cint),vda_ctx,extradata,extradata_size)
end
function ff_vda_destroy_decoder(_vda_ctx::Ptr)
    vda_ctx = convert(Ptr{vda_context},_vda_ctx)
    ccall((:ff_vda_destroy_decoder,libavcodec),Cint,(Ptr{vda_context},),vda_ctx)
end
function ff_vda_queue_pop(_vda_ctx::Ptr)
    vda_ctx = convert(Ptr{vda_context},_vda_ctx)
    ccall((:ff_vda_queue_pop,libavcodec),Ptr{vda_frame},(Ptr{vda_context},),vda_ctx)
end
function ff_vda_release_vda_frame(_frame::Ptr)
    frame = convert(Ptr{vda_frame},_frame)
    ccall((:ff_vda_release_vda_frame,libavcodec),Void,(Ptr{vda_frame},),frame)
end
