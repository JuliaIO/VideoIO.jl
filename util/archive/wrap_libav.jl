import Clang.wrap_c
import DataStructures: DefaultDict
import Base.Meta.isexpr
using Match

include("../src/version.jl")
 
indexh         = joinpath(JULIA_HOME, "../include/clang-c/Index.h")
clang_includes = [joinpath(JULIA_HOME, "../lib/clang/3.3/include"), joinpath(dirname(indexh), "..")]
 
if isempty(ARGS)
    root = "/usr/include"
else
    root = ARGS[1]
end

av_libs = ["libavcodec"
           "libavdevice"
           "libavfilter"
           "libavformat"
           "libavresample"
           "libavutil"
           "libpostproc"
           "libswresample"
           "libswscale"]

av_lib_ver = {}
for lib in av_libs
    try
        name = lib[4:end]
        ver = eval(Symbol(name*"_version"))()
        push!(av_lib_ver, (lib,ver))
    end
end

av_hpath = [joinpath(root, lib) for (lib,ver) in av_lib_ver]

ignore_header = DefaultDict(ASCIIString, Bool, false)

ignore_header["log.h"] = true
ignore_header["md5.h"] = true
ignore_header["parse.h"] = true
ignore_header["sha.h"] = true
ignore_header["vda.h"] = true

av_headers = Array(ASCIIString, 0)
for path in av_hpath
    !ispath(path) && continue
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
    for lib,ver in av_lib_ver
        if contains(hpath, lib)
            return lib
        end
    end
    warn("No library configured for: $hpath")
    return "shlib"
end

function get_header_outfile(hpath)
    dir, fn = splitdir(hpath)[end-1:end]
    subdir = splitdir(dir)[end]
    base_file = splitext(fn)[1]
    !ispath(subdir) && mkpath(subdir)
    return joinpath(subdir,"$base_file.jl")
end

function rewrite_fn(e, call, body)

    parms = Any[]
    content = Any[]

    push!(parms, call.args[1])  # function name

    for call_arg in call.args[2:end]
        @match call_arg begin
            Expr(:(::), [sym, Expr(:curly, [:Ptr, :UInt8], _)], _) => 
                begin 
                    orig_type = Expr(:curly, :Ptr, :UInt8)
                    _sym = Symbol(string("_", sym))
                    push!(parms,   :($_sym::Union{Ptr,ByteString}))
                    push!(content, :($sym = convert($orig_type, $_sym)))
                end
            Expr(:(::), [sym, Expr(:curly, [:Ptr, target_type], _)], _) => 
                begin 
                    orig_type = Expr(:curly, :Ptr, target_type)
                    _sym = Symbol(string("_", sym))
                    push!(parms,   :($_sym::Ptr))
                    push!(content, :($sym = convert($orig_type, $_sym)))
                end
            Expr(:(::), [sym, (:UInt32 || :Cuint)], _) => 
                begin
                    _sym = Symbol(string("_", sym))
                    push!(parms,   :($_sym::Integer))
                    push!(content, :($sym = uint32($_sym)))
                end
            Expr(:(::), [sym, (:Int32 || :Cint)], _) => 
                begin
                    _sym = Symbol(string("_", sym))
                    push!(parms,   :($_sym::Integer))
                    push!(content, :($sym = Int32($_sym)))
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

rewrite(buf::Array) = {rewrite(e) for e in buf}

rewrite(s::AbstractString) = s

function rewrite(e::Expr)
    try
        @match e begin
            Expr(:function, [call, body],                         _)  =>  return rewrite_fn(e, call, body)
            Expr(:type,     [_, name, Expr(:block, args, _)], _)      =>  return isempty(args) ? Expr(:typealias, name, :Void) : e
            _                                                         =>  e
        end
    end
    return e
end

context = wrap_c.init(
    #output_file = "VideoIO.jl",
    common_file = "libav_h.jl",
    clang_includes = clang_includes,
    header_wrapped = check_use_header, 
    header_library = get_header_library,
    header_outputfile = get_header_outfile,
    rewriter = rewrite)
wrap_c.wrap_c_headers(context, av_headers)
