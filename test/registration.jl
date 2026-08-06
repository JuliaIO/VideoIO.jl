using VideoIO:
    openvideo,
    frame_metadata,
    motion_vectors,
    MotionVector,
    correspondences,
    skipframe,
    seekstart,
    out_frame_size
using VideoIO.VideoRegistration
using VideoIO.VideoRegistration: residuals  # explicit: StatsBase also exports `residuals`
using Random: Random, MersenneTwister

# Build a synthetic smoothly-textured video translating by (2, 1) px/frame
function translating_test_video(; h = 144, w = 176, nframes = 12, dx = 2, dy = 1)
    rng = MersenneTwister(1234)
    pad = max(dx, dy) * nframes + 8
    basef = rand(rng, Float64, h + pad, w + pad)
    smooth(a) = 0.25 .* a[1:end-2, 2:end-1] .+ 0.5 .* a[2:end-1, 2:end-1] .+ 0.25 .* a[3:end, 2:end-1]
    basef = smooth(permutedims(smooth(permutedims(smooth(smooth(basef))))))
    base = round.(UInt8, 255 .* (basef .- minimum(basef)) ./ (maximum(basef) - minimum(basef)))
    return [base[(1+dy*(i-1)):(h+dy*(i-1)), (1+dx*(i-1)):(w+dx*(i-1))] for i in 1:nframes]
end

@testset "Motion vector extraction" begin
    dx, dy = 2, 1
    frames = translating_test_video(; dx, dy)
    path = joinpath(tempdir(), "vio_mv_translating.mp4")
    VideoIO.save(
        path,
        frames;
        codec_name = "libx264",
        encoder_options = (crf = "20", preset = "ultrafast", bf = 0, refs = 1, g = 30),
    )

    @testset "export_mvs = true" begin
        openvideo(path, export_mvs = true) do r
            # First frame is an I-frame: no motion vectors
            read(r)
            @test frame_metadata(r).pict_type == 'I'
            mvs = motion_vectors(r)
            @test mvs isa Vector{MotionVector}
            @test isempty(mvs)

            # P-frames carry vectors matching the known global translation
            nchecked = 0
            while !eof(r)
                read(r)
                frame_metadata(r).pict_type == 'P' || continue
                mvs = motion_vectors(r)
                @test !isempty(mvs)
                mv = first(mvs)
                # FFmpeg invariant: src = dst + motion / motion_scale
                @test mv.motion_scale > 0
                sx, sy = VideoIO.src_position(mv)
                @test sx ≈ mv.dst_x + mv.motion_x / mv.motion_scale
                @test sy ≈ mv.dst_y + mv.motion_y / mv.motion_scale
                @test VideoIO.displacement(mv) == (sx - mv.dst_x, sy - mv.dst_y)
                # Median displacement recovers the ground-truth translation
                dxs = [VideoIO.displacement(m)[1] for m in mvs]
                dys = [VideoIO.displacement(m)[2] for m in mvs]
                @test median(dxs) ≈ dx atol = 0.5
                @test median(dys) ≈ dy atol = 0.5
                nchecked += 1
            end
            @test nchecked > 5
        end
    end

    @testset "skipframe and seek bookkeeping" begin
        openvideo(path, export_mvs = true) do r
            read(r)                       # I-frame
            skipframe(r)                  # drop a P-frame (consumes its MVs)
            read(r)
            @test !isempty(motion_vectors(r))
            @test frame_metadata(r).pict_type == 'P'
            seekstart(r)
            @test isempty(motion_vectors(r))  # reset by seek
            read(r)
            @test frame_metadata(r).pict_type == 'I'
            @test isempty(motion_vectors(r))
        end
    end

    @testset "export_mvs not enabled" begin
        openvideo(path) do r
            read(r)
            @test_throws ErrorException motion_vectors(r)
        end
    end

    @testset "export_mvs incompatible with hwaccel" begin
        @test_throws ErrorException openvideo(path, export_mvs = true, hwaccel = :videotoolbox)
    end

    @testset "Registration from codec motion vectors" begin
        openvideo(path, export_mvs = true) do r
            sz = out_frame_size(r)
            read(r)  # I-frame
            @test estimate_global_motion(motion_vectors(r); frame_size = sz) === nothing
            @test classify_confidence(nothing) === :none
            while !eof(r)
                read(r)
                frame_metadata(r).pict_type == 'P' || continue
                mvs = motion_vectors(r)
                for model in (:translation, :similarity, :affine)
                    gm = estimate_global_motion(mvs; model, frame_size = sz)
                    @test gm isa GlobalMotion
                    tx, ty = translation(gm)
                    @test tx ≈ dx atol = 0.5
                    @test ty ≈ dy atol = 0.5
                    if model != :translation
                        @test rotation(gm) ≈ 0 atol = 0.02
                        @test scale_factor(gm) ≈ 1 atol = 0.02
                    end
                    @test classify_confidence(gm) === :high
                end
                # local residuals of a pure translation should be near zero
                dstm, srcm = correspondences(mvs; frame_size = sz)
                gm = estimate_global_motion(dstm, srcm; frame_size = sz)
                res = local_residuals(gm, dstm, srcm)
                @test median(hypot.(res[:, 1], res[:, 2])) < 0.5
            end
        end
        rm(path, force = true)
    end
end

@testset "VideoRegistration fitting" begin
    rng = MersenneTwister(42)

    # Ground truth similarity: rotation 0.05 rad, scale 1.02, translation (3, -2)
    θ, s, tx, ty = 0.05, 1.02, 3.0, -2.0
    A_true = [s*cos(θ) -s*sin(θ) tx; s*sin(θ) s*cos(θ) ty]
    npts = 200
    dst = 300 .* rand(rng, npts, 2)
    src = VideoRegistration.transform_points(A_true, dst)

    @testset "closed-form fits" begin
        A = fit_similarity(dst, src)
        @test A ≈ A_true atol = 1e-8
        A = fit_affine(dst, src)
        @test A ≈ A_true atol = 1e-8
        At = fit_translation(dst .+ 0, dst .+ [5.0 7.0])
        @test At ≈ [1 0 5; 0 1 7] atol = 1e-12

        # transform round trip
        Ainv = invert_transform(A_true)
        @test VideoRegistration.transform_points(Ainv, src) ≈ dst atol = 1e-8
        @test all(residuals(A_true, dst, src) .< 1e-8)
    end

    @testset "RANSAC with outliers" begin
        src_noisy = src .+ 0.1 .* randn(rng, npts, 2)
        # corrupt 30% of correspondences
        nbad = round(Int, 0.3 * npts)
        bad = Random.randperm(rng, npts)[1:nbad]
        src_noisy[bad, :] .+= 30 .* rand(rng, nbad, 2) .+ 10
        for model in (:similarity, :affine)
            A, inliers = ransac_fit(dst, src_noisy; model, threshold = 1.0, rng)
            @test count(inliers) >= npts - nbad
            @test all(.!inliers[bad])
            @test A ≈ A_true atol = 0.05
        end
        gm = estimate_global_motion(dst, src_noisy; model = :similarity, rng, frame_size = (300, 300))
        @test gm isa GlobalMotion
        @test translation(gm)[1] ≈ tx atol = 0.2
        @test translation(gm)[2] ≈ ty atol = 0.2
        @test rotation(gm) ≈ θ atol = 0.01
        @test scale_factor(gm) ≈ s atol = 0.01
        @test 0.6 <= gm.inlier_fraction <= 0.8
        @test classify_confidence(gm) === :high

        # outliers show up as large local residuals
        res = local_residuals(gm, dst, src_noisy)
        mags = hypot.(res[:, 1], res[:, 2])
        @test median(mags[gm.inliers]) < 0.5
        @test all(mags[bad] .> 1)
    end

    @testset "edge cases" begin
        @test estimate_global_motion(dst[1:3, :], src[1:3, :]) === nothing  # < min_points
        @test estimate_global_motion(MotionVector[]) === nothing
        @test_throws ArgumentError fit_similarity(dst[1:1, :], src[1:1, :])
        @test_throws ArgumentError ransac_fit(dst, src[1:10, :])
        @test_throws ArgumentError ransac_fit(dst, src; model = :homography)
        # degenerate: coincident points
        @test_throws ArgumentError fit_similarity(zeros(3, 2), zeros(3, 2))
    end

    @testset "correspondences filtering" begin
        mk(; source = -1, w = 16, h = 16, dst_x = 50, dst_y = 60, mx = 8, my = -4, scale = 4) =
            MotionVector(source, w, h, dst_x + mx ÷ scale, dst_y + my ÷ scale, dst_x, dst_y, 0, mx, my, scale)
        mvs = [
            mk(),                       # good: displacement (2, -1)
            mk(source = 1),             # future ref
            mk(w = 2, h = 2),           # tiny block
            mk(mx = 4000),              # huge displacement
            mk(dst_x = -300),           # out of frame
        ]
        d, s = correspondences(mvs; max_displacement = 50, frame_size = (176, 144))
        @test size(d) == (1, 2)
        @test d[1, :] == [50.0, 60.0]
        @test s[1, :] == [52.0, 59.0]
        # no filters except past_only
        d, s = correspondences(mvs; min_block_size = 0)
        @test size(d) == (4, 2)
        d, s = correspondences(mvs; past_only = false, min_block_size = 0)
        @test size(d) == (5, 2)
    end
end
