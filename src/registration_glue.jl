# VideoIO-side glue between motion vector extraction (avio.jl) and the
# point-based VideoRegistration module. If VideoRegistration moves to its own
# package, this method stays behind (e.g. as a package extension).

"""
    VideoRegistration.estimate_global_motion(mvs::AbstractVector{MotionVector}; kwargs...)

Estimate the global frame-to-reference transform directly from decoder motion
vectors: converts them to filtered point correspondences with
[`correspondences`](@ref) and fits with
`VideoRegistration.estimate_global_motion(dst, src; ...)`.

Accepts the filter keyword arguments of [`correspondences`](@ref)
(`past_only`, `min_block_size`, `max_displacement`, `border`, and
`frame_size`, which also enables the `coverage` quality metric) in addition to
the fitting keyword arguments of the point-matrix method.
"""
function VideoRegistration.estimate_global_motion(
    mvs::AbstractVector{MotionVector};
    frame_size = nothing,
    past_only::Bool = true,
    min_block_size::Integer = 4,
    max_displacement::Real = Inf,
    border::Real = 0,
    kwargs...,
)
    dst, src = correspondences(mvs; past_only, min_block_size, max_displacement, frame_size, border)
    return VideoRegistration.estimate_global_motion(dst, src; frame_size, kwargs...)
end
