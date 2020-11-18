using Test

include("main.jl")
include("estrutura.jl")

function tests()
  χ(x,v) = x == 0 ? 0.0 : v
  funset = [
    (exp,                      0.0,  1.0,          exp(1) - 1, "exp"),
    (x -> x^5,                -0.9,  1.1, (1.1^6 - 0.9^6) / 6, "x⁶"),
    (x -> sin(x),              0.0,   2π,                 0.0, "sin x from 0..2π"),
    (x -> sin(x),              0.0,  π/2,                 1.0, "sin x from 0..π/2"),
    (x -> cos(x),              0.0,   2π,                 0.0, "cos x from 0..2π"),
    (x -> cos(x),              0.0,  π/2,                 1.0, "cos x from 0..π/2"),
    (x -> χ(x, x * log(x)),    0.0,  1.0,               -0.25, "x * log(x)"),
    (x -> exp(-x^2),          -6.0,  6.0,             sqrt(π), "e⁻ˣ²"),
    (x -> x < π ? 0.0 : 1.0,   3.0,  4.0,               4 - π, "irrational step"),
    (x -> 1 / (1 + exp(-5x)), -1.0,  1.0,                 1.0, "sigmoid")
  ]

  @testset "Testes simples" begin
    for (f, a, b, sol, nome) in funset
      F = FuncaoComCache(f)
      for ϵ in [1e-3, 1e-4, 1e-5, 1e-6],
        S = simpson_adaptivo(F, a, b)
        @test abs(S - sol) < ϵ
        @test 0 < length(F) ≤ 1000
      end
    end
  end

  @testset "Casos específicos" begin
    @testset "Poly" begin
      f = FuncaoComCache(x -> x^3 + x^2 + x + 1)
      F(x) = x^4 / 4 + x^3 / 3 + x^2 / 2 + x
      I = simpson_adaptivo(f, -2.0, 3.0)
      @test I ≈ F(3) - F(-2)
      @test length(f) == 5 # 3 pontos do intervalo inicial + 2 do nível abaixo
    end

    @testset "Ugly" begin
      f = FuncaoComCache(x -> 1 / (1 + exp(-x)) + 0.3 * sin(25x - π / 12) * exp(-5x^2))
      I = simpson_adaptivo(f, -1.0, 3.0)
      @test length(f) == 437
    end
  end
end

tests()