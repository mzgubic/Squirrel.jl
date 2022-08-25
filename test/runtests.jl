using Squirrel
using Test

@testset "Squirrel.jl" begin
    a = 1
    b = "string"

    @squirrel a

    @squirrel a, b
end
