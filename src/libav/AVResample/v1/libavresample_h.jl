
export
    AVRESAMPLE_MAX_CHANNELS,
    AVAudioResampleContext,
    AVMixCoeffType,
    AV_MIX_COEFF_TYPE_Q8,
    AV_MIX_COEFF_TYPE_Q15,
    AV_MIX_COEFF_TYPE_FLT,
    AV_MIX_COEFF_TYPE_NB,
    AVResampleFilterType,
    AV_RESAMPLE_FILTER_TYPE_CUBIC,
    AV_RESAMPLE_FILTER_TYPE_BLACKMAN_NUTTALL,
    AV_RESAMPLE_FILTER_TYPE_KAISER,
    AVResampleDitherMethod,
    AV_RESAMPLE_DITHER_NONE,
    AV_RESAMPLE_DITHER_RECTANGULAR,
    AV_RESAMPLE_DITHER_TRIANGULAR,
    AV_RESAMPLE_DITHER_TRIANGULAR_HP,
    AV_RESAMPLE_DITHER_TRIANGULAR_NS,
    AV_RESAMPLE_DITHER_NB


const AVRESAMPLE_MAX_CHANNELS = 32

typealias AVAudioResampleContext Void

# begin enum AVMixCoeffType
typealias AVMixCoeffType Uint32
const AV_MIX_COEFF_TYPE_Q8 = uint32(0)
const AV_MIX_COEFF_TYPE_Q15 = uint32(1)
const AV_MIX_COEFF_TYPE_FLT = uint32(2)
const AV_MIX_COEFF_TYPE_NB = uint32(3)
# end enum AVMixCoeffType

# begin enum AVResampleFilterType
typealias AVResampleFilterType Uint32
const AV_RESAMPLE_FILTER_TYPE_CUBIC = uint32(0)
const AV_RESAMPLE_FILTER_TYPE_BLACKMAN_NUTTALL = uint32(1)
const AV_RESAMPLE_FILTER_TYPE_KAISER = uint32(2)
# end enum AVResampleFilterType

# begin enum AVResampleDitherMethod
typealias AVResampleDitherMethod Uint32
const AV_RESAMPLE_DITHER_NONE = uint32(0)
const AV_RESAMPLE_DITHER_RECTANGULAR = uint32(1)
const AV_RESAMPLE_DITHER_TRIANGULAR = uint32(2)
const AV_RESAMPLE_DITHER_TRIANGULAR_HP = uint32(3)
const AV_RESAMPLE_DITHER_TRIANGULAR_NS = uint32(4)
const AV_RESAMPLE_DITHER_NB = uint32(5)
# end enum AVResampleDitherMethod
