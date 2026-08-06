# Motion-vector based registration

```@meta
CurrentModule = VideoIO.VideoRegistration
```

The `VideoIO.VideoRegistration` module estimates global (and residual local)
frame-to-frame motion from the codec motion vectors exposed by
`openvideo(...; export_mvs = true)` (see
[Codec motion vectors](@ref)). This can be used to register video frames — or
to decide cheaply which frames actually require a full image-domain
registration pass.

!!! note
    Codec motion vectors are *compression decisions*, not measured optical
    flow. They may be coarse, reference non-adjacent frames, and be misleading
    around scene cuts and intra-coded regions. The module therefore fits
    models robustly (RANSAC) and reports quality metrics so that unreliable
    estimates can be detected and a conventional registration fallback used.
    The module is self-contained (stdlib dependencies only) and may move to a
    separate package in the future.

```@docs
VideoIO.VideoRegistration
```

!!! tip "Demo"
    `util/motion_vector_demo.jl` in the VideoIO repository renders a
    side-by-side video (original | annotated) with per-block dots colored by
    RANSAC inlier status and an arrow showing the fitted global translation:
    ```
    julia --project=. util/motion_vector_demo.jl [input.mp4] [output.mp4]
    ```
    With no arguments it generates a synthetic panning clip containing an
    independently moving patch, which shows up as a cluster of outlier dots.

## Estimating global motion

```@docs
estimate_global_motion
GlobalMotion
translation
rotation
scale_factor
classify_confidence
```

## Residual local motion

Point correspondences are extracted from motion vectors with
`VideoIO.correspondences` (see [Codec motion vectors](@ref)); the module
itself operates purely on `n×2` point matrices.

```@docs
local_residuals
```

## Fitting primitives

```@docs
fit_translation
fit_similarity
fit_affine
ransac_fit
residuals
apply_transform
transform_points
invert_transform
```
