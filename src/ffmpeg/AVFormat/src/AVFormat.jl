module AVFormat
  include(joinpath(dirname(@__FILE__),"..","..","..","init.jl"))
  w(f) = joinpath(avformat_dir, f)

  using AVUtil
  using AVCodecs

  include(w("LIBAVFORMAT.jl"))
end
