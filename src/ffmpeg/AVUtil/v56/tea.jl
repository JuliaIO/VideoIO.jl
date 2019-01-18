# Julia wrapper for header: /usr/include/libavutil/tea.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_tea_alloc,
    av_tea_init,
    av_tea_crypt


function av_tea_alloc()
    ccall((:av_tea_alloc, libavutil), Ptr{AVTEA}, ())
end

function av_tea_init(ctx, key::NTuple{16, UInt8}, rounds::Integer)
    ccall((:av_tea_init, libavutil), Cvoid, (Ptr{AVTEA}, NTuple{16, UInt8}, Cint), ctx, key, rounds)
end

function av_tea_crypt(ctx, dst, src, count::Integer, iv, decrypt::Integer)
    ccall((:av_tea_crypt, libavutil), Cvoid, (Ptr{AVTEA}, Ptr{UInt8}, Ptr{UInt8}, Cint, Ptr{UInt8}, Cint), ctx, dst, src, count, iv, decrypt)
end
