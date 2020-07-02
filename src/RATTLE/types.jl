import ..Bases: RealType, Vector3, Vector3s
import ..Constraints: FixedDistanceConstraint
import ..Types: AbstractIntegrator, current_positions, current_velocities, set_state!

# The constraints can only be of the type that require fixed distances.
struct RattleIntegrator{
    M <: Function, F <: Function,
    D <: Function
} <: AbstractIntegrator{M, F}
    positions::Vector3s
    velocities::Vector3s
    timestep::RealType

    mass_function::M
    force_function::F
    distance_function::D

    tolerance::RealType
    max_iterations::Int
    constraints::Vector{FixedDistanceConstraint}

    forces::Vector3s
end

# r_ij = r_i - r_j
_default_distance() = (a::Vector3, b::Vector3) -> a - b

function RattleIntegrator(
    r, v, dt, m, f, ξ, max_iter,
    gs = FixedDistanceConstraint[];
    distance = _default_distance()
)
    N = length(r)
    @assert N === length(v)
    fs = f(r)
    @assert N === length(fs)
    RattleIntegrator{typeof(m), typeof(f), typeof(distance)}(
        r, v, dt, m, f, distance, ξ, max_iter, gs, fs
    )
end

current_positions(ri::RattleIntegrator) = ri.positions
current_velocities(ri::RattleIntegrator) = ri.velocities

function set_state!(ri::RattleIntegrator, rs::Vector3s, vs::Vector3s)
    ri.positions .= rs
    ri.velocities .= vs
    ri
end
