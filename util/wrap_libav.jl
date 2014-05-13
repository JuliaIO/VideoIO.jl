
import Clang.wrap_c
 
indexh         = joinpath(JULIA_HOME, "../include/clang-c/Index.h")
clang_includes = [joinpath(JULIA_HOME, "../lib/clang/3.3/include"), joinpath(dirname(indexh), "..")]
 
av_hpath = [
  "/usr/include/libavutil/",
  "/usr/include/libavcodec/",
  "/usr/include/libavformat/",
  "/usr/include/libswscale/"]

av_headers = Array(ASCIIString, 0)
for path in av_hpath
    tmp = map(x->joinpath(path, x),split(readall(`ls $path` |> `sort`)) )
    append!(av_headers, tmp)
end
for header in av_headers
    println(header)
end
 
# called to determine if cursor should be included
check_use_header(top_h, hpath) = false

function check_include_header(top_h, hpath)
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

out_path = pwd()

context = wrap_c.init(
    output_file = "libAV.jl",
    common_file = "libav_h.jl",
    clang_includes = clang_includes,
    header_wrapped = check_use_header, 
    header_library = get_header_library,
    header_outputfile = get_header_outfile)
wrap_c.wrap_c_headers(context, av_headers)
