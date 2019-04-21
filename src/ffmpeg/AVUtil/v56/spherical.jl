# Julia wrapper for header: /usr/include/libavutil/spherical.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_spherical_alloc,
    av_spherical_tile_bounds,
    av_spherical_projection_name,
    av_spherical_from_name


function av_spherical_alloc(size)
    ccall((:av_spherical_alloc, libavutil), Ptr{AVSphericalMapping}, (Ptr{Csize_t},), size)
end

function av_spherical_tile_bounds(map, width::Csize_t, height::Csize_t, left, top, right, bottom)
    ccall((:av_spherical_tile_bounds, libavutil), Cvoid, (Ptr{AVSphericalMapping}, Csize_t, Csize_t, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Csize_t}), map, width, height, left, top, right, bottom)
end

function av_spherical_projection_name(projection::AVSphericalProjection)
    ccall((:av_spherical_projection_name, libavutil), Cstring, (AVSphericalProjection,), projection)
end

function av_spherical_from_name(name)
    ccall((:av_spherical_from_name, libavutil), Cint, (Cstring,), name)
end
