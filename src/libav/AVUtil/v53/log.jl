# Julia wrapper for header: /usr/local/include/libavutil/log.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_vlog,
    av_log_get_level,
    av_log_set_level,
    av_log_set_callback,
    av_log_default_callback,
    av_default_item_name,
    av_log_set_flags


# function av_vlog(avcl,level::Integer,fmt,vl)
#     ccall((:av_vlog,libavutil),Void,(Ptr{Void},Cint,Ptr{UInt8},Ptr{__va_list_tag}),avcl,level,fmt,vl)
# end

function av_log_get_level()
    ccall((:av_log_get_level,libavutil),Cint,())
end

function av_log_set_level(level::Integer)
    ccall((:av_log_set_level,libavutil),Cvoid,(Cint,),level)
end

function av_log_set_callback(callback)
    ccall((:av_log_set_callback,libavutil),Cvoid,(Ptr{Cvoid},),callback)
end

# function av_log_default_callback(avcl,level::Integer,fmt,vl)
#     ccall((:av_log_default_callback,libavutil),Void,(Ptr{Void},Cint,Ptr{UInt8},Ptr{__va_list_tag}),avcl,level,fmt,vl)
# end

function av_default_item_name(ctx)
    ccall((:av_default_item_name,libavutil),Ptr{UInt8},(Ptr{Cvoid},),ctx)
end

function av_log_set_flags(arg::Integer)
    ccall((:av_log_set_flags,libavutil),Cvoid,(Cint,),arg)
end
