#!/usr/bin/env julia
# bench_hwaccel.jl — Compare SW vs HW encoding & decoding throughput.
#
# Run:  julia --project util/bench_hwaccel.jl

using VideoIO
using ColorTypes: RGB, Gray, N0f8
using Statistics: mean

struct BenchConfig
    w::Int
    h::Int
    eltype::Type
    enc_opts::NamedTuple      # common to SW and HW
    sw_enc_opts::NamedTuple   # SW-only (e.g. crf)
    label::String
end

const CONFIGS = [
    BenchConfig(640,  480,  RGB{N0f8}, (;), (;),          "640×480 RGB"),
    BenchConfig(1280, 720,  RGB{N0f8}, (;), (;),          "1280×720 RGB"),
    BenchConfig(1920, 1080, RGB{N0f8}, (;), (;),          "1920×1080 RGB"),
    BenchConfig(2048, 1536, Gray{N0f8},(color_range=2,), (crf=13,), "2048×1536 Gray CR=2 CRF=13"),
]
const NFRAMES = 120
const FPS = 30

hw_devs = VideoIO.available_hw_devices()
hw_encs = VideoIO.available_hw_encoders()
isempty(hw_devs) && error("No HW device types available — nothing to benchmark")

dev = first(hw_devs)
println("Platform HW device: :$dev")
println("HW encoders:        $hw_encs")
println()

function gen_frames(::Type{RGB{N0f8}}, h, w, n)
    [RGB{N0f8}.(range(N0f8(0), N0f8(1); length=w)' .* ones(N0f8, h),
                 zeros(N0f8, h, w),
                 ones(N0f8, h, w) .- range(N0f8(0), N0f8(1); length=w)' .* ones(N0f8, h))
     for _ in 1:n]
end

function gen_frames(::Type{Gray{N0f8}}, h, w, n)
    [Gray{N0f8}.(range(N0f8(0), N0f8(1); length=w)' .* ones(N0f8, h))
     for _ in 1:n]
end

function bench_encode(frames, path; kwargs...)
    # Warmup
    VideoIO.save(path, frames; framerate=FPS, kwargs...)
    rm(path; force=true)
    # Timed
    t = @elapsed VideoIO.save(path, frames; framerate=FPS, kwargs...)
    sz_mb = filesize(path) / 1024^2
    return (; time=t, size_mb=sz_mb)
end

function bench_decode(path; kwargs...)
    # Warmup
    VideoIO.openvideo(path; kwargs...) do r
        while !eof(r); read(r); end
    end
    # Timed
    n = 0
    t = @elapsed VideoIO.openvideo(path; kwargs...) do r
        while !eof(r)
            read(r)
            n += 1
        end
    end
    return (; time=t, nframes=n)
end

# Header
println(rpad("Config", 30),
        rpad("Mode", 22),
        rpad("Enc (s)", 10), rpad("Enc FPS", 10), rpad("File MB", 10),
        rpad("Dec (s)", 10), rpad("Dec FPS", 10))
println("-"^102)

mktempdir() do dir
    for cfg in CONFIGS
        (; w, h, eltype, enc_opts, sw_enc_opts, label) = cfg
        frames = gen_frames(eltype, h, w, NFRAMES)
        tag = "$(w)x$(h)_$(nameof(eltype))"

        # ── Software encode + decode ──
        sw_path = joinpath(dir, "sw_$(tag).mp4")
        merged_sw_opts = merge((crf=23, preset="medium"), enc_opts, sw_enc_opts)
        enc = bench_encode(frames, sw_path;
                           encoder_options=merged_sw_opts)
        dec = bench_decode(sw_path)
        println(rpad(label, 30),
                rpad("SW encode/decode", 22),
                rpad(round(enc.time; digits=3), 10),
                rpad(round(NFRAMES / enc.time; digits=1), 10),
                rpad(round(enc.size_mb; digits=2), 10),
                rpad(round(dec.time; digits=3), 10),
                rpad(round(dec.nframes / dec.time; digits=1), 10))

        # ── HW encode (auto-selected) + SW decode ──
        hw_enc_path = joinpath(dir, "hw_enc_$(tag).mp4")
        enc_hw = bench_encode(frames, hw_enc_path; hwaccel=dev,
                              encoder_options=enc_opts)
        dec_sw = bench_decode(hw_enc_path)
        println(rpad("", 30),
                rpad("HW enc → SW dec", 22),
                rpad(round(enc_hw.time; digits=3), 10),
                rpad(round(NFRAMES / enc_hw.time; digits=1), 10),
                rpad(round(enc_hw.size_mb; digits=2), 10),
                rpad(round(dec_sw.time; digits=3), 10),
                rpad(round(dec_sw.nframes / dec_sw.time; digits=1), 10))

        # ── SW encode + HW decode ──
        dec_hw = bench_decode(sw_path; hwaccel=dev)
        println(rpad("", 30),
                rpad("SW enc → HW dec", 22),
                rpad("-", 10), rpad("-", 10), rpad("-", 10),
                rpad(round(dec_hw.time; digits=3), 10),
                rpad(round(dec_hw.nframes / dec_hw.time; digits=1), 10))

        # ── HW encode + HW decode ──
        dec_hw2 = bench_decode(hw_enc_path; hwaccel=dev)
        println(rpad("", 30),
                rpad("HW enc → HW dec", 22),
                rpad("-", 10), rpad("-", 10), rpad("-", 10),
                rpad(round(dec_hw2.time; digits=3), 10),
                rpad(round(dec_hw2.nframes / dec_hw2.time; digits=1), 10))

        println()

        # Cleanup
        rm(sw_path; force=true)
        rm(hw_enc_path; force=true)
    end
end
