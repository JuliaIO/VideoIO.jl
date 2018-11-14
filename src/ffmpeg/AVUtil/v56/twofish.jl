# Julia wrapper for header: /usr/include/libavutil/twofish.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_twofish_alloc,
    av_twofish_init,
    av_twofish_crypt


function av_twofish_alloc()
    ccall((:av_twofish_alloc, libavutil), Ptr{Cvoid}, ())
end

function av_twofish_init(ctx, key, key_bits::Integer)
    ccall((:av_twofish_init, libavutil), Cint, (Ptr{Cvoid}, Ptr{UInt8}, Cint), ctx, key, key_bits)
end

function av_twofish_crypt(ctx, dst, src, count::Integer, iv, decrypt::Integer)
    ccall((:av_twofish_crypt, libavutil), Cvoid, (Ptr{Cvoid}, Ptr{UInt8}, Ptr{UInt8}, Cint, Ptr{UInt8}, Cint), ctx, dst, src, count, iv, decrypt)
end
