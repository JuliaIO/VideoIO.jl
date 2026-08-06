# Demo of decoder motion-vector extraction (`export_mvs`) and the
# VideoRegistration module.
#
# Reads a video, extracts the codec motion vectors of every frame, fits a
# robust global-motion model, and renders a double-width video with the
# original on the left and an annotated copy on the right:
#
#   - green dots:  motion-vector blocks consistent with the fitted global
#                  motion (RANSAC inliers), with a dimmed tail showing where
#                  the block came from in the reference frame
#   - red dots:    blocks moving inconsistently with the global model
#                  (independent local motion, or unreliable codec vectors)
#   - orange dots: vectors present but no trustworthy global fit
#   - yellow arrow (from frame center): fitted global translation, scaled up
#
# Usage:
#   julia --project=. util/motion_vector_demo.jl [input.mp4] [output.mp4]
#
# With no input argument, a synthetic H.264 clip is generated: a textured
# background panning along a curve, plus a small independently-moving patch
# (which shows up as red dots).

using VideoIO
using VideoIO: correspondences
using VideoIO.VideoRegistration
using ColorTypes: RGB, N0f8
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

function annotate!(img, mvs, frame_size)
    dst, src = correspondences(mvs; frame_size)
    gm = estimate_global_motion(dst, src; frame_size)
    conf = classify_confidence(gm)
    fitted = gm !== nothing && conf !== :low
    for i in axes(dst, 1)
        color = fitted ? (gm.inliers[i] ? GREEN : RED) : ORANGE
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
    return gm, conf, size(dst, 1)
end

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

function run_demo(input, output)
    reader = openvideo(input, export_mvs = true, target_format = VideoIO.AV_PIX_FMT_RGB24)
    writer = nothing
    frame_size = nothing
    nframe = 0
    try
        for frame in reader
            nframe += 1
            # crop to even dimensions so the side-by-side encodes with libx264
            img = frame[1:(size(frame, 1)&~1), 1:(size(frame, 2)&~1)]
            if frame_size === nothing
                frame_size = (size(img, 2), size(img, 1)) # (width, height)
            end
            annotated = copy(img)
            gm, conf, npts = annotate!(annotated, motion_vectors(reader), frame_size)
            meta = frame_metadata(reader)
            if gm === nothing
                println("frame $nframe ($(meta.pict_type)): $npts usable vectors, no estimate")
            else
                tx, ty = round.(translation(gm), digits = 2)
                println(
                    "frame $nframe ($(meta.pict_type)): $npts vectors, translation=($tx, $ty), " *
                    "inliers=$(round(gm.inlier_fraction, digits = 2)), confidence=$conf",
                )
            end
            sidebyside = hcat(img, annotated)
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
    println("\nWrote $nframe side-by-side frames to $output")
end

if abspath(PROGRAM_FILE) == @__FILE__
    input = get(ARGS, 1) do
        path = joinpath(tempdir(), "vio_mv_demo_input.mp4")
        println("No input given - generating synthetic test video at $path\n")
        make_synthetic_video(path)
    end
    output = get(ARGS, 2, joinpath(dirname(abspath(input)), "mv_demo_sidebyside.mp4"))
    run_demo(input, output)
end
