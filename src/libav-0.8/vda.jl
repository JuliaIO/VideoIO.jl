# Julia wrapper for header: /usr/include/libavcodec/vda.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 ff_vda_create_decoder (Ptr{Void}, Ptr{uint8_t}, Int32) libavcodec
@c Int32 ff_vda_destroy_decoder (Ptr{Void},) libavcodec
@c Ptr{vda_frame} ff_vda_queue_pop (Ptr{Void},) libavcodec
@c None ff_vda_release_vda_frame (Ptr{vda_frame},) libavcodec

