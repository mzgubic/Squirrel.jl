module Squirrel

using JLSO

export @squirrel

# create multiple files
const SFILE = expanduser("~/.julia/squirrel/squirrel.jlso")

function __init__()
    mkpath(dirname(SFILE))

    # TODO: remove files more than a month old or something
    return nothing
end

# TODO: expand the syntax for multiple symbols as well

macro squirrel(arg::Symbol) # single item to squirrel away
    local argstr = string(arg)

    return quote
        $JLSO.save($SFILE, Symbol($argstr) => $(esc(arg)))
        println("using JLSO")
        println("loaded = JLSO.load(\"", $SFILE, "\")")
        println($argstr, " = loaded[:", $argstr, "]")
    end
end

macro squirrel(ex::Expr) # multiple items to squirrel
    (ex.head == :tuple) || throw(ArgumentError("squirrel macro accepts a single symbol or a tuple"))
    local argstrs = string.(ex.args)
    local pairs = [Symbol(s) => a for (s, a) in zip(ex.args, argstrs)]

    return quote
        $JLSO.save($SFILE, $pairs...)
        println("using JLSO")
        println("loaded = JLSO.load(\"", $SFILE,"\")")
        println(join($argstrs, ", "), " = loaded[:", join($argstrs, "], loaded[:"), "]")
    end
end

end
