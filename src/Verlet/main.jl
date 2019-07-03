import ..Bases: RealType, Vector3s
import ..Types: move!


function _move_half_step!(r::Vector3s{N}, v::Vector3s{N}, a::Vector3s{N}, dt::RealType) where N
    v .+= a * dt / 2
    r .+= v * dt
    r, v
end

function _move_full_step!(r::Vector3s{N}, v::Vector3s{N}, a::Vector3s{N}, dt::RealType) where N
    v .+= a * dt / 2
    r, v
end

function move!(integrator::VerletIntegrator)
    r = integrator.positions
    v = integrator.velocities
    dt = integrator.timestep
    f = integrator.acceleration_function
    a = integrator.acceleration
    _move_half_step!(r, v, a, dt)
    a .= f(r)
    _move_full_step!(r, v, a, dt)
    integrator
end
