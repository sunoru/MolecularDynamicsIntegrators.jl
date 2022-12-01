import ..Types: AbstractIntegrator, current_positions, current_velocities, set_state!, IntegratorParameters

struct VerletParameters <: IntegratorParameters end

struct VerletIntegrator{
    T,
    M<:Function,F<:Function
} <: AbstractIntegrator
    positions::Vector{T}
    velocities::Vector{T}
    timestep::Float64

    mass_function::M
    force_function::F

    params::VerletParameters

    forces::Vector{T}
end

function VerletIntegrator(
    r, v, dt, m, f,
    params=VerletParameters()
)
    N = length(r)
    @assert N === length(v)
    fs = f(r)
    @assert N === length(fs)
    T = eltype(r)
    VerletIntegrator{T,typeof(m),typeof(f)}(r, v, dt, m, f, params, fs)
end

current_positions(vi::VerletIntegrator) = vi.positions
current_velocities(vi::VerletIntegrator) = vi.velocities

function set_state!(vi::VerletIntegrator{T}, rs::Vector{T}, vs::Vector{T}) where {T}
    vi.positions .= rs
    vi.velocities .= vs
    vi
end
