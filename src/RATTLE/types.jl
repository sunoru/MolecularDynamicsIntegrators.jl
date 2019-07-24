import ..Bases: RealType, Vector3s, TVector
import ..Types: AbstractIntegrator, FixedDistanceConstraint


# The constraints can only be of the type that require fixed distances.
struct RattleIntegrator{N, K, M <: Function, F <: Function} <: AbstractIntegrator{N, M, F}
    positions::Vector3s{N}
    velocities::Vector3s{N}
    timestep::RealType

    mass_function::M
    force_function::F

    tolerance::RealType
    max_iterations::Int
    constraints::TVector{K, FixedDistanceConstraint}

    forces::Vector3s{N}
end

function RattleIntegrator(r, v, dt, m, f, ξ, max_iter, gs)
    N = length(r)
    K = length(gs)
    fs = f(r)
    RattleIntegrator{N, K, typeof(m), typeof(f)}(r, v, dt, m, f, ξ, max_iter, gs, fs)
end
