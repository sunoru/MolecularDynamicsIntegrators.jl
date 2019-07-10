import ..Bases: RealType, Vector3s, SVector, make_vector, make_svector
import ..Types: AbstractIntegrator, FixedDistanceConstraint


# The constraints can only be of the type that require fixed distances.
mutable struct RattleIntegrator{N, K, M <: Function, F <: Function} <: AbstractIntegrator{N, M, F}
    positions::Vector3s{N}
    velocities::Vector3s{N}
    timestep::RealType

    mass_function::M
    force_function::F

    tolerance::RealType
    max_iterations::Int
    constraints::SVector{K, FixedDistanceConstraint}

    forces::Vector3s{N}
end

RattleIntegrator(
    r, v, dt, m, f, ξ, max_iter, gs
) = RattleIntegrator(make_vector(r), make_vector(v), dt, m, make_vector ∘ f, ξ, max_iter, make_svector(gs), make_vector(f(r)))
