# Julia wrapper for header: /usr/include/libavutil/imgutils.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_image_fill_max_pixsteps,
    av_image_get_linesize,
    av_image_fill_linesizes,
    av_image_fill_pointers,
    av_image_alloc,
    av_image_copy_plane,
    av_image_copy,
    av_image_copy_uc_from,
    av_image_fill_arrays,
    av_image_get_buffer_size,
    av_image_copy_to_buffer,
    av_image_check_size,
    av_image_check_size2,
    av_image_check_sar,
    av_image_fill_black


function av_image_fill_max_pixsteps(max_pixsteps::NTuple{4, Cint}, max_pixstep_comps::NTuple{4, Cint}, pixdesc)
    ccall((:av_image_fill_max_pixsteps, libavutil), Cvoid, (NTuple{4, Cint}, NTuple{4, Cint}, Ptr{AVPixFmtDescriptor}), max_pixsteps, max_pixstep_comps, pixdesc)
end

function av_image_get_linesize(pix_fmt::Cvoid, width::Integer, plane::Integer)
    ccall((:av_image_get_linesize, libavutil), Cint, (Cvoid, Cint, Cint), pix_fmt, width, plane)
end

function av_image_fill_linesizes(linesizes::NTuple{4, Cint}, pix_fmt::Cvoid, width::Integer)
    ccall((:av_image_fill_linesizes, libavutil), Cint, (NTuple{4, Cint}, Cvoid, Cint), linesizes, pix_fmt, width)
end

function av_image_fill_pointers(data::NTuple{4, Ptr{UInt8}}, pix_fmt::Cvoid, height::Integer, ptr, linesizes::NTuple{4, Cint})
    ccall((:av_image_fill_pointers, libavutil), Cint, (NTuple{4, Ptr{UInt8}}, Cvoid, Cint, Ptr{UInt8}, NTuple{4, Cint}), data, pix_fmt, height, ptr, linesizes)
end

function av_image_alloc(pointers::NTuple{4, Ptr{UInt8}}, linesizes::NTuple{4, Cint}, w::Integer, h::Integer, pix_fmt::Cvoid, align::Integer)
    ccall((:av_image_alloc, libavutil), Cint, (NTuple{4, Ptr{UInt8}}, NTuple{4, Cint}, Cint, Cint, Cvoid, Cint), pointers, linesizes, w, h, pix_fmt, align)
end

function av_image_copy_plane(dst, dst_linesize::Integer, src, src_linesize::Integer, bytewidth::Integer, height::Integer)
    ccall((:av_image_copy_plane, libavutil), Cvoid, (Ptr{UInt8}, Cint, Ptr{UInt8}, Cint, Cint, Cint), dst, dst_linesize, src, src_linesize, bytewidth, height)
end

function av_image_copy(dst_data::NTuple{4, Ptr{UInt8}}, dst_linesizes::NTuple{4, Cint}, src_data::NTuple{4, Ptr{UInt8}}, src_linesizes::NTuple{4, Cint}, pix_fmt::Cvoid, width::Integer, height::Integer)
    ccall((:av_image_copy, libavutil), Cvoid, (NTuple{4, Ptr{UInt8}}, NTuple{4, Cint}, NTuple{4, Ptr{UInt8}}, NTuple{4, Cint}, Cvoid, Cint, Cint), dst_data, dst_linesizes, src_data, src_linesizes, pix_fmt, width, height)
end

function av_image_copy_uc_from(dst_data::NTuple{4, Ptr{UInt8}}, dst_linesizes::NTuple{4, Cptrdiff_t}, src_data::NTuple{4, Ptr{UInt8}}, src_linesizes::NTuple{4, Cptrdiff_t}, pix_fmt::Cvoid, width::Integer, height::Integer)
    ccall((:av_image_copy_uc_from, libavutil), Cvoid, (NTuple{4, Ptr{UInt8}}, NTuple{4, Cptrdiff_t}, NTuple{4, Ptr{UInt8}}, NTuple{4, Cptrdiff_t}, Cvoid, Cint, Cint), dst_data, dst_linesizes, src_data, src_linesizes, pix_fmt, width, height)
end

function av_image_fill_arrays(dst_data::NTuple{4, Ptr{UInt8}}, dst_linesize::NTuple{4, Cint}, src, pix_fmt::Cvoid, width::Integer, height::Integer, align::Integer)
    ccall((:av_image_fill_arrays, libavutil), Cint, (NTuple{4, Ptr{UInt8}}, NTuple{4, Cint}, Ptr{UInt8}, Cvoid, Cint, Cint, Cint), dst_data, dst_linesize, src, pix_fmt, width, height, align)
end

function av_image_get_buffer_size(pix_fmt::Cvoid, width::Integer, height::Integer, align::Integer)
    ccall((:av_image_get_buffer_size, libavutil), Cint, (Cvoid, Cint, Cint, Cint), pix_fmt, width, height, align)
end

function av_image_copy_to_buffer(dst, dst_size::Integer, src_data::NTuple{4, Ptr{UInt8}}, src_linesize::NTuple{4, Cint}, pix_fmt::Cvoid, width::Integer, height::Integer, align::Integer)
    ccall((:av_image_copy_to_buffer, libavutil), Cint, (Ptr{UInt8}, Cint, NTuple{4, Ptr{UInt8}}, NTuple{4, Cint}, Cvoid, Cint, Cint, Cint), dst, dst_size, src_data, src_linesize, pix_fmt, width, height, align)
end

function av_image_check_size(w::Integer, h::Integer, log_offset::Integer, log_ctx)
    ccall((:av_image_check_size, libavutil), Cint, (UInt32, UInt32, Cint, Ptr{Cvoid}), w, h, log_offset, log_ctx)
end

function av_image_check_size2(w::Integer, h::Integer, max_pixels::Int64, pix_fmt::Cvoid, log_offset::Integer, log_ctx)
    ccall((:av_image_check_size2, libavutil), Cint, (UInt32, UInt32, Int64, Cvoid, Cint, Ptr{Cvoid}), w, h, max_pixels, pix_fmt, log_offset, log_ctx)
end

function av_image_check_sar(w::Integer, h::Integer, sar::AVRational)
    ccall((:av_image_check_sar, libavutil), Cint, (UInt32, UInt32, AVRational), w, h, sar)
end

function av_image_fill_black(dst_data::NTuple{4, Ptr{UInt8}}, dst_linesize::NTuple{4, Cptrdiff_t}, pix_fmt::Cvoid, range::Cvoid, width::Integer, height::Integer)
    ccall((:av_image_fill_black, libavutil), Cint, (NTuple{4, Ptr{UInt8}}, NTuple{4, Cptrdiff_t}, Cvoid, Cvoid, Cint, Cint), dst_data, dst_linesize, pix_fmt, range, width, height)
end
