# Julia wrapper for header: /usr/include/libavutil/des.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_des_alloc,
    av_des_init,
    av_des_crypt,
    av_des_mac


function av_des_alloc()
    ccall((:av_des_alloc, libavutil), Ptr{AVDES}, ())
end

function av_des_init(d, key, key_bits::Integer, decrypt::Integer)
    ccall((:av_des_init, libavutil), Cint, (Ptr{AVDES}, Ptr{UInt8}, Cint, Cint), d, key, key_bits, decrypt)
end

function av_des_crypt(d, dst, src, count::Integer, iv, decrypt::Integer)
    ccall((:av_des_crypt, libavutil), Cvoid, (Ptr{AVDES}, Ptr{UInt8}, Ptr{UInt8}, Cint, Ptr{UInt8}, Cint), d, dst, src, count, iv, decrypt)
end

function av_des_mac(d, dst, src, count::Integer)
    ccall((:av_des_mac, libavutil), Cvoid, (Ptr{AVDES}, Ptr{UInt8}, Ptr{UInt8}, Cint), d, dst, src, count)
end
