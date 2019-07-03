import ..Bases: RealType, Vector3s
import ..Types: AbstractIntegrator

mutable struct RattleIntegrator{N, F <: Function, G <: Function, dG <: Function} <: AbstractIntegrator{N, F, G, dG}
    positions::Vector3s{N}
    velocities::Vector3s{N}
    timestep::RealType
    acceleration_function::F  # Use acceleration instead of force to include masses.
    tolerance::RealType
    constraint::G
    constraint_gradient::dG

    accelerations::Vector3s{N}
end

RattleIntegrator(r, v, dt, af) = RattleIntegrator(r, v, dt, af, af(r))
