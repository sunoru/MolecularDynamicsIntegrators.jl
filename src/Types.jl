module Types

export AbstractIntegrator, move!, AbstractConstraint, FixedDistanceConstraint

import ..Bases: RealType, Vector3s, Vector3

# N: number of particles; M: Mass function; F: Force function
# Accept mass as a function (index -> value) instead of an array in order to perform better in special
# cases like all the masses are the same.
abstract type AbstractIntegrator{N, M <: Function, F <: Function} end

@inline function acceleration(forces::Vector3s, m::M) where {M <: Function}
    N = length(forces)
    a = zeros(Vector3, N)
    @inbounds for i = 1:N
        a[i] = forces[i] / m(i)
    end
    a
end

move!(::AbstractIntegrator) = error("Unimplemented")

abstract type AbstractConstraint end

struct FixedDistanceConstraint <: AbstractConstraint
    i::Int
    j::Int
    distance::RealType
end

end
