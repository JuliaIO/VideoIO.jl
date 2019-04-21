# Julia wrapper for header: /usr/local/include/libavutil/opt.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_opt_show2,
    av_opt_set_defaults,
    av_opt_set_defaults2,
    av_set_options_string,
    av_opt_set_from_string,
    av_opt_free,
    av_opt_flag_is_set,
    av_opt_set_dict,
    av_opt_set_dict2,
    av_opt_get_key_value,
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
    av_opt_set_image_size,
    av_opt_set_pixel_fmt,
    av_opt_set_sample_fmt,
    av_opt_set_video_rate,
    av_opt_set_channel_layout,
    av_opt_set_dict_val,
    av_opt_get,
    av_opt_get_int,
    av_opt_get_double,
    av_opt_get_q,
    av_opt_get_image_size,
    av_opt_get_pixel_fmt,
    av_opt_get_sample_fmt,
    av_opt_get_video_rate,
    av_opt_get_channel_layout,
    av_opt_get_dict_val,
    av_opt_ptr,
    av_opt_freep_ranges,
    av_opt_query_ranges,
    av_opt_copy,
    av_opt_query_ranges_default,
    av_opt_is_set_to_default,
    av_opt_is_set_to_default_by_name,
    av_opt_serialize


function av_opt_show2(obj,av_log_obj,req_flags::Integer,rej_flags::Integer)
    ccall((:av_opt_show2,libavutil),Cint,(Ptr{Cvoid},Ptr{Cvoid},Cint,Cint),obj,av_log_obj,req_flags,rej_flags)
end

function av_opt_set_defaults(s)
    ccall((:av_opt_set_defaults,libavutil),Cvoid,(Ptr{Cvoid},),s)
end

function av_opt_set_defaults2(s,mask::Integer,flags::Integer)
    ccall((:av_opt_set_defaults2,libavutil),Cvoid,(Ptr{Cvoid},Cint,Cint),s,mask,flags)
end

function av_set_options_string(ctx,opts,key_val_sep,pairs_sep)
    ccall((:av_set_options_string,libavutil),Cint,(Ptr{Cvoid},Cstring,Cstring,Cstring),ctx,opts,key_val_sep,pairs_sep)
end

function av_opt_set_from_string(ctx,opts,shorthand,key_val_sep,pairs_sep)
    ccall((:av_opt_set_from_string,libavutil),Cint,(Ptr{Cvoid},Cstring,Ptr{Cstring},Cstring,Cstring),ctx,opts,shorthand,key_val_sep,pairs_sep)
end

function av_opt_free(obj)
    ccall((:av_opt_free,libavutil),Cvoid,(Ptr{Cvoid},),obj)
end

function av_opt_flag_is_set(obj,field_name,flag_name)
    ccall((:av_opt_flag_is_set,libavutil),Cint,(Ptr{Cvoid},Cstring,Cstring),obj,field_name,flag_name)
end

function av_opt_set_dict(obj,options)
    ccall((:av_opt_set_dict,libavutil),Cint,(Ptr{Cvoid},Ptr{Ptr{AVDictionary}}),obj,options)
end

function av_opt_set_dict2(obj,options,search_flags::Integer)
    ccall((:av_opt_set_dict2,libavutil),Cint,(Ptr{Cvoid},Ptr{Ptr{AVDictionary}},Cint),obj,options,search_flags)
end

function av_opt_get_key_value(ropts,key_val_sep,pairs_sep,flags::Integer,rkey,rval)
    ccall((:av_opt_get_key_value,libavutil),Cint,(Ptr{Cstring},Cstring,Cstring,UInt32,Ptr{Cstring},Ptr{Cstring}),ropts,key_val_sep,pairs_sep,flags,rkey,rval)
end

function av_opt_eval_flags(obj,o,val,flags_out)
    ccall((:av_opt_eval_flags,libavutil),Cint,(Ptr{Cvoid},Ptr{AVOption},Cstring,Ptr{Cint}),obj,o,val,flags_out)
end

function av_opt_eval_int(obj,o,val,int_out)
    ccall((:av_opt_eval_int,libavutil),Cint,(Ptr{Cvoid},Ptr{AVOption},Cstring,Ptr{Cint}),obj,o,val,int_out)
end

function av_opt_eval_int64(obj,o,val,int64_out)
    ccall((:av_opt_eval_int64,libavutil),Cint,(Ptr{Cvoid},Ptr{AVOption},Cstring,Ptr{Int64}),obj,o,val,int64_out)
end

function av_opt_eval_float(obj,o,val,float_out)
    ccall((:av_opt_eval_float,libavutil),Cint,(Ptr{Cvoid},Ptr{AVOption},Cstring,Ptr{Cfloat}),obj,o,val,float_out)
end

function av_opt_eval_double(obj,o,val,double_out)
    ccall((:av_opt_eval_double,libavutil),Cint,(Ptr{Cvoid},Ptr{AVOption},Cstring,Ptr{Cdouble}),obj,o,val,double_out)
end

function av_opt_eval_q(obj,o,val,q_out)
    ccall((:av_opt_eval_q,libavutil),Cint,(Ptr{Cvoid},Ptr{AVOption},Cstring,Ptr{AVRational}),obj,o,val,q_out)
end

function av_opt_find(obj,name,unit,opt_flags::Integer,search_flags::Integer)
    ccall((:av_opt_find,libavutil),Ptr{AVOption},(Ptr{Cvoid},Cstring,Cstring,Cint,Cint),obj,name,unit,opt_flags,search_flags)
end

function av_opt_find2(obj,name,unit,opt_flags::Integer,search_flags::Integer,target_obj)
    ccall((:av_opt_find2,libavutil),Ptr{AVOption},(Ptr{Cvoid},Cstring,Cstring,Cint,Cint,Ptr{Ptr{Cvoid}}),obj,name,unit,opt_flags,search_flags,target_obj)
end

function av_opt_next(obj,prev)
    ccall((:av_opt_next,libavutil),Ptr{AVOption},(Ptr{Cvoid},Ptr{AVOption}),obj,prev)
end

function av_opt_child_next(obj,prev)
    ccall((:av_opt_child_next,libavutil),Ptr{Cvoid},(Ptr{Cvoid},Ptr{Cvoid}),obj,prev)
end

function av_opt_child_class_next(parent,prev)
    ccall((:av_opt_child_class_next,libavutil),Ptr{AVClass},(Ptr{AVClass},Ptr{AVClass}),parent,prev)
end

function av_opt_set(obj,name,val,search_flags::Integer)
    ccall((:av_opt_set,libavutil),Cint,(Ptr{Cvoid},Cstring,Cstring,Cint),obj,name,val,search_flags)
end

function av_opt_set_int(obj,name,val::Int64,search_flags::Integer)
    ccall((:av_opt_set_int,libavutil),Cint,(Ptr{Cvoid},Cstring,Int64,Cint),obj,name,val,search_flags)
end

function av_opt_set_double(obj,name,val::Cdouble,search_flags::Integer)
    ccall((:av_opt_set_double,libavutil),Cint,(Ptr{Cvoid},Cstring,Cdouble,Cint),obj,name,val,search_flags)
end

function av_opt_set_q(obj,name,val::AVRational,search_flags::Integer)
    ccall((:av_opt_set_q,libavutil),Cint,(Ptr{Cvoid},Cstring,AVRational,Cint),obj,name,val,search_flags)
end

function av_opt_set_bin(obj,name,val,size::Integer,search_flags::Integer)
    ccall((:av_opt_set_bin,libavutil),Cint,(Ptr{Cvoid},Cstring,Ptr{UInt8},Cint,Cint),obj,name,val,size,search_flags)
end

function av_opt_set_image_size(obj,name,w::Integer,h::Integer,search_flags::Integer)
    ccall((:av_opt_set_image_size,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Cint,Cint),obj,name,w,h,search_flags)
end

function av_opt_set_pixel_fmt(obj,name,fmt::AVPixelFormat,search_flags::Integer)
    ccall((:av_opt_set_pixel_fmt,libavutil),Cint,(Ptr{Cvoid},Cstring,AVPixelFormat,Cint),obj,name,fmt,search_flags)
end

function av_opt_set_sample_fmt(obj,name,fmt::AVSampleFormat,search_flags::Integer)
    ccall((:av_opt_set_sample_fmt,libavutil),Cint,(Ptr{Cvoid},Cstring,AVSampleFormat,Cint),obj,name,fmt,search_flags)
end

function av_opt_set_video_rate(obj,name,val::AVRational,search_flags::Integer)
    ccall((:av_opt_set_video_rate,libavutil),Cint,(Ptr{Cvoid},Cstring,AVRational,Cint),obj,name,val,search_flags)
end

function av_opt_set_channel_layout(obj,name,ch_layout::Int64,search_flags::Integer)
    ccall((:av_opt_set_channel_layout,libavutil),Cint,(Ptr{Cvoid},Cstring,Int64,Cint),obj,name,ch_layout,search_flags)
end

function av_opt_set_dict_val(obj,name,val,search_flags::Integer)
    ccall((:av_opt_set_dict_val,libavutil),Cint,(Ptr{Cvoid},Cstring,Ptr{AVDictionary},Cint),obj,name,val,search_flags)
end

function av_opt_get(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{Ptr{UInt8}}),obj,name,search_flags,out_val)
end

function av_opt_get_int(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get_int,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{Int64}),obj,name,search_flags,out_val)
end

function av_opt_get_double(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get_double,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{Cdouble}),obj,name,search_flags,out_val)
end

function av_opt_get_q(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get_q,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{AVRational}),obj,name,search_flags,out_val)
end

function av_opt_get_image_size(obj,name,search_flags::Integer,w_out,h_out)
    ccall((:av_opt_get_image_size,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{Cint},Ptr{Cint}),obj,name,search_flags,w_out,h_out)
end

function av_opt_get_pixel_fmt(obj,name,search_flags::Integer,out_fmt)
    ccall((:av_opt_get_pixel_fmt,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{AVPixelFormat}),obj,name,search_flags,out_fmt)
end

function av_opt_get_sample_fmt(obj,name,search_flags::Integer,out_fmt)
    ccall((:av_opt_get_sample_fmt,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{AVSampleFormat}),obj,name,search_flags,out_fmt)
end

function av_opt_get_video_rate(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get_video_rate,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{AVRational}),obj,name,search_flags,out_val)
end

function av_opt_get_channel_layout(obj,name,search_flags::Integer,ch_layout)
    ccall((:av_opt_get_channel_layout,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{Int64}),obj,name,search_flags,ch_layout)
end

function av_opt_get_dict_val(obj,name,search_flags::Integer,out_val)
    ccall((:av_opt_get_dict_val,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint,Ptr{Ptr{AVDictionary}}),obj,name,search_flags,out_val)
end

function av_opt_ptr(avclass,obj,name)
    ccall((:av_opt_ptr,libavutil),Ptr{Cvoid},(Ptr{AVClass},Ptr{Cvoid},Cstring),avclass,obj,name)
end

function av_opt_freep_ranges(ranges)
    ccall((:av_opt_freep_ranges,libavutil),Cvoid,(Ptr{Ptr{AVOptionRanges}},),ranges)
end

function av_opt_query_ranges(arg1,obj,key,flags::Integer)
    ccall((:av_opt_query_ranges,libavutil),Cint,(Ptr{Ptr{AVOptionRanges}},Ptr{Cvoid},Cstring,Cint),arg1,obj,key,flags)
end

function av_opt_copy(dest,src)
    ccall((:av_opt_copy,libavutil),Cint,(Ptr{Cvoid},Ptr{Cvoid}),dest,src)
end

function av_opt_query_ranges_default(arg1,obj,key,flags::Integer)
    ccall((:av_opt_query_ranges_default,libavutil),Cint,(Ptr{Ptr{AVOptionRanges}},Ptr{Cvoid},Cstring,Cint),arg1,obj,key,flags)
end

function av_opt_is_set_to_default(obj,o)
    ccall((:av_opt_is_set_to_default,libavutil),Cint,(Ptr{Cvoid},Ptr{AVOption}),obj,o)
end

function av_opt_is_set_to_default_by_name(obj,name,search_flags::Integer)
    ccall((:av_opt_is_set_to_default_by_name,libavutil),Cint,(Ptr{Cvoid},Cstring,Cint),obj,name,search_flags)
end

function av_opt_serialize(obj,opt_flags::Integer,flags::Integer,buffer,key_val_sep::UInt8,pairs_sep::UInt8)
    ccall((:av_opt_serialize,libavutil),Cint,(Ptr{Cvoid},Cint,Cint,Ptr{Cstring},UInt8,UInt8),obj,opt_flags,flags,buffer,key_val_sep,pairs_sep)
end
