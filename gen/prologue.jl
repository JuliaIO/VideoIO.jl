const intptr_t = UInt
const time_t = Int

const AV_NOPTS_VALUE = 0x8000000000000000 % Int64
AV_VERSION_INT(a, b, c) = (a << 16 | b << 8) | c
AV_VERSION(a, b, c) = nothing
const AVPROBE_SCORE_MAX = 100
MKTAG(a, b, c, d) = (UInt32(a) | (UInt32(b) << 8) | (UInt32(c) << 16) | UInt32(d) << 24)
FFERRTAG(a, b, c, d) = -MKTAG(a, b, c, d)
macro AV_PIX_FMT_NE(be, le)
    return Symbol("AV_PIX_FMT_" * string(le))
end

# Defined in AMD's AMF SDK headers, which are not available when generating
const AMF_SURFACE_FORMAT = Int32

const AMF_SURFACE_UNKNOWN     = 0  % Int32
const AMF_SURFACE_NV12        = 1  % Int32
const AMF_SURFACE_YV12        = 2  % Int32
const AMF_SURFACE_BGRA        = 3  % Int32
const AMF_SURFACE_ARGB        = 4  % Int32
const AMF_SURFACE_RGBA        = 5  % Int32
const AMF_SURFACE_GRAY8       = 6  % Int32
const AMF_SURFACE_YUV420P     = 7  % Int32
const AMF_SURFACE_U8V8        = 8  % Int32
const AMF_SURFACE_YUY2        = 9  % Int32
const AMF_SURFACE_P010        = 10 % Int32
const AMF_SURFACE_RGBA_F16    = 11 % Int32
const AMF_SURFACE_UYVY        = 12 % Int32
const AMF_SURFACE_R10G10B10A2 = 13 % Int32
const AMF_SURFACE_Y210        = 14 % Int32
const AMF_SURFACE_AYUV        = 15 % Int32
const AMF_SURFACE_Y410        = 16 % Int32
const AMF_SURFACE_Y416        = 17 % Int32
const AMF_SURFACE_GRAY9       = 18 % Int32
const AMF_SURFACE_GRAY10      = 19 % Int32
const AMF_SURFACE_GRAY12      = 20 % Int32
const AMF_SURFACE_GRAY14      = 21 % Int32
