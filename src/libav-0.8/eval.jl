# Julia wrapper for header: /usr/include/libavutil/eval.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 av_expr_parse_and_eval (Ptr{Float64}, Ptr{Uint8}, Ptr{Ptr{Uint8}}, Ptr{Float64}, Ptr{Ptr{Uint8}}, Ptr{Ptr{Void}}, Ptr{Ptr{Uint8}}, Ptr{Ptr{Void}}, Ptr{None}, Int32, Ptr{None}) libavutil
@c Int32 av_expr_parse (Ptr{Ptr{AVExpr}}, Ptr{Uint8}, Ptr{Ptr{Uint8}}, Ptr{Ptr{Uint8}}, Ptr{Ptr{Void}}, Ptr{Ptr{Uint8}}, Ptr{Ptr{Void}}, Int32, Ptr{None}) libavutil
@c Float64 av_expr_eval (Ptr{AVExpr}, Ptr{Float64}, Ptr{None}) libavutil
@c None av_expr_free (Ptr{AVExpr},) libavutil
@c Float64 av_strtod (Ptr{Uint8}, Ptr{Ptr{Uint8}}) libavutil

