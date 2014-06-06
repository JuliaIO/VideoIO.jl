module AV

const lib="libav-0.8"
w(f) = joinpath(Pkg.dir("AV"), "src", lib, f)

export Codec, SWScale, Format
include(w("exports.jl"))
include(w("libav_h_ext.jl"))

module Codec
  using AV
  import AV.w
  include(w("libav_h_ext.jl"))
  include(w("avcodec.jl"))
end

module SWScale
  using AV
  import AV.w
  include(w("libav_h_ext.jl"))
  include(w("swscale.jl"))
end

module Format
  using AV
  import AV.w
  include(w("libav_h_ext.jl"))
  include(w("avformat.jl"))
  include(w("avio.jl"))
end

include("av_capture.jl")

end # AV
