module AV

const lib="libav-0.8"
w(f) = joinpath(Pkg.dir("libAV"), "src", lib, f)

export Codec, SWScale, Format
include(w("exports.jl"))
include(w("libav_h_ext.jl"))

module Codec
  using libAV
  import libAV.w
  include(w("libav_h_ext.jl"))
  include(w("avcodec.jl"))
end

module SWScale
  using libAV
  import libAV.w
  include(w("libav_h_ext.jl"))
  include(w("swscale.jl"))
end

module Format
  using libAV
  import libAV.w
  include(w("libav_h_ext.jl"))
  include(w("avformat.jl"))
  include(w("avio.jl"))
end

include("av_capture.jl")

end # libAV
