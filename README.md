# Squirrel

```julia
julia> Squirrel.@squirrel var1, var2
using JLSO
loaded = JLSO.load("squirrel.jlso")
var1, var2 = loaded[:var1], loaded[:var2]
```

will serialise `var1` and `var2`, and print copiable code to recover them in the REPL.
Useful for debugging deep call stacks.
