# Julia wrapper for header: /usr/include/libavutil/opt.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_opt_show2,
    av_opt_set_defaults,
    av_set_options_string,
    av_opt_free,
    av_opt_flag_is_set,
    av_opt_set_dict,
    av_opt_eval_flags,
    av_opt_eval_int,
    av_opt_eval_int64,
    av_opt_eval_float,
    av_opt_eval_double,
    av_opt_eval_q,
    av_opt_find,
    av_opt_find2,
    av_opt_next,
    av_opt_child_next,
    av_opt_child_class_next,
    av_opt_set,
    av_opt_set_int,
    av_opt_set_double,
    av_opt_set_q,
    av_opt_set_bin,
    av_opt_get,
    av_opt_get_int,
    av_opt_get_double,
    av_opt_get_q


function av_opt_show2(obj,av_log_obj,req_flags::Integer,rej_flags::Integer)
    ccall((:av_opt_show2,libavutil),Cint,(Ptr{Void},Ptr{Void},Cint,Cint),obj,av_log_obj,req_flags,rej_flags)
end

function av_opt_set_defaults(s)
    ccall((:av_opt_set_defaults,libavutil),Void,(Ptr{Void},),s)
end

function av_set_options_string(ctx,opts,key_val_sep,pairs_sep)
    ccall((:av_set_options_string,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Ptr{Uint8},Ptr{Uint8}),ctx,opts,key_val_sep,pairs_sep)
end

function av_opt_free(obj)
    ccall((:av_opt_free,libavutil),Void,(Ptr{Void},),obj)
end

function av_opt_flag_is_set(obj,field_name,flag_name)
    ccall((:av_opt_flag_is_set,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Ptr{Uint8}),obj,field_name,flag_name)
end

function av_opt_set_dict(obj,options)
    ccall((:av_opt_set_dict,libavutil),Cint,(Ptr{Void},Ptr{Ptr{AVDictionary}}),obj,options)
end

function av_opt_eval_flags(obj,o,val,flags_out)
    ccall((:av_opt_eval_flags,libavutil),Cint,(Ptr{Void},Ptr{AVOption},Ptr{Uint8},Ptr{Cint}),obj,o,val,flags_out)
end

function av_opt_eval_int(obj,o,val,int_out)
    ccall((:av_opt_eval_int,libavutil),Cint,(Ptr{Void},Ptr{AVOption},Ptr{Uint8},Ptr{Cint}),obj,o,val,int_out)
end

function av_opt_eval_int64(obj,o,val,int64_out)
    ccall((:av_opt_eval_int64,libavutil),Cint,(Ptr{Void},Ptr{AVOption},Ptr{Uint8},Ptr{Int64}),obj,o,val,int64_out)
end

function av_opt_eval_float(obj,o,val,float_out)
    ccall((:av_opt_eval_float,libavutil),Cint,(Ptr{Void},Ptr{AVOption},Ptr{Uint8},Ptr{Cfloat}),obj,o,val,float_out)
end

function av_opt_eval_double(obj,o,val,double_out)
    ccall((:av_opt_eval_double,libavutil),Cint,(Ptr{Void},Ptr{AVOption},Ptr{Uint8},Ptr{Cdouble}),obj,o,val,double_out)
end

function av_opt_eval_q(obj,o,val,q_out)
    ccall((:av_opt_eval_q,libavutil),Cint,(Ptr{Void},Ptr{AVOption},Ptr{Uint8},Ptr{AVRational}),obj,o,val,q_out)
end

function av_opt_find(obj,name,unit,opt_flags::Integer,search_flags::Integer)
    ccall((:av_opt_find,libavutil),Ptr{AVOption},(Ptr{Void},Ptr{Uint8},Ptr{Uint8},Cint,Cint),obj,name,unit,opt_flags,search_flags)
end

function av_opt_find2(obj,name,unit,opt_flags::Integer,search_flags::Integer,target_obj)
    ccall((:av_opt_find2,libavutil),Ptr{AVOption},(Ptr{Void},Ptr{Uint8},Ptr{Uint8},Cint,Cint,Ptr{Ptr{Void}}),obj,name,unit,opt_flags,search_flags,target_obj)
end

function av_opt_next(obj,prev)
    ccall((:av_opt_next,libavutil),Ptr{AVOption},(Ptr{Void},Ptr{AVOption}),obj,prev)
end

function av_opt_child_next(obj,prev)
    ccall((:av_opt_child_next,libavutil),Ptr{Void},(Ptr{Void},Ptr{Void}),obj,prev)
end

function av_opt_child_class_next(parent,prev)
    ccall((:av_opt_child_class_next,libavutil),Ptr{AVClass},(Ptr{AVClass},Ptr{AVClass}),parent,prev)
end

function av_opt_set(obj,name,val,search_flags::Integer)
    ccall((:av_opt_set,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Ptr{Uint8},Cint),obj,name,val,search_flags)
end

function av_opt_set_int(obj,name,val::Int64,search_flags::Integer)
    ccall((:av_opt_set_int,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Int64,Cint),obj,name,val,search_flags)
end

function av_opt_set_double(obj,name,val::Cdouble,search_flags::Integer)
    ccall((:av_opt_set_double,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Cdouble,Cint),obj,name,val,search_flags)
end

function av_opt_set_q(obj,name,val::AVRational,search_flags::Integer)
    ccall((:av_opt_set_q,libavutil),Cint,(Ptr{Void},Ptr{Uint8},AVRational,Cint),obj,name,val,search_flags)
end

function av_opt_set_bin(obj,name,val,size::Integer,search_flags::Integer)
    ccall((:av_opt_set_bin,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Ptr{Uint8},Cint,Cint),obj,name,val,size,search_flags)
end

function av_opt_get(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Cint,Ptr{Ptr{Uint8}}),obj,name,search_flags,out_val)
end

function av_opt_get_int(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get_int,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Cint,Ptr{Int64}),obj,name,search_flags,out_val)
end

function av_opt_get_double(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get_double,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Cint,Ptr{Cdouble}),obj,name,search_flags,out_val)
end

function av_opt_get_q(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get_q,libavutil),Cint,(Ptr{Void},Ptr{Uint8},Cint,Ptr{AVRational}),obj,name,search_flags,out_val)
end
