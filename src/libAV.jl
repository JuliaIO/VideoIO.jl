module libAV

const lib="libav-0.8"
w(f) = joinpath(Pkg.dir("libAV"), "src", lib, f)

module Codec
  import libAV.w
  include(w("libav_h_ext.jl"))
  include(w("avcodec.jl"))
end

module SWScale
  import libAV.w
  include(w("libav_h_ext.jl"))
  include(w("swscale.jl"))
end

module Format
  import libAV.w
  include(w("libav_h_ext.jl"))
  include(w("avformat.jl"))
  include(w("avio.jl"))
end

end # libAV
