# Julia wrapper for header: /usr/include/libavutil/eval.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_expr_parse_and_eval(_res::Ptr,_s::Union(Ptr,ByteString),_const_names::Ptr,_const_values::Ptr,_func1_names::Ptr,_funcs1::Ptr,_func2_names::Ptr,_funcs2::Ptr,_opaque::Ptr,_log_offset::Integer,_log_ctx::Ptr)
    res = convert(Ptr{Cdouble},_res)
    s = convert(Ptr{Uint8},_s)
    const_names = convert(Ptr{Ptr{Uint8}},_const_names)
    const_values = convert(Ptr{Cdouble},_const_values)
    func1_names = convert(Ptr{Ptr{Uint8}},_func1_names)
    funcs1 = convert(Ptr{Ptr{Void}},_funcs1)
    func2_names = convert(Ptr{Ptr{Uint8}},_func2_names)
    funcs2 = convert(Ptr{Ptr{Void}},_funcs2)
    opaque = convert(Ptr{Void},_opaque)
    log_offset = int32(_log_offset)
    log_ctx = convert(Ptr{Void},_log_ctx)
    ccall((:av_expr_parse_and_eval,libavutil),Cint,(Ptr{Cdouble},Ptr{Uint8},Ptr{Ptr{Uint8}},Ptr{Cdouble},Ptr{Ptr{Uint8}},Ptr{Ptr{Void}},Ptr{Ptr{Uint8}},Ptr{Ptr{Void}},Ptr{Void},Cint,Ptr{Void}),res,s,const_names,const_values,func1_names,funcs1,func2_names,funcs2,opaque,log_offset,log_ctx)
end
function av_expr_parse(_expr::Ptr,_s::Union(Ptr,ByteString),_const_names::Ptr,_func1_names::Ptr,_funcs1::Ptr,_func2_names::Ptr,_funcs2::Ptr,_log_offset::Integer,_log_ctx::Ptr)
    expr = convert(Ptr{Ptr{AVExpr}},_expr)
    s = convert(Ptr{Uint8},_s)
    const_names = convert(Ptr{Ptr{Uint8}},_const_names)
    func1_names = convert(Ptr{Ptr{Uint8}},_func1_names)
    funcs1 = convert(Ptr{Ptr{Void}},_funcs1)
    func2_names = convert(Ptr{Ptr{Uint8}},_func2_names)
    funcs2 = convert(Ptr{Ptr{Void}},_funcs2)
    log_offset = int32(_log_offset)
    log_ctx = convert(Ptr{Void},_log_ctx)
    ccall((:av_expr_parse,libavutil),Cint,(Ptr{Ptr{AVExpr}},Ptr{Uint8},Ptr{Ptr{Uint8}},Ptr{Ptr{Uint8}},Ptr{Ptr{Void}},Ptr{Ptr{Uint8}},Ptr{Ptr{Void}},Cint,Ptr{Void}),expr,s,const_names,func1_names,funcs1,func2_names,funcs2,log_offset,log_ctx)
end
function av_expr_eval(_e::Ptr,_const_values::Ptr,_opaque::Ptr)
    e = convert(Ptr{AVExpr},_e)
    const_values = convert(Ptr{Cdouble},_const_values)
    opaque = convert(Ptr{Void},_opaque)
    ccall((:av_expr_eval,libavutil),Cdouble,(Ptr{AVExpr},Ptr{Cdouble},Ptr{Void}),e,const_values,opaque)
end
function av_expr_free(_e::Ptr)
    e = convert(Ptr{AVExpr},_e)
    ccall((:av_expr_free,libavutil),Void,(Ptr{AVExpr},),e)
end
function av_strtod(_numstr::Union(Ptr,ByteString),_tail::Ptr)
    numstr = convert(Ptr{Uint8},_numstr)
    tail = convert(Ptr{Ptr{Uint8}},_tail)
    ccall((:av_strtod,libavutil),Cdouble,(Ptr{Uint8},Ptr{Ptr{Uint8}}),numstr,tail)
end
