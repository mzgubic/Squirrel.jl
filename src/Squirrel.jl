module Squirrel

using JLSO

macro squirrel(arg::Symbol) # single item to squirrel away
    local argstr = string(arg)

    return quote
        $JLSO.save("squirrel.jlso", Symbol($argstr) => $(esc(arg)))
        println("using JLSO")
        println("loaded = JLSO.load(\"squirrel.jlso\")")
        println($argstr, " = loaded[:", $argstr, "]")
    end
end

macro squirrel(ex::Expr) # multiple items to squirrel
    (ex.head == :tuple) || throw(ArgumentError("squirrel macro accepts a single symbol or a tuple"))
    local argstrs = string.(ex.args)
    local pairs = [Symbol(s) => a for (s, a) in zip(ex.args, argstrs)]

    return quote
        $JLSO.save("squirrel.jlso", $pairs...)
        println("using JLSO")
        println("loaded = JLSO.load(\"squirrel.jlso\")")
        println(join($argstrs, ", "), " = loaded[:", join($argstrs, "], loaded[:"), "]")
    end
end

end
