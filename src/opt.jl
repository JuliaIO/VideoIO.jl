# Julia wrapper for header: /usr/include/libavutil/opt.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Ptr{:AVOption} av_find_opt (Ptr{:None},Ptr{:Uint8},Ptr{:Uint8},:Int32,:Int32) libavutil
@c Int32 av_set_string3 (Ptr{:None},Ptr{:Uint8},Ptr{:Uint8},:Int32,Ptr{Ptr{:AVOption}}) libavutil
@c Ptr{:AVOption} av_set_double (Ptr{:None},Ptr{:Uint8},:Float64) libavutil
@c Ptr{:AVOption} av_set_q (Ptr{:None},Ptr{:Uint8},:AVRational) libavutil
@c Ptr{:AVOption} av_set_int (Ptr{:None},Ptr{:Uint8},:int64_t) libavutil
@c Float64 av_get_double (Ptr{:None},Ptr{:Uint8},Ptr{Ptr{:AVOption}}) libavutil
@c AVRational av_get_q (Ptr{:None},Ptr{:Uint8},Ptr{Ptr{:AVOption}}) libavutil
@c int64_t av_get_int (Ptr{:None},Ptr{:Uint8},Ptr{Ptr{:AVOption}}) libavutil
@c Ptr{:Uint8} av_get_string (Ptr{:None},Ptr{:Uint8},Ptr{Ptr{:AVOption}},Ptr{:Uint8},:Int32) libavutil
@c Ptr{:AVOption} av_next_option (Ptr{:None},Ptr{:AVOption}) libavutil
@c Int32 av_opt_show2 (Ptr{:None},Ptr{:None},:Int32,:Int32) libavutil
@c None av_opt_set_defaults (Ptr{:None},) libavutil
@c None av_opt_set_defaults2 (Ptr{:None},:Int32,:Int32) libavutil
@c Int32 av_set_options_string (Ptr{:None},Ptr{:Uint8},Ptr{:Uint8},Ptr{:Uint8}) libavutil
@c None av_opt_free (Ptr{:None},) libavutil
@c Int32 av_opt_flag_is_set (Ptr{:None},Ptr{:Uint8},Ptr{:Uint8}) libavutil
@c Int32 av_opt_set_dict (Ptr{:None},Ptr{Ptr{:Void}}) libavutil
@c Int32 av_opt_eval_flags (Ptr{:None},Ptr{:AVOption},Ptr{:Uint8},Ptr{:Int32}) libavutil
@c Int32 av_opt_eval_int (Ptr{:None},Ptr{:AVOption},Ptr{:Uint8},Ptr{:Int32}) libavutil
@c Int32 av_opt_eval_int64 (Ptr{:None},Ptr{:AVOption},Ptr{:Uint8},Ptr{:int64_t}) libavutil
@c Int32 av_opt_eval_float (Ptr{:None},Ptr{:AVOption},Ptr{:Uint8},Ptr{:Float32}) libavutil
@c Int32 av_opt_eval_double (Ptr{:None},Ptr{:AVOption},Ptr{:Uint8},Ptr{:Float64}) libavutil
@c Int32 av_opt_eval_q (Ptr{:None},Ptr{:AVOption},Ptr{:Uint8},Ptr{:AVRational}) libavutil
@c Ptr{:AVOption} av_opt_find (Ptr{:None},Ptr{:Uint8},Ptr{:Uint8},:Int32,:Int32) libavutil
@c Ptr{:AVOption} av_opt_find2 (Ptr{:None},Ptr{:Uint8},Ptr{:Uint8},:Int32,:Int32,Ptr{Ptr{:None}}) libavutil
@c Ptr{:AVOption} av_opt_next (Ptr{:None},Ptr{:AVOption}) libavutil
@c Ptr{:None} av_opt_child_next (Ptr{:None},Ptr{:None}) libavutil
@c Ptr{:AVClass} av_opt_child_class_next (Ptr{:AVClass},Ptr{:AVClass}) libavutil
@c Int32 av_opt_set (Ptr{:None},Ptr{:Uint8},Ptr{:Uint8},:Int32) libavutil
@c Int32 av_opt_set_int (Ptr{:None},Ptr{:Uint8},:int64_t,:Int32) libavutil
@c Int32 av_opt_set_double (Ptr{:None},Ptr{:Uint8},:Float64,:Int32) libavutil
@c Int32 av_opt_set_q (Ptr{:None},Ptr{:Uint8},:AVRational,:Int32) libavutil
@c Int32 av_opt_get (Ptr{:None},Ptr{:Uint8},:Int32,Ptr{Ptr{:uint8_t}}) libavutil
@c Int32 av_opt_get_int (Ptr{:None},Ptr{:Uint8},:Int32,Ptr{:int64_t}) libavutil
@c Int32 av_opt_get_double (Ptr{:None},Ptr{:Uint8},:Int32,Ptr{:Float64}) libavutil
@c Int32 av_opt_get_q (Ptr{:None},Ptr{:Uint8},:Int32,Ptr{:AVRational}) libavutil


