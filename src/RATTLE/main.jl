using LinearAlgebra: ⋅, norm_sqr

using ..Constraints: FixedDistanceConstraint
import ..Types: move!
using ..Utils: acceleration

using ..Verlet: Verlet


@inline function _move_half_step!(
    r::Vector{T}, v::Vector{T},
    dt::Float64, tolerance::Float64, m::Function, dist::Function,
    max_iter::Int, last_r::Vector{T}, constraints::Vector{FixedDistanceConstraint}
) where {T}
    N = length(r)
    K = length(constraints)
    moved = ones(Bool, N)
    moving = zeros(Bool, N)
    iter = 0
    correcting = true
    while correcting && iter < max_iter
        iter += 1
        correcting = false
        @inbounds for ki in 1:K
            constraint = constraints[ki]
            i, j, d = constraint.i, constraint.j, constraint.distance
            !(moved[i] || moved[j]) && continue
            d² = d^2
            ξ = 2 * tolerance * d²
            rij = dist(last_r[i], last_r[j])
            s = dist(r[i], r[j])
            rmi, rmj = 1 / m(i), 1 / m(j)
            c = norm_sqr(s) - d²
            if abs(c) ≥ ξ
                correcting = true
                moving[i] = moving[j] = true
                g = c / 2dt / (s ⋅ rij) / (rmi + rmj)
                dvi = -rij * rmi * g
                dvj = rij * rmj * g
                v[i] += dvi
                v[j] += dvj
                r[i] += dvi * dt
                r[j] += dvj * dt
            end
        end
        moved .= moving
        moving .= false
    end
end


@inline function _move_full_step!(
    r::Vector{T}, v::Vector{T},
    tolerance::Float64, m::Function, dist::Function,
    max_iter::Int, constraints::Vector{FixedDistanceConstraint}
) where {T}
    N = length(r)
    K = length(constraints)
    moved = ones(Bool, N)
    moving = zeros(Bool, N)
    iter = 0
    correcting = true
    while correcting && iter < max_iter
        iter += 1
        correcting = false
        @inbounds for ki in 1:K
            constraint = constraints[ki]
            i, j, d = constraint.i, constraint.j, constraint.distance
            !(moved[i] || moved[j]) && continue
            d² = d^2
            ξ = tolerance * d²
            rij = dist(r[i], r[j])
            vij = v[i] - v[j]
            rmi, rmj = 1 / m(i), 1 / m(j)
            c = rij ⋅ vij
            if abs(c) ≥ ξ
                correcting = true
                moving[i] = moving[j] = true
                k = c / d² / (rmi + rmj)
                v[i] += -rij * rmi * k
                v[j] += rij * rmj * k
            end
        end
        moved .= moving
        moving .= false
    end
end


function move!(integrator::RattleIntegrator)
    r = integrator.positions
    v = integrator.velocities
    dt = integrator.timestep
    m = integrator.mass_function
    f = integrator.force_function
    dist = integrator.params.distance_function
    fv = integrator.forces
    max_iter = integrator.params.max_iterations
    constraints = integrator.params.constraints
    tol = integrator.params.ξ

    last_r = copy(r)

    a = acceleration(fv, m)
    Verlet._move_half_step!(r, v, a, dt)
    _move_half_step!(r, v, dt, tol, m, dist, max_iter, last_r, constraints)

    fv .= f(r)
    a = acceleration(fv, m)
    Verlet._move_full_step!(r, v, a, dt)
    _move_full_step!(r, v, tol, m, dist, max_iter, constraints)

    integrator, dt
end
