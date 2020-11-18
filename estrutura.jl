struct FuncaoComCache
  f
  D :: Dict{Real,Real}
end

FuncaoComCache(f) = FuncaoComCache(f, Dict{Real,Real}())

function obj_val(f :: FuncaoComCache, x :: Real)
  fx = if haskey(f.D, x)
    f.D[x]
  else
    fℓ = f.f(x)
    f.D[x] = fℓ
    fℓ
  end
  return fx
end

(F::FuncaoComCache)(x :: Real) = obj_val(F, x)

Base.length(f :: FuncaoComCache) = length(f.D)

function tem_guardado(f :: FuncaoComCache, x :: Real)
  return haskey(f.D, x)
end