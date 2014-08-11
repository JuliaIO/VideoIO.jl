# Helpful utility functions


# Set the value of a field of a pointer
# Equivalent to s->name = value
function av_setfield{T}(s::Ptr{T}, name::Symbol, value)
    field = findfirst(names(T), name)
    byteoffset = fieldoffsets(T)[field]
    S = T.types[field]
    
    p = convert(Ptr{S}, s+byteoffset)
    a = pointer_to_array(p,1)
    a[1] = convert(S, value)
end

function av_pointer_to_field{T}(s::Ptr{T}, name::Symbol)
    field = findfirst(names(T), name)
    byteoffset = fieldoffsets(T)[field]
    return s + byteoffset
end

av_pointer_to_field(s::Array, name::Symbol) = av_pointer_to_field(pointer(s), name)
