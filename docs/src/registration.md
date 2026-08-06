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

!!! warning "Experimental"
    `VideoRegistration` is experimental. Its API may change in breaking ways
    between minor VideoIO releases, and the module may be moved out of
    VideoIO into a separate package in the future (it is self-contained —
    stdlib dependencies only — precisely to allow that). The motion-vector
    extraction API in VideoIO itself (`export_mvs`, `motion_vectors`,
    `MotionVector`, `correspondences`) is not affected and would remain in
    VideoIO.

!!! note
    Codec motion vectors are *compression decisions*, not measured optical
    flow. They may be coarse, reference non-adjacent frames, and be misleading
    around scene cuts and intra-coded regions. The module therefore fits
    models robustly (RANSAC) and reports quality metrics so that unreliable
    estimates can be detected and a conventional registration fallback used.

```@docs
VideoIO.VideoRegistration
```

!!! tip "Demo"
    `util/motion_vector_demo.jl` in the VideoIO repository renders a
    triple-pane video (original | annotated | globally corrected): per-block
    dots colored by RANSAC inlier status, an arrow showing the fitted global
    translation, and a third pane stabilized by warping each frame with the
    chained global-motion estimates:
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
compose_transform
```
