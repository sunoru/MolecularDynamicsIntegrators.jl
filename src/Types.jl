module Types

export AbstractIntegrator, move!

# N atoms and use F Force
abstract type AbstractIntegrator{N, F} end

move!(::AbstractIntegrator) = error("Unimplemented")

end
