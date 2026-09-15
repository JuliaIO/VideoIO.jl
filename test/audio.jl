# Decode an audio stream with the ffmpeg executable into an nsamples × nchannels
# matrix, for comparison with VideoIO's decoding.
function ffmpeg_decode_audio(path; T = Float32, samplerate = nothing, nchannels = 2, streamno = 0)
    fmt = Dict(UInt8 => "u8", Int16 => "s16le", Int32 => "s32le", Float32 => "f32le", Float64 => "f64le")[T]
    raw_path = tempname() * ".raw"
    args = ["-y", "-v", "error", "-i", path, "-map", "0:a:$streamno"]
    samplerate === nothing || push!(args, "-ar", string(samplerate))
    push!(args, "-ac", string(nchannels), "-f", fmt, "-c:a", "pcm_$fmt", raw_path)
    FFMPEG.exe(Cmd(args))
    raw = reinterpret(T, read(raw_path))
    rm(raw_path)
    return permutedims(reshape(raw, nchannels, :))
end

ffprobe_audio_entry(path, entry) = strip(only(FFMPEG.exe(
    `-v error -select_streams a:0 -show_entries stream=$entry -of default=nokey=1:noprint_wrappers=1 $path`,
    command = FFMPEG.ffprobe, collect = true,
)))

# Synthetic test files: 3 s of a 440 Hz tone (left) and an 880 Hz tone (right)
# at 48 kHz, optionally with a small video stream, encoded with the ffmpeg
# executable into `dir`.
function synth_audio_file(dir, name, acodec; vcodec = nothing)
    out = joinpath(dir, name)
    args = ["-y", "-v", "error"]
    vcodec === nothing || append!(args, ["-f", "lavfi", "-i", "testsrc=duration=3:size=64x64:rate=25"])
    nvideo = vcodec === nothing ? 0 : 1
    append!(args, [
        "-f", "lavfi", "-i", "sine=frequency=440:sample_rate=48000:duration=3",
        "-f", "lavfi", "-i", "sine=frequency=880:sample_rate=48000:duration=3",
        "-filter_complex", "[$(nvideo):a][$(nvideo + 1):a]amerge=inputs=2[a]",
    ])
    vcodec === nothing || append!(args, ["-map", "0:v", "-c:v", vcodec])
    append!(args, ["-map", "[a]", "-c:a", acodec, out])
    FFMPEG.exe(Cmd(args))
    return out
end

# Magnitude of the `f` Hz component of `x` (sampled at `fs`)
tone_magnitude(x, f, fs) = abs(sum(x[i] * cispi(-2 * f * (i - 1) / fs) for i in eachindex(x)))

# Index into a full decode of the sample at time `t`, given the stream's start time
sample_index(t, t_start, fs) = round(Int, (t - t_start) * fs) + 1

maxabsdiff(a, b) = maximum(abs.(a .- b))

# Smallest elementwise difference between `block` and `samples` starting at
# `i0`, allowing the block to be shifted by up to `maxlag` samples (for
# containers whose timestamps are coarser than a sample, e.g. Matroska's 1 ms).
function aligned_maxabsdiff(block, samples, i0, maxlag)
    n = size(block, 1)
    return minimum(maxabsdiff(block, samples[(i0 + k):(i0 + k + n - 1), :]) for k in (-maxlag):maxlag)
end

@testset "Audio" begin
    @testset "Synthetic streams" begin
        mktempdir() do dir
            # (label, path, seek tolerance, seek alignment slack in samples)
            synth_files = [
                ("mp4 / aac", synth_audio_file(dir, "sine.mp4", "aac"; vcodec = "mpeg4"), 1e-3, 0),
                ("webm / vorbis", synth_audio_file(dir, "sine.webm", "libvorbis"; vcodec = "libvpx"), 1e-3, 24),
                ("mkv / flac", synth_audio_file(dir, "sine.mkv", "flac"; vcodec = "mpeg4"), 0, 24),
                ("ogg / vorbis", synth_audio_file(dir, "sine.ogg", "libvorbis"), 1e-3, 0),
                ("opus", synth_audio_file(dir, "sine.opus", "libopus"), 1e-3, 0),
                ("mp3", synth_audio_file(dir, "sine.mp3", "libmp3lame"), 1e-3, 0),
                ("wav", synth_audio_file(dir, "sine.wav", "pcm_s16le"), 0, 0),
                ("flac", synth_audio_file(dir, "sine.flac", "flac"), 0, 0),
            ]
            for (label, path, seek_tol, seek_lag) in synth_files
                @testset "$label" begin
                    reference = ffmpeg_decode_audio(path)
                    samples, fs = VideoIO.loadaudio(path)
                    @test fs == 48000
                    @test samples isa Matrix{Float32}
                    @test size(samples) == size(reference)
                    @test samples == reference
                    # Channel order: 440 Hz left, 880 Hz right
                    @test tone_magnitude(samples[:, 1], 440, fs) > 10 * tone_magnitude(samples[:, 1], 880, fs)
                    @test tone_magnitude(samples[:, 2], 880, fs) > 10 * tone_magnitude(samples[:, 2], 440, fs)

                    r = VideoIO.openaudio(path)
                    try
                        @test VideoIO.samplerate(r) == 48000
                        @test VideoIO.nchannels(r) == 2
                        first_block = read(r)
                        t_start = VideoIO.gettime(r) # container timeline, e.g. the MP3 encoder delay
                        @test 0 <= t_start < 0.05
                        @test first_block == samples[1:size(first_block, 1), :]
                        for t in (1.5, 0.7)
                            seek(r, t)
                            block = read(r, 4800)
                            @test VideoIO.gettime(r) ≈ t atol = 1 / fs
                            i0 = sample_index(t, t_start, fs)
                            @test aligned_maxabsdiff(block, samples, i0, seek_lag) <= seek_tol
                        end
                    finally
                        close(r)
                    end

                    mono, fs_mono = VideoIO.loadaudio(path; samplerate = 16000, nchannels = 1)
                    @test fs_mono == 16000
                    mono_ref = ffmpeg_decode_audio(path; samplerate = 16000, nchannels = 1)
                    @test size(mono) == size(mono_ref)
                    @test maxabsdiff(mono, mono_ref) <= 1e-4
                end
            end
        end
    end

    @testset "ladybird.mp4" begin
        path = joinpath(videodir, "ladybird.mp4") # stereo AAC, stored before the video stream
        fs_ref = 44100
        reference = ffmpeg_decode_audio(path)

        samples, fs = VideoIO.loadaudio(path)
        @test fs == fs_ref
        @test samples isa Matrix{Float32}
        @test size(samples) == size(reference)
        @test samples == reference

        # Other sample element types
        samples16, _ = VideoIO.loadaudio(path; eltype = Int16)
        @test samples16 isa Matrix{Int16}
        @test size(samples16) == size(reference)
        @test maximum(abs.(Int.(samples16) .- Int.(ffmpeg_decode_audio(path; T = Int16)))) <= 1
        samples64, _ = VideoIO.loadaudio(path; eltype = Float64)
        @test samples64 isa Matrix{Float64}
        @test maxabsdiff(samples64, reference) <= 1e-6
        @test_throws ArgumentError VideoIO.loadaudio(path; eltype = Int8)
        @test_throws ArgumentError VideoIO.loadaudio(path; samplerate = 0)
        @test_throws ArgumentError VideoIO.loadaudio(path; nchannels = 0)

        # Portions
        part, _ = VideoIO.loadaudio(path; start = 2, duration = 0.5)
        @test size(part) == (round(Int, 0.5 * fs_ref), 2)
        @test part == samples[(2 * fs_ref + 1):(2 * fs_ref + size(part, 1)), :]
        @test_throws ArgumentError VideoIO.loadaudio(path; duration = -1)

        @testset "Streaming reads" begin
            r = VideoIO.openaudio(VideoIO.testvideo("ladybird"))
            try
                @test VideoIO.samplerate(r) == fs_ref
                @test VideoIO.nchannels(r) == 2
                @test VideoIO.sample_eltype(r) == Float32
                @test eltype(r) == Matrix{Float32}
                @test occursin("aac 44100 Hz stereo", sprint(show, r))
                @test isopen(r)
                @test VideoIO.gettime(r) == 0.0

                # Codec-sized blocks
                first_block = read(r)
                @test first_block isa Matrix{Float32}
                @test size(first_block) == (1024, 2)
                @test first_block == samples[1:1024, :]
                @test VideoIO.gettime(r) == 0.0
                rest = reduce(vcat, collect(r))
                @test vcat(first_block, rest) == samples
                @test eof(r)
                @test_throws EOFError read(r)
                @test size(read(r, 10)) == (0, 2)

                # Fixed-size blocks spanning codec block boundaries
                seekstart(r)
                n = 1000
                blocks = Matrix{Float32}[]
                while !eof(r)
                    push!(blocks, read(r, n))
                end
                @test all(b -> size(b, 1) == n, blocks[1:(end - 1)])
                @test 0 < size(blocks[end], 1) <= n
                @test reduce(vcat, blocks) == samples

                # read! into preallocated buffers
                seekstart(r)
                buf = zeros(Float32, 3000, 2)
                @test read!(r, buf) === buf
                @test buf == samples[1:3000, :]
                @test VideoIO.gettime(r) == 0.0
                read!(r, buf)
                @test buf == samples[3001:6000, :]
                @test VideoIO.gettime(r) ≈ 3000 / fs_ref
                @test_throws ArgumentError read!(r, zeros(Float32, 100, 1))
                @test_throws MethodError read!(r, zeros(Float64, 100, 2))
                seek(r, (size(samples, 1) - 100) / fs_ref)
                @test_throws EOFError read!(r, buf)

                # Seeking is sample accurate
                for t in (5.0, 1.234, 0.0)
                    seek(r, t)
                    i0 = sample_index(t, 0, fs_ref)
                    block = read(r, 4096)
                    @test VideoIO.gettime(r) ≈ t atol = 1 / fs_ref
                    @test maxabsdiff(block, samples[i0:(i0 + 4095), :]) <= 1e-4
                end

                # Resampled reader
                mono, _ = VideoIO.loadaudio(path; samplerate = 16000, nchannels = 1)
                rm = VideoIO.openaudio(path; samplerate = 16000, nchannels = 1, eltype = Int16)
                @test VideoIO.samplerate(rm) == 16000
                @test VideoIO.nchannels(rm) == 1
                @test VideoIO.sample_eltype(rm) == Int16
                v = zeros(Int16, 500) # vectors are accepted for mono output
                read!(rm, v)
                @test maximum(abs.(Int.(v) .- Int.(round.(Int16, clamp.(mono[1:500, 1], -1, 1) .* 32767)))) <= 2
                close(rm)
                @test !isopen(rm)
            finally
                close(r)
            end
            @test !isopen(r)
            @test eof(r)
        end

        @testset "Video and audio from one AVInput" begin
            avin = VideoIO.open(path)
            v = VideoIO.openvideo(avin)
            a = VideoIO.openaudio(avin)
            img = read(v)
            block = read(a)
            @test size(img) == VideoIO.out_frame_size(v)[[2, 1]]
            @test block == samples[1:size(block, 1), :]
            # Draining one stream must not confuse the other's EOF detection
            nframes = 1
            while !eof(v)
                read(v)
                nframes += 1
            end
            @test nframes == 397
            @test !eof(a)
            @test vcat(block, reduce(vcat, collect(a))) == samples
            @test eof(a)
            # Seeking through the audio reader repositions the video reader too
            seek(a, 3)
            @test VideoIO.gettime(v) == 0.0
            read(v)
            @test VideoIO.gettime(v) ≈ 3 atol = 0.1
            @test VideoIO.gettime(a) == 0.0
            read(a)
            @test VideoIO.gettime(a) ≈ 3 atol = 1e-6
            # Seeking through the video reader repositions the audio reader, with the
            # audio decoder warmed up so the samples are accurate
            for t in (5.0, 1.0)
                seek(v, t)
                read(v)
                block = read(a, 4096)
                @test VideoIO.gettime(a) ≈ t atol = 1 / fs_ref
                i0 = sample_index(t, 0, fs_ref)
                @test maxabsdiff(block, samples[i0:(i0 + 4095), :]) <= 1e-4
            end
            close(avin)
        end

        @testset "extract_audio" begin
            mktempdir() do dir
                wav = joinpath(dir, "audio.wav")
                @test VideoIO.extract_audio(path, wav) == wav
                @test ffprobe_audio_entry(wav, "codec_name") == "pcm_s16le"
                wav_samples, wav_fs = VideoIO.loadaudio(wav)
                @test wav_fs == fs_ref
                @test size(wav_samples) == size(samples)
                @test maxabsdiff(wav_samples, samples) <= 2 / 32768

                # Resampling, downmixing and trimming
                trimmed = joinpath(dir, "trimmed.wav")
                VideoIO.extract_audio(path, trimmed; samplerate = 8000, nchannels = 1, start = 1, duration = 2)
                @test ffprobe_audio_entry(trimmed, "sample_rate") == "8000"
                @test ffprobe_audio_entry(trimmed, "channels") == "1"
                trimmed_samples, trimmed_fs = VideoIO.loadaudio(trimmed)
                @test trimmed_fs == 8000
                @test size(trimmed_samples) == (16000, 1)

                # Explicit codec
                flac = joinpath(dir, "audio.flac")
                VideoIO.extract_audio(path, flac; codec = "flac")
                @test ffprobe_audio_entry(flac, "codec_name") == "flac"
                @test size(VideoIO.loadaudio(flac; eltype = Int16)[1]) == size(samples)

                # Stream copy
                m4a = joinpath(dir, "audio.m4a")
                VideoIO.extract_audio(path, m4a; codec = "copy")
                @test ffprobe_audio_entry(m4a, "codec_name") == "aac"
                @test VideoIO.loadaudio(m4a) == (samples, fs_ref)

                @test_throws ArgumentError VideoIO.extract_audio(path, joinpath(dir, "noext"))
                @test_throws ArgumentError VideoIO.extract_audio(joinpath(dir, "missing.mp4"), wav)
                @test_throws ArgumentError VideoIO.extract_audio(path, wav; codec = "copy", samplerate = 8000)
                @test_throws ArgumentError VideoIO.extract_audio(path, wav; audio_stream = 0)
                @test_throws ProcessFailedException VideoIO.extract_audio(path, wav; audio_stream = 2)
            end
        end
    end

    @testset "Timestamp discontinuity" begin
        mktempdir() do dir
            src = synth_audio_file(dir, "sine.mkv", "flac")
            # Shift every packet from 1.5 s onwards by one second, leaving a
            # gap in the container timeline (Matroska timestamps are in ms)
            gapped = joinpath(dir, "gap.mkv")
            FFMPEG.exe(`-y -v error -i $src -c:a copy -bsf:a "setts=ts='TS+gte(TS\,1500)*1000'" $gapped`)
            samples, fs = VideoIO.loadaudio(src)
            gapped_samples, _ = VideoIO.loadaudio(gapped)
            @test gapped_samples == samples # no samples are invented for the gap
            r = VideoIO.openaudio(gapped)
            try
                t = 0.0
                while !eof(r)
                    read(r, 4800)
                    t = VideoIO.gettime(r)
                end
                @test t ≈ 2.9 + 1 atol = 1 / fs # last block starts at 2.9 s on the source timeline
                seek(r, 3.0) # 2.0 s of the source
                block = read(r, 4800)
                @test VideoIO.gettime(r) ≈ 3.0 atol = 1 / fs
                @test aligned_maxabsdiff(block, samples, sample_index(2.0, 0, fs), 24) == 0
                seek(r, 1.0)
                block = read(r, 4800)
                @test aligned_maxabsdiff(block, samples, sample_index(1.0, 0, fs), 24) == 0
            finally
                close(r)
            end
        end
    end

    @testset "Empty and missing audio streams" begin
        # black_hole.webm declares a Vorbis stream that contains no packets
        path = joinpath(videodir, "black_hole.webm")
        samples, fs = VideoIO.loadaudio(path)
        @test size(samples) == (0, 2)
        @test fs == 44100
        r = VideoIO.openaudio(path)
        @test eof(r)
        @test_throws EOFError read(r)
        close(r)

        @test_throws ErrorException VideoIO.openaudio(joinpath(videodir, "annie_oakley.ogg"))
        @test_throws ErrorException VideoIO.openaudio(joinpath(videodir, "ladybird.mp4"), 2)
    end
end
