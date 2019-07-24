import ..Bases: RealType, Vector3s
import ..Types: move!, acceleration


@inline function _move_half_step!(r::Vector3s{N}, v::Vector3s{N}, a::Vector3s{N}, dt::RealType) where N
    v .+= a * dt / 2
    r .+= v * dt
    r, v
end

@inline function _move_full_step!(r::Vector3s{N}, v::Vector3s{N}, a::Vector3s{N}, dt::RealType) where N
    v .+= a * dt / 2
    r, v
end

function move!(integrator::VerletIntegrator)
    r = integrator.positions
    v = integrator.velocities
    dt = integrator.timestep
    m = integrator.mass_function
    f = integrator.force_function
    fv = integrator.forces

    a = acceleration(fv, m)
    _move_half_step!(r, v, a, dt)

    fv .= f(r)

    a = acceleration(fv, m)
    _move_full_step!(r, v, a, dt)

    integrator
end
