import LinearAlgebra: ⋅, norm_sqr

import MolecularDynamicsIntegrators: move!, RattleIntegrator, FixedDistanceConstraint

N = 4
d = 1.0
r = [
    [0, 0, 0],
    [0, 1, 0],
    [0, 2, 0],
    [0, 3, 0]
]
v = [
    [0, 0, 0],
    [0.5, 0, 0.8],
    [0.9, 0, -0.4],
    [0.6, 0, -0.6]
]
dt = 0.001
mass = i -> 1.0
force = lj_potential_forces
steps = 200
tol = 0.000001
max_iter = 10000
K = 3
gs = [
    FixedDistanceConstraint(1, 2, d),
    FixedDistanceConstraint(2, 3, d),
    FixedDistanceConstraint(3, 4, d)
]

setup = RattleIntegrator(r, v, dt, mass, force, tol, max_iter, gs)

@info "Testing RattleIntegrator..."

function test_constraints(r, v, gs, tol)
    K = length(gs)
    @inbounds for ki = 1:K
        i, j, d = gs[ki].i, gs[ki].j, gs[ki].distance
        @test abs(norm_sqr(r[i] - r[j]) - d ^ 2) ≤ 2 * tol * d^2
        @test abs((r[i] - r[j]) ⋅ (v[i] - v[j])) ≤ tol * d^2
    end
end

test_constraints(setup.positions, setup.velocities, gs, tol)
for i = 1:steps
    move!(setup)
    test_constraints(setup.positions, setup.velocities, gs, tol)
end

@test vector_equal(setup.positions, [
    [0.000926047, 0.028409, 0.00170405],
    [0.100176, 1.01162, 0.154843],
    [0.1784, 1.98129, -0.0767061],
    [0.120499, 2.97868, -0.119841]
])
@test vector_equal(setup.velocities, [
    [0.013087, 0.269705, 0.024221],
    [0.502556, 0.110891, 0.72665],
    [0.877244, -0.177166, -0.353082],
    [0.607113, -0.20343, -0.597789]
])
