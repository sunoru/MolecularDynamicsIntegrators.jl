import ..Constraints: FixedDistanceConstraint
import ..Types: AbstractIntegrator, current_positions, current_velocities, set_state!, IntegratorParameters

default_distance(a, b) = a - b

Base.@kwdef struct RattleParameters{D<:Function} <: IntegratorParameters
    ξ::Float64 = 1e-6  # tolerance
    max_iterations::Int = 10000
    constraints::Vector{FixedDistanceConstraint} = []
    distance_function::D = default_distance
end

# The constraints can only be of the type that require fixed distances.
struct RattleIntegrator{
    T,P<:RattleParameters,
    M<:Function,F<:Function,
} <: AbstractIntegrator
    positions::Vector{T}
    velocities::Vector{T}
    timestep::Float64

    mass_function::M
    force_function::F

    params::P

    forces::Vector{T}
end

function RattleIntegrator(
    r, v, dt, m, f,
    params=RattleParameters()
)
    N = length(r)
    @assert N === length(v)
    fs = f(r)
    @assert N === length(fs)
    T = eltype(r)
    RattleIntegrator{T,typeof(params),typeof(m),typeof(f)}(
        r, v, dt, m, f, params, fs
    )
end

current_positions(ri::RattleIntegrator) = ri.positions
current_velocities(ri::RattleIntegrator) = ri.velocities

function set_state!(ri::RattleIntegrator{T}, rs::Vector{T}, vs::Vector{T}) where {T}
    ri.positions .= rs
    ri.velocities .= vs
    ri
end
