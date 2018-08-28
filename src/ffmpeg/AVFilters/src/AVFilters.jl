module AVFilters
  include(joinpath(dirname(@__FILE__),"..","..","..","init.jl"))
  w(f) = joinpath(avfilter_dir, f)

  using ..AVUtil
  include(w("LIBAVFILTER.jl"))
end
