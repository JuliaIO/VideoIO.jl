# Audio stream decoding (openaudio / AudioReader / loadaudio) and file-to-file
# audio extraction via the ffmpeg executable.

export openaudio

# libswresample is not covered by the generated bindings in lib/libffmpeg.jl, so
# the handful of functions needed here are declared by hand.
mutable struct SwrContext end

const libswresample = FFMPEG.libswresample

swr_alloc() = ccall((:swr_alloc, libswresample), Ptr{SwrContext}, ())
swr_free(s) = ccall((:swr_free, libswresample), Cvoid, (Ptr{Ptr{SwrContext}},), s)
swr_init(s) = ccall((:swr_init, libswresample), Cint, (Ptr{SwrContext},), s)
function swr_alloc_set_opts2(
    ps, out_ch_layout, out_sample_fmt::AVSampleFormat, out_sample_rate::Integer,
    in_ch_layout, in_sample_fmt::AVSampleFormat, in_sample_rate::Integer, log_offset::Integer, log_ctx,
)
    return ccall(
        (:swr_alloc_set_opts2, libswresample), Cint,
        (Ptr{Ptr{SwrContext}}, Ptr{AVChannelLayout}, AVSampleFormat, Cint, Ptr{AVChannelLayout}, AVSampleFormat, Cint, Cint, Ptr{Cvoid}),
        ps, out_ch_layout, out_sample_fmt, out_sample_rate, in_ch_layout, in_sample_fmt, in_sample_rate, log_offset, log_ctx,
    )
end
swr_get_out_samples(s, in_samples::Integer) =
    ccall((:swr_get_out_samples, libswresample), Cint, (Ptr{SwrContext}, Cint), s, in_samples)
swr_get_delay(s, base::Integer) = ccall((:swr_get_delay, libswresample), Int64, (Ptr{SwrContext}, Int64), s, base)
swr_convert(s, out, out_count::Integer, in, in_count::Integer) = ccall(
    (:swr_convert, libswresample), Cint,
    (Ptr{SwrContext}, Ptr{Ptr{UInt8}}, Cint, Ptr{Ptr{UInt8}}, Cint),
    s, out, out_count, in, in_count,
)

@avptr SwrContextPtr SwrContext swr_alloc swr_free

# Samples are always converted to a planar format so that each channel maps
# directly onto a column of a Julia matrix.
sample_eltype_to_planar_fmt(::Type{UInt8}) = AV_SAMPLE_FMT_U8P
sample_eltype_to_planar_fmt(::Type{Int16}) = AV_SAMPLE_FMT_S16P
sample_eltype_to_planar_fmt(::Type{Int32}) = AV_SAMPLE_FMT_S32P
sample_eltype_to_planar_fmt(::Type{Float32}) = AV_SAMPLE_FMT_FLTP
sample_eltype_to_planar_fmt(::Type{Float64}) = AV_SAMPLE_FMT_DBLP
sample_eltype_to_planar_fmt(::Type{T}) where {T} = throw(ArgumentError(
    "Unsupported audio sample eltype $T. Supported: UInt8, Int16, Int32, Float32, Float64",
))

const ChannelLayoutRef = RefValue{AVChannelLayout}
new_channel_layout() = Ref(AVChannelLayout(ntuple(_ -> 0x00, 24)))

layout_ptr(layout::ChannelLayoutRef) = unsafe_convert(Ptr{AVChannelLayout}, layout)
layout_ptr(layout::Ptr{AVChannelLayout}) = layout
layout_nchannels(layout) = GC.@preserve layout Int(unsafe_load(layout_ptr(layout).nb_channels))
layout_order(layout) = GC.@preserve layout unsafe_load(layout_ptr(layout).order)

# Copy `src` into `dst`, replacing an unspecified channel order (as reported for
# e.g. plain WAV files) by FFmpeg's default layout for that channel count.
function set_channel_layout!(dst::ChannelLayoutRef, src)
    ret = av_channel_layout_copy(dst, src)
    ret < 0 && error("Could not copy channel layout: $(av_error_string(ret))")
    if layout_order(dst) == AV_CHANNEL_ORDER_UNSPEC
        nch = layout_nchannels(dst)
        av_channel_layout_uninit(dst)
        av_channel_layout_default(dst, nch)
    end
    return dst
end

function describe_layout(layout)
    buf = Vector{UInt8}(undef, 64)
    ret = GC.@preserve buf av_channel_layout_describe(layout, pointer(buf), Csize_t(length(buf)))
    ret < 0 && return "unknown"
    return GC.@preserve buf unsafe_string(pointer(buf))
end

"""
    AudioReader{T}

Decodes an audio stream of an `AVInput` into blocks of samples, returned as
`Matrix{T}` with one row per sample and one column per channel. Created by
[`openaudio`](@ref).
"""
mutable struct AudioReader{T,I} <: StreamContext
    avin::AVInput{I}
    stream_index0::Int
    codec_context::AVCodecContextPtr
    swr::SwrContextPtr
    in_ch_layout::ChannelLayoutRef   # resampler input configuration, tracks the decoded frames
    in_sample_fmt::Cint
    in_samplerate::Int
    out_ch_layout::ChannelLayoutRef
    out_sample_fmt::Cint
    samplerate::Int
    nchannels::Int
    decoded_frame::AVFramePtr
    chunk_queue::Vector{Matrix{T}}   # converted, not yet consumed sample blocks (FIFO)
    chunk_times::Vector{Float64}     # start time (s) of each queued block
    head_offset::Int                 # samples of chunk_queue[1] already consumed
    base_time::Float64               # time (s) of the first decoded frame since the last (re)start, NaN until known
    emitted::Int                     # output samples produced since the last (re)start
    flush::Bool
    finished::Bool
    last_time::Float64               # start time (s) of the last block returned to the user, NaN before the first read
end

function AudioReader(
    avin::AVInput{I},
    audio_stream::Integer = 1;
    samplerate::Union{Nothing,Integer} = nothing,
    nchannels::Union{Nothing,Integer} = nothing,
    eltype::Type{T} = Float32,
) where {I,T}
    out_sample_fmt = sample_eltype_to_planar_fmt(T)
    samplerate === nothing || samplerate > 0 || throw(ArgumentError("samplerate must be positive"))
    nchannels === nothing || nchannels > 0 || throw(ArgumentError("nchannels must be positive"))
    1 <= audio_stream <= length(avin.audio_indices) || error("audio stream $audio_stream not found")

    stream_index0 = avin.audio_indices[audio_stream]
    stream = get_stream(avin, stream_index0)
    codec = avcodec_find_decoder(stream.codecpar.codec_id)
    check_ptr_valid(codec, false) || error("Failed to find decoder")

    # Tell the demuxer to retain packets from this stream
    stream.discard = AVDISCARD_DEFAULT

    codec_context = AVCodecContextPtr(codec) # Allocates
    ret = avcodec_parameters_to_context(codec_context, stream.codecpar)
    ret < 0 && error("Could not copy the codec parameters to the decoder")
    # Lets the decoder keep frame timestamps consistent when it discards
    # encoder priming/padding samples.
    codec_context.pkt_timebase = stream.time_base

    ret = disable_sigint() do
        lock(VIO_LOCK) do
            return avcodec_open2(codec_context, codec, C_NULL)
        end
    end
    ret < 0 && error("Could not open codec")

    in_samplerate = Int(codec_context.sample_rate)
    in_sample_fmt = codec_context.sample_fmt
    in_samplerate > 0 || error("Unknown sample rate")
    in_sample_fmt != AV_SAMPLE_FMT_NONE || error("Unknown sample format")
    layout_nchannels(field_ptr(codec_context, :ch_layout)) > 0 || error("Unknown channel layout")
    in_ch_layout = set_channel_layout!(new_channel_layout(), field_ptr(codec_context, :ch_layout))

    out_samplerate = samplerate === nothing ? in_samplerate : Int(samplerate)
    out_ch_layout = new_channel_layout()
    if nchannels === nothing
        set_channel_layout!(out_ch_layout, in_ch_layout)
    else
        av_channel_layout_default(out_ch_layout, nchannels)
    end
    out_nchannels = layout_nchannels(out_ch_layout)

    r = AudioReader{T,I}(
        avin,
        stream_index0,
        codec_context,
        SwrContextPtr(), # Allocates
        in_ch_layout,
        in_sample_fmt,
        in_samplerate,
        out_ch_layout,
        out_sample_fmt,
        out_samplerate,
        out_nchannels,
        AVFramePtr(),
        Matrix{T}[],
        Float64[],
        0,
        NaN,
        0,
        false,
        false,
        NaN,
    )
    # Layouts with a custom channel order own heap memory
    finalizer(r) do r
        av_channel_layout_uninit(r.in_ch_layout)
        av_channel_layout_uninit(r.out_ch_layout)
    end
    configure_resampler!(r)

    push!(avin.listening, stream_index0)
    avin.stream_contexts[stream_index0] = r
    return r
end

AudioReader(s::Union{IO,AbstractString}, args...; kwargs...) = AudioReader(AVInput(s), args...; kwargs...)

function configure_resampler!(r::AudioReader)
    ret = swr_alloc_set_opts2(
        r.swr, r.out_ch_layout, r.out_sample_fmt, r.samplerate,
        r.in_ch_layout, r.in_sample_fmt, r.in_samplerate, 0, C_NULL,
    )
    ret < 0 && error("Could not configure the audio resampler: $(av_error_string(ret))")
    ret = swr_init(r.swr)
    ret < 0 && error("Could not initialize the audio resampler: $(av_error_string(ret))")
    return r
end

# Decoded frame parameters can differ from the stream header, or change
# mid-stream; the resampler input must then follow.
function input_changed(r::AudioReader, frame)
    frame.sample_rate != r.in_samplerate && return true
    frame.format != r.in_sample_fmt && return true
    frame_layout = field_ptr(frame, :ch_layout)
    layout_nchannels(frame_layout) != layout_nchannels(r.in_ch_layout) && return true
    layout_order(frame_layout) == AV_CHANNEL_ORDER_UNSPEC && return false
    return av_channel_layout_compare(r.in_ch_layout, frame_layout) != 0
end

function reconfigure_resampler!(r::AudioReader, frame)
    r.in_samplerate = frame.sample_rate
    r.in_sample_fmt = frame.format
    set_channel_layout!(r.in_ch_layout, field_ptr(frame, :ch_layout))
    return configure_resampler!(r)
end

get_stream(r::AudioReader) = get_stream(r.avin, r.stream_index0)

"""
    samplerate(reader::AudioReader) -> Int

Sample rate (Hz) of the samples returned by `reader`. This is the stream's
native rate unless `openaudio` was called with `samplerate`.
"""
samplerate(r::AudioReader) = r.samplerate

"""
    nchannels(reader::AudioReader) -> Int

Number of channels (columns) of the sample blocks returned by `reader`. This is
the stream's native channel count unless `openaudio` was called with `nchannels`.
"""
nchannels(r::AudioReader) = r.nchannels

"""
    sample_eltype(reader::AudioReader) -> T

Element type of the sample blocks returned by `reader`.
"""
sample_eltype(::AudioReader{T}) where {T} = T

function show(io::IO, r::AudioReader{T}) where {T}
    cc = r.codec_context
    codec_name = unsafe_string(avcodec_get_name(cc.codec_id))
    fmt_name = unsafe_string(av_get_sample_fmt_name(cc.sample_fmt))
    print(io, "AudioReader(", codec_name, " ", cc.sample_rate, " Hz ", describe_layout(field_ptr(cc, :ch_layout)), " ", fmt_name,
        " -> ", r.samplerate, " Hz ", describe_layout(r.out_ch_layout), " ", T, ")")
end

Base.eltype(::Type{<:AudioReader{T}}) where {T} = Matrix{T}
IteratorSize(::Type{<:AudioReader}) = Base.SizeUnknown()
IteratorEltype(::Type{<:AudioReader}) = Base.HasEltype()

function iterate(r::AudioReader, state = 0)
    eof(r) && return
    return read(r), state + 1
end

is_finished(r::AudioReader) = r.finished
frame_is_queued(r::AudioReader) = !isempty(r.chunk_queue)

isopen(r::AudioReader) = isopen(r.avin)
close(r::AudioReader) = close(r.avin)
eof(r::AudioReader) = eof_stream(r)

# Time (s) of the first sample of a decoded frame, NaN if it has no timestamp
function frame_time(r::AudioReader, frame)
    pts = frame.pts
    pts == AV_NOPTS_VALUE && (pts = frame.best_effort_timestamp)
    pts == AV_NOPTS_VALUE && return NaN
    return Float64(pts * convert(Rational, get_stream(r).time_base))
end

# Output sample times are normally derived by counting: base_time plus the
# number of samples emitted. Compare each frame's own timestamp against that
# prediction and re-anchor on a discontinuity (a gap or cut in the container),
# so that `gettime` and `seek` follow the container timeline. Timestamp jitter
# below a frame's duration (e.g. Matroska's 1 ms resolution) is ignored.
function track_timeline!(r::AudioReader, in_frame, in_count)
    t_frame = frame_time(r, in_frame)
    if isnan(r.base_time)
        r.base_time = isnan(t_frame) ? 0.0 : t_frame
        return
    end
    isnan(t_frame) && return
    # Samples still buffered in the resampler precede this frame
    pending = Int(swr_get_delay(r.swr, r.samplerate))
    position = (r.emitted + pending) / r.samplerate
    if abs(t_frame - (r.base_time + position)) > max(in_count / r.in_samplerate, 0.002)
        r.base_time = t_frame - position
    end
    return
end

# Convert a decoded frame (or drain the resampler if `in_frame` is C_NULL) and
# append the result to the queue.
function enqueue_converted!(r::AudioReader{T}, in_frame) where {T}
    if in_frame === C_NULL
        in_planes = Ptr{Ptr{UInt8}}(C_NULL)
        in_count = 0
    else
        input_changed(r, in_frame) && reconfigure_resampler!(r, in_frame)
        in_planes = unsafe_load(field_ptr(in_frame, :extended_data))
        in_count = Int(in_frame.nb_samples)
        track_timeline!(r, in_frame, in_count)
    end
    out_max = Int(swr_get_out_samples(r.swr, in_count))
    out_max < 0 && error("swr_get_out_samples: $(av_error_string(out_max))")
    out_max == 0 && return
    chunk = Matrix{T}(undef, out_max, r.nchannels)
    out_planes = [Ptr{UInt8}(pointer(chunk, (c - 1) * out_max + 1)) for c in 1:r.nchannels]
    n = GC.@preserve chunk out_planes Int(swr_convert(r.swr, pointer(out_planes), out_max, in_planes, in_count))
    n < 0 && error("swr_convert: $(av_error_string(n))")
    n == 0 && return
    n < out_max && (chunk = chunk[1:n, :])
    push!(r.chunk_queue, chunk)
    push!(r.chunk_times, r.base_time + r.emitted / r.samplerate)
    r.emitted += n
    return
end

function decode(r::AudioReader, packet)
    r.finished && return
    pret = 0
    if !r.flush
        pret = avcodec_send_packet(r.codec_context, packet)
        pret < 0 && pret != -Libc.EAGAIN && error("avcodec_send_packet: $(av_error_string(pret))")
    end
    fret = avcodec_receive_frame(r.codec_context, r.decoded_frame)
    if fret == 0
        enqueue_converted!(r, r.decoded_frame)
        av_frame_unref(r.decoded_frame)
    elseif fret == VIO_AVERROR_EOF
        enqueue_converted!(r, C_NULL) # drain the resampler
        r.finished = true
    elseif fret != -Libc.EAGAIN
        error("avcodec_receive_frame: $(av_error_string(fret))")
    end
    if !r.finished && !r.flush && pret == -Libc.EAGAIN
        pret = avcodec_send_packet(r.codec_context, packet)
        pret < 0 && pret != -Libc.EAGAIN && error("avcodec_send_packet (retry): $(av_error_string(pret))")
    end
    return
end

# Ensure at least one unconsumed sample block is queued. Returns false at EOF.
function fill_queue!(r::AudioReader)
    while isempty(r.chunk_queue)
        pump_until_frame(r, false) || return false
    end
    return true
end

function pop_chunk!(r::AudioReader)
    popfirst!(r.chunk_times)
    r.head_offset = 0
    return popfirst!(r.chunk_queue)
end

"""
    read(reader::AudioReader{T}) -> Matrix{T}

Return the next block of decoded samples as an `nsamples × nchannels` matrix,
advancing the audio stream. Block sizes are determined by the codec (typically
a few hundred to a few thousand samples) and may vary; use `read(reader, n)` or
`read!` for blocks of a fixed size. Throws `EOFError` at the end of the stream.
"""
function read(r::AudioReader{T}) where {T}
    fill_queue!(r) || throw(EOFError())
    k = r.head_offset
    r.last_time = r.chunk_times[1] + k / r.samplerate
    chunk = pop_chunk!(r)
    return k == 0 ? chunk : chunk[(k + 1):end, :]
end

"""
    read(reader::AudioReader{T}, n::Integer) -> Matrix{T}

Return the next `n` samples as an `n × nchannels` matrix, advancing the audio
stream. Fewer than `n` rows are returned if the end of the stream is reached.
"""
function read(r::AudioReader{T}, n::Integer) where {T}
    n >= 0 || throw(ArgumentError("n must be non-negative"))
    buf = Matrix{T}(undef, n, r.nchannels)
    got = readsamples!(r, buf, n)
    return got == n ? buf : buf[1:got, :]
end

"""
    read!(reader::AudioReader{T}, buf::AbstractVecOrMat{T}) -> buf

Fill `buf` with the next `size(buf, 1)` samples, advancing the audio stream.
`buf` must have `nchannels(reader)` columns (a vector is accepted for mono
output). Throws `EOFError` if the stream ends before `buf` is full; samples
read up to that point are left in `buf`.
"""
function read!(r::AudioReader{T}, buf::AbstractVecOrMat{T}) where {T}
    size(buf, 2) == r.nchannels ||
        throw(ArgumentError("Buffer must have $(r.nchannels) column(s), got $(size(buf, 2))"))
    n = size(buf, 1)
    got = readsamples!(r, buf, n)
    got < n && throw(EOFError())
    return buf
end

# Copy up to `n` samples into the first rows of `buf`, returning the count.
function readsamples!(r::AudioReader, buf, n)
    filled = 0
    while filled < n
        fill_queue!(r) || break
        chunk = r.chunk_queue[1]
        k = r.head_offset
        avail = size(chunk, 1) - k
        m = min(avail, n - filled)
        filled == 0 && (r.last_time = r.chunk_times[1] + k / r.samplerate)
        @views buf[(filled + 1):(filled + m), :] .= chunk[(k + 1):(k + m), :]
        filled += m
        if m == avail
            pop_chunk!(r)
        else
            r.head_offset = k + m
        end
    end
    return filled
end

"""
    gettime(reader::AudioReader) -> Float64

Presentation time, in seconds, of the first sample of the block most recently
returned by `read` or `read!`, on the container's own timeline (streams need
not start at exactly `0.0`). Returns `0.0` before anything has been read.
"""
gettime(r::AudioReader) = isnan(r.last_time) ? 0.0 : r.last_time

# To be called for all stream contexts following a seek of AVInput
function reset_file_position_information!(r::AudioReader)
    avcodec_flush_buffers(r.codec_context)
    empty!(r.chunk_queue)
    empty!(r.chunk_times)
    r.head_offset = 0
    r.base_time = NaN
    r.emitted = 0
    r.flush = false
    r.last_time = NaN
    # Discard samples buffered inside the resampler
    ret = swr_init(r.swr)
    ret < 0 && error("Could not reset the audio resampler: $(av_error_string(ret))")
    return r.finished = false
end

# Drop decoded samples that precede `seconds`, to sample precision
function seek_trim(r::AudioReader, seconds::Number)
    while fill_queue!(r)
        t0 = r.chunk_times[1]
        n = size(r.chunk_queue[1], 1)
        k = round(Int, (seconds - t0) * r.samplerate)
        if k >= n
            pop_chunk!(r)
        else
            r.head_offset = max(k, 0)
            break
        end
    end
    return r
end

# Audio decoders with inter-frame state (AAC overlap-add, the MP3 bit
# reservoir, Opus, ...) need to decode some packets before their output is
# accurate, so seeks land this much before the requested time and the excess
# is trimmed by `seek_trim`.
seek_preroll(::AudioReader) = 0.1

"""
    seek(reader::AudioReader, seconds)

Seek the parent `AVInput` so that the next sample returned by `reader` is the
first at or after `seconds`. Other readers sharing the same `AVInput` are
repositioned as well.

Positioning is accurate to the sample, on the container's own timeline: like
FFmpeg, VideoIO reports the stream's timestamps as stored, so a stream need not
start at exactly `0.0` (e.g. MP3 files typically start at the encoder delay of
0.023 s). Use [`gettime`](@ref) to obtain the time of the samples actually
returned.
"""
function seek(r::AudioReader, seconds::Number)
    !isopen(r) && throw(ErrorException("Audio input stream is not open!"))
    _seek_stream!(r.avin, seconds, r.stream_index0)
    return r
end

"""
    seekstart(reader::AudioReader)

Seek to the start of the audio stream.
"""
seekstart(r::AudioReader) = seek(r, 0)

"""
    openaudio(file[, audio_stream = 1]; samplerate = nothing, nchannels = nothing, eltype = Float32) -> reader
    openaudio(f, ...)

Open `file` and create an [`AudioReader`](@ref) that decodes audio stream number
`audio_stream`. `file` can be the name of a file as an `AbstractString`, an
`IO` object, or an `AVInput` created by `VideoIO.open` (which allows a video
and an audio stream of the same file to be read side by side).

Samples are returned as `Matrix{eltype}` blocks with one row per sample and one
column per channel, via `read(reader)` (one codec-sized block), `read(reader, n)`
(`n` samples), `read!(reader, buf)`, or by iterating over `reader`. Other
supported operations are `seek`, `seekstart`, `eof`, `close`, and `gettime`.
Stream properties are available via `VideoIO.samplerate`, `VideoIO.nchannels`,
and `VideoIO.sample_eltype`.

If called with a single argument function as the first argument, the `reader`
will be passed to the function, and will be closed once the call returns whether
or not an error occurred.

# Keyword arguments

  - `samplerate::Union{Nothing,Integer} = nothing`: Resample to this rate (Hz).
    `nothing` keeps the stream's native rate.
  - `nchannels::Union{Nothing,Integer} = nothing`: Remix to this many channels
    using FFmpeg's default channel layout for that count (e.g. `1` downmixes to
    mono). `nothing` keeps the stream's native channels.
  - `eltype::Type = Float32`: Element type of the returned samples. Floating
    point types (`Float32`, `Float64`) are scaled to `[-1, 1]`; integer types
    (`UInt8`, `Int16`, `Int32`) span their full range.

# Example

```julia
openaudio("video.mp4", samplerate = 16000, nchannels = 1) do audio
    while !eof(audio)
        block = read(audio, 1024)  # 1024 × 1 Matrix{Float32}
        process(block)
    end
end
```
"""
openaudio(s::Union{IO,AbstractString,AVInput}, args...; kwargs...) = AudioReader(s, args...; kwargs...)

function openaudio(f, args...; kwargs...)
    r = openaudio(args...; kwargs...)
    try
        f(r)
    finally
        close(r)
    end
end

"""
    loadaudio(file[, audio_stream = 1]; start = nothing, duration = nothing, kwargs...) -> (samples, samplerate)

Decode audio stream `audio_stream` of `file` into memory, returning an
`nsamples × nchannels` matrix and the sample rate in Hz. `start` and `duration`
(seconds) select a portion of the stream. All other keyword arguments
(`samplerate`, `nchannels`, `eltype`) are passed to [`openaudio`](@ref).

# Example

```julia
samples, fs = VideoIO.loadaudio("video.mp4")
mono, fs = VideoIO.loadaudio("video.mp4", samplerate = 16000, nchannels = 1, start = 10, duration = 5)
```
"""
function loadaudio(
    source, args...;
    start::Union{Nothing,Real} = nothing, duration::Union{Nothing,Real} = nothing, kwargs...,
)
    openaudio(source, args...; kwargs...) do r
        start === nothing || seek(r, start)
        if duration === nothing
            chunks = collect(r)
            samples = isempty(chunks) ? Matrix{sample_eltype(r)}(undef, 0, r.nchannels) : reduce(vcat, chunks)
        else
            duration >= 0 || throw(ArgumentError("duration must be non-negative"))
            samples = read(r, round(Int, duration * r.samplerate))
        end
        return samples, r.samplerate
    end
end

"""
    extract_audio(input, output; audio_stream = 1, codec = nothing, samplerate = nothing,
                  nchannels = nothing, bitrate = nothing, start = nothing, duration = nothing)

Write audio stream `audio_stream` of `input` to the file `output` using the
`ffmpeg` executable. The container format is chosen from the extension of
`output` (e.g. `.wav`, `.flac`, `.mp3`, `.m4a`, `.ogg`), and `output` is
overwritten if it exists. Returns `output`.

# Keyword arguments

  - `codec = nothing`: Audio encoder name (e.g. `"libmp3lame"`, `"aac"`,
    `"pcm_s16le"`), or `"copy"` to copy the compressed stream without
    re-encoding (the output container must support the stream's codec, e.g.
    AAC from `.mp4` into `.m4a`). `nothing` uses the default encoder of the
    output container.
  - `samplerate`, `nchannels`: Resample / remix the audio before encoding.
  - `bitrate`: Target bitrate for lossy encoders, in bits per second or as an
    FFmpeg string such as `"192k"`.
  - `start`, `duration`: Extract only the given portion, in seconds.

`samplerate`, `nchannels` and `bitrate` cannot be combined with `codec = "copy"`.

# Example

```julia
VideoIO.extract_audio("video.mp4", "audio.wav")
VideoIO.extract_audio("video.mp4", "audio.m4a", codec = "copy")
VideoIO.extract_audio("video.mp4", "speech.wav", samplerate = 16000, nchannels = 1, start = 60, duration = 30)
```
"""
function extract_audio(
    input::AbstractString,
    output::AbstractString;
    audio_stream::Integer = 1,
    codec::Union{Nothing,AbstractString} = nothing,
    samplerate::Union{Nothing,Integer} = nothing,
    nchannels::Union{Nothing,Integer} = nothing,
    bitrate::Union{Nothing,Integer,AbstractString} = nothing,
    start::Union{Nothing,Real} = nothing,
    duration::Union{Nothing,Real} = nothing,
)
    isfile(input) || throw(ArgumentError("Input file \"$input\" not found"))
    isempty(splitext(output)[2]) && throw(ArgumentError(
        "Output filename \"$output\" has no file extension. " *
        "A file extension (e.g. .wav, .mp3, .m4a) is required to determine the container format.",
    ))
    audio_stream >= 1 || throw(ArgumentError("audio_stream must be positive"))
    if codec == "copy" && (samplerate !== nothing || nchannels !== nothing || bitrate !== nothing)
        throw(ArgumentError("`codec = \"copy\"` cannot be combined with `samplerate`, `nchannels` or `bitrate`"))
    end
    args = ["-y", "-v", "error", "-i", input, "-map", "0:a:$(audio_stream - 1)", "-vn", "-sn", "-dn"]
    start === nothing || push!(args, "-ss", string(start))
    duration === nothing || push!(args, "-t", string(duration))
    codec === nothing || push!(args, "-c:a", codec)
    samplerate === nothing || push!(args, "-ar", string(samplerate))
    nchannels === nothing || push!(args, "-ac", string(nchannels))
    bitrate === nothing || push!(args, "-b:a", string(bitrate))
    push!(args, output)
    FFMPEG.exe(Cmd(args))
    return output
end
