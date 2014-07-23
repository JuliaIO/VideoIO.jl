# Julia wrapper for header: /usr/include/libavutil/log.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_vlog,
    av_log_get_level,
    av_log_set_level,
    av_log_set_callback,
    av_log_default_callback,
    av_default_item_name,
    av_log_set_flags


function av_vlog(avcl,level::Integer,fmt,arg1)
    ccall((:av_vlog,libavutil),Void,(Ptr{Void},Cint,Ptr{Uint8},Ptr{__va_list_tag}),avcl,level,fmt,arg1)
end

function av_log_get_level()
    ccall((:av_log_get_level,libavutil),Cint,())
end

function av_log_set_level(arg1::Integer)
    ccall((:av_log_set_level,libavutil),Void,(Cint,),arg1)
end

function av_log_set_callback(arg1)
    ccall((:av_log_set_callback,libavutil),Void,(Ptr{Void},),arg1)
end

function av_log_default_callback(ptr,level::Integer,fmt,vl)
    ccall((:av_log_default_callback,libavutil),Void,(Ptr{Void},Cint,Ptr{Uint8},Ptr{__va_list_tag}),ptr,level,fmt,vl)
end

function av_default_item_name(ctx)
    ccall((:av_default_item_name,libavutil),Ptr{Uint8},(Ptr{Void},),ctx)
end

function av_log_set_flags(arg::Integer)
    ccall((:av_log_set_flags,libavutil),Void,(Cint,),arg)
end
