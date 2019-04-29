module AVUtil
  include(joinpath(dirname(@__FILE__),"..","..","..","init.jl"))
  w(f) = joinpath(avutil_dir, f)

  include(w("LIBAVUTIL.jl"))

  Base.zero(::Type{AVRational}) = AVRational(0, 1)

end
