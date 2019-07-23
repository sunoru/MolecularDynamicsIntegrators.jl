import ..Bases: RealType, Vector3s
import ..Types: AbstractIntegrator

struct VerletIntegrator{N, M <: Function, F <: Function} <: AbstractIntegrator{N, M, F}
    positions::Vector3s
    velocities::Vector3s
    timestep::RealType

    mass_function::M
    force_function::F

    forces::Vector3s
end

function VerletIntegrator(r, v, dt, m, f)
    N = length(r)
    @assert length(v) === N
    fs = f(r)
    @assert length(fs) === N
    VerletIntegrator{N, typeof(m), typeof(f)}(r, v, dt, m, f, fs)
end
