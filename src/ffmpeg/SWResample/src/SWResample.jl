module SWResample
  include(joinpath(Pkg.dir("VideoIO"),"src","init.jl"))
  w(f) = joinpath(swresample_dir, f)

  using AVUtil
  include(w("LIBSWRESAMPLE.jl"))  
end
