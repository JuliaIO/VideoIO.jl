module AVDevice
  include(joinpath(Pkg.dir("AV"),"src","init.jl"))
  w(f) = joinpath(avdevice_dir, f)

  include(w("LIBAVDEVICE.jl"))
end
