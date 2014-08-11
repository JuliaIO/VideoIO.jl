module SWScale
  include(joinpath(Pkg.dir("VideoIO"),"src","init.jl"))
  w(f) = joinpath(swscale_dir, f)

  using AVUtil
  include(w("LIBSWSCALE.jl"))
end
