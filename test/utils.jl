
swapext(f, new_ext) = "$(splitext(f)[1])$new_ext"

isarm() = Base.Sys.ARCH in (:arm, :arm32, :arm7l, :armv7l, :arm8l, :armv8l, :aarch64, :arm64)

@noinline function isblank(img)
    return all(c -> green(c) == 0, img) ||
           all(c -> blue(c) == 0, img) ||
           all(c -> red(c) == 0, img) ||
           maximum(rawview(channelview(img))) < 0xcf
end

function compare_colors(a::RGB, b::RGB, tol)
    ok = true
    for f in (red, green, blue)
        dev = abs(float(f(a)) - float(f(b)))
        ok &= dev <= tol
    end
    return ok
end

# Helper functions
function test_compare_frames(test_frame, ref_frame, tol = 0.05)
    frames_similar = true
    for (a, b) in zip(test_frame, ref_frame)
        frames_similar &= compare_colors(a, b, tol)
    end
    @test frames_similar
end

# uses read!
function read_frameno!(img, v, frameno)
    seekstart(v)
    i = 0
    while !eof(v) && i < frameno
        read!(v, img)
        i += 1
    end
end

function make_comparison_frame_png(vidpath::AbstractString, frameno::Integer, writedir = tempdir())
    vid_basename = first(splitext(basename(vidpath)))
    png_name = joinpath(writedir, "$(vid_basename)_$(frameno).png")
    FFMPEG.exe(
        `-y -v error -i $(vidpath) -vf "sws_flags=accurate_rnd+full_chroma_inp+full_chroma_int; select=eq(n\,$(frameno-1))" -vframes 1 $(png_name)`,
    )
    return png_name
end

function make_comparison_frame_png(f, args...)
    png_name = make_comparison_frame_png(args...)
    try
        f(png_name)
    finally
        rm(png_name, force = true)
    end
end

function get_video_extrema(v)
    img = read(v)
    raw_img = parent(img)
    # Test that the limited range of this video is converted to full range
    minp, maxp = extrema(raw_img)
    while !eof(v)
        read!(v, raw_img)
        this_minp, this_maxp = extrema(raw_img)
        minp = min(minp, this_minp)
        maxp = max(maxp, this_maxp)
    end
    return minp, maxp
end

function get_raw_luma_extrema(elt, vidpath, nw, nh)
    buff, align = VideoIO.openvideo(vidpath) do v
        return VideoIO.read_raw(v, 1)
    end
    luma_buff = view(buff, 1:nw*nh*sizeof(elt))
    luma_vals = reinterpret(elt, luma_buff)
    return reinterpret.(extrema(luma_vals))
end

using ColorTypes: RGB, HSV
using FixedPointNumbers: Normed, N6f10
using Base: ReinterpretArray

function test_tone!(a::AbstractMatrix{X}, offset = 0, minval = 0, maxval = reinterpret(one(X))) where {T,X<:Normed{T}}
    maxcodept = reinterpret(one(X))
    modsize = maxval - minval + 1
    @inbounds for i in eachindex(a)
        a[i] = reinterpret(X, T(minval + mod(i + offset - 1, modsize)))
    end
    return a
end

function test_tone!(
    a::AbstractMatrix{C},
    offset = 0,
    minval = 0,
    maxval = reinterpet(one(X)),
) where {T,X<:Normed{T},C<:RGB{X}}
    modsize = maxval - minval + 1
    @inbounds for i in eachindex(a)
        h = mod(i, 360)
        v = minval + mod(i + offset - 1, modsize) / maxcodept
        hsv = HSV(h, 1, v)
        a[i] = convert(RGB{X}, hsv)
    end
    return a
end

test_tone(::Type{T}, nx::Integer, ny, args...) where {T} = test_tone!(Matrix{T}(undef, nx, ny), args...)

test_tone(nx::Integer, ny, args...) = test_tone(N6f10, nx, ny, args...)

function make_test_tones(::Type{T}, nx, ny, nf, args...) where {T}
    imgs = Vector{Matrix{T}}(undef, nf)
    @inbounds for i in 1:nf
        imgs[i] = test_tone(T, nx, ny, i - 1, args...)
    end
    return imgs
end

sizeof_parent(buf::Array) = sizeof(buf)
sizeof_parent(buf::ReinterpretArray) = sizeof_parent(parent(buf))

function copy_imgbuf_to_buf!(
    buf::StridedArray{UInt8},
    bwidth::Integer,
    fheight::Integer,
    imgbufp::Ptr{UInt8},
    linesize::Integer,
)
    sizeof_parent(buf) < bwidth * fheight && throw(ArgumentError("buf is not large enough"))
    for lineno in 1:fheight
        offno = lineno - 1
        bufp = pointer(buf, bwidth * offno + 1)
        imgp = imgbufp + linesize * offno
        GC.@preserve buf unsafe_copyto!(bufp, imgp, bwidth)
    end
end

function copy_imgbuf_to_buf!(
    buf::StridedArray{UInt8},
    bwidth::Integer,
    fheight::Integer,
    imgbuf::StridedArray{UInt8},
    align::Integer,
)
    linesize = align * cld(bwidth, align)
    imgbufp = pointer(imgbuf)
    GC.@preserve imgbuf copy_imgbuf_to_buf!(buf, bwidth, fheight, imgbufp, linesize)
end

function copy_imgbuf_to_buf!(buf::StridedArray, fwidth::Integer, fheight::Integer, nbytesperpixel::Integer, args...)
    bwidth = nbytesperpixel * fwidth
    return copy_imgbuf_to_buf!(reinterpret(UInt8, buf), bwidth, fheight, args...)
end

macro memory_profile()
    if memory_profiling
        _line = __source__.line
        _file = string(__source__.file)
        _mod = __module__
        quote
            local snap_fpath = Profile.take_heap_snapshot()
            local free_mem = Base.format_bytes(Sys.free_memory())
            local total_mem = Base.format_bytes(Sys.total_memory())
            @warn "Memory profile @ $(time() - start_time)s" free_mem total_mem snap_fpath _module=$_mod _line=$_line _file=$(repr(_file))
        end
    end
end
