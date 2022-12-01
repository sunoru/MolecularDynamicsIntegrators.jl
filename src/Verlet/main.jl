import ..Types: move!
import ..Utils: acceleration


@inline function _move_half_step!(r::Vector{T}, v::Vector{T}, a::Vector{T}, dt::Float64) where {T}
    v .+= a * dt / 2
    r .+= v * dt
    r, v
end

@inline function _move_full_step!(r::Vector{T}, v::Vector{T}, a::Vector{T}, dt::Float64) where {T}
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

    integrator, dt
end
