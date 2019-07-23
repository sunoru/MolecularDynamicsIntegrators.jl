import ..Bases: RealType, Vector3s
import ..Types: AbstractIntegrator, FixedDistanceConstraint


# The constraints can only be of the type that require fixed distances.
struct RattleIntegrator{N, K, M <: Function, F <: Function} <: AbstractIntegrator{N, M, F}
    positions::Vector3s
    velocities::Vector3s
    timestep::RealType

    mass_function::M
    force_function::F

    tolerance::RealType
    max_iterations::Int
    constraints::Vector{FixedDistanceConstraint}

    forces::Vector3s
end

function RattleIntegrator(r, v, dt, m, f, ξ, max_iter, gs)
    N = length(r)
    @assert length(v) === N
    fs = f(r)
    @assert length(fs) === N
    K = length(gs)
    RattleIntegrator{N, K, typeof(m), typeof(f)}(r, v, dt, m, f, ξ, max_iter, gs, fs)
end
