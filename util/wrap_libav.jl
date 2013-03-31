
import Clang.wrap_c
 
if (!has(ENV, "JULIAHOME"))
  error("Please set JULIAHOME variable to the root of your julia install")
end
 
clang_includes = map(x->joinpath(ENV["JULIAHOME"], x), [
  "deps/llvm-3.2/build/Release/lib/clang/3.2/include",
  "deps/llvm-3.2/include",
  "deps/llvm-3.2/include",
  "deps/llvm-3.2/build/include/",
  "deps/llvm-3.2/include/"
  ])
 
av_hpath = [
  "/usr/include/libavutil/",
  "/usr/include/libavcodec/",
  "/usr/include/libavformat/",
  "/usr/include/libswscale/"]

append!(clang_includes, av_hpath)
av_headers = Array(ASCIIString, 0)
for path in av_hpath
    tmp = map(x->joinpath(path, x),split(readall(`ls $path` | `sort`)) )
    append!(av_headers, tmp)
end
println(av_headers)
 
# called to determine if cursor should be included
check_use_header(top_h, hpath) = begin
  hbase = av_hpath
  ret = false
  for d in hbase
      l = min(length(hpath), length(d))
      ret = ret | (hpath[1:l] == d[1:l])
  end
  ret
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

out_path = pwd()

context = wrap_c.WrapContext(
    out_path, "libav_h.jl",
    clang_includes, ASCIIString[],
    check_use_header, get_header_library,
    get_header_outfile)
wrap_c.wrap_c_headers(context, av_headers)
