### Libraries
libavutil = :libavutil
libavformat = :libavformat
libavcodec = :libavcodec
libswscale = :libswscale

### Fixups
typealias size_t Int32
typealias uint64_t Uint64
typealias int64_t Int64
typealias uint32_t Uint32
typealias int32_t Int32
typealias uint8_t Uint8
typealias int8_t Int8
typealias uint16_t Uint16
typealias int16_t Int16

###
include("libav_h.jl")
include("avutil.jl")
