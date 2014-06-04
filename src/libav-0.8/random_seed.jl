# Julia wrapper for header: /usr/include/libavutil/random_seed.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_get_random_seed()
    ccall((:av_get_random_seed,libavutil),Uint32,())
end
