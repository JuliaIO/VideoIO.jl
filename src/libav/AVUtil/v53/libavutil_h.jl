
import Base.zero


export
    AV_TIME_BASE,
    AVMediaType,
    AVMEDIA_TYPE_UNKNOWN,
    AVMEDIA_TYPE_VIDEO,
    AVMEDIA_TYPE_AUDIO,
    AVMEDIA_TYPE_DATA,
    AVMEDIA_TYPE_SUBTITLE,
    AVMEDIA_TYPE_ATTACHMENT,
    AVMEDIA_TYPE_NB,
    AVPictureType,
    AV_PICTURE_TYPE_I,
    AV_PICTURE_TYPE_P,
    AV_PICTURE_TYPE_B,
    AV_PICTURE_TYPE_S,
    AV_PICTURE_TYPE_SI,
    AV_PICTURE_TYPE_SP,
    AV_PICTURE_TYPE_BI,
    AV_BUFFER_FLAG_READONLY,
    AVBuffer,
    AVBufferRef,
    AVBufferPool,
    AV_CH_FRONT_LEFT,
    AV_CH_FRONT_RIGHT,
    AV_CH_FRONT_CENTER,
    AV_CH_LOW_FREQUENCY,
    AV_CH_BACK_LEFT,
    AV_CH_BACK_RIGHT,
    AV_CH_FRONT_LEFT_OF_CENTER,
    AV_CH_FRONT_RIGHT_OF_CENTER,
    AV_CH_BACK_CENTER,
    AV_CH_SIDE_LEFT,
    AV_CH_SIDE_RIGHT,
    AV_CH_TOP_CENTER,
    AV_CH_TOP_FRONT_LEFT,
    AV_CH_TOP_FRONT_CENTER,
    AV_CH_TOP_FRONT_RIGHT,
    AV_CH_TOP_BACK_LEFT,
    AV_CH_TOP_BACK_CENTER,
    AV_CH_TOP_BACK_RIGHT,
    AV_CH_STEREO_LEFT,
    AV_CH_STEREO_RIGHT,
    AV_CH_WIDE_LEFT,
    AV_CH_WIDE_RIGHT,
    AV_CH_SURROUND_DIRECT_LEFT,
    AV_CH_SURROUND_DIRECT_RIGHT,
    AV_CH_LOW_FREQUENCY_2,
    AV_CH_LAYOUT_NATIVE,
    AV_CH_LAYOUT_MONO,
    AV_CH_LAYOUT_STEREO,
    AV_CH_LAYOUT_2POINT1,
    AV_CH_LAYOUT_2_1,
    AV_CH_LAYOUT_SURROUND,
    AV_CH_LAYOUT_3POINT1,
    AV_CH_LAYOUT_4POINT0,
    AV_CH_LAYOUT_4POINT1,
    AV_CH_LAYOUT_2_2,
    AV_CH_LAYOUT_QUAD,
    AV_CH_LAYOUT_5POINT0,
    AV_CH_LAYOUT_5POINT1,
    AV_CH_LAYOUT_5POINT0_BACK,
    AV_CH_LAYOUT_5POINT1_BACK,
    AV_CH_LAYOUT_6POINT0,
    AV_CH_LAYOUT_6POINT0_FRONT,
    AV_CH_LAYOUT_HEXAGONAL,
    AV_CH_LAYOUT_6POINT1,
    AV_CH_LAYOUT_6POINT1_BACK,
    AV_CH_LAYOUT_6POINT1_FRONT,
    AV_CH_LAYOUT_7POINT0,
    AV_CH_LAYOUT_7POINT0_FRONT,
    AV_CH_LAYOUT_7POINT1,
    AV_CH_LAYOUT_7POINT1_WIDE,
    AV_CH_LAYOUT_7POINT1_WIDE_BACK,
    AV_CH_LAYOUT_OCTAGONAL,
    AV_CH_LAYOUT_STEREO_DOWNMIX,
    AVMatrixEncoding,
    AV_MATRIX_ENCODING_NONE,
    AV_MATRIX_ENCODING_DOLBY,
    AV_MATRIX_ENCODING_DPLII,
    AV_MATRIX_ENCODING_DPLIIX,
    AV_MATRIX_ENCODING_DPLIIZ,
    AV_MATRIX_ENCODING_DOLBYEX,
    AV_MATRIX_ENCODING_DOLBYHEADPHONE,
    AV_MATRIX_ENCODING_NB,
    AV_DICT_MATCH_CASE,
    AV_DICT_IGNORE_SUFFIX,
    AV_DICT_DONT_STRDUP_KEY,
    AV_DICT_DONT_STRDUP_VAL,
    AV_DICT_DONT_OVERWRITE,
    AV_DICT_APPEND,
    AVDictionaryEntry,
    AVDictionary,
    AVFifoBuffer,
    AV_NUM_DATA_POINTERS,
    AV_FRAME_FLAG_CORRUPT,
    AVFrameSideDataType,
    AV_FRAME_DATA_PANSCAN,
    AV_FRAME_DATA_A53_CC,
    AV_FRAME_DATA_STEREO3D,
    AV_FRAME_DATA_MATRIXENCODING,
    AV_FRAME_DATA_DOWNMIX_INFO,
    AVFrameSideData,
    Array_8_Ptr,
    Array_8_Cint,
    Array_2_Ptr,
    Array_8_Uint64,
    AVRational,
    AVFrame,
    AV_LOG_QUIET,
    AV_LOG_PANIC,
    AV_LOG_FATAL,
    AV_LOG_ERROR,
    AV_LOG_WARNING,
    AV_LOG_INFO,
    AV_LOG_VERBOSE,
    AV_LOG_DEBUG,
    AV_LOG_SKIP_REPEATED,
    AVOptionType,
    AV_OPT_TYPE_FLAGS,
    AV_OPT_TYPE_INT,
    AV_OPT_TYPE_INT64,
    AV_OPT_TYPE_DOUBLE,
    AV_OPT_TYPE_FLOAT,
    AV_OPT_TYPE_STRING,
    AV_OPT_TYPE_RATIONAL,
    AV_OPT_TYPE_BINARY,
    AV_OPT_TYPE_CONST,
    AVOption,
    AVClass,
    AV_PIX_FMT_FLAG_BE,
    AV_PIX_FMT_FLAG_PAL,
    AV_PIX_FMT_FLAG_BITSTREAM,
    AV_PIX_FMT_FLAG_HWACCEL,
    AV_PIX_FMT_FLAG_PLANAR,
    AV_PIX_FMT_FLAG_RGB,
    AV_PIX_FMT_FLAG_PSEUDOPAL,
    AV_PIX_FMT_FLAG_ALPHA,
    PIX_FMT_BE,
    PIX_FMT_PAL,
    PIX_FMT_BITSTREAM,
    PIX_FMT_HWACCEL,
    PIX_FMT_PLANAR,
    PIX_FMT_RGB,
    PIX_FMT_PSEUDOPAL,
    PIX_FMT_ALPHA,
    AVComponentDescriptor,
    Array_4_AVComponentDescriptor,
    AVPixFmtDescriptor,
    AVPixelFormat,
    AV_PIX_FMT_NONE,
    AV_PIX_FMT_YUV420P,
    AV_PIX_FMT_YUYV422,
    AV_PIX_FMT_RGB24,
    AV_PIX_FMT_BGR24,
    AV_PIX_FMT_YUV422P,
    AV_PIX_FMT_YUV444P,
    AV_PIX_FMT_YUV410P,
    AV_PIX_FMT_YUV411P,
    AV_PIX_FMT_GRAY8,
    AV_PIX_FMT_MONOWHITE,
    AV_PIX_FMT_MONOBLACK,
    AV_PIX_FMT_PAL8,
    AV_PIX_FMT_YUVJ420P,
    AV_PIX_FMT_YUVJ422P,
    AV_PIX_FMT_YUVJ444P,
    AV_PIX_FMT_XVMC_MPEG2_MC,
    AV_PIX_FMT_XVMC_MPEG2_IDCT,
    AV_PIX_FMT_UYVY422,
    AV_PIX_FMT_UYYVYY411,
    AV_PIX_FMT_BGR8,
    AV_PIX_FMT_BGR4,
    AV_PIX_FMT_BGR4_BYTE,
    AV_PIX_FMT_RGB8,
    AV_PIX_FMT_RGB4,
    AV_PIX_FMT_RGB4_BYTE,
    AV_PIX_FMT_NV12,
    AV_PIX_FMT_NV21,
    AV_PIX_FMT_ARGB,
    AV_PIX_FMT_RGBA,
    AV_PIX_FMT_ABGR,
    AV_PIX_FMT_BGRA,
    AV_PIX_FMT_GRAY16BE,
    AV_PIX_FMT_GRAY16LE,
    AV_PIX_FMT_YUV440P,
    AV_PIX_FMT_YUVJ440P,
    AV_PIX_FMT_YUVA420P,
    AV_PIX_FMT_VDPAU_H264,
    AV_PIX_FMT_VDPAU_MPEG1,
    AV_PIX_FMT_VDPAU_MPEG2,
    AV_PIX_FMT_VDPAU_WMV3,
    AV_PIX_FMT_VDPAU_VC1,
    AV_PIX_FMT_RGB48BE,
    AV_PIX_FMT_RGB48LE,
    AV_PIX_FMT_RGB565BE,
    AV_PIX_FMT_RGB565LE,
    AV_PIX_FMT_RGB555BE,
    AV_PIX_FMT_RGB555LE,
    AV_PIX_FMT_BGR565BE,
    AV_PIX_FMT_BGR565LE,
    AV_PIX_FMT_BGR555BE,
    AV_PIX_FMT_BGR555LE,
    AV_PIX_FMT_VAAPI_MOCO,
    AV_PIX_FMT_VAAPI_IDCT,
    AV_PIX_FMT_VAAPI_VLD,
    AV_PIX_FMT_YUV420P16LE,
    AV_PIX_FMT_YUV420P16BE,
    AV_PIX_FMT_YUV422P16LE,
    AV_PIX_FMT_YUV422P16BE,
    AV_PIX_FMT_YUV444P16LE,
    AV_PIX_FMT_YUV444P16BE,
    AV_PIX_FMT_VDPAU_MPEG4,
    AV_PIX_FMT_DXVA2_VLD,
    AV_PIX_FMT_RGB444LE,
    AV_PIX_FMT_RGB444BE,
    AV_PIX_FMT_BGR444LE,
    AV_PIX_FMT_BGR444BE,
    AV_PIX_FMT_Y400A,
    AV_PIX_FMT_BGR48BE,
    AV_PIX_FMT_BGR48LE,
    AV_PIX_FMT_YUV420P9BE,
    AV_PIX_FMT_YUV420P9LE,
    AV_PIX_FMT_YUV420P10BE,
    AV_PIX_FMT_YUV420P10LE,
    AV_PIX_FMT_YUV422P10BE,
    AV_PIX_FMT_YUV422P10LE,
    AV_PIX_FMT_YUV444P9BE,
    AV_PIX_FMT_YUV444P9LE,
    AV_PIX_FMT_YUV444P10BE,
    AV_PIX_FMT_YUV444P10LE,
    AV_PIX_FMT_YUV422P9BE,
    AV_PIX_FMT_YUV422P9LE,
    AV_PIX_FMT_VDA_VLD,
    AV_PIX_FMT_GBRP,
    AV_PIX_FMT_GBRP9BE,
    AV_PIX_FMT_GBRP9LE,
    AV_PIX_FMT_GBRP10BE,
    AV_PIX_FMT_GBRP10LE,
    AV_PIX_FMT_GBRP16BE,
    AV_PIX_FMT_GBRP16LE,
    AV_PIX_FMT_YUVA422P,
    AV_PIX_FMT_YUVA444P,
    AV_PIX_FMT_YUVA420P9BE,
    AV_PIX_FMT_YUVA420P9LE,
    AV_PIX_FMT_YUVA422P9BE,
    AV_PIX_FMT_YUVA422P9LE,
    AV_PIX_FMT_YUVA444P9BE,
    AV_PIX_FMT_YUVA444P9LE,
    AV_PIX_FMT_YUVA420P10BE,
    AV_PIX_FMT_YUVA420P10LE,
    AV_PIX_FMT_YUVA422P10BE,
    AV_PIX_FMT_YUVA422P10LE,
    AV_PIX_FMT_YUVA444P10BE,
    AV_PIX_FMT_YUVA444P10LE,
    AV_PIX_FMT_YUVA420P16BE,
    AV_PIX_FMT_YUVA420P16LE,
    AV_PIX_FMT_YUVA422P16BE,
    AV_PIX_FMT_YUVA422P16LE,
    AV_PIX_FMT_YUVA444P16BE,
    AV_PIX_FMT_YUVA444P16LE,
    AV_PIX_FMT_VDPAU,
    AV_PIX_FMT_XYZ12LE,
    AV_PIX_FMT_XYZ12BE,
    AV_PIX_FMT_NV16,
    AV_PIX_FMT_NV20LE,
    AV_PIX_FMT_NV20BE,
    AV_PIX_FMT_NB,
    PIX_FMT_NONE,
    PIX_FMT_YUV420P,
    PIX_FMT_YUYV422,
    PIX_FMT_RGB24,
    PIX_FMT_BGR24,
    PIX_FMT_YUV422P,
    PIX_FMT_YUV444P,
    PIX_FMT_YUV410P,
    PIX_FMT_YUV411P,
    PIX_FMT_GRAY8,
    PIX_FMT_MONOWHITE,
    PIX_FMT_MONOBLACK,
    PIX_FMT_PAL8,
    PIX_FMT_YUVJ420P,
    PIX_FMT_YUVJ422P,
    PIX_FMT_YUVJ444P,
    PIX_FMT_XVMC_MPEG2_MC,
    PIX_FMT_XVMC_MPEG2_IDCT,
    PIX_FMT_UYVY422,
    PIX_FMT_UYYVYY411,
    PIX_FMT_BGR8,
    PIX_FMT_BGR4,
    PIX_FMT_BGR4_BYTE,
    PIX_FMT_RGB8,
    PIX_FMT_RGB4,
    PIX_FMT_RGB4_BYTE,
    PIX_FMT_NV12,
    PIX_FMT_NV21,
    PIX_FMT_ARGB,
    PIX_FMT_RGBA,
    PIX_FMT_ABGR,
    PIX_FMT_BGRA,
    PIX_FMT_GRAY16BE,
    PIX_FMT_GRAY16LE,
    PIX_FMT_YUV440P,
    PIX_FMT_YUVJ440P,
    PIX_FMT_YUVA420P,
    PIX_FMT_VDPAU_H264,
    PIX_FMT_VDPAU_MPEG1,
    PIX_FMT_VDPAU_MPEG2,
    PIX_FMT_VDPAU_WMV3,
    PIX_FMT_VDPAU_VC1,
    PIX_FMT_RGB48BE,
    PIX_FMT_RGB48LE,
    PIX_FMT_RGB565BE,
    PIX_FMT_RGB565LE,
    PIX_FMT_RGB555BE,
    PIX_FMT_RGB555LE,
    PIX_FMT_BGR565BE,
    PIX_FMT_BGR565LE,
    PIX_FMT_BGR555BE,
    PIX_FMT_BGR555LE,
    PIX_FMT_VAAPI_MOCO,
    PIX_FMT_VAAPI_IDCT,
    PIX_FMT_VAAPI_VLD,
    PIX_FMT_YUV420P16LE,
    PIX_FMT_YUV420P16BE,
    PIX_FMT_YUV422P16LE,
    PIX_FMT_YUV422P16BE,
    PIX_FMT_YUV444P16LE,
    PIX_FMT_YUV444P16BE,
    PIX_FMT_VDPAU_MPEG4,
    PIX_FMT_DXVA2_VLD,
    PIX_FMT_RGB444LE,
    PIX_FMT_RGB444BE,
    PIX_FMT_BGR444LE,
    PIX_FMT_BGR444BE,
    PIX_FMT_Y400A,
    PIX_FMT_BGR48BE,
    PIX_FMT_BGR48LE,
    PIX_FMT_YUV420P9BE,
    PIX_FMT_YUV420P9LE,
    PIX_FMT_YUV420P10BE,
    PIX_FMT_YUV420P10LE,
    PIX_FMT_YUV422P10BE,
    PIX_FMT_YUV422P10LE,
    PIX_FMT_YUV444P9BE,
    PIX_FMT_YUV444P9LE,
    PIX_FMT_YUV444P10BE,
    PIX_FMT_YUV444P10LE,
    PIX_FMT_YUV422P9BE,
    PIX_FMT_YUV422P9LE,
    PIX_FMT_VDA_VLD,
    PIX_FMT_GBRP,
    PIX_FMT_GBRP9BE,
    PIX_FMT_GBRP9LE,
    PIX_FMT_GBRP10BE,
    PIX_FMT_GBRP10LE,
    PIX_FMT_GBRP16BE,
    PIX_FMT_GBRP16LE,
    PIX_FMT_NB,
    PixelFormat,
    PIX_FMT_RGB32,
    PIX_FMT_RGB32_1,
    PIX_FMT_BGR32,
    PIX_FMT_BGR32_1,
    PIX_FMT_GRAY16,
    PIX_FMT_RGB48,
    PIX_FMT_RGB565,
    PIX_FMT_RGB555,
    PIX_FMT_RGB444,
    PIX_FMT_BGR48,
    PIX_FMT_BGR565,
    PIX_FMT_BGR555,
    PIX_FMT_BGR444,
    PIX_FMT_YUV420P9,
    PIX_FMT_YUV422P9,
    PIX_FMT_YUV444P9,
    PIX_FMT_YUV420P10,
    PIX_FMT_YUV422P10,
    PIX_FMT_YUV444P10,
    PIX_FMT_YUV420P16,
    PIX_FMT_YUV422P16,
    PIX_FMT_YUV444P16,
    PIX_FMT_GBRP9,
    PIX_FMT_GBRP10,
    PIX_FMT_GBRP16,
    AVSampleFormat,
    AV_SAMPLE_FMT_NONE,
    AV_SAMPLE_FMT_U8,
    AV_SAMPLE_FMT_S16,
    AV_SAMPLE_FMT_S32,
    AV_SAMPLE_FMT_FLT,
    AV_SAMPLE_FMT_DBL,
    AV_SAMPLE_FMT_U8P,
    AV_SAMPLE_FMT_S16P,
    AV_SAMPLE_FMT_S32P,
    AV_SAMPLE_FMT_FLTP,
    AV_SAMPLE_FMT_DBLP,
    AV_SAMPLE_FMT_NB,
    LIBAVUTIL_VERSION_MAJOR,
    LIBAVUTIL_VERSION_MINOR,
    LIBAVUTIL_VERSION_MICRO,
    LIBAVUTIL_BUILD,
    AVAudioFifo,
    AVDownmixType,
    AV_DOWNMIX_TYPE_UNKNOWN,
    AV_DOWNMIX_TYPE_LORO,
    AV_DOWNMIX_TYPE_LTRT,
    AV_DOWNMIX_TYPE_DPLII,
    AV_DOWNMIX_TYPE_NB,
    AVDownmixInfo,
    AV_OPT_FLAG_ENCODING_PARAM,
    AV_OPT_FLAG_DECODING_PARAM,
    AV_OPT_FLAG_METADATA,
    AV_OPT_FLAG_AUDIO_PARAM,
    AV_OPT_FLAG_VIDEO_PARAM,
    AV_OPT_FLAG_SUBTITLE_PARAM,
    AV_OPT_SEARCH_CHILDREN,
    AV_OPT_SEARCH_FAKE_OBJ,
    AV_STEREO3D_FLAG_INVERT,
    AVStereo3DType,
    AV_STEREO3D_2D,
    AV_STEREO3D_SIDEBYSIDE,
    AV_STEREO3D_TOPBOTTOM,
    AV_STEREO3D_FRAMESEQUENCE,
    AV_STEREO3D_CHECKERBOARD,
    AV_STEREO3D_SIDEBYSIDE_QUINCUNX,
    AV_STEREO3D_LINES,
    AV_STEREO3D_COLUMNS,
    AVStereo3D,
    Array_16_Uint32,
    AVXTEA


const FF_LAMBDA_SHIFT = 7
const FF_LAMBDA_SCALE = 1 << FF_LAMBDA_SHIFT
const FF_QP2LAMBDA = 118
const FF_LAMBDA_MAX = 256 * 128 - 1
const FF_QUALITY_SCALE = FF_LAMBDA_SCALE

const AV_NOPTS_VALUE = reinterpret(Int64, 0x8000000000000000)

const AV_TIME_BASE = 1000000

immutable AVRational
    num::Cint
    den::Cint
end

const AV_TIME_BASE_Q = AVRational( 1 , AV_TIME_BASE )

# begin enum AVMediaType
typealias AVMediaType Cint
const AVMEDIA_TYPE_UNKNOWN = @compat Int32(-1)
const AVMEDIA_TYPE_VIDEO = @compat Int32(0)
const AVMEDIA_TYPE_AUDIO = @compat Int32(1)
const AVMEDIA_TYPE_DATA = @compat Int32(2)
const AVMEDIA_TYPE_SUBTITLE = @compat Int32(3)
const AVMEDIA_TYPE_ATTACHMENT = @compat Int32(4)
const AVMEDIA_TYPE_NB = @compat Int32(5)
# end enum AVMediaType

# begin enum AVPictureType
typealias AVPictureType UInt32
const AV_PICTURE_TYPE_I = @compat UInt32(1)
const AV_PICTURE_TYPE_P = @compat UInt32(2)
const AV_PICTURE_TYPE_B = @compat UInt32(3)
const AV_PICTURE_TYPE_S = @compat UInt32(4)
const AV_PICTURE_TYPE_SI = @compat UInt32(5)
const AV_PICTURE_TYPE_SP = @compat UInt32(6)
const AV_PICTURE_TYPE_BI = @compat UInt32(7)
# end enum AVPictureType

const AV_BUFFER_FLAG_READONLY = 1 << 0

typealias AVBuffer Void

immutable AVBufferRef
    buffer::Ptr{AVBuffer}
    data::Ptr{UInt8}
    size::Cint
end

typealias AVBufferPool Void

const AV_CH_FRONT_LEFT = 0x00000001
const AV_CH_FRONT_RIGHT = 0x00000002
const AV_CH_FRONT_CENTER = 0x00000004
const AV_CH_LOW_FREQUENCY = 0x00000008
const AV_CH_BACK_LEFT = 0x00000010
const AV_CH_BACK_RIGHT = 0x00000020
const AV_CH_FRONT_LEFT_OF_CENTER = 0x00000040
const AV_CH_FRONT_RIGHT_OF_CENTER = 0x00000080
const AV_CH_BACK_CENTER = 0x00000100
const AV_CH_SIDE_LEFT = 0x00000200
const AV_CH_SIDE_RIGHT = 0x00000400
const AV_CH_TOP_CENTER = 0x00000800
const AV_CH_TOP_FRONT_LEFT = 0x00001000
const AV_CH_TOP_FRONT_CENTER = 0x00002000
const AV_CH_TOP_FRONT_RIGHT = 0x00004000
const AV_CH_TOP_BACK_LEFT = 0x00008000
const AV_CH_TOP_BACK_CENTER = 0x00010000
const AV_CH_TOP_BACK_RIGHT = 0x00020000
const AV_CH_STEREO_LEFT = 0x20000000
const AV_CH_STEREO_RIGHT = 0x40000000
const AV_CH_WIDE_LEFT = 0x0000000080000000
const AV_CH_WIDE_RIGHT = 0x0000000100000000
const AV_CH_SURROUND_DIRECT_LEFT = 0x0000000200000000
const AV_CH_SURROUND_DIRECT_RIGHT = 0x0000000400000000
const AV_CH_LOW_FREQUENCY_2 = 0x0000000800000000
const AV_CH_LAYOUT_NATIVE = 0x8000000000000000
const AV_CH_LAYOUT_MONO = AV_CH_FRONT_CENTER
const AV_CH_LAYOUT_STEREO = AV_CH_FRONT_LEFT | AV_CH_FRONT_RIGHT
const AV_CH_LAYOUT_2POINT1 = AV_CH_LAYOUT_STEREO | AV_CH_LOW_FREQUENCY
const AV_CH_LAYOUT_2_1 = AV_CH_LAYOUT_STEREO | AV_CH_BACK_CENTER
const AV_CH_LAYOUT_SURROUND = AV_CH_LAYOUT_STEREO | AV_CH_FRONT_CENTER
const AV_CH_LAYOUT_3POINT1 = AV_CH_LAYOUT_SURROUND | AV_CH_LOW_FREQUENCY
const AV_CH_LAYOUT_4POINT0 = AV_CH_LAYOUT_SURROUND | AV_CH_BACK_CENTER
const AV_CH_LAYOUT_4POINT1 = AV_CH_LAYOUT_4POINT0 | AV_CH_LOW_FREQUENCY
const AV_CH_LAYOUT_2_2 = (AV_CH_LAYOUT_STEREO | AV_CH_SIDE_LEFT) | AV_CH_SIDE_RIGHT
const AV_CH_LAYOUT_QUAD = (AV_CH_LAYOUT_STEREO | AV_CH_BACK_LEFT) | AV_CH_BACK_RIGHT
const AV_CH_LAYOUT_5POINT0 = (AV_CH_LAYOUT_SURROUND | AV_CH_SIDE_LEFT) | AV_CH_SIDE_RIGHT
const AV_CH_LAYOUT_5POINT1 = AV_CH_LAYOUT_5POINT0 | AV_CH_LOW_FREQUENCY
const AV_CH_LAYOUT_5POINT0_BACK = (AV_CH_LAYOUT_SURROUND | AV_CH_BACK_LEFT) | AV_CH_BACK_RIGHT
const AV_CH_LAYOUT_5POINT1_BACK = AV_CH_LAYOUT_5POINT0_BACK | AV_CH_LOW_FREQUENCY
const AV_CH_LAYOUT_6POINT0 = AV_CH_LAYOUT_5POINT0 | AV_CH_BACK_CENTER
const AV_CH_LAYOUT_6POINT0_FRONT = (AV_CH_LAYOUT_2_2 | AV_CH_FRONT_LEFT_OF_CENTER) | AV_CH_FRONT_RIGHT_OF_CENTER
const AV_CH_LAYOUT_HEXAGONAL = AV_CH_LAYOUT_5POINT0_BACK | AV_CH_BACK_CENTER
const AV_CH_LAYOUT_6POINT1 = AV_CH_LAYOUT_5POINT1 | AV_CH_BACK_CENTER
const AV_CH_LAYOUT_6POINT1_BACK = AV_CH_LAYOUT_5POINT1_BACK | AV_CH_BACK_CENTER
const AV_CH_LAYOUT_6POINT1_FRONT = AV_CH_LAYOUT_6POINT0_FRONT | AV_CH_LOW_FREQUENCY
const AV_CH_LAYOUT_7POINT0 = (AV_CH_LAYOUT_5POINT0 | AV_CH_BACK_LEFT) | AV_CH_BACK_RIGHT
const AV_CH_LAYOUT_7POINT0_FRONT = (AV_CH_LAYOUT_5POINT0 | AV_CH_FRONT_LEFT_OF_CENTER) | AV_CH_FRONT_RIGHT_OF_CENTER
const AV_CH_LAYOUT_7POINT1 = (AV_CH_LAYOUT_5POINT1 | AV_CH_BACK_LEFT) | AV_CH_BACK_RIGHT
const AV_CH_LAYOUT_7POINT1_WIDE = (AV_CH_LAYOUT_5POINT1 | AV_CH_FRONT_LEFT_OF_CENTER) | AV_CH_FRONT_RIGHT_OF_CENTER
const AV_CH_LAYOUT_7POINT1_WIDE_BACK = (AV_CH_LAYOUT_5POINT1_BACK | AV_CH_FRONT_LEFT_OF_CENTER) | AV_CH_FRONT_RIGHT_OF_CENTER
const AV_CH_LAYOUT_OCTAGONAL = ((AV_CH_LAYOUT_5POINT0 | AV_CH_BACK_LEFT) | AV_CH_BACK_CENTER) | AV_CH_BACK_RIGHT
const AV_CH_LAYOUT_STEREO_DOWNMIX = AV_CH_STEREO_LEFT | AV_CH_STEREO_RIGHT

# begin enum AVMatrixEncoding
typealias AVMatrixEncoding UInt32
const AV_MATRIX_ENCODING_NONE = @compat UInt32(0)
const AV_MATRIX_ENCODING_DOLBY = @compat UInt32(1)
const AV_MATRIX_ENCODING_DPLII = @compat UInt32(2)
const AV_MATRIX_ENCODING_DPLIIX = @compat UInt32(3)
const AV_MATRIX_ENCODING_DPLIIZ = @compat UInt32(4)
const AV_MATRIX_ENCODING_DOLBYEX = @compat UInt32(5)
const AV_MATRIX_ENCODING_DOLBYHEADPHONE = @compat UInt32(6)
const AV_MATRIX_ENCODING_NB = @compat UInt32(7)
# end enum AVMatrixEncoding

const AV_DICT_MATCH_CASE = 1
const AV_DICT_IGNORE_SUFFIX = 2
const AV_DICT_DONT_STRDUP_KEY = 4
const AV_DICT_DONT_STRDUP_VAL = 8
const AV_DICT_DONT_OVERWRITE = 16
const AV_DICT_APPEND = 32

immutable AVDictionaryEntry
    key::Ptr{UInt8}
    value::Ptr{UInt8}
end

typealias AVDictionary Void

immutable AVFifoBuffer
    buffer::Ptr{UInt8}
    rptr::Ptr{UInt8}
    wptr::Ptr{UInt8}
    _end::Ptr{UInt8}
    rndx::UInt32
    wndx::UInt32
end

const AV_NUM_DATA_POINTERS = 8
const AV_FRAME_FLAG_CORRUPT = 1 << 0

# begin enum AVFrameSideDataType
typealias AVFrameSideDataType UInt32
const AV_FRAME_DATA_PANSCAN = @compat UInt32(0)
const AV_FRAME_DATA_A53_CC = @compat UInt32(1)
const AV_FRAME_DATA_STEREO3D = @compat UInt32(2)
const AV_FRAME_DATA_MATRIXENCODING = @compat UInt32(3)
const AV_FRAME_DATA_DOWNMIX_INFO = @compat UInt32(4)
# end enum AVFrameSideDataType

immutable AVFrameSideData
    _type::AVFrameSideDataType
    data::Ptr{UInt8}
    size::Cint
    metadata::Ptr{AVDictionary}
end

immutable Array_8_Ptr
    d1::Ptr{UInt8}
    d2::Ptr{UInt8}
    d3::Ptr{UInt8}
    d4::Ptr{UInt8}
    d5::Ptr{UInt8}
    d6::Ptr{UInt8}
    d7::Ptr{UInt8}
    d8::Ptr{UInt8}
end

zero(::Type{Array_8_Ptr}) = Array_8_Ptr(fill(C_NULL,8)...)

immutable Array_8_Cint
    d1::Cint
    d2::Cint
    d3::Cint
    d4::Cint
    d5::Cint
    d6::Cint
    d7::Cint
    d8::Cint
end

zero(::Type{Array_8_Cint}) = Array_8_Cint(fill(zero(Cint),8)...)

immutable Array_2_Ptr
    d1::Ptr{Void}
    d2::Ptr{Void}
end

zero(::Type{Array_2_Ptr}) = Array_2_Ptr(fill(C_NULL,2)...)

immutable Array_8_Uint64
    d1::UInt64
    d2::UInt64
    d3::UInt64
    d4::UInt64
    d5::UInt64
    d6::UInt64
    d7::UInt64
    d8::UInt64
end

zero(::Type{Array_8_Uint64}) = Array_8_Uint64(fill(zero(UInt64),8)...)

immutable AVFrame
    data::Array_8_Ptr
    linesize::Array_8_Cint
    extended_data::Ptr{Ptr{UInt8}}
    width::Cint
    height::Cint
    nb_samples::Cint
    format::Cint
    key_frame::Cint
    pict_type::AVPictureType
    base::Array_8_Ptr
    sample_aspect_ratio::AVRational
    pts::Int64
    pkt_pts::Int64
    pkt_dts::Int64
    coded_picture_number::Cint
    display_picture_number::Cint
    quality::Cint
    reference::Cint
    qscale_table::Ptr{Int8}
    qstride::Cint
    qscale_type::Cint
    mbskip_table::Ptr{UInt8}
    motion_val::Array_2_Ptr
    mb_type::Ptr{UInt32}
    dct_coeff::Ptr{Int16}
    ref_index::Array_2_Ptr
    opaque::Ptr{Void}
    error::Array_8_Uint64
    _type::Cint
    repeat_pict::Cint
    interlaced_frame::Cint
    top_field_first::Cint
    palette_has_changed::Cint
    buffer_hints::Cint
    pan_scan::Ptr{Void}  #Ptr{AVPanScan}
    reordered_opaque::Int64
    hwaccel_picture_private::Ptr{Void}
    owner::Ptr{Void} #Ptr{AVCodecContext}
    thread_opaque::Ptr{Void}
    motion_subsample_log2::UInt8
    sample_rate::Cint
    channel_layout::UInt64
    buf::Array_8_Ptr
    extended_buf::Ptr{Ptr{AVBufferRef}}
    nb_extended_buf::Cint
    side_data::Ptr{Ptr{AVFrameSideData}}
    nb_side_data::Cint
    flags::Cint
end

const AV_LOG_QUIET = -8
const AV_LOG_PANIC = 0
const AV_LOG_FATAL = 8
const AV_LOG_ERROR = 16
const AV_LOG_WARNING = 24
const AV_LOG_INFO = 32
const AV_LOG_VERBOSE = 40
const AV_LOG_DEBUG = 48

# Skipping MacroDefinition: av_dlog ( pctx , ... )

const AV_LOG_SKIP_REPEATED = 1

# begin enum AVOptionType
typealias AVOptionType UInt32
const AV_OPT_TYPE_FLAGS = @compat UInt32(0)
const AV_OPT_TYPE_INT = @compat UInt32(1)
const AV_OPT_TYPE_INT64 = @compat UInt32(2)
const AV_OPT_TYPE_DOUBLE = @compat UInt32(3)
const AV_OPT_TYPE_FLOAT = @compat UInt32(4)
const AV_OPT_TYPE_STRING = @compat UInt32(5)
const AV_OPT_TYPE_RATIONAL = @compat UInt32(6)
const AV_OPT_TYPE_BINARY = @compat UInt32(7)
const AV_OPT_TYPE_CONST = @compat UInt32(128)
# end enum AVOptionType

immutable AVOption
    name::Ptr{UInt8}
    help::Ptr{UInt8}
    offset::Cint
    _type::AVOptionType
    default_val::Void
    min::Cdouble
    max::Cdouble
    flags::Cint
    unit::Ptr{UInt8}
end

immutable AVClass
    class_name::Ptr{UInt8}
    item_name::Ptr{Void}
    option::Ptr{AVOption}
    version::Cint
    log_level_offset_offset::Cint
    parent_log_context_offset::Cint
    child_next::Ptr{Void}
    child_class_next::Ptr{Void}
end

const AV_PIX_FMT_FLAG_BE = 1 << 0
const AV_PIX_FMT_FLAG_PAL = 1 << 1
const AV_PIX_FMT_FLAG_BITSTREAM = 1 << 2
const AV_PIX_FMT_FLAG_HWACCEL = 1 << 3
const AV_PIX_FMT_FLAG_PLANAR = 1 << 4
const AV_PIX_FMT_FLAG_RGB = 1 << 5
const AV_PIX_FMT_FLAG_PSEUDOPAL = 1 << 6
const AV_PIX_FMT_FLAG_ALPHA = 1 << 7
const PIX_FMT_BE = AV_PIX_FMT_FLAG_BE
const PIX_FMT_PAL = AV_PIX_FMT_FLAG_PAL
const PIX_FMT_BITSTREAM = AV_PIX_FMT_FLAG_BITSTREAM
const PIX_FMT_HWACCEL = AV_PIX_FMT_FLAG_HWACCEL
const PIX_FMT_PLANAR = AV_PIX_FMT_FLAG_PLANAR
const PIX_FMT_RGB = AV_PIX_FMT_FLAG_RGB
const PIX_FMT_PSEUDOPAL = AV_PIX_FMT_FLAG_PSEUDOPAL
const PIX_FMT_ALPHA = AV_PIX_FMT_FLAG_ALPHA

immutable AVComponentDescriptor
    plane::UInt16
    step_minus1::UInt16
    offset_plus1::UInt16
    shift::UInt16
    depth_minus1::UInt16
end

immutable Array_4_AVComponentDescriptor
    d1::AVComponentDescriptor
    d2::AVComponentDescriptor
    d3::AVComponentDescriptor
    d4::AVComponentDescriptor
end

zero(::Type{Array_4_AVComponentDescriptor}) = Array_4_AVComponentDescriptor(fill(zero(AVComponentDescriptor),4)...)

immutable AVPixFmtDescriptor
    name::Ptr{UInt8}
    nb_components::UInt8
    log2_chroma_w::UInt8
    log2_chroma_h::UInt8
    flags::UInt8
    comp::Array_4_AVComponentDescriptor
end


# begin enum AVPixelFormat
typealias AVPixelFormat Cint
const AV_PIX_FMT_NONE = @compat Int32(-1)
const AV_PIX_FMT_YUV420P = @compat Int32(0)
const AV_PIX_FMT_YUYV422 = @compat Int32(1)
const AV_PIX_FMT_RGB24 = @compat Int32(2)
const AV_PIX_FMT_BGR24 = @compat Int32(3)
const AV_PIX_FMT_YUV422P = @compat Int32(4)
const AV_PIX_FMT_YUV444P = @compat Int32(5)
const AV_PIX_FMT_YUV410P = @compat Int32(6)
const AV_PIX_FMT_YUV411P = @compat Int32(7)
const AV_PIX_FMT_GRAY8 = @compat Int32(8)
const AV_PIX_FMT_MONOWHITE = @compat Int32(9)
const AV_PIX_FMT_MONOBLACK = @compat Int32(10)
const AV_PIX_FMT_PAL8 = @compat Int32(11)
const AV_PIX_FMT_YUVJ420P = @compat Int32(12)
const AV_PIX_FMT_YUVJ422P = @compat Int32(13)
const AV_PIX_FMT_YUVJ444P = @compat Int32(14)
const AV_PIX_FMT_XVMC_MPEG2_MC = @compat Int32(15)
const AV_PIX_FMT_XVMC_MPEG2_IDCT = @compat Int32(16)
const AV_PIX_FMT_UYVY422 = @compat Int32(17)
const AV_PIX_FMT_UYYVYY411 = @compat Int32(18)
const AV_PIX_FMT_BGR8 = @compat Int32(19)
const AV_PIX_FMT_BGR4 = @compat Int32(20)
const AV_PIX_FMT_BGR4_BYTE = @compat Int32(21)
const AV_PIX_FMT_RGB8 = @compat Int32(22)
const AV_PIX_FMT_RGB4 = @compat Int32(23)
const AV_PIX_FMT_RGB4_BYTE = @compat Int32(24)
const AV_PIX_FMT_NV12 = @compat Int32(25)
const AV_PIX_FMT_NV21 = @compat Int32(26)
const AV_PIX_FMT_ARGB = @compat Int32(27)
const AV_PIX_FMT_RGBA = @compat Int32(28)
const AV_PIX_FMT_ABGR = @compat Int32(29)
const AV_PIX_FMT_BGRA = @compat Int32(30)
const AV_PIX_FMT_GRAY16BE = @compat Int32(31)
const AV_PIX_FMT_GRAY16LE = @compat Int32(32)
const AV_PIX_FMT_YUV440P = @compat Int32(33)
const AV_PIX_FMT_YUVJ440P = @compat Int32(34)
const AV_PIX_FMT_YUVA420P = @compat Int32(35)
const AV_PIX_FMT_VDPAU_H264 = @compat Int32(36)
const AV_PIX_FMT_VDPAU_MPEG1 = @compat Int32(37)
const AV_PIX_FMT_VDPAU_MPEG2 = @compat Int32(38)
const AV_PIX_FMT_VDPAU_WMV3 = @compat Int32(39)
const AV_PIX_FMT_VDPAU_VC1 = @compat Int32(40)
const AV_PIX_FMT_RGB48BE = @compat Int32(41)
const AV_PIX_FMT_RGB48LE = @compat Int32(42)
const AV_PIX_FMT_RGB565BE = @compat Int32(43)
const AV_PIX_FMT_RGB565LE = @compat Int32(44)
const AV_PIX_FMT_RGB555BE = @compat Int32(45)
const AV_PIX_FMT_RGB555LE = @compat Int32(46)
const AV_PIX_FMT_BGR565BE = @compat Int32(47)
const AV_PIX_FMT_BGR565LE = @compat Int32(48)
const AV_PIX_FMT_BGR555BE = @compat Int32(49)
const AV_PIX_FMT_BGR555LE = @compat Int32(50)
const AV_PIX_FMT_VAAPI_MOCO = @compat Int32(51)
const AV_PIX_FMT_VAAPI_IDCT = @compat Int32(52)
const AV_PIX_FMT_VAAPI_VLD = @compat Int32(53)
const AV_PIX_FMT_YUV420P16LE = @compat Int32(54)
const AV_PIX_FMT_YUV420P16BE = @compat Int32(55)
const AV_PIX_FMT_YUV422P16LE = @compat Int32(56)
const AV_PIX_FMT_YUV422P16BE = @compat Int32(57)
const AV_PIX_FMT_YUV444P16LE = @compat Int32(58)
const AV_PIX_FMT_YUV444P16BE = @compat Int32(59)
const AV_PIX_FMT_VDPAU_MPEG4 = @compat Int32(60)
const AV_PIX_FMT_DXVA2_VLD = @compat Int32(61)
const AV_PIX_FMT_RGB444LE = @compat Int32(62)
const AV_PIX_FMT_RGB444BE = @compat Int32(63)
const AV_PIX_FMT_BGR444LE = @compat Int32(64)
const AV_PIX_FMT_BGR444BE = @compat Int32(65)
const AV_PIX_FMT_Y400A = @compat Int32(66)
const AV_PIX_FMT_BGR48BE = @compat Int32(67)
const AV_PIX_FMT_BGR48LE = @compat Int32(68)
const AV_PIX_FMT_YUV420P9BE = @compat Int32(69)
const AV_PIX_FMT_YUV420P9LE = @compat Int32(70)
const AV_PIX_FMT_YUV420P10BE = @compat Int32(71)
const AV_PIX_FMT_YUV420P10LE = @compat Int32(72)
const AV_PIX_FMT_YUV422P10BE = @compat Int32(73)
const AV_PIX_FMT_YUV422P10LE = @compat Int32(74)
const AV_PIX_FMT_YUV444P9BE = @compat Int32(75)
const AV_PIX_FMT_YUV444P9LE = @compat Int32(76)
const AV_PIX_FMT_YUV444P10BE = @compat Int32(77)
const AV_PIX_FMT_YUV444P10LE = @compat Int32(78)
const AV_PIX_FMT_YUV422P9BE = @compat Int32(79)
const AV_PIX_FMT_YUV422P9LE = @compat Int32(80)
const AV_PIX_FMT_VDA_VLD = @compat Int32(81)
const AV_PIX_FMT_GBRP = @compat Int32(82)
const AV_PIX_FMT_GBRP9BE = @compat Int32(83)
const AV_PIX_FMT_GBRP9LE = @compat Int32(84)
const AV_PIX_FMT_GBRP10BE = @compat Int32(85)
const AV_PIX_FMT_GBRP10LE = @compat Int32(86)
const AV_PIX_FMT_GBRP16BE = @compat Int32(87)
const AV_PIX_FMT_GBRP16LE = @compat Int32(88)
const AV_PIX_FMT_YUVA422P = @compat Int32(89)
const AV_PIX_FMT_YUVA444P = @compat Int32(90)
const AV_PIX_FMT_YUVA420P9BE = @compat Int32(91)
const AV_PIX_FMT_YUVA420P9LE = @compat Int32(92)
const AV_PIX_FMT_YUVA422P9BE = @compat Int32(93)
const AV_PIX_FMT_YUVA422P9LE = @compat Int32(94)
const AV_PIX_FMT_YUVA444P9BE = @compat Int32(95)
const AV_PIX_FMT_YUVA444P9LE = @compat Int32(96)
const AV_PIX_FMT_YUVA420P10BE = @compat Int32(97)
const AV_PIX_FMT_YUVA420P10LE = @compat Int32(98)
const AV_PIX_FMT_YUVA422P10BE = @compat Int32(99)
const AV_PIX_FMT_YUVA422P10LE = @compat Int32(100)
const AV_PIX_FMT_YUVA444P10BE = @compat Int32(101)
const AV_PIX_FMT_YUVA444P10LE = @compat Int32(102)
const AV_PIX_FMT_YUVA420P16BE = @compat Int32(103)
const AV_PIX_FMT_YUVA420P16LE = @compat Int32(104)
const AV_PIX_FMT_YUVA422P16BE = @compat Int32(105)
const AV_PIX_FMT_YUVA422P16LE = @compat Int32(106)
const AV_PIX_FMT_YUVA444P16BE = @compat Int32(107)
const AV_PIX_FMT_YUVA444P16LE = @compat Int32(108)
const AV_PIX_FMT_VDPAU = @compat Int32(109)
const AV_PIX_FMT_XYZ12LE = @compat Int32(110)
const AV_PIX_FMT_XYZ12BE = @compat Int32(111)
const AV_PIX_FMT_NV16 = @compat Int32(112)
const AV_PIX_FMT_NV20LE = @compat Int32(113)
const AV_PIX_FMT_NV20BE = @compat Int32(114)
const AV_PIX_FMT_NB = @compat Int32(115)
const PIX_FMT_NONE = @compat Int32(-1)
const PIX_FMT_YUV420P = @compat Int32(0)
const PIX_FMT_YUYV422 = @compat Int32(1)
const PIX_FMT_RGB24 = @compat Int32(2)
const PIX_FMT_BGR24 = @compat Int32(3)
const PIX_FMT_YUV422P = @compat Int32(4)
const PIX_FMT_YUV444P = @compat Int32(5)
const PIX_FMT_YUV410P = @compat Int32(6)
const PIX_FMT_YUV411P = @compat Int32(7)
const PIX_FMT_GRAY8 = @compat Int32(8)
const PIX_FMT_MONOWHITE = @compat Int32(9)
const PIX_FMT_MONOBLACK = @compat Int32(10)
const PIX_FMT_PAL8 = @compat Int32(11)
const PIX_FMT_YUVJ420P = @compat Int32(12)
const PIX_FMT_YUVJ422P = @compat Int32(13)
const PIX_FMT_YUVJ444P = @compat Int32(14)
const PIX_FMT_XVMC_MPEG2_MC = @compat Int32(15)
const PIX_FMT_XVMC_MPEG2_IDCT = @compat Int32(16)
const PIX_FMT_UYVY422 = @compat Int32(17)
const PIX_FMT_UYYVYY411 = @compat Int32(18)
const PIX_FMT_BGR8 = @compat Int32(19)
const PIX_FMT_BGR4 = @compat Int32(20)
const PIX_FMT_BGR4_BYTE = @compat Int32(21)
const PIX_FMT_RGB8 = @compat Int32(22)
const PIX_FMT_RGB4 = @compat Int32(23)
const PIX_FMT_RGB4_BYTE = @compat Int32(24)
const PIX_FMT_NV12 = @compat Int32(25)
const PIX_FMT_NV21 = @compat Int32(26)
const PIX_FMT_ARGB = @compat Int32(27)
const PIX_FMT_RGBA = @compat Int32(28)
const PIX_FMT_ABGR = @compat Int32(29)
const PIX_FMT_BGRA = @compat Int32(30)
const PIX_FMT_GRAY16BE = @compat Int32(31)
const PIX_FMT_GRAY16LE = @compat Int32(32)
const PIX_FMT_YUV440P = @compat Int32(33)
const PIX_FMT_YUVJ440P = @compat Int32(34)
const PIX_FMT_YUVA420P = @compat Int32(35)
const PIX_FMT_VDPAU_H264 = @compat Int32(36)
const PIX_FMT_VDPAU_MPEG1 = @compat Int32(37)
const PIX_FMT_VDPAU_MPEG2 = @compat Int32(38)
const PIX_FMT_VDPAU_WMV3 = @compat Int32(39)
const PIX_FMT_VDPAU_VC1 = @compat Int32(40)
const PIX_FMT_RGB48BE = @compat Int32(41)
const PIX_FMT_RGB48LE = @compat Int32(42)
const PIX_FMT_RGB565BE = @compat Int32(43)
const PIX_FMT_RGB565LE = @compat Int32(44)
const PIX_FMT_RGB555BE = @compat Int32(45)
const PIX_FMT_RGB555LE = @compat Int32(46)
const PIX_FMT_BGR565BE = @compat Int32(47)
const PIX_FMT_BGR565LE = @compat Int32(48)
const PIX_FMT_BGR555BE = @compat Int32(49)
const PIX_FMT_BGR555LE = @compat Int32(50)
const PIX_FMT_VAAPI_MOCO = @compat Int32(51)
const PIX_FMT_VAAPI_IDCT = @compat Int32(52)
const PIX_FMT_VAAPI_VLD = @compat Int32(53)
const PIX_FMT_YUV420P16LE = @compat Int32(54)
const PIX_FMT_YUV420P16BE = @compat Int32(55)
const PIX_FMT_YUV422P16LE = @compat Int32(56)
const PIX_FMT_YUV422P16BE = @compat Int32(57)
const PIX_FMT_YUV444P16LE = @compat Int32(58)
const PIX_FMT_YUV444P16BE = @compat Int32(59)
const PIX_FMT_VDPAU_MPEG4 = @compat Int32(60)
const PIX_FMT_DXVA2_VLD = @compat Int32(61)
const PIX_FMT_RGB444LE = @compat Int32(62)
const PIX_FMT_RGB444BE = @compat Int32(63)
const PIX_FMT_BGR444LE = @compat Int32(64)
const PIX_FMT_BGR444BE = @compat Int32(65)
const PIX_FMT_Y400A = @compat Int32(66)
const PIX_FMT_BGR48BE = @compat Int32(67)
const PIX_FMT_BGR48LE = @compat Int32(68)
const PIX_FMT_YUV420P9BE = @compat Int32(69)
const PIX_FMT_YUV420P9LE = @compat Int32(70)
const PIX_FMT_YUV420P10BE = @compat Int32(71)
const PIX_FMT_YUV420P10LE = @compat Int32(72)
const PIX_FMT_YUV422P10BE = @compat Int32(73)
const PIX_FMT_YUV422P10LE = @compat Int32(74)
const PIX_FMT_YUV444P9BE = @compat Int32(75)
const PIX_FMT_YUV444P9LE = @compat Int32(76)
const PIX_FMT_YUV444P10BE = @compat Int32(77)
const PIX_FMT_YUV444P10LE = @compat Int32(78)
const PIX_FMT_YUV422P9BE = @compat Int32(79)
const PIX_FMT_YUV422P9LE = @compat Int32(80)
const PIX_FMT_VDA_VLD = @compat Int32(81)
const PIX_FMT_GBRP = @compat Int32(82)
const PIX_FMT_GBRP9BE = @compat Int32(83)
const PIX_FMT_GBRP9LE = @compat Int32(84)
const PIX_FMT_GBRP10BE = @compat Int32(85)
const PIX_FMT_GBRP10LE = @compat Int32(86)
const PIX_FMT_GBRP16BE = @compat Int32(87)
const PIX_FMT_GBRP16LE = @compat Int32(88)
const PIX_FMT_NB = @compat Int32(89)
# end enum AVPixelFormat

const PixelFormat = AVPixelFormat


macro AV_PIX_FMT_NE(be,le)
    symbol("AV_PIX_FMT_"*string(le))
end
 
const AV_PIX_FMT_RGB32 = @AV_PIX_FMT_NE(ARGB,BGRA)
const AV_PIX_FMT_RGB32_1 = @AV_PIX_FMT_NE(RGBA,ABGR)
const AV_PIX_FMT_BGR32 = @AV_PIX_FMT_NE(ABGR,RGBA)
const AV_PIX_FMT_BGR32_1 = @AV_PIX_FMT_NE(BGRA,ARGB)
const AV_PIX_FMT_GRAY16 = @AV_PIX_FMT_NE(GRAY16BE,GRAY16LE)
const AV_PIX_FMT_RGB48 = @AV_PIX_FMT_NE(RGB48BE,RGB48LE)
const AV_PIX_FMT_RGB565 = @AV_PIX_FMT_NE(RGB565BE,RGB565LE)
const AV_PIX_FMT_RGB555 = @AV_PIX_FMT_NE(RGB555BE,RGB555LE)
const AV_PIX_FMT_RGB444 = @AV_PIX_FMT_NE(RGB444BE,RGB444LE)
const AV_PIX_FMT_BGR48 = @AV_PIX_FMT_NE(BGR48BE,BGR48LE)
const AV_PIX_FMT_BGR565 = @AV_PIX_FMT_NE(BGR565BE,BGR565LE)
const AV_PIX_FMT_BGR555 = @AV_PIX_FMT_NE(BGR555BE,BGR555LE)
const AV_PIX_FMT_BGR444 = @AV_PIX_FMT_NE(BGR444BE,BGR444LE)
const AV_PIX_FMT_YUV420P9 = @AV_PIX_FMT_NE(YUV420P9BE,YUV420P9LE)
const AV_PIX_FMT_YUV422P9 = @AV_PIX_FMT_NE(YUV422P9BE,YUV422P9LE)
const AV_PIX_FMT_YUV444P9 = @AV_PIX_FMT_NE(YUV444P9BE,YUV444P9LE)
const AV_PIX_FMT_YUV420P10 = @AV_PIX_FMT_NE(YUV420P10BE,YUV420P10LE)
const AV_PIX_FMT_YUV422P10 = @AV_PIX_FMT_NE(YUV422P10BE,YUV422P10LE)
const AV_PIX_FMT_YUV444P10 = @AV_PIX_FMT_NE(YUV444P10BE,YUV444P10LE)
const AV_PIX_FMT_YUV420P16 = @AV_PIX_FMT_NE(YUV420P16BE,YUV420P16LE)
const AV_PIX_FMT_YUV422P16 = @AV_PIX_FMT_NE(YUV422P16BE,YUV422P16LE)
const AV_PIX_FMT_YUV444P16 = @AV_PIX_FMT_NE(YUV444P16BE,YUV444P16LE)
const AV_PIX_FMT_GBRP9 = @AV_PIX_FMT_NE(GBRP9BE,GBRP9LE)
const AV_PIX_FMT_GBRP10 = @AV_PIX_FMT_NE(GBRP10BE,GBRP10LE)
const AV_PIX_FMT_GBRP16 = @AV_PIX_FMT_NE(GBRP16BE,GBRP16LE)

const PIX_FMT_RGB32 = AV_PIX_FMT_RGB32
const PIX_FMT_RGB32_1 = AV_PIX_FMT_RGB32_1
const PIX_FMT_BGR32 = AV_PIX_FMT_BGR32
const PIX_FMT_BGR32_1 = AV_PIX_FMT_BGR32_1
const PIX_FMT_GRAY16 = AV_PIX_FMT_GRAY16
const PIX_FMT_RGB48 = AV_PIX_FMT_RGB48
const PIX_FMT_RGB565 = AV_PIX_FMT_RGB565
const PIX_FMT_RGB555 = AV_PIX_FMT_RGB555
const PIX_FMT_RGB444 = AV_PIX_FMT_RGB444
const PIX_FMT_BGR48 = AV_PIX_FMT_BGR48
const PIX_FMT_BGR565 = AV_PIX_FMT_BGR565
const PIX_FMT_BGR555 = AV_PIX_FMT_BGR555
const PIX_FMT_BGR444 = AV_PIX_FMT_BGR444
const PIX_FMT_YUV420P9 = AV_PIX_FMT_YUV420P9
const PIX_FMT_YUV422P9 = AV_PIX_FMT_YUV422P9
const PIX_FMT_YUV444P9 = AV_PIX_FMT_YUV444P9
const PIX_FMT_YUV420P10 = AV_PIX_FMT_YUV420P10
const PIX_FMT_YUV422P10 = AV_PIX_FMT_YUV422P10
const PIX_FMT_YUV444P10 = AV_PIX_FMT_YUV444P10
const PIX_FMT_YUV420P16 = AV_PIX_FMT_YUV420P16
const PIX_FMT_YUV422P16 = AV_PIX_FMT_YUV422P16
const PIX_FMT_YUV444P16 = AV_PIX_FMT_YUV444P16
const PIX_FMT_GBRP9 = AV_PIX_FMT_GBRP9
const PIX_FMT_GBRP10 = AV_PIX_FMT_GBRP10
const PIX_FMT_GBRP16 = AV_PIX_FMT_GBRP16

# begin enum AVSampleFormat
typealias AVSampleFormat Cint
const AV_SAMPLE_FMT_NONE = @compat Int32(-1)
const AV_SAMPLE_FMT_U8 = @compat Int32(0)
const AV_SAMPLE_FMT_S16 = @compat Int32(1)
const AV_SAMPLE_FMT_S32 = @compat Int32(2)
const AV_SAMPLE_FMT_FLT = @compat Int32(3)
const AV_SAMPLE_FMT_DBL = @compat Int32(4)
const AV_SAMPLE_FMT_U8P = @compat Int32(5)
const AV_SAMPLE_FMT_S16P = @compat Int32(6)
const AV_SAMPLE_FMT_S32P = @compat Int32(7)
const AV_SAMPLE_FMT_FLTP = @compat Int32(8)
const AV_SAMPLE_FMT_DBLP = @compat Int32(9)
const AV_SAMPLE_FMT_NB = @compat Int32(10)
# end enum AVSampleFormat

# Skipping MacroDefinition: AV_VERSION_INT ( a , b , c ) ( a << 16 | b << 8 | c )
# Skipping MacroDefinition: AV_VERSION_DOT ( a , b , c ) a ## . ## b ## . ## c
# Skipping MacroDefinition: AV_VERSION ( a , b , c ) AV_VERSION_DOT ( a , b , c )

const LIBAVUTIL_VERSION_MAJOR = 53
const LIBAVUTIL_VERSION_MINOR = 3
const LIBAVUTIL_VERSION_MICRO = 0

# Skipping MacroDefinition: LIBAVUTIL_VERSION_INT AV_VERSION_INT ( LIBAVUTIL_VERSION_MAJOR , LIBAVUTIL_VERSION_MINOR , LIBAVUTIL_VERSION_MICRO )
# Skipping MacroDefinition: LIBAVUTIL_VERSION AV_VERSION ( LIBAVUTIL_VERSION_MAJOR , LIBAVUTIL_VERSION_MINOR , LIBAVUTIL_VERSION_MICRO )

# const LIBAVUTIL_BUILD = LIBAVUTIL_VERSION_INT

# Skipping MacroDefinition: LIBAVUTIL_IDENT "Lavu" AV_STRINGIFY ( LIBAVUTIL_VERSION )
# Skipping MacroDefinition: FF_API_PIX_FMT ( LIBAVUTIL_VERSION_MAJOR < 54 )
# Skipping MacroDefinition: FF_API_CONTEXT_SIZE ( LIBAVUTIL_VERSION_MAJOR < 54 )
# Skipping MacroDefinition: FF_API_PIX_FMT_DESC ( LIBAVUTIL_VERSION_MAJOR < 54 )
# Skipping MacroDefinition: FF_API_AV_REVERSE ( LIBAVUTIL_VERSION_MAJOR < 54 )
# Skipping MacroDefinition: FF_API_AUDIOCONVERT ( LIBAVUTIL_VERSION_MAJOR < 54 )
# Skipping MacroDefinition: FF_API_CPU_FLAG_MMX2 ( LIBAVUTIL_VERSION_MAJOR < 54 )
# Skipping MacroDefinition: FF_API_LLS_PRIVATE ( LIBAVUTIL_VERSION_MAJOR < 54 )
# Skipping MacroDefinition: FF_API_AVFRAME_LAVC ( LIBAVUTIL_VERSION_MAJOR < 54 )
# Skipping MacroDefinition: FF_API_VDPAU ( LIBAVUTIL_VERSION_MAJOR < 54 )
# Skipping MacroDefinition: FF_API_XVMC ( LIBAVUTIL_VERSION_MAJOR < 54 )

typealias AVAudioFifo Void

# begin enum AVDownmixType
typealias AVDownmixType UInt32
const AV_DOWNMIX_TYPE_UNKNOWN = @compat UInt32(0)
const AV_DOWNMIX_TYPE_LORO = @compat UInt32(1)
const AV_DOWNMIX_TYPE_LTRT = @compat UInt32(2)
const AV_DOWNMIX_TYPE_DPLII = @compat UInt32(3)
const AV_DOWNMIX_TYPE_NB = @compat UInt32(4)
# end enum AVDownmixType

immutable AVDownmixInfo
    preferred_downmix_type::AVDownmixType
    center_mix_level::Cdouble
    center_mix_level_ltrt::Cdouble
    surround_mix_level::Cdouble
    surround_mix_level_ltrt::Cdouble
    lfe_mix_level::Cdouble
end

# Skipping MacroDefinition: DECLARE_ALIGNED ( n , t , v ) t __attribute__ ( ( aligned ( n ) ) ) v
# Skipping MacroDefinition: DECLARE_ASM_CONST ( n , t , v ) static const t av_used __attribute__ ( ( aligned ( n ) ) ) v
# Skipping MacroDefinition: av_malloc_attrib __attribute__ ( ( __malloc__ ) )
# Skipping MacroDefinition: av_alloc_size ( ... )

const AV_OPT_FLAG_ENCODING_PARAM = 1
const AV_OPT_FLAG_DECODING_PARAM = 2
const AV_OPT_FLAG_METADATA = 4
const AV_OPT_FLAG_AUDIO_PARAM = 8
const AV_OPT_FLAG_VIDEO_PARAM = 16
const AV_OPT_FLAG_SUBTITLE_PARAM = 32
const AV_OPT_SEARCH_CHILDREN = 0x0001
const AV_OPT_SEARCH_FAKE_OBJ = 0x0002
const AV_STEREO3D_FLAG_INVERT = 1 << 0

# begin enum AVStereo3DType
typealias AVStereo3DType UInt32
const AV_STEREO3D_2D = @compat UInt32(0)
const AV_STEREO3D_SIDEBYSIDE = @compat UInt32(1)
const AV_STEREO3D_TOPBOTTOM = @compat UInt32(2)
const AV_STEREO3D_FRAMESEQUENCE = @compat UInt32(3)
const AV_STEREO3D_CHECKERBOARD = @compat UInt32(4)
const AV_STEREO3D_SIDEBYSIDE_QUINCUNX = @compat UInt32(5)
const AV_STEREO3D_LINES = @compat UInt32(6)
const AV_STEREO3D_COLUMNS = @compat UInt32(7)
# end enum AVStereo3DType

immutable AVStereo3D
    _type::AVStereo3DType
    flags::Cint
end

immutable Array_16_Uint32
    d1::UInt32
    d2::UInt32
    d3::UInt32
    d4::UInt32
    d5::UInt32
    d6::UInt32
    d7::UInt32
    d8::UInt32
    d9::UInt32
    d10::UInt32
    d11::UInt32
    d12::UInt32
    d13::UInt32
    d14::UInt32
    d15::UInt32
    d16::UInt32
end

zero(::Type{Array_16_Uint32}) = Array_16_Uint32(fill(zero(UInt32),16)...)

immutable AVXTEA
    key::Array_16_Uint32
end
