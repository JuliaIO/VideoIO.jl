const VIO_PIX_FMT_DEF_ELTYPE_LU = Dict{Cint,DataType}(
    AV_PIX_FMT_GRAY8 => Gray{N0f8},
    AV_PIX_FMT_GRAY10LE => Gray{N6f10},
    AV_PIX_FMT_RGB24 => RGB{N0f8},
    AV_PIX_FMT_GBRP10LE => RGB{N6f10},
)

const VIO_SUPPORTED_PIX_FMTS = collect(keys(VIO_PIX_FMT_DEF_ELTYPE_LU))
# This array is terminated by AV_PIX_FMT_NONE so it can be used by libav functions
const VIO_SUPPORTED_PIX_FMTS_AVARRAY = push!(copy(VIO_SUPPORTED_PIX_FMTS), AV_PIX_FMT_NONE)

strip_interpretation(::Type{X}) where {T,X<:Gray{T}} = strip_interpretation(T)
strip_interpretation(::Type{X}) where {T,X<:Normed{T}} = strip_interpretation(T)
strip_interpretation(::Type{T}) where {T} = T

const VIO_DEF_ELTYPE_PIX_FMT_LU =
    Dict{DataType,Int32}((strip_interpretation(v) => k for (k, v) in pairs(VIO_PIX_FMT_DEF_ELTYPE_LU)))

struct VioColorspaceDetails
    color_primaries::Cint
    color_trc::Cint
    colorspace::Cint
    color_range::Cint
end

VioColorspaceDetails() =
    VioColorspaceDetails(AVCOL_PRI_UNSPECIFIED, AVCOL_TRC_UNSPECIFIED, AVCOL_SPC_UNSPECIFIED, AVCOL_RANGE_UNSPECIFIED)

const VIO_DEFAULT_COLORSPACE_DETAILS =
    VioColorspaceDetails(AVCOL_PRI_BT709, AVCOL_TRC_IEC61966_2_1, AVCOL_SPC_RGB, AVCOL_RANGE_JPEG)

const VIO_DEFAULT_TRANSFER_COLORSPACE_DETAILS = Dict{Cint,VioColorspaceDetails}(
    AV_PIX_FMT_GRAY8 => VIO_DEFAULT_COLORSPACE_DETAILS,
    AV_PIX_FMT_GRAY10LE => VIO_DEFAULT_COLORSPACE_DETAILS,
    AV_PIX_FMT_RGB24 => VIO_DEFAULT_COLORSPACE_DETAILS,
    AV_PIX_FMT_GBRP10LE => VIO_DEFAULT_COLORSPACE_DETAILS,
)

# avarray_dst_pix_fmts MUST be terminated properly, see `avcodec_find_best_pix_fmt_of_list`
function _vio_determine_best_pix_fmt(src_pix_fmt, avarray_dst_pix_fmts = VIO_SUPPORTED_PIX_FMTS_AVARRAY; loss_flags = 0)
    loss_ptr = Ref{Cint}(loss_flags)
    dst_pix_fmt = avcodec_find_best_pix_fmt_of_list(avarray_dst_pix_fmts, src_pix_fmt, 0, loss_ptr)
    return dst_pix_fmt, loss_ptr[]
end

is_pixel_type_supported(pxfmt) = haskey(VIO_PIX_FMT_DEF_ELTYPE_LU, pxfmt)

is_eltype_transfer_supported(::Type{T}) where {T} = haskey(VIO_DEF_ELTYPE_PIX_FMT_LU, strip_interpretation(T))

get_transfer_pix_fmt(::Type{T}) where {T} = VIO_DEF_ELTYPE_PIX_FMT_LU[strip_interpretation(T)]

@inline function bytes_of_uint16(x::UInt16)
    msb = convert(UInt8, (x & 0xFF00) >> 8)
    lsb = convert(UInt8, x & 0x00FF)
    return msb, lsb
end

@inline function unsafe_store_uint16_in_le!(data, x, offset)
    msb, lsb = bytes_of_uint16(x)
    unsafe_store!(data, lsb, offset)
    return unsafe_store!(data, msb, offset + 1)
end

@inline uint16_from_bytes(msb, lsb) = (convert(UInt16, msb) << 8) | lsb

function load_uint16_from_le_bytes(data, pos)
    lsb = unsafe_load(data, pos)
    msb = unsafe_load(data, pos + 1)
    return uint16_from_bytes(msb, lsb)
end

load_n6f10_from_le_bytes(data, pos) = reinterpret(N6f10, load_uint16_from_le_bytes(data, pos))

function set_basic_frame_properties!(frame, width, height, format)
    frame.format = format
    frame.width = width
    frame.height = height
    ret = av_frame_get_buffer(frame, 0) # Allocate picture buffers
    return ret < 0 && error("Could not allocate the video frame data")
end

#############################
## AVFrame -> Julia Buffer ##
#############################

# Transfer bytes from AVFrame to buffer
function _transfer_frame_bytes_to_img_buf!(buf::AbstractArray{UInt8}, frame, bytes_per_pixel)
    width = frame.width
    height = frame.height
    ip = frame.data[1]
    op = pointer(buf)
    out_linesize = width * bytes_per_pixel
    for h in 1:height
        out_line_p = op + (h - 1) * out_linesize
        in_line_p = ip + (h - 1) * frame.linesize[1]
        unsafe_copyto!(out_line_p, in_line_p, out_linesize)
    end
    return buf
end

# Read a 8 bit monochrome frame
function transfer_frame_to_img_buf!(buf::AbstractArray{UInt8}, frame, bytes_per_pixel)
    target_format = frame.format
    if target_format == AV_PIX_FMT_GRAY8
        _transfer_frame_bytes_to_img_buf!(buf, frame, bytes_per_pixel)
    else
        unsupported_retrieval_format(target_format)
    end
    return buf
end

# Read a 10 bit monochrome frame
function transfer_frame_to_img_buf!(buf::AbstractArray{UInt16}, frame, bytes_per_pixel)
    target_format = frame.format
    if target_format == AV_PIX_FMT_GRAY10LE
        if ENDIAN_BOM != 0x04030201
            error("Reading AV_PIX_FMT_GRAY10LE on big-endian machines not yet supported")
        end
        _transfer_frame_bytes_to_img_buf!(reinterpret(UInt8, buf), frame, bytes_per_pixel)
    else
        unsupported_retrieval_format(target_format)
    end
    return buf
end

transfer_frame_to_img_buf!(buf::AbstractArray{X}, args...) where {T,X<:Normed{T}} =
    transfer_frame_to_img_buf!(reinterpret(T, buf), args...)

transfer_frame_to_img_buf!(buf::AbstractArray{<:Gray}, args...) = transfer_frame_to_img_buf!(channelview(buf), args...)

# Read a 8 bit RGB frame
function transfer_frame_to_img_buf!(buf::AbstractArray{RGB{N0f8}}, frame, bytes_per_pixel)
    target_format = frame.format
    if target_format == AV_PIX_FMT_RGB24
        _transfer_frame_bytes_to_img_buf!(reinterpret(UInt8, buf), frame, bytes_per_pixel)
    else
        unsupported_retrieval_format(target_format)
    end
    return buf
end

# Read a 10 bit RGB frame
function transfer_frame_to_img_buf!(buf::AbstractArray{RGB{N6f10}}, frame, ::Any)
    target_format = frame.format
    if target_format == AV_PIX_FMT_GBRP10LE
        bytes_per_sample = 2
        width = frame.width
        height = frame.height
        size(buf) == (width, height) || error("buffer wrong size")
        ls = frame.linesize
        @inbounds linesizes = ntuple(i -> ls[i], 3)
        @inbounds for r in 1:height
            line_offsets = (r - 1) .* linesizes
            @simd ivdep for c in 1:width
                col_pos = (c - 1) * bytes_per_sample + 1
                line_poss = line_offsets .+ col_pos
                rg = load_n6f10_from_le_bytes(frame.data[1], line_poss[1])
                rb = load_n6f10_from_le_bytes(frame.data[2], line_poss[2])
                rr = load_n6f10_from_le_bytes(frame.data[3], line_poss[3])
                buf[c, r] = RGB{N6f10}(rr, rg, rb) # scanline-major!
            end
        end
    else
        unsupported_retrieval_format(target_format)
    end
    return buf
end

transfer_frame_to_img_buf!(buf::PermutedDimsArray, frame, bytes_per_sample) =
    transfer_frame_to_img_buf!(parent(buf), frame, bytes_per_sample)

#############################
## Julia Buffer -> AVFrame ##
#############################

_unsupported_append_encode_type() = error("Array element type not supported")

# bytes_per_sample is the number of bytes per pixel sample, not the size of the
# element type of img
function transfer_img_bytes_to_frame_plane!(
    data_ptr,
    img::AbstractArray{UInt8},
    px_width,
    px_height,
    data_linesize,
    bytes_per_sample = 1,
)
    stride(img, 1) == 1 || error("stride(img, 1) must be equal to one")
    img_line_nbytes = px_width * bytes_per_sample
    if data_linesize == img_line_nbytes
        # When both sizes match the buffers are both contiguous, so can be transferred in one go
        unsafe_copyto!(data_ptr, pointer(img), length(img))
    else
        for r in 1:px_height
            data_line_ptr = data_ptr + (r - 1) * data_linesize
            img_line_ptr = try
                pointer(img, img_line_nbytes * (r - 1) + 1)
            catch
                @show typeof(img) size(img) img_line_nbytes * (r - 1) + 1
                rethrow()
            end
            unsafe_copyto!(data_line_ptr, img_line_ptr, img_line_nbytes)
        end
    end
end

function make_into_sl_col_mat(img::AbstractVector{<:Union{RGB,Unsigned}}, width, height)
    img_mat = reshape(img, (height, width))
    return PermutedDimsArray(img_mat, (2, 1))
end
make_into_sl_col_mat(img::AbstractMatrix{<:Union{RGB,Unsigned}}, args...) = PermutedDimsArray(img, (2, 1))

function transfer_sl_col_img_buf_to_frame!(frame, img::AbstractArray{UInt8})
    frame.format == AV_PIX_FMT_RGB24 || _unsupported_append_encode_type()
    width = frame.width
    height = frame.height
    ls = frame.linesize[1]
    data_p = frame.data[1]
    @inbounds for r in 1:height
        line_offset = (r - 1) * ls
        @simd for c in 1:width
            val = img[c, r]
            row_offset = line_offset + c
            for s in 0:2
                @preserve frame unsafe_store!(data_p, val, row_offset + s)
            end
        end
    end
end

function transfer_img_buf_to_frame!(frame, img::AbstractArray{UInt8}, scanline_major)
    pix_fmt = frame.format
    if pix_fmt == AV_PIX_FMT_GRAY8
        width = frame.width
        height = frame.height
        ls = frame.linesize[1]
        data_p = frame.data[1]
        if scanline_major
            @preserve frame transfer_img_bytes_to_frame_plane!(data_p, img, width, height, ls)
        else
            @inbounds for r in 1:height
                line_offset = (r - 1) * ls
                @simd for c in 1:width
                    @preserve frame unsafe_store!(data_p, img[r, c], line_offset + c)
                end
            end
        end
    elseif pix_fmt == AV_PIX_FMT_RGB24
        # This is specifying each RGB triple with one UInt8 "luma" value
        if scanline_major
            transfer_sl_col_img_buf_to_frame!(frame, img)
        else
            img_sl_col_mat = make_into_sl_col_mat(img)
            transfer_sl_col_img_buf_to_frame!(frame, img_sl_col_mat)
        end
    else
        _unsupported_append_encode_type()
    end
end

function transfer_img_buf_to_frame!(frame, img::AbstractArray{UInt16}, scanline_major)
    bytes_per_sample = 2
    pix_fmt = frame.format
    if pix_fmt == AV_PIX_FMT_GRAY10LE
        width = frame.width
        height = frame.height
        ls = frame.linesize[1]
        datap = frame.data[1]
        if scanline_major
            if ENDIAN_BOM != 0x04030201
                error("""
    Writing scanline_major AV_PIX_FMT_GRAY10LE on big-endian machines not yet
    supported, use scanline_major = false
    """)
            end
            img_raw = reinterpret(UInt8, img)
            @preserve frame transfer_img_bytes_to_frame_plane!(datap, img_raw, width, height, ls, bytes_per_sample)
        else
            @inbounds for r in 1:height
                line_offset = (r - 1) * ls
                @simd for c in 1:width
                    px_offset = line_offset + bytes_per_sample * (c - 1) + 1
                    @preserve frame unsafe_store_uint16_in_le!(datap, img[r, c], px_offset)
                end
            end
        end
    else
        _unsupported_append_encode_type()
    end
end

simple_rawview(a::AbstractArray{X}) where {T,X<:Normed{T}} = reinterpret(T, a)

transfer_img_buf_to_frame!(frame, img::AbstractArray{<:Normed}, args...) =
    transfer_img_buf_to_frame!(frame, simple_rawview(img), args...)

transfer_img_buf_to_frame!(frame, img::AbstractArray{<:Gray}, args...) =
    transfer_img_buf_to_frame!(frame, channelview(img), args...)

function transfer_img_buf_to_frame!(frame, img::AbstractMatrix{RGB{N0f8}}, scanline_major)
    pix_fmt = frame.format
    if pix_fmt == AV_PIX_FMT_RGB24
        width = frame.width
        height = frame.height
        lss = frame.linesize
        fdata = frame.data
        bytes_per_pixel = 3
        if scanline_major
            data_p = fdata[1]
            @preserve frame transfer_img_bytes_to_frame_plane!(
                data_p,
                reinterpret(UInt8, img),
                width,
                height,
                lss[1],
                bytes_per_pixel,
            )
        else
            @inbounds for h in 1:height
                line_offset = (h - 1) * lss[1]
                @simd for w in 1:width
                    px = img[h, w]
                    px_offset = line_offset + (w - 1) * bytes_per_pixel + 1
                    unsafe_store!(fdata[1], reinterpret(px.r), px_offset)
                    unsafe_store!(fdata[1], reinterpret(px.g), px_offset + 1)
                    unsafe_store!(fdata[1], reinterpret(px.b), px_offset + 2)
                end
            end
        end
    else
        _unsupported_append_encode_type()
    end
end

function transfer_sl_col_img_buf_to_frame!(frame, img::AbstractArray{RGB{N6f10}})
    pix_fmt = frame.format
    pix_fmt == AV_PIX_FMT_GBRP10LE || _unsupported_append_encode_type()
    bytes_per_sample = 2
    # Luma
    fdata = frame.data
    linesize_y = frame.linesize[1]
    width = frame.width
    height = frame.height
    all(size(img) .>= (width, height)) || error("img is not large enough")
    ls = frame.linesize
    @inbounds linesizes = ntuple(i -> ls[i], 3)
    @inbounds for h in 1:height
        line_offsets = (h - 1) .* linesizes
        @simd ivdep for w in 1:width
            col_pos = (w - 1) * bytes_per_sample + 1
            line_poss = line_offsets .+ col_pos
            input_px = img[w, h]
            unsafe_store_uint16_in_le!(fdata[1], reinterpret(green(input_px)), line_poss[1])
            unsafe_store_uint16_in_le!(fdata[2], reinterpret(blue(input_px)), line_poss[2])
            unsafe_store_uint16_in_le!(fdata[3], reinterpret(red(input_px)), line_poss[3])
        end
    end
end

function transfer_img_buf_to_frame!(frame, img::AbstractArray{RGB{N6f10}}, scanline_major)
    if scanline_major
        transfer_img = img
    else
        transfer_img = img_sl_col_mat = make_into_sl_col_mat(img)
    end
    return transfer_sl_col_img_buf_to_frame!(frame, transfer_img)
end

# Fallback
transfer_img_buf_to_frame!(frame, img, scanline_major) = _unsuported_append_encode_type()
