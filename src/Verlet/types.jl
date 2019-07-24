import ..Bases: RealType, Vector3s
import ..Types: AbstractIntegrator

struct VerletIntegrator{N, M <: Function, F <: Function} <: AbstractIntegrator{N, M, F}
    positions::Vector3s{N}
    velocities::Vector3s{N}
    timestep::RealType

    mass_function::M
    force_function::F

    forces::Vector3s{N}
end

function VerletIntegrator(r, v, dt, m, f)
    N = length(r)
    fs = f(r)
    VerletIntegrator{N, typeof(m), typeof(f)}(r, v, dt, m, f, fs)
end
