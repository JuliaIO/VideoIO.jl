# Julia wrapper for header: /usr/include/libavutil/encryption_info.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_encryption_info_alloc,
    av_encryption_info_clone,
    av_encryption_info_free,
    av_encryption_info_get_side_data,
    av_encryption_info_add_side_data,
    av_encryption_init_info_alloc,
    av_encryption_init_info_free,
    av_encryption_init_info_get_side_data,
    av_encryption_init_info_add_side_data


function av_encryption_info_alloc(subsample_count::Integer, key_id_size::Integer, iv_size::Integer)
    ccall((:av_encryption_info_alloc, libavutil), Ptr{AVEncryptionInfo}, (UInt32, UInt32, UInt32), subsample_count, key_id_size, iv_size)
end

function av_encryption_info_clone(info)
    ccall((:av_encryption_info_clone, libavutil), Ptr{AVEncryptionInfo}, (Ptr{AVEncryptionInfo},), info)
end

function av_encryption_info_free(info)
    ccall((:av_encryption_info_free, libavutil), Cvoid, (Ptr{AVEncryptionInfo},), info)
end

function av_encryption_info_get_side_data(side_data, side_data_size::Csize_t)
    ccall((:av_encryption_info_get_side_data, libavutil), Ptr{AVEncryptionInfo}, (Ptr{UInt8}, Csize_t), side_data, side_data_size)
end

function av_encryption_info_add_side_data(info, side_data_size)
    ccall((:av_encryption_info_add_side_data, libavutil), Ptr{UInt8}, (Ptr{AVEncryptionInfo}, Ptr{Csize_t}), info, side_data_size)
end

function av_encryption_init_info_alloc(system_id_size::Integer, num_key_ids::Integer, key_id_size::Integer, data_size::Integer)
    ccall((:av_encryption_init_info_alloc, libavutil), Ptr{AVEncryptionInitInfo}, (UInt32, UInt32, UInt32, UInt32), system_id_size, num_key_ids, key_id_size, data_size)
end

function av_encryption_init_info_free(info)
    ccall((:av_encryption_init_info_free, libavutil), Cvoid, (Ptr{AVEncryptionInitInfo},), info)
end

function av_encryption_init_info_get_side_data(side_data, side_data_size::Csize_t)
    ccall((:av_encryption_init_info_get_side_data, libavutil), Ptr{AVEncryptionInitInfo}, (Ptr{UInt8}, Csize_t), side_data, side_data_size)
end

function av_encryption_init_info_add_side_data(info, side_data_size)
    ccall((:av_encryption_init_info_add_side_data, libavutil), Ptr{UInt8}, (Ptr{AVEncryptionInitInfo}, Ptr{Csize_t}), info, side_data_size)
end
