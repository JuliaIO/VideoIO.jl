module AVUtil
  include(joinpath(dirname(@__FILE__),"..","..","..","init.jl"))
  w(f) = joinpath(avutil_dir, f)

  include(w("LIBAVUTIL.jl"))

AVRational(r::Rational) = AVRational(numerator(r), denominator(r))

    #If AVUtil v55 is needed, this will need to be added back
  #Base.zero(::Type{AVRational}) = AVRational(0, 1)

end
