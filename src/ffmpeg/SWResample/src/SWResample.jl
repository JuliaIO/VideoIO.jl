module SWResample
  include(joinpath(dirname(@__FILE__),"..","..","..","init.jl"))
  w(f) = joinpath(swresample_dir, f)

  using AVUtil
  include(w("LIBSWRESAMPLE.jl"))  
end
