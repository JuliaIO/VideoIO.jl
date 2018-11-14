# Julia wrapper for header: /usr/include/libavutil/pixdesc.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_get_bits_per_pixel,
    av_get_padded_bits_per_pixel,
    av_pix_fmt_desc_get,
    av_pix_fmt_desc_next,
    av_pix_fmt_desc_get_id,
    av_pix_fmt_get_chroma_sub_sample,
    av_pix_fmt_count_planes,
    av_color_range_name,
    av_color_range_from_name,
    av_color_primaries_name,
    av_color_primaries_from_name,
    av_color_transfer_name,
    av_color_transfer_from_name,
    av_color_space_name,
    av_color_space_from_name,
    av_chroma_location_name,
    av_chroma_location_from_name,
    av_get_pix_fmt,
    av_get_pix_fmt_name,
    av_get_pix_fmt_string,
    av_read_image_line2,
    av_read_image_line,
    av_write_image_line2,
    av_write_image_line,
    av_pix_fmt_swap_endianness,
    av_get_pix_fmt_loss,
    av_find_best_pix_fmt_of_2


function av_get_bits_per_pixel(pixdesc)
    ccall((:av_get_bits_per_pixel, libavutil), Cint, (Ptr{AVPixFmtDescriptor},), pixdesc)
end

function av_get_padded_bits_per_pixel(pixdesc)
    ccall((:av_get_padded_bits_per_pixel, libavutil), Cint, (Ptr{AVPixFmtDescriptor},), pixdesc)
end

function av_pix_fmt_desc_get(pix_fmt::Cvoid)
    ccall((:av_pix_fmt_desc_get, libavutil), Ptr{AVPixFmtDescriptor}, (Cvoid,), pix_fmt)
end

function av_pix_fmt_desc_next(prev)
    ccall((:av_pix_fmt_desc_next, libavutil), Ptr{AVPixFmtDescriptor}, (Ptr{AVPixFmtDescriptor},), prev)
end

function av_pix_fmt_desc_get_id(desc)
    ccall((:av_pix_fmt_desc_get_id, libavutil), Cvoid, (Ptr{AVPixFmtDescriptor},), desc)
end

function av_pix_fmt_get_chroma_sub_sample(pix_fmt::Cvoid, h_shift, v_shift)
    ccall((:av_pix_fmt_get_chroma_sub_sample, libavutil), Cint, (Cvoid, Ptr{Cint}, Ptr{Cint}), pix_fmt, h_shift, v_shift)
end

function av_pix_fmt_count_planes(pix_fmt::Cvoid)
    ccall((:av_pix_fmt_count_planes, libavutil), Cint, (Cvoid,), pix_fmt)
end

function av_color_range_name(range::Cvoid)
    ccall((:av_color_range_name, libavutil), Cstring, (Cvoid,), range)
end

function av_color_range_from_name(name)
    ccall((:av_color_range_from_name, libavutil), Cint, (Cstring,), name)
end

function av_color_primaries_name(primaries::Cvoid)
    ccall((:av_color_primaries_name, libavutil), Cstring, (Cvoid,), primaries)
end

function av_color_primaries_from_name(name)
    ccall((:av_color_primaries_from_name, libavutil), Cint, (Cstring,), name)
end

function av_color_transfer_name(transfer::Cvoid)
    ccall((:av_color_transfer_name, libavutil), Cstring, (Cvoid,), transfer)
end

function av_color_transfer_from_name(name)
    ccall((:av_color_transfer_from_name, libavutil), Cint, (Cstring,), name)
end

function av_color_space_name(space::Cvoid)
    ccall((:av_color_space_name, libavutil), Cstring, (Cvoid,), space)
end

function av_color_space_from_name(name)
    ccall((:av_color_space_from_name, libavutil), Cint, (Cstring,), name)
end

function av_chroma_location_name(location::Cvoid)
    ccall((:av_chroma_location_name, libavutil), Cstring, (Cvoid,), location)
end

function av_chroma_location_from_name(name)
    ccall((:av_chroma_location_from_name, libavutil), Cint, (Cstring,), name)
end

function av_get_pix_fmt(name)
    ccall((:av_get_pix_fmt, libavutil), Cvoid, (Cstring,), name)
end

function av_get_pix_fmt_name(pix_fmt::Cvoid)
    ccall((:av_get_pix_fmt_name, libavutil), Cstring, (Cvoid,), pix_fmt)
end

function av_get_pix_fmt_string(buf, buf_size::Integer, pix_fmt::Cvoid)
    ccall((:av_get_pix_fmt_string, libavutil), Cstring, (Cstring, Cint, Cvoid), buf, buf_size, pix_fmt)
end

function av_read_image_line2(dst, data::NTuple{4, Ptr{UInt8}}, linesize::NTuple{4, Cint}, desc, x::Integer, y::Integer, c::Integer, w::Integer, read_pal_component::Integer, dst_element_size::Integer)
    ccall((:av_read_image_line2, libavutil), Cvoid, (Ptr{Cvoid}, NTuple{4, Ptr{UInt8}}, NTuple{4, Cint}, Ptr{AVPixFmtDescriptor}, Cint, Cint, Cint, Cint, Cint, Cint), dst, data, linesize, desc, x, y, c, w, read_pal_component, dst_element_size)
end

function av_read_image_line(dst, data::NTuple{4, Ptr{UInt8}}, linesize::NTuple{4, Cint}, desc, x::Integer, y::Integer, c::Integer, w::Integer, read_pal_component::Integer)
    ccall((:av_read_image_line, libavutil), Cvoid, (Ptr{UInt16}, NTuple{4, Ptr{UInt8}}, NTuple{4, Cint}, Ptr{AVPixFmtDescriptor}, Cint, Cint, Cint, Cint, Cint), dst, data, linesize, desc, x, y, c, w, read_pal_component)
end

function av_write_image_line2(src, data::NTuple{4, Ptr{UInt8}}, linesize::NTuple{4, Cint}, desc, x::Integer, y::Integer, c::Integer, w::Integer, src_element_size::Integer)
    ccall((:av_write_image_line2, libavutil), Cvoid, (Ptr{Cvoid}, NTuple{4, Ptr{UInt8}}, NTuple{4, Cint}, Ptr{AVPixFmtDescriptor}, Cint, Cint, Cint, Cint, Cint), src, data, linesize, desc, x, y, c, w, src_element_size)
end

function av_write_image_line(src, data::NTuple{4, Ptr{UInt8}}, linesize::NTuple{4, Cint}, desc, x::Integer, y::Integer, c::Integer, w::Integer)
    ccall((:av_write_image_line, libavutil), Cvoid, (Ptr{UInt16}, NTuple{4, Ptr{UInt8}}, NTuple{4, Cint}, Ptr{AVPixFmtDescriptor}, Cint, Cint, Cint, Cint), src, data, linesize, desc, x, y, c, w)
end

function av_pix_fmt_swap_endianness(pix_fmt::Cvoid)
    ccall((:av_pix_fmt_swap_endianness, libavutil), Cvoid, (Cvoid,), pix_fmt)
end

function av_get_pix_fmt_loss(dst_pix_fmt::Cvoid, src_pix_fmt::Cvoid, has_alpha::Integer)
    ccall((:av_get_pix_fmt_loss, libavutil), Cint, (Cvoid, Cvoid, Cint), dst_pix_fmt, src_pix_fmt, has_alpha)
end

function av_find_best_pix_fmt_of_2(dst_pix_fmt1::Cvoid, dst_pix_fmt2::Cvoid, src_pix_fmt::Cvoid, has_alpha::Integer, loss_ptr)
    ccall((:av_find_best_pix_fmt_of_2, libavutil), Cvoid, (Cvoid, Cvoid, Cvoid, Cint, Ptr{Cint}), dst_pix_fmt1, dst_pix_fmt2, src_pix_fmt, has_alpha, loss_ptr)
end
