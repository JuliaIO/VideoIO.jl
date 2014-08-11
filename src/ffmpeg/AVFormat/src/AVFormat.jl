module AVFormat
  include(joinpath(Pkg.dir("VideoIO"),"src","init.jl"))
  w(f) = joinpath(avformat_dir, f)

  using AVUtil
  using AVCodecs

  include(w("LIBAVFORMAT.jl"))
end
