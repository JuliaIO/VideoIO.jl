module SWScale
  include(joinpath(dirname(@__FILE__),"..","..","..","init.jl"))
  w(f) = joinpath(swscale_dir, f)

  using ..AVUtil

  include(w("LIBSWSCALE.jl"))
end
