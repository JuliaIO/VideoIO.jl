module AVCodecs
  include(normpath(joinpath(dirname(@__FILE__),"..","..","..","init.jl")))
  w(f) = joinpath(avcodec_dir, f)

  using AVUtil

  include(w("LIBAVCODEC.jl"))

  AVPacket() = AVPacket([T<:Ptr ? C_NULL : zero(T) for T in AVPacket.types]...)
  
end

