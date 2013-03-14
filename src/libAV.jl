module libAV

module avcodec
  include("libav_h_ext.jl")
  include("avcodec.jl")
  include("avfft.jl")
  include("opt.jl")
  include("version.jl")
end

module swscale
  include("libav_h_ext.jl")
  include("swscale.jl")
end

module avformat
  include("libav_h_ext.jl")
  include("avformat.jl")
  include("avio.jl")
  include("version.jl")
end

end # libAV
