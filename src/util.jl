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

function collectexecoutput(exec::Cmd)
    out = Pipe(); err = Pipe()
    p = Base.open(pipeline(ignorestatus(exec), stdout=out, stderr=err))
    close(out.in); close(err.in)
    err_s = readlines(err); out_s = readlines(out)
    return (length(out_s) > length(err_s)) ? out_s : err_s
end

# a convenience function for getting the aspect ratio
function aspect_ratio(f)
    if iszero(f.aspect_ratio) || isnan(f.aspect_ratio) || isinf(f.aspect_ratio) # if the stored aspect ratio is nonsense then we default to one. OBS, this might still be wrong for some videos and an unnecessary test for most
        1//1
    else
        f.aspect_ratio
    end
end
