module Squirrel

using Dates
using JLSO

export @squirrel

const SPATH = expanduser("~/.julia/squirrel")

function __init__()
    mkpath(SPATH)

    # TODO: remove files more than a month old or something
    return nothing
end

# TODO: expand the syntax for multiple symbols as well

macro squirrel(arg::Symbol) # single item to squirrel away
    local argstr = string(arg)
    fname = joinpath(SPATH, "nut_$(now())_$(argstr).jlso")

    return quote
        $JLSO.save($fname, Symbol($argstr) => $(esc(arg)))
        println("using JLSO")
        println("loaded = JLSO.load(\"", $fname, "\")")
        println($argstr, " = loaded[:", $argstr, "]")
    end
end

macro squirrel(ex::Expr) # multiple items to squirrel
    (ex.head == :tuple) || throw(ArgumentError("squirrel macro accepts a single symbol or a tuple"))
    local argstrs = string.(ex.args)
    local pairs = [Symbol(s) => a for (s, a) in zip(ex.args, argstrs)]
    fname = joinpath(SPATH, "nut_$(now())_$(join(argstrs, "_")).jlso")

    return quote
        $JLSO.save($fname, $pairs...)
        println("using JLSO")
        println("loaded = JLSO.load(\"", $fname, "\")")
        println(join($argstrs, ", "), " = loaded[:", join($argstrs, "], loaded[:"), "]")
    end
end

end
