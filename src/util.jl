# Helpful utility functions

const VIO_AVERROR_EOF = -541478725 # AVERROR_EOF

"""
loglevel!(loglevel::Integer)

Set FFMPEG log level. Options are:

  - `VideoIO.AVUtil.AV_LOG_QUIET`
  - `VideoIO.AVUtil.AV_LOG_PANIC`
  - `VideoIO.AVUtil.AV_LOG_FATAL`
  - `VideoIO.AVUtil.AV_LOG_ERROR`
  - `VideoIO.AVUtil.AV_LOG_WARNING`
  - `VideoIO.AVUtil.AV_LOG_INFO`
  - `VideoIO.AVUtil.AV_LOG_VERBOSE`
  - `VideoIO.AVUtil.AV_LOG_DEBUG`
  - `VideoIO.AVUtil.AV_LOG_TRACE`
"""
function loglevel!(level::Integer)
    av_log_set_level(level)
    return loglevel()
end

"""
loglevel() -> String

Get FFMPEG log level as a variable name string.
"""
function loglevel()
    current_level = av_log_get_level()
    level_strings = [
        "VideoIO.AVUtil.AV_LOG_QUIET",
        "VideoIO.AVUtil.AV_LOG_PANIC",
        "VideoIO.AVUtil.AV_LOG_FATAL",
        "VideoIO.AVUtil.AV_LOG_ERROR",
        "VideoIO.AVUtil.AV_LOG_WARNING",
        "VideoIO.AVUtil.AV_LOG_INFO",
        "VideoIO.AVUtil.AV_LOG_VERBOSE",
        "VideoIO.AVUtil.AV_LOG_DEBUG",
        "VideoIO.AVUtil.AV_LOG_TRACE",
    ]
    level_values = [
        VideoIO.libffmpeg.AV_LOG_QUIET,
        VideoIO.libffmpeg.AV_LOG_PANIC,
        VideoIO.libffmpeg.AV_LOG_FATAL,
        VideoIO.libffmpeg.AV_LOG_ERROR,
        VideoIO.libffmpeg.AV_LOG_WARNING,
        VideoIO.libffmpeg.AV_LOG_INFO,
        VideoIO.libffmpeg.AV_LOG_VERBOSE,
        VideoIO.libffmpeg.AV_LOG_DEBUG,
        VideoIO.libffmpeg.AV_LOG_TRACE,
    ]
    i = findfirst(level_values .== current_level)
    if i !== nothing
        return level_strings[i]
    else
        return "Unknown log level: $current_level"
    end
end

@inline function field_ptr(::Type{S}, struct_pointer::Ptr{T}, field::Symbol, index::Integer = 1) where {S,T}
    field_pointer = getproperty(struct_pointer, field) + (index - 1) * sizeof(S)
    return convert(Ptr{S}, field_pointer)
end

@inline field_ptr(a::Ptr{T}, field::Symbol) where {T} = getproperty(a, field)

function check_ptr_valid(p::Ptr, err::Bool = true)
    valid = p != C_NULL
    err && !valid && error("Invalid pointer")
    return valid
end
