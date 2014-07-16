module AVCodecs
  include(joinpath(Pkg.dir("AV"),"src","init.jl"))
  w(f) = joinpath(avcodec_dir, f)

  using AVUtil

  include(w("LIBAVCODEC.jl"))

  AVPacket() = AVPacket([zero(T) for T in AVPacket.types]...)
  
end

