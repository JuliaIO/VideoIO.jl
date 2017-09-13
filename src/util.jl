# Helpful utility functions

# Set the value of a field of a pointer
# Equivalent to s->name = value
function av_setfield{T}(s::Ptr{T}, name::Symbol, value)
    field = findfirst(fieldnames(T), name)
    byteoffset = fieldoffset(T, field)
    S = T.types[field]

    p = convert(Ptr{S}, s+byteoffset)
    a = unsafe_wrap(Array, p,1)
    a[1] = convert(S, value)
end

function av_pointer_to_field{T}(s::Ptr{T}, name::Symbol)
    field = findfirst(fieldnames(T), name)
    byteoffset = fieldoffset(T, field)
    return s + byteoffset
end

av_pointer_to_field(s::Array, name::Symbol) = av_pointer_to_field(pointer(s), name)

function open_stdout_stderr(cmd::Cmd)
    out = Base.PipeEndpoint()
    err = Base.PipeEndpoint()
    cmd_out = Base.PipeEndpoint()
    cmd_err = Base.PipeEndpoint()
    Base.link_pipe(out, true, cmd_out, false)
    Base.link_pipe(err, true, cmd_err, false)

    r = spawn(ignorestatus(cmd), (DevNull, cmd_out, cmd_err))

    Base.close_pipe_sync(cmd_out)
    Base.close_pipe_sync(cmd_err)

    # NOTE: these are not necessary on v0.4 (although they don't seem
    #       to hurt). Remove when we drop support for v0.3.
    Base.start_reading(out)
    Base.start_reading(err)

    return (out, err, r)
end

function readall_stdout_stderr(cmd::Cmd)
    (out, err, proc) = open_stdout_stderr(cmd)
    return (readstring(out), readstring(err))
end

function _get_fc(file::String) # convenience function for `get_duration` and `get_start_time`
    v = VideoIO.open(file)
    return unsafe_load(v.apFormatContext[1])
end
get_duration(fc::VideoIO.AVFormatContext) = Dates.Millisecond(fc.duration) # this is a bit risky: if AV_TIME_BASE ≠ 1e6 then this conversion will give false results, or if `fc.duration` is not a whole number then this will result in an InexactError. I'll add the appropriate checks if you'll tell me that either event or both are possible.

"""
    get_duration(file::String) -> Millisecond

Return the duration of the video `file` in `Millisecond`s.
"""
get_duration(file::String) = get_duration(_get_fc(file))

get_start_time(fc::VideoIO.AVFormatContext) = Dates.unix2datetime(fc.start_time_realtime)

"""
    get_start_time(file::String) -> DateTime

Return the starting date & time of the video `file`. Note that if the starting date & time are missing, this function will return the Unix epoch (00:00 1st January 1970).
"""
get_start_time(file::String) = get_start_time(_get_fc(file))
