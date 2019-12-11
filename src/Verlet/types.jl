import ..Bases: RealType, Vector3s
import ..Types: AbstractIntegrator, current_positions, current_velocities

struct VerletIntegrator{M <: Function, F <: Function} <: AbstractIntegrator{M, F}
    positions::Vector3s
    velocities::Vector3s
    timestep::RealType

    mass_function::M
    force_function::F

    forces::Vector3s
end

function VerletIntegrator(r, v, dt, m, f)
    N = length(r)
    @assert N === length(v)
    fs = f(r)
    @assert N === length(fs)
    VerletIntegrator{typeof(m), typeof(f)}(r, v, dt, m, f, fs)
end

current_positions(vi::VerletIntegrator) = vi.positions
current_velocities(vi::VerletIntegrator) = vi.velocities

