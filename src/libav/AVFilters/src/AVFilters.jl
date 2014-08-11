module AVFilters
  include(joinpath(Pkg.dir("VideoIO"),"src","init.jl"))
  w(f) = joinpath(avfilter_dir, f)

  include(w("LIBAVFILTER.jl"))
end
