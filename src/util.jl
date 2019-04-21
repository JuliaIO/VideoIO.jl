# Helpful utility functions

function fieldposition(::Type{T}, name::Symbol) where T
    field_pos = findfirst(isequal(name), fieldnames(T))
    if field_pos === nothing
        throw(ErrorException("The type `$T` does not contain field $name!"))
    end
    return field_pos
end

# Set the value of a field of a pointer
# Equivalent to s->name = value
function av_setfield(s::Ptr{T}, name::Symbol, value) where T
    field_pos = fieldposition(T, name)
    byteoffset = fieldoffset(T, field_pos)
    S = T.types[field_pos]

    p = convert(Ptr{S}, s + byteoffset)
    a = unsafe_wrap(Array, p, 1)
    a[1] = convert(S, value)
end

function av_pointer_to_field(s::Ptr{T}, name::Symbol) where T
    field_pos = fieldposition(T, name)
    byteoffset = fieldoffset(T, field_pos)
    return s + byteoffset
end

av_pointer_to_field(s::Array, name::Symbol) = av_pointer_to_field(pointer(s), name)

function _get_fc(file::String) # convenience function for `get_duration` and `get_start_time`
    v = open(file)
    return unsafe_load(v.apFormatContext[1])
end
get_duration(fc::AVFormatContext) = Dates.Millisecond(fc.duration) # this is a bit risky: if AV_TIME_BASE ≠ 1e6 then this conversion will give false results, or if `fc.duration` is not a whole number then this will result in an InexactError. I'll add the appropriate checks if you'll tell me that either event or both are possible.

"""
    get_duration(file::String) -> Millisecond

Return the duration of the video `file` in `Millisecond`s.
"""
get_duration(file::String) = get_duration(_get_fc(file))

get_start_time(fc::AVFormatContext) = Dates.unix2datetime(fc.start_time_realtime)

"""
    get_start_time(file::String) -> DateTime

Return the starting date & time of the video `file`. Note that if the starting date & time are missing, this function will return the Unix epoch (00:00 1st January 1970).
"""
get_start_time(file::String) = get_start_time(_get_fc(file))

get_time_duration(fc::AVFormatContext) = (get_start_time(fc), get_duration(fc))

"""
    get_time_duration(file::String) -> (DateTime, Millisecond)

Return the starting date & time as well as the duration of the video `file`. Note that if the starting date & time are missing, this function will return the Unix epoch (00:00 1st January 1970).
"""
get_time_duration(file::String) = get_time_duration(_get_fc(file))
