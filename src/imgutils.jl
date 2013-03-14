# Julia wrapper for header: /usr/include/libavutil/imgutils.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c None av_read_image_line (Ptr{:uint16_t},Ptr{Ptr{:uint8_t}},Ptr{:Int32},Ptr{:AVPixFmtDescriptor},:Int32,:Int32,:Int32,:Int32,:Int32) libavutil
@c None av_write_image_line (Ptr{:uint16_t},Ptr{Ptr{:uint8_t}},Ptr{:Int32},Ptr{:AVPixFmtDescriptor},:Int32,:Int32,:Int32,:Int32) libavutil
@c Int32 av_get_pix_fmt (Ptr{:Uint8},) libavutil
@c Ptr{:Uint8} av_get_pix_fmt_name (:Void,) libavutil
@c Ptr{:Uint8} av_get_pix_fmt_string (Ptr{:Uint8},:Int32,:Void) libavutil
@c Int32 av_get_bits_per_pixel (Ptr{:AVPixFmtDescriptor},) libavutil
@c None av_image_fill_max_pixsteps (Ptr{:Int32},Ptr{:Int32},Ptr{:AVPixFmtDescriptor}) libavutil
@c Int32 av_image_get_linesize (:Void,:Int32,:Int32) libavutil
@c Int32 av_image_fill_linesizes (Ptr{:Int32},:Void,:Int32) libavutil
@c Int32 av_image_fill_pointers (Ptr{Ptr{:uint8_t}},:Void,:Int32,Ptr{:uint8_t},Ptr{:Int32}) libavutil
@c Int32 av_image_alloc (Ptr{Ptr{:uint8_t}},Ptr{:Int32},:Int32,:Int32,:Void,:Int32) libavutil
@c None av_image_copy_plane (Ptr{:uint8_t},:Int32,Ptr{:uint8_t},:Int32,:Int32,:Int32) libavutil
@c None av_image_copy (Ptr{Ptr{:uint8_t}},Ptr{:Int32},Ptr{Ptr{:uint8_t}},Ptr{:Int32},:Void,:Int32,:Int32) libavutil
@c Int32 av_image_check_size (:Uint32,:Uint32,:Int32,Ptr{:None}) libavutil
@c Int32 ff_set_systematic_pal2 (Ptr{:uint32_t},:Void) libavutil

