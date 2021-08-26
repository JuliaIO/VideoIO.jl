import .libffmpeg: AVDictionary
import Base: getindex, setindex!, iterate, length, empty!

mutable struct AVDict <: AbstractDict{String, String}
    ref_ptr_dict::Ref{Ptr{AVDictionary}}
end

function AVDict()
    d = AVDict(Ref{Ptr{AVDictionary}}(C_NULL))
    finalizer(empty!, d)
end

function AVDict(ps::Pair...)
    d = AVDict()
    for (key, value) in ps
        d[key] = value
    end
    return d
end

function AVDict(o::AbstractDict)
    d = AVDict()
    for (key, value) in o
        d[key] = value
    end
    return d
end

Base.empty!(d::AVDict) = libffmpeg.av_dict_free(d.ref_ptr_dict)

Base.convert(::Type{Ref{Ptr{AVDictionary}}}, d::AVDict) = d.ref_ptr_dict

function setindex!(d::AVDict, value, key)
    libffmpeg.av_dict_set(d.ref_ptr_dict, string(key), string(value), 0)
    nothing
end

function getindex(d::AVDict, key::AbstractString)
    pItem = libffmpeg.av_dict_get(d.ref_ptr_dict[], key, C_NULL, 0)
    item = unsafe_load(pItem)
    value = unsafe_string(item.value)
    return value
end

function iterate(d::AVDict, state=C_NULL)
    pItem = libffmpeg.av_dict_get(d.ref_ptr_dict[], "", state, libffmpeg.AV_DICT_IGNORE_SUFFIX)
    pItem == C_NULL && return nothing

    item = unsafe_load(pItem)
    key = unsafe_string(item.key)
    value = unsafe_string(item.value)

    return (key => value, pItem)
end

function length(d::AVDict)
    return libffmpeg.av_dict_count(d.ref_ptr_dict[])
end
