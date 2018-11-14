# Julia wrapper for header: /usr/include/libavutil/xtea.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_xtea_alloc,
    av_xtea_init,
    av_xtea_le_init,
    av_xtea_crypt,
    av_xtea_le_crypt


function av_xtea_alloc()
    ccall((:av_xtea_alloc, libavutil), Ptr{AVXTEA}, ())
end

function av_xtea_init(ctx, key::NTuple{16, UInt8})
    ccall((:av_xtea_init, libavutil), Cvoid, (Ptr{Cvoid}, NTuple{16, UInt8}), ctx, key)
end

function av_xtea_le_init(ctx, key::NTuple{16, UInt8})
    ccall((:av_xtea_le_init, libavutil), Cvoid, (Ptr{Cvoid}, NTuple{16, UInt8}), ctx, key)
end

function av_xtea_crypt(ctx, dst, src, count::Integer, iv, decrypt::Integer)
    ccall((:av_xtea_crypt, libavutil), Cvoid, (Ptr{Cvoid}, Ptr{UInt8}, Ptr{UInt8}, Cint, Ptr{UInt8}, Cint), ctx, dst, src, count, iv, decrypt)
end

function av_xtea_le_crypt(ctx, dst, src, count::Integer, iv, decrypt::Integer)
    ccall((:av_xtea_le_crypt, libavutil), Cvoid, (Ptr{Cvoid}, Ptr{UInt8}, Ptr{UInt8}, Cint, Ptr{UInt8}, Cint), ctx, dst, src, count, iv, decrypt)
end
