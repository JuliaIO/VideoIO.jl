
export
    SWR_CH_MAX,
    SWR_FLAG_RESAMPLE,
    SwrDitherType,
    SWR_DITHER_NONE,
    SWR_DITHER_RECTANGULAR,
    SWR_DITHER_TRIANGULAR,
    SWR_DITHER_TRIANGULAR_HIGHPASS,
    SWR_DITHER_NS,
    SWR_DITHER_NS_LIPSHITZ,
    SWR_DITHER_NS_F_WEIGHTED,
    SWR_DITHER_NS_MODIFIED_E_WEIGHTED,
    SWR_DITHER_NS_IMPROVED_E_WEIGHTED,
    SWR_DITHER_NS_SHIBATA,
    SWR_DITHER_NS_LOW_SHIBATA,
    SWR_DITHER_NS_HIGH_SHIBATA,
    SWR_DITHER_NB,
    SwrEngine,
    SWR_ENGINE_SWR,
    SWR_ENGINE_SOXR,
    SWR_ENGINE_NB,
    SwrFilterType,
    SWR_FILTER_TYPE_CUBIC,
    SWR_FILTER_TYPE_BLACKMAN_NUTTALL,
    SWR_FILTER_TYPE_KAISER,
    SwrContext


const SWR_CH_MAX = 32
const SWR_FLAG_RESAMPLE = 1

# begin enum SwrDitherType
typealias SwrDitherType UInt32
const SWR_DITHER_NONE = @compat UInt32(0)
const SWR_DITHER_RECTANGULAR = @compat UInt32(1)
const SWR_DITHER_TRIANGULAR = @compat UInt32(2)
const SWR_DITHER_TRIANGULAR_HIGHPASS = @compat UInt32(3)
const SWR_DITHER_NS = @compat UInt32(64)
const SWR_DITHER_NS_LIPSHITZ = @compat UInt32(65)
const SWR_DITHER_NS_F_WEIGHTED = @compat UInt32(66)
const SWR_DITHER_NS_MODIFIED_E_WEIGHTED = @compat UInt32(67)
const SWR_DITHER_NS_IMPROVED_E_WEIGHTED = @compat UInt32(68)
const SWR_DITHER_NS_SHIBATA = @compat UInt32(69)
const SWR_DITHER_NS_LOW_SHIBATA = @compat UInt32(70)
const SWR_DITHER_NS_HIGH_SHIBATA = @compat UInt32(71)
const SWR_DITHER_NB = @compat UInt32(72)
# end enum SwrDitherType

# begin enum SwrEngine
typealias SwrEngine UInt32
const SWR_ENGINE_SWR = @compat UInt32(0)
const SWR_ENGINE_SOXR = @compat UInt32(1)
const SWR_ENGINE_NB = @compat UInt32(2)
# end enum SwrEngine

# begin enum SwrFilterType
typealias SwrFilterType UInt32
const SWR_FILTER_TYPE_CUBIC = @compat UInt32(0)
const SWR_FILTER_TYPE_BLACKMAN_NUTTALL = @compat UInt32(1)
const SWR_FILTER_TYPE_KAISER = @compat UInt32(2)
# end enum SwrFilterType

typealias SwrContext Void
