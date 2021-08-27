
# Custom @cenum to create enum as integer
macro cenum(decl::Expr, body::Expr)
    @assert Meta.isexpr(decl, :(::))
    enumname, basetype = decl.args
    esc(body)
    res = quote
        Base.@__doc__(const $enumname = $basetype)
    end
    for ex in body.args
        ex isa Expr || continue
        @assert Meta.isexpr(ex, :(=))
        push!(res.args, :(const $(ex.args[1]) = $(enumname)($(ex.args[2]))))
    end
    esc(res)
end

const intptr_t = UInt
const time_t = Int

const AV_NOPTS_VALUE = 0x8000000000000000 % Int64
AV_VERSION_INT(a, b, c) = (a << 16 | b << 8) | c
AV_VERSION(a,b,c) = nothing
const AVPROBE_SCORE_MAX = 100
MKTAG(a,b,c,d) = (UInt32(a) | (UInt32(b) << 8) | (UInt32(c) << 16) | UInt32(d) << 24)
FFERRTAG(a,b,c,d) = -MKTAG(a,b,c,d)
macro AV_PIX_FMT_NE(be, le)
    Symbol("AV_PIX_FMT_"*string(le))
end
