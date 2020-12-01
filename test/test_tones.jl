using ColorTypes: RGB, HSV
using FixedPointNumbers: Normed, N6f10
using Base: ReinterpretArray

function test_tone!(a::AbstractMatrix{X}, offset = 0) where {T, X<:Normed{T}}
    maxcodept = reinterpret(one(X))
    modsize = maxcodept + 1
    @inbounds for i in eachindex(a)
        a[i] = reinterpret(X, T(mod(i + offset - 1, modsize)))
    end
    a
end

function test_tone!(a::AbstractMatrix{C}, offset = 0
                    ) where {T, X<:Normed{T}, C<:RGB{X}}
    maxcodept = reinterpret(one(X))
    modsize = maxcodept + 1
    @inbounds for i in eachindex(a)
        h = mod(i, 360)
        v = mod(i + offset - 1, modsize) / maxcodept
        hsv = HSV(h, 1, v)
        a[i] = convert(RGB{X}, hsv)
    end
    a
end

test_tone(::Type{T}, nx::Integer, ny, args...) where T =
    test_tone!(Matrix{T}(undef, nx, ny), args...)

test_tone(nx::Integer, ny, args...) = test_tone(N6f10, nx, ny, args...)

function make_test_tones(::Type{T}, nx, ny, nf) where T
    imgs = Vector{Matrix{T}}(undef, nf)
    @inbounds for i in 1:nf
        imgs[i] = test_tone(T, nx, ny, i - 1)
    end
    imgs
end

sizeof_parent(buf::Array) = sizeof(buf)
sizeof_parent(buf::ReinterpretArray) = sizeof_parent(parent(buf))

function copy_imgbuf_to_buf!(buf::StridedArray{UInt8}, bwidth::Integer,
                             fheight::Integer, imgbufp::Ptr{UInt8},
                             linesize::Integer)
    sizeof_parent(buf) < bwidth * fheight && throw(ArgumentError("buf is not large enough"))
    for lineno in 1:fheight
        offno = lineno - 1
        bufp = pointer(buf, bwidth * offno + 1)
        imgp = imgbufp + linesize * offno
        GC.@preserve buf unsafe_copyto!(bufp, imgp, bwidth)
    end
end

function copy_imgbuf_to_buf!(buf::StridedArray{UInt8}, bwidth::Integer,
                             fheight::Integer, imgbuf::StridedArray{UInt8},
                             align::Integer)
    linesize = align * cld(bwidth, align)
    imgbufp = pointer(imgbuf)
    GC.@preserve imgbuf copy_imgbuf_to_buf!(buf, bwidth, fheight, imgbufp,
                                            linesize)
end

function copy_imgbuf_to_buf!(buf::StridedArray, fwidth::Integer,
                             fheight::Integer, nbytesperpixel::Integer, args...)
    bwidth = nbytesperpixel * fwidth
    copy_imgbuf_to_buf!(reinterpret(UInt8, buf), bwidth, fheight, args...)
end
