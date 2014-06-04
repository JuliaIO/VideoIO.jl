
import Clang.wrap_c
import DataStructures: DefaultDict
import Base.Meta.isexpr
using Match
 
indexh         = joinpath(JULIA_HOME, "../include/clang-c/Index.h")
clang_includes = [joinpath(JULIA_HOME, "../lib/clang/3.3/include"), joinpath(dirname(indexh), "..")]
 
av_hpath = [
  "/usr/include/libavutil/",
  "/usr/include/libavcodec/",
  "/usr/include/libavformat/",
  "/usr/include/libswscale/"]

ignore_header = DefaultDict(ASCIIString, Bool, false)

ignore_header["log.h"] = true
ignore_header["md5.h"] = true
ignore_header["parse.h"] = true
ignore_header["sha.h"] = true
ignore_header["vda.h"] = true

av_headers = Array(ASCIIString, 0)
for path in av_hpath
    tmp = map(x->joinpath(path, x),split(readall(`ls $path` |> `sort`)) )
    append!(av_headers, tmp)
end
for header in av_headers
    println(header)
end
 
# called to determine if cursor should be included
function check_use_header(top_h, hpath)
  b = basename(top_h)
  ignore_header[b] && return false
  ignore_header[b] = true
  hbase = av_hpath
  for d in hbase
      beginswith(hpath, d) && return true
  end
  return false
end

function get_header_library(hpath)
  if (match(r"avcodec", hpath) != nothing)
    return :libavcodec
  elseif (match(r"avformat", hpath) != nothing)
    return :libavformat
  elseif (match(r"libswscale", hpath) != nothing)
    return :libswscale
  elseif (match(r"libavutil", hpath) != nothing)
    return :libavutil
  else
    warn("No library configured for: $hpath")
    return "shlib"
  end
end

function get_header_outfile(hpath)
  base_file = splitext(splitdir(hpath)[end])[1]
  return "$base_file.jl"
end

function rewrite_fn(e::Expr)
    (head, call, body) = @match e Expr(head, [call, body], _) => (head, call, body)

    parms = Any[]
    content = Any[]

    push!(parms, call.args[1])  # function name

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
            Expr(:(::), [sym, (:Uint32 || :Cuint)], _) => 
                begin
                    _sym = symbol(string("_", sym))
                    push!(parms,   :($_sym::Integer))
                    push!(content, :($sym = uint32($_sym)))
                end
            Expr(:(::), [sym, (:Int32 || :Cint)], _) => 
                begin
                    _sym = symbol(string("_", sym))
                    push!(parms,   :($_sym::Integer))
                    push!(content, :($sym = int32($_sym)))
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
    output_file = "libAV.jl",
    common_file = "libav_h.jl",
    clang_includes = clang_includes,
    header_wrapped = check_use_header, 
    header_library = get_header_library,
    header_outputfile = get_header_outfile,
    func_rewriter = rewrite_fn)
wrap_c.wrap_c_headers(context, av_headers)
