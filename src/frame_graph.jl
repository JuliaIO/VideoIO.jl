# Force transform of input range for the following formats
const VIO_GRAY_SCALE_TYPES = Set((AV_PIX_FMT_GRAY8, AV_PIX_FMT_GRAY10LE))

const VIO_AVCOL_PRI_TO_SWS_CS = Dict{Cint, Cint}(
    AVCOL_PRI_BT709 => SWS_CS_ITU709,
    AVCOL_PRI_SMPTE170M => SWS_CS_ITU601,
    AVCOL_PRI_SMPTE240M => SWS_CS_SMPTE240M,
    AVCOL_PRI_BT2020    => SWS_CS_BT2020,
    AVCOL_PRI_BT470M    => SWS_CS_FCC
)

mutable struct SwsTransform
    sws_context::SwsContextPtr
    srcframe::AVFramePtr
    dstframe::AVFramePtr
end

function SwsTransform(src_w, src_h, src_pix_fmt, dst_w, dst_h, dst_pix_fmt,
                      interp)
    sws_context = SwsContextPtr(src_w, src_h, src_pix_fmt, dst_w, dst_h,
                                dst_pix_fmt, interp)
    srcframe = AVFramePtr()
    dstframe = AVFramePtr()
    SwsTransform(sws_context, srcframe, dstframe)
end

SwsTransform(src_w, src_h, src_pix_fmt, dst_pix_fmt, interp) =
    SwsTransform(src_w, src_h, src_pix_fmt, src_w, src_h, dst_pix_fmt, interp)

mutable struct GrayTransform
    srcframe::AVFramePtr
    src_depth::Int
    dstframe::AVFramePtr
    dst_depth::Int
end

function GrayTransform()
    srcframe = AVFramePtr()
    dstframe = AVFramePtr()
    GrayTransform(srcframe, 0, dstframe, 0)
end

const GraphType = Union{AVFramePtr, GrayTransform, SwsTransform}

graph_input_frame(s::SwsTransform) = s.srcframe
graph_output_frame(s::SwsTransform) = s.dstframe

graph_input_frame(s::AVFramePtr) = s
graph_output_frame(s::AVFramePtr) = s

graph_input_frame(s::GrayTransform) = s.srcframe
graph_output_frame(s::GrayTransform) = s.dstframe

null_graph(s::AVFramePtr) = AVFramePtr(C_NULL)
null_graph(s::SwsTransform) =
    SwsTransform(SwsContextPtr(C_NULL), AVFramePtr(C_NULL), AVFramePtr(C_NULL))
null_graph(s::GrayTransform) = GrayTransform(AVFramePtr(C_NULL), 0,
                                             AVFramePtr(C_NULL), 0)

function exec!(s::SwsTransform)
    src_ptr = unsafe_convert(Ptr{AVFrame}, s.srcframe)
    @preserve s begin
        # s is preserved if r is preserved, hopefully? A little confusing.
        src_data_ptr = field_ptr(src_ptr, :data)
        src_linesize_ptr = field_ptr(src_ptr, :linesize)
        dst_ptr = unsafe_convert(Ptr{AVFrame}, s.dstframe)
        dst_data_ptr = field_ptr(dst_ptr, :data)
        dst_linesize_ptr = field_ptr(dst_ptr, :linesize)

        sigatomic_begin()
        ret = sws_scale(s.sws_context, src_data_ptr, src_linesize_ptr,
                        0, s.dstframe.height, dst_data_ptr,
                        dst_linesize_ptr)
        sigatomic_end()
    end
    nothing
end

function scale_gray_frames!(f, dstframe, ::Type{T}, ::Type{S}, srcframe
                            ) where {T<:Unsigned, S<:Unsigned}
    height = srcframe.height
    width = srcframe.width
    ok = height == dstframe.height && width == dstframe.width
    ok || throw(ArgumentError("Frames and not the same size"))
    srcls = srcframe.linesize[1]
    dstls = dstframe.linesize[1]
    srcdp = srcframe.data[1]
    dstdp = dstframe.data[1]
    for h in 0:height-1
        src_line_offset = srcls * h
        dst_line_offset = dstls * h
        src_line_ptr = convert(Ptr{S}, srcdp + src_line_offset)
        dst_line_ptr = convert(Ptr{T}, dstdp + dst_line_offset)
        for w in 1:width
            input_el = unsafe_load(src_line_ptr, w)
            unsafe_store!(dst_line_ptr, f(input_el), w)
        end
    end
end

function gray_range(av_colrange, bitdepth)
    if av_colrange == AVCOL_RANGE_JPEG
        r = (0, 2 ^ bitdepth - 1)
    else
        b = 16 * 2 ^ (bitdepth - 8)
        r = (b, b + 219 * 2 ^ (bitdepth - 8))
    end
    r
end

function exec!(s::GrayTransform)
    r_src = gray_range(s.srcframe.color_range, s.src_depth)
    r_dst = gray_range(s.dstframe.color_range, s.dst_depth)
    src_range = r_src[2] - r_src[1]
    dst_range = r_dst[2] - r_dst[1]
    dst_t = strip_interpretation(VIO_PIX_FMT_DEF_ELTYPE_LU[s.dstframe.format])
    src_t = strip_interpretation(VIO_PIX_FMT_DEF_ELTYPE_LU[s.srcframe.format])
    f = x -> round(dst_t, (dst_range * UInt32(x - r_src[1])) // src_range + r_dst[1])
    scale_gray_frames!(f, s.dstframe, dst_t, src_t, s.srcframe)
end

exec!(f::AVFramePtr) = nothing

function _vio_sws_getCoefficients(cs_num)
    table_ptr = sws_getCoefficients(cs_num)
    unsafe_wrap(Array, table_ptr, 4)
end

function _vio_primaries_to_sws_table(avcol_pri)
    sws_cs = get(VIO_AVCOL_PRI_TO_SWS_CS, avcol_pri, SWS_CS_DEFAULT)
    _vio_sws_getCoefficients(sws_cs)
end

function sws_get_color_details(sws_context)
    inv_table_dp = Ref(Ptr{Cint}())
    srcRange = Ref{Cint}()
    table_dp = Ref(Ptr{Cint}())
    dstRange = Ref{Cint}()
    brightness = Ref{Cint}()
    contrast = Ref{Cint}()
    saturation = Ref{Cint}()
    ret = sws_getColorspaceDetails(sws_context, inv_table_dp, srcRange,
                                   table_dp, dstRange, brightness, contrast,
                                   saturation)
    ret < 0 && return nothing
    inv_table = Vector{Cint}(undef, 4)
    table = similar(inv_table)
    unsafe_copyto!(pointer(inv_table), inv_table_dp[], 4)
    unsafe_copyto!(pointer(table), table_dp[], 4)
    return inv_table, srcRange[], table, dstRange[], brightness[], contrast[], saturation[]
end

function sws_set_color_details(sws_context, inv_table, src_range, table,
                               dst_range, brightness, contrast, saturation)
    length(inv_table) == length(table) == 4 || throw(ArgumentError("tables wrong size"))
    ret = sws_setColorspaceDetails(sws_context, inv_table, src_range, table,
                                   dst_range, brightness, contrast, saturation)
    ret != -1
end

function sws_update_color_details(sws_context; kwargs...)
    outs = sws_get_color_details(sws_context)
    outs === nothing && return false
    inv_table, src_range, table, dst_range, brightness, contrast, saturation = outs
    vals = (inv_table = inv_table, src_range = src_range, table = table,
            dst_range = dst_range, brightness = brightness, contrast = contrast,
            saturation = saturation)
    valnames = keys(vals)
    new_vals = ntuple(length(vals)) do i
        key = keys(vals)[i]
        get(kwargs, key, vals[i])
    end
    sws_set_color_details(sws_context, new_vals...)
end

function pix_fmt_to_bits_per_pixel(pix_fmt)
    fmt_desc = av_pix_fmt_desc_get(pix_fmt)
    check_ptr_valid(fmt_desc, false) || error("Unknown pixel format $dst_pix_fmt")
    padded_bits = av_get_padded_bits_per_pixel(fmt_desc)
    bits = av_get_bits_per_pixel(fmt_desc)
    bits, padded_bits
end
