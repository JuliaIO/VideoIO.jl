# Demo of decoder motion-vector extraction (`export_mvs`) and the
# VideoRegistration module.
#
# Reads a video, extracts the codec motion vectors of every frame, fits a
# robust global-motion model, and renders a triple-width video:
#
#   left:   original frame
#   middle: annotated copy
#     - green dots:  motion-vector blocks consistent with the fitted global
#                    motion (RANSAC inliers), with a dimmed tail showing where
#                    the block came from in the reference frame
#     - red dots:    blocks moving inconsistently with the global model
#                    (independent local motion, or unreliable codec vectors)
#     - orange dots: vectors present but no trustworthy global fit
#     - yellow arrow (from frame center): fitted global translation, scaled up
#   right:  frame corrected for global movement — warped by the cumulative
#           chained transform so scene content stays put (black borders where
#           the frame has moved out of the anchor's view). The chain resets to
#           identity whenever no trustworthy estimate is available (I-frames,
#           scene cuts, low-confidence fits).
#
# Usage:
#   julia --project=. util/motion_vector_demo.jl [flags] [input.mp4] [output.mp4]
#
# Flags:
#   --coast                In frames with no trustworthy estimate, carry the
#                          correction chain through unchanged instead of
#                          resetting to identity (for continuous footage).
#   --model=<m>            Global model: translation | similarity | affine
#   --smooth=<N>           Correct only the deviation from an exponentially
#                          smoothed trajectory (time constant ~N frames)
#                          instead of registering to a fixed anchor. Follows
#                          slow/intentional motion, removes jitter, immune to
#                          long-sequence drift. 0 (default) = fixed anchor.
#   --refine               Hybrid pipeline: refine each frame's translation
#                          with a small image-domain search seeded by the
#                          codec-derived estimate. The search matches gradient
#                          images (flicker-immune, structure-driven) and masks
#                          out local movers (MV blocks the RANSAC fit rejected)
#                          so it follows the background, not moving objects.
#                          Codec motion vectors are compression decisions:
#                          encoders often code global jitter as residuals on
#                          low-contrast/grainy content (blocks vote "zero
#                          motion" despite real movement), which motion vectors
#                          alone cannot reveal. This also bridges I-frames,
#                          which have no vectors at all.
#
# With no input argument, a synthetic H.264 clip is generated: a textured
# background panning along a curve, plus a small independently-moving patch
# (which shows up as red dots).

using VideoIO
using VideoIO: correspondences
using VideoIO.VideoRegistration
using ColorTypes: RGB, N0f8, red, green, blue
using Random: MersenneTwister

# ---------------------------------------------------------------------------
# Synthetic default input
# ---------------------------------------------------------------------------

function make_synthetic_video(path; h = 288, w = 352, nframes = 120)
    rng = MersenneTwister(7)
    pad = 80
    smooth(a) = 0.25 .* a[1:end-2, 2:end-1] .+ 0.5 .* a[2:end-1, 2:end-1] .+ 0.25 .* a[3:end, 2:end-1]
    blur(a, passes) = (for _ in 1:passes
        a = permutedims(smooth(permutedims(smooth(a))))
    end; a)
    norm01(a) = (a .- minimum(a)) ./ (maximum(a) - minimum(a))
    # low-frequency cloudy texture: blurred noise at two spatial scales
    margin = 40 # eaten by blur passes
    coarse = repeat(rand(rng, Float64, (h + 2pad + 2margin) ÷ 8, (w + 2pad + 2margin) ÷ 8), inner = (8, 8))
    fine = rand(rng, Float64, size(coarse))
    basef = norm01(blur(0.8 .* coarse .+ 0.2 .* fine, 8))
    base = round.(UInt8, 30 .+ 195 .* basef[1:(h+2pad), 1:(w+2pad)])

    patchf = repeat(rand(rng, Float64, 8, 8), inner = (10, 10))
    patchf = norm01(blur(patchf, 3))
    patch = round.(UInt8, 30 .+ 195 .* patchf)
    ph, pw = size(patch)

    frames = Vector{Matrix{UInt8}}(undef, nframes)
    for i in 1:nframes
        # background pans along a smooth curve
        t = (i - 1) / nframes
        ox = pad + round(Int, (pad - 10) * sinpi(2t))
        oy = pad + round(Int, (pad - 10) * cospi(2t))
        frame = base[(1+oy):(h+oy), (1+ox):(w+ox)]
        # independently moving patch (crosses the frame diagonally)
        py = 1 + mod(round(Int, 40 + 1.5i), h - ph)
        px = 1 + mod(round(Int, 60 + 2.5i), w - pw)
        frame = copy(frame)
        frame[py:(py+ph-1), px:(px+pw-1)] .= patch
        frames[i] = frame
    end
    VideoIO.save(
        path,
        frames;
        framerate = 30,
        codec_name = "libx264",
        encoder_options = (crf = "20", preset = "medium", bf = 0, refs = 1, g = 30),
    )
    return path
end

# ---------------------------------------------------------------------------
# Simple pixel drawing
# ---------------------------------------------------------------------------

function draw_dot!(img, x, y, color; radius = 2)
    h, w = size(img)
    for dy in -radius:radius, dx in -radius:radius
        dx^2 + dy^2 <= radius^2 || continue
        r, c = round(Int, y) + dy + 1, round(Int, x) + dx + 1
        (1 <= r <= h && 1 <= c <= w) && (img[r, c] = color)
    end
end

function draw_line!(img, x1, y1, x2, y2, color)
    h, w = size(img)
    n = max(2, ceil(Int, hypot(x2 - x1, y2 - y1)) + 1)
    for t in range(0.0, 1.0; length = n)
        r = round(Int, y1 + t * (y2 - y1)) + 1
        c = round(Int, x1 + t * (x2 - x1)) + 1
        (1 <= r <= h && 1 <= c <= w) && (img[r, c] = color)
    end
end

function draw_arrow!(img, x1, y1, x2, y2, color)
    draw_line!(img, x1, y1, x2, y2, color)
    # arrow head
    len = hypot(x2 - x1, y2 - y1)
    len < 1 && return
    ux, uy = (x2 - x1) / len, (y2 - y1) / len
    for s in (-1, 1)
        hx = -0.35ux + s * 0.35uy
        hy = -0.35uy - s * 0.35ux
        draw_line!(img, x2, y2, x2 + 8hx, y2 + 8hy, color)
    end
end

dim(c::RGB{N0f8}, f) = RGB{N0f8}(f * c.r, f * c.g, f * c.b)

const GREEN = RGB{N0f8}(0.1, 0.9, 0.1)
const RED = RGB{N0f8}(0.95, 0.1, 0.1)
const ORANGE = RGB{N0f8}(1.0, 0.6, 0.05)
const YELLOW = RGB{N0f8}(1.0, 0.95, 0.1)

# ---------------------------------------------------------------------------
# Annotation
# ---------------------------------------------------------------------------

function annotate!(img, mvs, frame_size; model::Symbol = :similarity)
    dst, src = correspondences(mvs; frame_size)
    gm = estimate_global_motion(dst, src; frame_size, model)
    conf = classify_confidence(gm)
    fitted = gm !== nothing && conf !== :low
    outlier_pts = Tuple{Float64,Float64}[] # blocks moving against the global fit
    for i in axes(dst, 1)
        inlier = fitted && gm.inliers[i]
        color = fitted ? (inlier ? GREEN : RED) : ORANGE
        fitted && !inlier && push!(outlier_pts, (dst[i, 1], dst[i, 2]))
        # tail: where this block came from in the reference frame
        draw_line!(img, src[i, 1], src[i, 2], dst[i, 1], dst[i, 2], dim(color, 0.45))
        draw_dot!(img, dst[i, 1], dst[i, 2], color)
    end
    if fitted
        # fitted global translation, scaled ×8, drawn from the frame center
        tx, ty = translation(gm)
        cx, cy = frame_size[1] / 2, frame_size[2] / 2
        draw_arrow!(img, cx, cy, cx + 8tx, cy + 8ty, YELLOW)
    end
    return gm, conf, size(dst, 1), outlier_pts
end

# ---------------------------------------------------------------------------
# Global-motion correction (stabilization)
# ---------------------------------------------------------------------------

const IDENTITY_TRANSFORM = [1.0 0.0 0.0; 0.0 1.0 0.0]

# Gradient-magnitude image (central differences). Matching gradients instead
# of intensities makes the image-domain refinement immune to global luminance
# flicker and drives it by scene structure rather than flat regions.
function gradmag(g)
    h, w = size(g)
    out = zeros(Float32, h, w)
    @views out[2:(h-1), 2:(w-1)] .=
        abs.(g[2:(h-1), 3:w] .- g[2:(h-1), 1:(w-2)]) .+ abs.(g[3:h, 2:(w-1)] .- g[1:(h-2), 2:(w-1)])
    return out
end

# Weight mask that excludes local movers: zero out a square neighbourhood
# around each motion-vector block that the RANSAC fit rejected as inconsistent
# with the global motion, so the refinement is driven by the background only.
function background_weights(sz, outlier_pts; radius = 12)
    h, w = sz
    m = ones(Float32, h, w)
    for (x, y) in outlier_pts
        r0 = clamp(round(Int, y) - radius, 0, h - 1)
        r1 = clamp(round(Int, y) + radius, 0, h - 1)
        c0 = clamp(round(Int, x) - radius, 0, w - 1)
        c1 = clamp(round(Int, x) + radius, 0, w - 1)
        m[(r0+1):(r1+1), (c0+1):(c1+1)] .= 0
    end
    return m
end

# Image-domain refinement (the design doc's hybrid pipeline): take the
# codec-derived per-frame transform `A` (current -> reference coords, or
# identity when none is available) and refine its translation by minimizing
# the weighted sum of absolute gradient differences of a central crop over
# integer offsets within `radius` of the estimate, followed by parabolic
# sub-pixel interpolation. `prevG`/`curG` are gradient-magnitude images (see
# [`gradmag`](@ref)); `weight` masks out local movers (see
# [`background_weights`](@ref)) so the estimate follows the background, not
# moving objects. The linear part of `A` is kept as-is (the search treats the
# motion as locally translational, valid for the small rotations/scalings a
# frame-to-frame transform exhibits).
function refine_translation(A, prevG, curG, weight; radius = 4)
    h, w = size(curG)
    r0, r1 = h ÷ 4, 3h ÷ 4
    c0, c1 = w ÷ 4, 3w ÷ 4
    margin = min(r0 - 1, c0 - 1, h - r1, w - c1) - 1
    wcrop = @view weight[r0:r1, c0:c1]
    # refuse to refine if the movers mask leaves too little background
    sum(wcrop) >= 0.2 * length(wcrop) || return A
    bx, by = round(Int, A[1, 3]), round(Int, A[2, 3])
    sad(tx, ty) = @views sum(wcrop .* abs.(curG[r0:r1, c0:c1] .- prevG[(r0+ty):(r1+ty), (c0+tx):(c1+tx)]))
    best = (Inf32, 0, 0)
    for ty in (by-radius):(by+radius), tx in (bx-radius):(bx+radius)
        (abs(tx) <= margin && abs(ty) <= margin) || continue
        s = sad(tx, ty)
        s < best[1] && (best = (s, tx, ty))
    end
    isfinite(best[1]) || return A
    _, tx, ty = best
    # parabolic sub-pixel interpolation per axis (guarded at search bounds)
    subpix(s₋, s₀, s₊) = (d = s₋ - 2s₀ + s₊; d <= 0 ? 0.0 : clamp(0.5 * (s₋ - s₊) / d, -0.5, 0.5))
    fx = abs(tx - 1) <= margin && abs(tx + 1) <= margin ? subpix(sad(tx - 1, ty), best[1], sad(tx + 1, ty)) : 0.0
    fy = abs(ty - 1) <= margin && abs(ty + 1) <= margin ? subpix(sad(tx, ty - 1), best[1], sad(tx, ty + 1)) : 0.0
    refined = copy(A)
    refined[1, 3] = tx + fx
    refined[2, 3] = ty + fy
    return refined
end

# Warp `img` by the cumulative transform `C` (current-frame -> anchor coords)
# with bilinear sampling; pixels from outside the frame are left black.
function warp_global(img, C)
    Ci = invert_transform(C) # anchor -> current-frame coords
    h, w = size(img)
    out = fill(RGB{N0f8}(0, 0, 0), h, w)
    for r in 1:h, c in 1:w
        x, y = apply_transform(Ci, (c - 1.0, r - 1.0))
        x0, y0 = floor(Int, x), floor(Int, y)
        (0 <= x0 <= w - 2 && 0 <= y0 <= h - 2) || continue
        fx, fy = x - x0, y - y0
        p00, p01 = img[y0+1, x0+1], img[y0+1, x0+2]
        p10, p11 = img[y0+2, x0+1], img[y0+2, x0+2]
        blend(f) =
            (1 - fy) * ((1 - fx) * Float32(f(p00)) + fx * Float32(f(p01))) +
            fy * ((1 - fx) * Float32(f(p10)) + fx * Float32(f(p11)))
        out[r, c] = RGB{N0f8}(clamp(blend(red), 0, 1), clamp(blend(green), 0, 1), clamp(blend(blue), 0, 1))
    end
    return out
end

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

"""
    run_demo(input, output; model = :similarity, coast = false, refine = false)

Render the triple-pane demo video.

- `model`: global-motion model for the correction chain (`:translation` has
  the fewest degrees of freedom and is most robust for near-static footage)
- `coast = false`: on frames without a trustworthy estimate (I-frames, scene
  cuts, low confidence), reset the correction chain to identity. `coast =
  true` instead carries the chain through unchanged (assumes zero motion for
  that transition) — appropriate for temporally continuous footage; note that
  chained estimates accumulate drift the longer the chain runs.
- `refine = false`: refine each per-frame translation with a small
  image-domain search seeded by the codec-derived estimate (see
  [`refine_translation`](@ref)): gradient matching (flicker-immune) with
  local movers masked out, so the estimate follows the background rather than
  moving objects. Recovers global motion that the encoder chose to code as
  residuals instead of motion vectors, and bridges I-frames.
- `smooth = 0`: with `smooth = 0` the corrected pane registers every frame to
  a fixed anchor (good for short clips and genuinely static scenes). With
  `smooth = N > 0` it corrects only the deviation from an exponentially
  smoothed trajectory (time constant ≈ N frames): slow/intentional motion is
  followed, high-frequency jitter is removed, and long-sequence drift cannot
  push the content out of view.
"""
function run_demo(
    input,
    output;
    model::Symbol = :similarity,
    coast::Bool = false,
    refine::Bool = false,
    smooth::Integer = 0,
)
    reader = openvideo(input, export_mvs = true, target_format = VideoIO.AV_PIX_FMT_RGB24)
    writer = nothing
    frame_size = nothing
    nframe = 0
    cumulative = IDENTITY_TRANSFORM # chained current-frame -> anchor transform
    smoothed = nothing              # EMA of `cumulative` when smooth > 0
    # temporal-stability metric: mean abs frame-to-frame difference of the
    # central crop, downsampled 4×4 so pixel-level noise (film grain, codec
    # noise) does not dominate and the metric reflects structural motion
    jitter_orig = jitter_corr = 0.0
    prev_orig = prev_corr = nothing
    prev_gray = nothing # full-frame gradient image of previous frame, for --refine
    function graycrop(x)
        g = Float32.(green.(@view x[(size(x, 1)÷4):(3 * size(x, 1)÷4), (size(x, 2)÷4):(3 * size(x, 2)÷4)]))
        h4, w4 = size(g, 1) ÷ 4, size(g, 2) ÷ 4
        return [sum(@view g[(4i-3):(4i), (4j-3):(4j)]) / 16 for i in 1:h4, j in 1:w4]
    end
    try
        for frame in reader
            nframe += 1
            # crop to even dimensions so the side-by-side encodes with libx264
            img = frame[1:(size(frame, 1)&~1), 1:(size(frame, 2)&~1)]
            if frame_size === nothing
                frame_size = (size(img, 2), size(img, 1)) # (width, height)
            end
            annotated = copy(img)
            gm, conf, npts, outlier_pts = annotate!(annotated, motion_vectors(reader), frame_size; model)
            meta = frame_metadata(reader)
            # chain the estimate for the corrected view
            trustworthy = gm !== nothing && conf !== :low
            g_grad = refine ? gradmag(Float32.(green.(img))) : nothing
            if refine && prev_gray !== nothing
                # hybrid: image-domain refinement seeded by the codec estimate
                # (identity seed on I-frames / untrustworthy fits), driven by
                # background structure only: gradient matching, local movers
                # (MV outlier blocks) masked out
                weight = background_weights(size(g_grad), outlier_pts)
                An = refine_translation(trustworthy ? gm.A : IDENTITY_TRANSFORM, prev_gray, g_grad, weight)
                cumulative = compose_transform(cumulative, An)
            elseif trustworthy
                cumulative = compose_transform(cumulative, gm.A)
            elseif !coast
                cumulative = IDENTITY_TRANSFORM
            end
            prev_gray = g_grad
            if smooth > 0
                # follow the smoothed camera trajectory; correct only the
                # high-frequency deviation from it
                λ = exp(-1 / smooth)
                smoothed = smoothed === nothing ? copy(cumulative) : λ .* smoothed .+ (1 - λ) .* cumulative
                correction = compose_transform(invert_transform(smoothed), cumulative)
            else
                correction = cumulative
            end
            corrected = warp_global(img, correction)
            g_orig, g_corr = graycrop(img), graycrop(corrected)
            if prev_orig !== nothing
                jitter_orig += sum(abs, g_orig .- prev_orig) / length(g_orig)
                jitter_corr += sum(abs, g_corr .- prev_corr) / length(g_corr)
            end
            prev_orig, prev_corr = g_orig, g_corr
            if gm === nothing
                println("frame $nframe ($(meta.pict_type)): $npts usable vectors, no estimate")
            else
                tx, ty = round.(translation(gm), digits = 2)
                println(
                    "frame $nframe ($(meta.pict_type)): $npts vectors, translation=($tx, $ty), " *
                    "inliers=$(round(gm.inlier_fraction, digits = 2)), confidence=$conf",
                )
            end
            sep = fill(RGB{N0f8}(1, 1, 1), size(img, 1), 2) # pane separator
            sidebyside = hcat(img, sep, annotated, sep, corrected)
            if writer === nothing
                fps = round(Int, VideoIO.framerate(reader))
                writer = VideoIO.open_video_out(
                    output,
                    sidebyside;
                    framerate = fps <= 0 ? 30 : fps,
                    encoder_options = (crf = "20", preset = "medium"),
                )
            end
            write(writer, sidebyside)
        end
    finally
        writer === nothing || VideoIO.close_video_out!(writer)
        close(reader)
    end
    if nframe > 1
        jo, jc = jitter_orig / (nframe - 1), jitter_corr / (nframe - 1)
        println("\nTemporal stability (mean abs frame-to-frame difference, downsampled central crop):")
        println("  original:  ", round(jo, digits = 5))
        println("  corrected: ", round(jc, digits = 5), "  (", round(100 * (1 - jc / jo), digits = 1), "% reduction)")
        println("  final chain translation (drift indicator): (",
            round(cumulative[1, 3], digits = 1), ", ", round(cumulative[2, 3], digits = 1), ")")
    end
    println("Wrote $nframe original | annotated | corrected frames to $output")
end

if abspath(PROGRAM_FILE) == @__FILE__
    flags = filter(startswith("--"), ARGS)
    pos = filter(!startswith("--"), ARGS)
    coast = "--coast" in flags
    refine = "--refine" in flags
    modelflag = findfirst(startswith("--model="), flags)
    model = modelflag === nothing ? :similarity : Symbol(chopprefix(flags[modelflag], "--model="))
    smoothflag = findfirst(startswith("--smooth="), flags)
    smooth = smoothflag === nothing ? 0 : parse(Int, chopprefix(flags[smoothflag], "--smooth="))
    input = get(pos, 1) do
        path = joinpath(tempdir(), "vio_mv_demo_input.mp4")
        println("No input given - generating synthetic test video at $path\n")
        make_synthetic_video(path)
    end
    output = get(pos, 2, joinpath(dirname(abspath(input)), "mv_demo_sidebyside.mp4"))
    run_demo(input, output; model, coast, refine, smooth)
end
