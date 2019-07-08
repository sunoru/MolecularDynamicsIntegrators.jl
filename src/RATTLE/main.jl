import LinearAlgebra: norm_sqr, ⋅

import ..Bases: RealType, Vector3s, SVector, MVector
import ..Types: move!, acceleration, FixedDistanceConstraint

import ..Verlet


@inline function _move_half_step!(
    r::Vector3s{N}, v::Vector3s{N}, a::Vector3s{N},
    dt::RealType, tolerance::RealType, m::M,
    max_iter::Int, last_r::Vector3s{N}, constraints::SVector{K, FixedDistanceConstraint}
) where {N, M <: Function, K}
    moved = zeros(MVector{K, Bool})
    iter = 0
    correcting = true
    while correcting && iter < max_iter
        iter += 1
        correcting = false
        @inbounds for ki in 1:K
            moved[ki] && continue
            constraint = constraints[ki]
            i, j, d = constraint.i, constraint.j, constraint.distance
            d² = d ^ 2
            ξ = 2 * tolerance * d²
            rij = last_r[i] - last_r[j]
            s = r[i] - r[j]
            rmi, rmj = 1 / m(i), 1 / m(j)
            c = norm_sqr(s) - d²
            if abs(c) ≥ ξ
                correcting = true
                moved[ki] = true
                g = c / 2dt / (s ⋅ rij) / (rmi + rmj)
                dvi = -rij * rmi * g
                dvj = rij * rmj * g
                v[i] += dvi
                v[j] += dvj
                r[i] += dvi * dt
                r[j] += dvj * dt
            end
        end
    end
end


@inline function _move_full_step!(
    r::Vector3s{N}, v::Vector3s{N}, a::Vector3s{N},
    dt::RealType, tolerance::RealType, m::M,
    max_iter::Int, constraints::SVector{K, FixedDistanceConstraint}
) where {N, M <: Function, K}
    moved = zeros(MVector{K, Bool})
    iter = 0
    correcting = true
    while correcting && iter < max_iter
        iter += 1
        correcting = false
        @inbounds for ki in 1:K
            moved[ki] && continue
            constraint = constraints[ki]
            i, j, d = constraint.i, constraint.j, constraint.distance
            d² = d ^ 2
            ξ = tolerance * d²
            rij = r[i] - r[j]
            vij = v[i] - v[j]
            rmi, rmj = 1 / m(i), 1 / m(j)
            c = rij ⋅ vij
            if abs(c) ≥ ξ
                correcting = true
                moved[ki] = true
                k = c / d² / (rmi + rmj)
                v[i] += -rij * rmi * k
                v[j] += rij * rmj * k
            end
        end
    end
end


function move!(integrator::RattleIntegrator)
    r = integrator.positions
    v = integrator.velocities
    dt = integrator.timestep
    m = integrator.mass_function
    f = integrator.force_function
    fv = integrator.forces
    max_iter = integrator.max_iterations
    constraints = integrator.constraints
    tol = integrator.tolerance

    last_r = copy(r)

    a = acceleration(fv, m)
    Verlet._move_half_step!(r, v, a, dt)
    _move_half_step!(r, v, a, dt, tol, m, max_iter, last_r, constraints)

    fv .= f(r)
    a = acceleration(fv, m)
    Verlet._move_full_step!(r, v, a, dt)
    _move_full_step!(r, v, a, dt, tol, m, max_iter, constraints)

    integrator
end
