import LinearAlgebra: norm_sqr

import MolecularDynamicsIntegrators.Bases: Vector3s

@inline function lj_potential_fij(a, b)
    r = b - a
    r2 = norm_sqr(r)
    @fastmath frac = 1.0 / r2 ^ 3
    wij = 24 * (2 * frac ^ 2 - frac)
    fij = r * wij / r2
end

function lj_potential_forces(r)
    N = length(r)
    forces = zeros(Vector3s{N})
    @inbounds @simd for i = 1:N - 2
        @simd for j = i + 2:N
            fij = lj_potential_fij(r[i], r[j])
            forces[i] += fij
            forces[j] -= fij
        end
    end
    forces
end

function vector_equal(a, b, tol=1e-5)
    N = length(a)
    @inbounds for i = 1:N
        all(abs.(a[i] - b[i]) .≤ tol) || return false
    end
    true
end