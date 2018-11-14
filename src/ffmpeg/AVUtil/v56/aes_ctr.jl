# Julia wrapper for header: /usr/include/libavutil/aes_ctr.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_aes_ctr_alloc,
    av_aes_ctr_init,
    av_aes_ctr_free,
    av_aes_ctr_crypt,
    av_aes_ctr_get_iv,
    av_aes_ctr_set_random_iv,
    av_aes_ctr_set_iv,
    av_aes_ctr_set_full_iv,
    av_aes_ctr_increment_iv


function av_aes_ctr_alloc()
    ccall((:av_aes_ctr_alloc, libavutil), Ptr{Cvoid}, ())
end

function av_aes_ctr_init(a, key)
    ccall((:av_aes_ctr_init, libavutil), Cint, (Ptr{Cvoid}, Ptr{UInt8}), a, key)
end

function av_aes_ctr_free(a)
    ccall((:av_aes_ctr_free, libavutil), Cvoid, (Ptr{Cvoid},), a)
end

function av_aes_ctr_crypt(a, dst, src, size::Integer)
    ccall((:av_aes_ctr_crypt, libavutil), Cvoid, (Ptr{Cvoid}, Ptr{UInt8}, Ptr{UInt8}, Cint), a, dst, src, size)
end

function av_aes_ctr_get_iv(a)
    ccall((:av_aes_ctr_get_iv, libavutil), Ptr{UInt8}, (Ptr{Cvoid},), a)
end

function av_aes_ctr_set_random_iv(a)
    ccall((:av_aes_ctr_set_random_iv, libavutil), Cvoid, (Ptr{Cvoid},), a)
end

function av_aes_ctr_set_iv(a, iv)
    ccall((:av_aes_ctr_set_iv, libavutil), Cvoid, (Ptr{Cvoid}, Ptr{UInt8}), a, iv)
end

function av_aes_ctr_set_full_iv(a, iv)
    ccall((:av_aes_ctr_set_full_iv, libavutil), Cvoid, (Ptr{Cvoid}, Ptr{UInt8}), a, iv)
end

function av_aes_ctr_increment_iv(a)
    ccall((:av_aes_ctr_increment_iv, libavutil), Cvoid, (Ptr{Cvoid},), a)
end
