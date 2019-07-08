import ..Bases: RealType, Vector3s
import ..Types: AbstractIntegrator

mutable struct VerletIntegrator{N, M <: Function, F <: Function} <: AbstractIntegrator{N, M, F}
    positions::Vector3s{N}
    velocities::Vector3s{N}
    timestep::RealType

    mass_function::M
    force_function::F

    forces::Vector3s{N}
end

VerletIntegrator(r, v, dt, m, f) = VerletIntegrator(r, v, dt, m, f, f(r))
