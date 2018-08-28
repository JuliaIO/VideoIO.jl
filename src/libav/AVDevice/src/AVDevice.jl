module AVDevice
  include(joinpath(dirname(@__FILE__),"..","..","..","init.jl"))
  w(f) = joinpath(avdevice_dir, f)

  using ..AVUtil
  using ..AVFormat
  using ..AVCodecs
  include(w("LIBAVDEVICE.jl"))
end
