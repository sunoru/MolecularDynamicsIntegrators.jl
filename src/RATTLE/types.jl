import ..Bases: RealType, Vector3s, SVector
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
) = RattleIntegrator(r, v, dt, m, f, ξ, max_iter, gs, f(r))
