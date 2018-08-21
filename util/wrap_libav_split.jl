
import Clang.wrap_c
import DataStructures: DefaultDict
import Base.Meta.isexpr
using Match

include("../src/init.jl")

indexh         = joinpath(Sys.BINDIR, "../include/clang-c/Index.h")
clang_includes = String[joinpath(Sys.BINDIR, "../lib/clang/3.7.1/include"), joinpath(dirname(indexh), "..")]
#clang_includes = String[joinpath(JULIA_HOME, "../lib/clang/3.3/include"), joinpath(dirname(indexh), "..")]

strpack_structs = Set{Symbol}()

# Allow root to be specified as the first argument
if isempty(ARGS)
    root = "/usr/local/include"
else
    root = ARGS[1]
end

const av_libs  =  ["libavutil"
                 "libavcodec"
                 "libavdevice"
                 "libavfilter"
                 "libavformat"
                 "libavresample"
                 "libpostproc"
                 "libswresample"
                 "libswscale"]

const av_lib_ver  =  []
for lib in av_libs
    try
        name = lib[4:end]
        ver = eval(Symbol("_"*name*"_version"))()
        dir = eval(Symbol(name*"_dir"))
        push!(av_lib_ver, (lib,ver,dir))
    catch
    end
end

const av_hpath  =  [joinpath(root, lib) for (lib,ver,dir) in av_lib_ver]

const ignore_header  =  DefaultDict(String, Bool, false)

for i in ["lzo.h", "md5.h", "parse.h", "sha.h", "vda.h", "bprint.h",
          "attributes.h", "crc.h", "adler32.h", "aes.h", "avassert.h",
          "avconfig.h", "avstring.h", "base64.h", "blowfish.h", "common.h",
          "cpu.h", "crc.h", "eval.h", "ffversion.h", "hmac.h", "intfloat.h",
          "intreadwrite.h", "intfloat_readwrite.h", "lfg.h", "macros.h",
          "mathematics.h", "murmur3.h", "parseutils.h", "random_seed.h",
          "ripemd.h", "sha512.h", "time.h", "timestamp.h", "bswap.h",
          "error.h", "old_codec_ids.h", "old_pix_fmts.h", "dxva2.h", "avfft.h"]
    ignore_header[i] = true
end

function wrap_library(library, path, outdir = ".")
    if !ispath(path)
        return
    end

    av_headers = filter(file -> !ignore_header[file], readdir(path))
    av_headers = [joinpath(path, file) for file in av_headers]

    println("\nWrapping $library")
    println("==============")
    for header in av_headers
        println("  $header")
    end

    if !isdir(outdir)
        mkpath(outdir)
    end

    wc = wrap_c.init(headers = av_headers,
                     common_file = joinpath(outdir, "$(library)_h.jl"),
                     clang_includes = clang_includes,
                     header_wrapped = check_use_header,
                     header_library = library,
                     header_outputfile = x->get_header_outfile(outdir,x),
                     rewriter = rewrite,
                     options = wrap_c.InternalOptions(true, true))
    wrap_c.run(wc)

    if outdir != "."
        jl_files = sort(readdir(outdir))
        main_file = uppercase(library)*".jl"
        main_hfile = library*"_h.jl"
        h = open(joinpath(outdir, main_file), "w")
        println(h, "include(\"$main_hfile\")")
        println(h)
        for file in jl_files
            (file == main_file || file == main_hfile) && continue
            println(h, "#include(\"$file\")")
        end
    end
    return
end

seen = Set{String}()
current_path = ""

# called to determine if cursor should be included
function check_use_header(top_h, hpath)
    global current_path

    b = basename(top_h)
    ignore_header[b] && return false
    if hpath == "" || (startswith(hpath, current_path) && basename(hpath) == b)
        return true
    end

    return false
end

function get_header_outfile(hpath)
    for ((lib,ver,dir),path) in zip(av_lib_ver, av_hpath)
        if contains(hpath, path)
            outdir = "$lib$(ver.major)"
            return get_header_outfile(outdir, hpath)
        end
    end
    return get_header_outfile(".", hpath)
end

function get_header_outfile(dir, hpath)
  base_file = splitext(splitdir(hpath)[end])[1]
  return joinpath(dir,"$base_file.jl")
end

# Rewrite function signatures to be more friendly
function rewrite_fn(e, fncall, body, use_strpack=false)
    parms = Any[]
    content = Any[]

    push!(parms, fncall.args[1])  # function name

    global strpack_structs

    # Add explicit conversions for Ptr, UInt32/Int32, and va_list
    for call_arg in fncall.args[2:end]
        @match call_arg begin
            # Don't type Ptr{x} types
            Expr(:(::), [sym, Expr(:curly, [:Ptr, _], _)], _) => push!(parms, sym)

            # Type all integers as Integer
            Expr(:(::), [sym, (:UInt32 || :Cuint || :Int32 || :Cint)], _) => (sym; push!(parms, :($sym::Integer)))

            # va_list
            Expr(:(::), [sym, :va_list], _) => push!(parms, sym)

            # Everything else is unchanged
            _ => push!(parms, call_arg)
        end
    end

    if !isexpr(body, :block)
        # body just consists of the ccall
        push!(content, body)
    else
        append!(content, body.args)
    end

    fncall = Expr(:call, parms...)
    body = Expr(:block, content...)

    new = Expr(e.head, fncall, body)

    return new
end

# Wrap type in @struct macro, and replace Array_<type>_<len> immutable types
# (Not currently used, but possibly useful)
function rewrite_struct(e::Expr)
    @match(e, Expr(:type, [true, name, vars], _))

    global strpack_structs
    push!(strpack_structs, name)

    new_vars = []
    for arg in vars.args
        @match arg begin
            Expr(:(::), [varname, vartype], _), if startswith(string(vartype), "Array") end =>
                begin
                    @match string(vartype) r"Array_([0-9]+)_(.*)"(size_str, type_str)
                    size = Int(size_str)
                    t = Symbol(type_str)
                    push!(new_vars, Expr(:(::), varname, :(Array{$t}($size))))
                end

            ex => push!(new_vars, ex)
        end
    end

    Expr(:macrocall, :@struct, Expr(:type, true, name, Expr(:block, new_vars...)))
end

function rewrite_type(e::Expr)
    try
        @match e begin
            #Expr(:type,     [false, _...], _)                      =>  return ""

            # Change empty types to type aliases
            Expr(:type,     [_, name, Expr(:block, [], _)], _)      =>  return Expr(:typealias, name, :Void)

            #Expr(:type,     _, _)                                  =>  return rewrite_struct(e)
            _                                                       =>  e
        end
    catch
    end
    return e
end

rewrite_type(s) = s

function rewrite_fn(e::Expr)
    @match e begin
        Expr(:function, [fncall, body], _)  =>  rewrite_fn(e, fncall, body)
        _                                   =>  e
    end
end

rewrite_fn(s) = s

extract_name(x) = string(x)
function extract_name(e::Expr)
    @match e begin
        Expr(:type,      [_, name, _], _)     => name
        Expr(:typealias, [name, _], _)        => name
        Expr(:call,      [name, _...], _)     => name
        Expr(:function,  [sig, _...], _)      => extract_name(sig)
        Expr(:const,     [assn, _...], _)     => extract_name(assn)
        Expr(:(=),       [fn, body, _...], _) => extract_name(fn)
        Expr(expr_type,  _...)                => error("Can't extract name from ", expr_type, " expression:\n    $e\n")
    end
end

# Main rewrite function
function rewrite(buf::Array)
    # Rewrite empty types as typealiases, and collect all typealiases
    buf = Any[rewrite_type(e) for e in buf]
    buf = Any[rewrite_fn(e) for e in buf]
    exports = [string(extract_name(e)) for e in filter(x->isa(x, Expr), buf)]
    have_zero = "zero" in exports
    filter!(x -> x!="" && x!="zero" && !startswith(x,"FF_"), exports)
    export_string = "export\n" * join(["    $name" for name in exports], ",\n")*"\n\n"
    header = have_zero ? ["import Base.zero","\n",export_string] : [export_string]
    splice!(buf, 1:0, header)
    return buf
end


###############################################################
# Do it!

function doit()
    global current_path
    for ((lib,ver,dir),path) in zip(av_lib_ver, av_hpath)
        dir = basename(dirname(dir))
        outdir = joinpath("$dir","v$(ver.major)")
        current_path = path
        wrap_library(lib, path, outdir)
    end
end

doit()
