# Helpful utility functions

function fieldposition(::Type{T}, name::Symbol) where T
    field_pos = findfirst(isequal(name), fieldnames(T))
    if field_pos === nothing
        throw(ErrorException(string("The type `$T` does not contain field ",string(name))))
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
