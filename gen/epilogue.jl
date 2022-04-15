struct_types = Type[]
# Export everything
for name in names(@__MODULE__, all = true)
    name in [Symbol("#eval"), Symbol("#include"), :include, :eval] && continue
    @eval begin
        export $name
        $name isa Type && isstructtype($name) && push!(struct_types, $name)
    end
end

function Base.getproperty(x::Ptr{<:Union{struct_types...}}, f::Symbol)
    T = eltype(x)
    fieldpos = Base.fieldindex(T, f)
    field_pointer = convert(Ptr{fieldtype(T, fieldpos)}, x + fieldoffset(T, fieldpos))
    return field_pointer
end
