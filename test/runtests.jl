using LITS
using PowerSystems
using Test
using NLsolve
using DiffEqBase
using Sundials

const PSY = PowerSystems

include("./data_tests/network_test_data.jl")
include("./data_tests/dynamic_test_data.jl")

tests = readdir(dirname(@__FILE__))
tests = filter(
    f -> startswith(f, "test_") && endswith(f, ".jl") && f != basename(@__FILE__),
    tests,
)

@testset "BasicTests" begin

    for test in tests
        print(splitext(test)[1], ": ")
        include(test)
        println()
    end

end
