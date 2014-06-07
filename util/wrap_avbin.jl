
import Clang.wrap_c
import DataStructures: DefaultDict
import Base.Meta.isexpr
using Match
 
indexh         = joinpath(JULIA_HOME, "../include/clang-c/Index.h")
clang_includes = [joinpath(JULIA_HOME, "../lib/clang/3.3/include"), joinpath(dirname(indexh), "..")]
 
av_headers = ["/usr/include/avbin.h"]
for header in av_headers
    println(header)
end
 
get_header_library(hpath) = :libavbin

get_header_outfile(hpath) = "avbin.jl"

check_use_header(top_h, hpath) = basename(top_h) == "avbin.h"

function rewrite_fn(e::Expr)
    (head, call, body) = @match e Expr(head, [call, body], _) => (head, call, body)

    parms = Any[]
    content = Any[]

    fn_name = call.args[1]
    push!(parms, fn_name)  # function name

    for call_arg in call.args[2:end]
        @match call_arg begin
            Expr(:(::), [sym, Expr(:curly, [:Ptr, :Uint8], _)], _) => 
                begin 
                    orig_type = Expr(:curly, :Ptr, :Uint8)
                    _sym = symbol(string("_", sym))
                    push!(parms,   :($_sym::Union(Ptr,ByteString)))
                    push!(content, :($sym = convert($orig_type, $_sym)))
                end
            Expr(:(::), [sym, Expr(:curly, [:Ptr, target_type], _)], _) => 
                begin 
                    orig_type = Expr(:curly, :Ptr, target_type)
                    _sym = symbol(string("_", sym))
                    push!(parms,   :($_sym::Ptr))
                    push!(content, :($sym = convert($orig_type, $_sym)))
                end
            Expr(:(::), [sym, (:Int32 || :Uint32 || :Int64 || :Uint64 || :Cuint || :Cint || :Csize_t)], _) => 
                begin
                    println(sym)
                    push!(parms, :($sym::Integer))
                end
            _ => push!(parms, call_arg)
        end
    end

    if !isexpr(body, :block)
        push!(content, body)
    else
        append!(content, body.args)
    end

    call = Expr(:call, parms...)
    body = Expr(:block, content...)

    new = Expr(e.head, call, body)

    return new
end

out_path = pwd()

context = wrap_c.init(
    output_file = "avbin.jl",
    common_file = "avbin_h.jl",
    clang_includes = clang_includes,
    header_wrapped = check_use_header, 
    header_library = get_header_library,
    header_outputfile = get_header_outfile,
    func_rewriter = rewrite_fn)
wrap_c.wrap_c_headers(context, av_headers)
