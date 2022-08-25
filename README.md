# Squirrel

```julia
julia> @squirrel var1, var2
using JLSO
loaded = JLSO.load("/Users/mzgubic/.julia/squirrel/nut_2022-08-25T11:15:34.367_var1_var2.jlso")
var1, var2 = loaded[:var1], loaded[:var2]
```

will serialise `var1` and `var2`, and print copiable code to recover them in the REPL.
Useful for debugging deep call stacks, where you call `@squirrel` inside some code that takes a long time to execute before it errors, and you want to examine the object just before it errors.
