module AVFilters
  include(joinpath(Pkg.dir("AV"),"src","init.jl"))
  w(f) = joinpath(avfilter_dir, f)

  using AVUtil
  include(w("LIBAVFILTER.jl"))  
end
