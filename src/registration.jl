"""
    VideoRegistration

Robust 2D point-set registration: estimation of a global transform (and
residual local motion) from point correspondences, such as those derived from
codec block motion vectors via `openvideo(...; export_mvs = true)`,
`VideoIO.motion_vectors`, and `VideoIO.correspondences`.

This module is deliberately self-contained — stdlib dependencies only, and a
purely point-based API (`n×2` matrices) — so that it can be moved to a
separate package unchanged. All codec-specific knowledge (motion vector
semantics, filtering) lives in VideoIO.

Codec motion vectors are *compression decisions*, not measured optical flow.
This module therefore emphasises robust fitting (RANSAC + closed-form model
fits) and quality metrics, so that a caller can decide when to trust the
codec-derived estimate, when to use it only as an initialization for
conventional registration, and when to fall back entirely.

# Typical usage

```julia
using VideoIO
using VideoIO.VideoRegistration

video = openvideo("video.mp4", export_mvs = true)
sz = out_frame_size(video)  # (width, height)
for frame in video
    mvs = motion_vectors(video)
    gm = estimate_global_motion(mvs; model = :similarity, frame_size = sz)
    conf = classify_confidence(gm)
    if conf === :high || conf === :moderate
        # use `gm.A` (a 2×3 matrix mapping current-frame points to
        # reference-frame points) directly, or as an initialization
        dx, dy = translation(gm)
    else
        # fall back to full image-domain registration
    end
end
```

(The `estimate_global_motion(mvs; ...)` motion-vector convenience method is
VideoIO-side glue — see `src/registration_glue.jl`; the module itself only
takes point matrices.)

# Conventions

A fitted transform is stored as a 2×3 matrix `A` such that

    [x_src, y_src] ≈ A * [x_dst, y_dst, 1]

i.e. it maps a point in the *current* frame (`dst`) to the corresponding point
in the *reference* frame (`src`), matching FFmpeg's motion vector convention
`src = dst + motion / motion_scale`. Use [`invert_transform`](@ref) for the
reference→current direction.

Point sets are `n×2` matrices with columns `(x, y)` in pixels.
"""
module VideoRegistration

using LinearAlgebra: LinearAlgebra, svd, det, Diagonal, dot
using Random: AbstractRNG, default_rng
using Statistics: median, mean

export fit_translation,
    fit_similarity,
    fit_affine,
    ransac_fit,
    estimate_global_motion,
    GlobalMotion,
    translation,
    rotation,
    scale_factor,
    transform_points,
    apply_transform,
    invert_transform,
    residuals,
    local_residuals,
    classify_confidence

# ---------------------------------------------------------------------------
# Transform representation helpers
# ---------------------------------------------------------------------------

"""
    apply_transform(A, p) -> (x, y)

Apply a 2×3 transform to the point `p = (x, y)`.
"""
apply_transform(A::AbstractMatrix, p) =
    (A[1, 1] * p[1] + A[1, 2] * p[2] + A[1, 3], A[2, 1] * p[1] + A[2, 2] * p[2] + A[2, 3])

"""
    transform_points(A, pts::AbstractMatrix) -> Matrix{Float64}

Apply a 2×3 transform to each row of an `n×2` point matrix.
"""
function transform_points(A::AbstractMatrix, pts::AbstractMatrix)
    out = Matrix{Float64}(undef, size(pts, 1), 2)
    for i in axes(pts, 1)
        out[i, 1], out[i, 2] = apply_transform(A, (pts[i, 1], pts[i, 2]))
    end
    return out
end

"""
    invert_transform(A) -> Matrix{Float64}

Invert a 2×3 affine transform.
"""
function invert_transform(A::AbstractMatrix)
    M = [A[1, 1] A[1, 2]; A[2, 1] A[2, 2]]
    Minv = inv(M)
    t = Minv * [-A[1, 3], -A[2, 3]]
    return [Minv[1, 1] Minv[1, 2] t[1]; Minv[2, 1] Minv[2, 2] t[2]]
end

"""
    residuals(A, dst, src) -> Vector{Float64}

Euclidean residual per correspondence: `‖A*[dstᵢ,1] - srcᵢ‖`.
"""
function residuals(A::AbstractMatrix, dst::AbstractMatrix, src::AbstractMatrix)
    res = Vector{Float64}(undef, size(dst, 1))
    for i in axes(dst, 1)
        px, py = apply_transform(A, (dst[i, 1], dst[i, 2]))
        res[i] = hypot(px - src[i, 1], py - src[i, 2])
    end
    return res
end

# ---------------------------------------------------------------------------
# Closed-form model fits (dst -> src)
# ---------------------------------------------------------------------------

"""
    fit_translation(dst, src) -> Matrix{Float64}

Robust (coordinate-wise median) translation fit. Returns a 2×3 transform.
"""
function fit_translation(dst::AbstractMatrix, src::AbstractMatrix)
    size(dst, 1) >= 1 || throw(ArgumentError("need at least 1 correspondence"))
    tx = median(view(src, :, 1) .- view(dst, :, 1))
    ty = median(view(src, :, 2) .- view(dst, :, 2))
    return [1.0 0.0 tx; 0.0 1.0 ty]
end

"""
    fit_similarity(dst, src) -> Matrix{Float64}

Least-squares similarity (partial affine) fit: translation + rotation +
uniform scale (Umeyama's method). Returns a 2×3 transform mapping `dst`
points to `src` points.
"""
function fit_similarity(dst::AbstractMatrix, src::AbstractMatrix)
    n = size(dst, 1)
    n >= 2 || throw(ArgumentError("need at least 2 correspondences"))
    μd = vec(mean(dst, dims = 1))
    μs = vec(mean(src, dims = 1))
    Xd = dst .- μd'
    Xs = src .- μs'
    Σ = (Xs' * Xd) ./ n           # 2×2 cross-covariance
    F = svd(Σ)
    d = det(F.U) * det(F.V) < 0 ? -1.0 : 1.0
    S = Diagonal([1.0, d])
    R = F.U * S * F.V'
    σd² = sum(abs2, Xd) / n
    σd² > 0 || throw(ArgumentError("degenerate (coincident) points"))
    c = dot([F.S[1], F.S[2]], [1.0, d]) / σd²
    t = μs - c * R * μd
    return [c*R[1, 1] c*R[1, 2] t[1]; c*R[2, 1] c*R[2, 2] t[2]]
end

"""
    fit_affine(dst, src) -> Matrix{Float64}

Least-squares full affine fit (translation, rotation, anisotropic scale,
shear). Returns a 2×3 transform mapping `dst` points to `src` points.
"""
function fit_affine(dst::AbstractMatrix, src::AbstractMatrix)
    n = size(dst, 1)
    n >= 3 || throw(ArgumentError("need at least 3 correspondences"))
    X = hcat(dst, ones(n))        # n×3
    B = X \ src                   # 3×2 least squares
    return permutedims(B)         # 2×3
end

# ---------------------------------------------------------------------------
# RANSAC
# ---------------------------------------------------------------------------

const MODEL_FITTERS = Dict{Symbol,Tuple{Int,Function}}(
    :translation => (1, (d, s) -> begin
        # exact fit on the minimal sample; mean generalises to refits
        tx = mean(view(s, :, 1) .- view(d, :, 1))
        ty = mean(view(s, :, 2) .- view(d, :, 2))
        [1.0 0.0 tx; 0.0 1.0 ty]
    end),
    :similarity => (2, fit_similarity),
    :affine => (3, fit_affine),
)

"""
    ransac_fit(dst, src; model = :similarity, threshold = 2.0,
               max_iterations = 2000, confidence = 0.99,
               rng = Random.default_rng()) -> (A, inliers::BitVector)

Robustly fit a 2×3 transform mapping `dst` points to `src` points using
RANSAC, then refine by refitting the model on all inliers.

- `model`: `:translation`, `:similarity` (translation + rotation + uniform
  scale), or `:affine`.
- `threshold`: inlier reprojection threshold in pixels.
- `max_iterations`: RANSAC iteration cap; iterations also stop early once the
  observed inlier ratio makes further sampling unnecessary at the requested
  `confidence`.

Returns the refined transform and the inlier mask (recomputed after
refinement). Throws `ArgumentError` if there are fewer correspondences than
the model's minimal sample size.
"""
function ransac_fit(
    dst::AbstractMatrix,
    src::AbstractMatrix,
    ;
    model::Symbol = :similarity,
    threshold::Real = 2.0,
    max_iterations::Integer = 2000,
    confidence::Real = 0.99,
    rng::AbstractRNG = default_rng(),
)
    haskey(MODEL_FITTERS, model) ||
        throw(ArgumentError("unknown model $model; expected :translation, :similarity, or :affine"))
    sample_size, fitter = MODEL_FITTERS[model]
    n = size(dst, 1)
    n >= sample_size || throw(ArgumentError("need at least $sample_size correspondences for $model"))
    size(src, 1) == n || throw(ArgumentError("dst and src must have the same number of rows"))

    best_inliers = falses(n)
    best_count = 0
    niter = Int(max_iterations)
    iter = 0
    idx = Vector{Int}(undef, sample_size)
    while iter < niter
        iter += 1
        # sample distinct indices
        for k in 1:sample_size
            while true
                idx[k] = rand(rng, 1:n)
                any(j -> idx[j] == idx[k], 1:(k-1)) || break
            end
        end
        A = try
            fitter(dst[idx, :], src[idx, :])
        catch e
            e isa ArgumentError && continue # degenerate sample
            e isa LinearAlgebra.SingularException && continue
            rethrow()
        end
        res = residuals(A, dst, src)
        inliers = res .<= threshold
        count = Base.count(inliers)
        if count > best_count
            best_count = count
            best_inliers = inliers
            # adaptive iteration count
            ε = count / n
            if ε > 0 && ε < 1
                needed = log(1 - confidence) / log(1 - ε^sample_size)
                niter = min(niter, max(iter, ceil(Int, needed)))
            elseif ε >= 1
                break
            end
        end
    end
    best_count >= sample_size || throw(ArgumentError("RANSAC failed to find a valid model"))

    # Refine on all inliers, then recompute the inlier set
    A = fitter(dst[best_inliers, :], src[best_inliers, :])
    inliers = residuals(A, dst, src) .<= threshold
    if Base.count(inliers) >= sample_size
        A = fitter(dst[inliers, :], src[inliers, :])
        inliers = residuals(A, dst, src) .<= threshold
    else
        inliers = best_inliers
    end
    return A, inliers
end

# ---------------------------------------------------------------------------
# Global motion estimation
# ---------------------------------------------------------------------------

"""
    GlobalMotion

Result of [`estimate_global_motion`](@ref).

# Fields
- `model::Symbol`: the fitted model (`:translation`, `:similarity`, `:affine`)
- `A::Matrix{Float64}`: 2×3 transform mapping current-frame (`dst`) points to
  reference-frame (`src`) points
- `npoints::Int`: number of correspondences after filtering
- `inliers::BitVector`: RANSAC inlier mask over those correspondences
- `inlier_fraction::Float64`
- `median_residual::Float64`: median reprojection error of the inliers, pixels
- `coverage::Float64`: fraction of the frame area spanned by the inlier
  points' bounding box (`NaN` if `frame_size` was not provided)
"""
struct GlobalMotion
    model::Symbol
    A::Matrix{Float64}
    npoints::Int
    inliers::BitVector
    inlier_fraction::Float64
    median_residual::Float64
    coverage::Float64
end

"""
    translation(gm::GlobalMotion) -> (tx, ty)

Translation component of the fitted transform.
"""
translation(gm::GlobalMotion) = (gm.A[1, 3], gm.A[2, 3])

"""
    rotation(gm::GlobalMotion) -> θ

In-plane rotation angle (radians) of the fitted transform. Meaningful for
`:similarity` fits (and `:affine` fits with little shear).
"""
rotation(gm::GlobalMotion) = atan(gm.A[2, 1], gm.A[1, 1])

"""
    scale_factor(gm::GlobalMotion) -> s

Uniform scale of the fitted transform. Meaningful for `:similarity` fits.
"""
scale_factor(gm::GlobalMotion) = hypot(gm.A[1, 1], gm.A[2, 1])

function _coverage(dst::AbstractMatrix, inliers, frame_size)
    frame_size === nothing && return NaN
    any(inliers) || return 0.0
    xs = view(dst, inliers, 1)
    ys = view(dst, inliers, 2)
    w, h = frame_size
    (w > 0 && h > 0) || return NaN
    return ((maximum(xs) - minimum(xs)) * (maximum(ys) - minimum(ys))) / (Float64(w) * Float64(h))
end

"""
    estimate_global_motion(dst::AbstractMatrix, src::AbstractMatrix; kwargs...)

Estimate the global transform mapping the `n×2` point set `dst` to `src`
(e.g. current-frame → reference-frame correspondences from
`VideoIO.correspondences`).

Returns a [`GlobalMotion`](@ref), or `nothing` when there are fewer than
`min_points` correspondences (e.g. I-frames) or RANSAC fails — callers should
treat `nothing` as "no estimate available" and fall back to conventional
registration.

# Keyword arguments
- `model = :similarity`: `:translation`, `:similarity`, or `:affine`
- `min_points = 8`: minimum correspondences required
- `threshold = 2.0`, `max_iterations = 2000`, `confidence = 0.99`, `rng`:
  RANSAC parameters, see [`ransac_fit`](@ref)
- `frame_size = nothing`: `(width, height)`; enables the `coverage` quality
  metric
"""
function estimate_global_motion(
    dst::AbstractMatrix,
    src::AbstractMatrix,
    ;
    model::Symbol = :similarity,
    min_points::Integer = 8,
    threshold::Real = 2.0,
    max_iterations::Integer = 2000,
    confidence::Real = 0.99,
    rng::AbstractRNG = default_rng(),
    frame_size = nothing,
)
    haskey(MODEL_FITTERS, model) ||
        throw(ArgumentError("unknown model $model; expected :translation, :similarity, or :affine"))
    n = size(dst, 1)
    n >= max(min_points, first(MODEL_FITTERS[model])) || return nothing
    A, inliers = try
        ransac_fit(dst, src; model, threshold, max_iterations, confidence, rng)
    catch e
        e isa ArgumentError && return nothing
        rethrow()
    end
    res = residuals(A, dst, src)
    med = any(inliers) ? median(res[inliers]) : NaN
    return GlobalMotion(
        model,
        A,
        n,
        inliers,
        Base.count(inliers) / n,
        med,
        _coverage(dst, inliers, frame_size),
    )
end

# ---------------------------------------------------------------------------
# Local residual motion
# ---------------------------------------------------------------------------

"""
    local_residuals(gm::GlobalMotion, dst, src) -> Matrix{Float64}

Residual local motion after removing the fitted global motion: for each
correspondence, `observed src - predicted src`. Returns an `n×2` matrix
row-aligned with `dst`/`src`. Rows with large residuals indicate blocks moving
inconsistently with the global model (independent motion, deformation, or bad
codec vectors).

Note this is a sparse, block-based signal, not a dense optical-flow field.
"""
local_residuals(gm::GlobalMotion, dst::AbstractMatrix, src::AbstractMatrix) =
    src .- transform_points(gm.A, dst)

# ---------------------------------------------------------------------------
# Confidence classification
# ---------------------------------------------------------------------------

"""
    classify_confidence(gm; min_points = 30, min_inlier_fraction = 0.5,
                        max_median_residual = 1.0, min_coverage = 0.25)
        -> :high | :moderate | :low | :none

Classify a [`GlobalMotion`](@ref) estimate for decision making:

| Result      | Suggested action                                            |
|-------------|-------------------------------------------------------------|
| `:high`     | Use the codec-derived transform directly                    |
| `:moderate` | Use it as an initialization for registration refinement     |
| `:low`      | Run full image-domain registration                          |
| `:none`     | No usable estimate (`gm === nothing`); run full registration |

`:high` requires all thresholds to pass (`coverage` is only checked when it
was computed, i.e. `frame_size` was provided); `:moderate` requires the
inlier-fraction and residual checks; anything else is `:low`.
"""
function classify_confidence(
    gm::Union{Nothing,GlobalMotion};
    min_points::Integer = 30,
    min_inlier_fraction::Real = 0.5,
    max_median_residual::Real = 1.0,
    min_coverage::Real = 0.25,
)
    gm === nothing && return :none
    enough_points = gm.npoints >= min_points
    good_inliers = gm.inlier_fraction >= min_inlier_fraction
    good_residual = isfinite(gm.median_residual) && gm.median_residual <= max_median_residual
    good_coverage = isnan(gm.coverage) || gm.coverage >= min_coverage
    if enough_points && good_inliers && good_residual && good_coverage
        return :high
    elseif good_inliers && good_residual
        return :moderate
    else
        return :low
    end
end

end # module VideoRegistration
