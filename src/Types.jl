module Types

export AbstractIntegrator, move!

import ..Bases: RealType, Vector3s

# N: number of particles; M: Mass function; F: Force function
# Accept mass as a function (index -> value) instead of an array in order to perform better in special
# cases like all the masses are the same.
abstract type AbstractIntegrator{N, M <: Function, F <: Function} end

@inline function acceleration(forces::Vector3s{N}, m::M) where {N, M <: Function}
    a = zeros(Vector3s{N})
    @inbounds for i = 1:N
        a[i] = fv[i] / m(i)
    end
    a
end

move!(::AbstractIntegrator) = error("Unimplemented")

abstract type Constraint end

struct FixedDistanceConstraint <: Constraint
    i::Int
    j::Int
    distance::RealType
end

end
