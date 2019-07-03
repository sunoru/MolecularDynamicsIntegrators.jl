import ..Bases: RealType, Vector3s
import ..Types: AbstractIntegrator

mutable struct VerletIntegrator{N, F <: Function} <: AbstractIntegrator{N, F}
    positions::Vector3s{N}
    velocities::Vector3s{N}
    timestep::RealType
    acceleration_function::F  # Use acceleration instead of force to include masses.

    accelerations::Vector3s{N}
end

VerletIntegrator(r, v, dt, af) = VerletIntegrator(r, v, dt, af, af(r))
