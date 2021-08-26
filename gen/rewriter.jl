using Match
import Base.Meta.isexpr

function rewrite(e::Expr)
    @match e begin
        Expr(:function, [fncall, body])  =>  rewrite_fn(e, fncall, body)
        Expr(:const, [arg])              =>  rewrite_const(e)
        _                                =>  e
    end
end

function rewrite_const(e)
    body = e.args[]
    lhs, rhs = body.args
    name = string(lhs)
    if match(r"^AV_PIX_FMT_[\w\d]+$", name) |> !isnothing
        func, be, le = rhs.args
        func == :AV_PIX_FMT_NE || return e
        rhs = Expr(:macrocall, Symbol("@AV_PIX_FMT_NE"), nothing, be, le)
        body.args[2] = rhs
    end
    e
end

# Rewrite function signatures to be more friendly
function rewrite_fn(e, fncall, body, use_strpack=false)
    fncall.args[1] isa Symbol || return e
    
    parms = Any[]
    content = Any[]

    push!(parms, fncall.args[1])  # function name

    # Add explicit conversions for Ptr, UInt32/Int32, and va_list
    for call_arg in fncall.args[2:end]
        @match call_arg begin
            # Don't type Ptr{x} types
            Expr(:(::), [sym, Expr(:curly, [:Ptr, _])]) => push!(parms, sym)

            # Type all integers as Integer
            Expr(:(::), [sym, (:UInt32 || :Cuint || :Int32 || :Cint)]) => (sym; push!(parms, :($sym::Integer)))

            # va_list
            Expr(:(::), [sym, :va_list]) => push!(parms, sym)

            # Everything else is unchanged
            _ => push!(parms, call_arg)
        end
    end

    if !isexpr(body, :block)
        # body just consists of the ccall
        push!(content, body)
    else
        append!(content, body.args)
    end

    fncall = Expr(:call, parms...)
    body = Expr(:block, content...)

    new = Expr(e.head, fncall, body)

    return new
end

