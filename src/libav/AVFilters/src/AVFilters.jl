module AVFilters
  include(joinpath(dirname(@__FILE__),"..","..","..","init.jl"))
  w(f) = joinpath(avfilter_dir, f)

  include(w("LIBAVFILTER.jl"))
end
