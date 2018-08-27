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

function open_stdout_stderr(cmd::Cmd)
    out = Base.PipeEndpoint()
    err = Base.PipeEndpoint()
    cmd_out = Base.PipeEndpoint()
    cmd_err = Base.PipeEndpoint()
    Base.link_pipe(out, true, cmd_out, false)
    Base.link_pipe(err, true, cmd_err, false)

    r = spawn(ignorestatus(cmd), (devnull, cmd_out, cmd_err))

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
    return (read(out, String), read(err, String))
end
