# Julia wrapper for header: /usr/include/libavutil/log.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_vlog(_avcl::Ptr,_level::Integer,_fmt::Union(Ptr,ByteString),_::Ptr)
    avcl = convert(Ptr{Void},_avcl)
    level = int32(_level)
    fmt = convert(Ptr{Uint8},_fmt)
     = convert(Ptr{__va_list_tag},_)
    ccall((:av_vlog,libavutil),Void,(Ptr{Void},Cint,Ptr{Uint8},Ptr{__va_list_tag}),avcl,level,fmt,)
end
function av_log_get_level()
    ccall((:av_log_get_level,libavutil),Cint,())
end
function av_log_set_level(_::Integer)
     = int32(_)
    ccall((:av_log_set_level,libavutil),Void,(Cint,),)
end
function av_log_set_callback(_::Ptr)
     = convert(Ptr{Void},_)
    ccall((:av_log_set_callback,libavutil),Void,(Ptr{Void},),)
end
function av_log_default_callback(_ptr::Ptr,_level::Integer,_fmt::Union(Ptr,ByteString),_vl::Ptr)
    ptr = convert(Ptr{Void},_ptr)
    level = int32(_level)
    fmt = convert(Ptr{Uint8},_fmt)
    vl = convert(Ptr{__va_list_tag},_vl)
    ccall((:av_log_default_callback,libavutil),Void,(Ptr{Void},Cint,Ptr{Uint8},Ptr{__va_list_tag}),ptr,level,fmt,vl)
end
function av_default_item_name(_ctx::Ptr)
    ctx = convert(Ptr{Void},_ctx)
    ccall((:av_default_item_name,libavutil),Ptr{Uint8},(Ptr{Void},),ctx)
end
function av_log_set_flags(_arg::Integer)
    arg = int32(_arg)
    ccall((:av_log_set_flags,libavutil),Void,(Cint,),arg)
end
