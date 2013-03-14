# Julia wrapper for header: /usr/include/libavutil/pixdesc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c None av_read_image_line (Ptr{:uint16_t},Ptr{Ptr{:uint8_t}},Ptr{:Int32},Ptr{:AVPixFmtDescriptor},:Int32,:Int32,:Int32,:Int32,:Int32) libavutil
@c None av_write_image_line (Ptr{:uint16_t},Ptr{Ptr{:uint8_t}},Ptr{:Int32},Ptr{:AVPixFmtDescriptor},:Int32,:Int32,:Int32,:Int32) libavutil
@c Int32 av_get_pix_fmt (Ptr{:Uint8},) libavutil
@c Ptr{:Uint8} av_get_pix_fmt_name (:Void,) libavutil
@c Ptr{:Uint8} av_get_pix_fmt_string (Ptr{:Uint8},:Int32,:Void) libavutil
@c Int32 av_get_bits_per_pixel (Ptr{:AVPixFmtDescriptor},) libavutil

