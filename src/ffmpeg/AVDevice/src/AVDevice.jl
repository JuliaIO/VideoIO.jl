module AVDevice
  include(joinpath(Pkg.dir("VideoIO"),"src","init.jl"))
  w(f) = joinpath(avdevice_dir, f)

  using AVUtil
  include(w("LIBAVDEVICE.jl"))
end
