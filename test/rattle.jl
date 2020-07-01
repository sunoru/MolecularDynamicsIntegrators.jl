import LinearAlgebra: ⋅, norm_sqr

import MolecularDynamicsIntegrators: move!, RattleIntegrator, FixedDistanceConstraint
import MolecularDynamicsIntegrators.Bases: Vector3

N = 4
d = 1.0
r = [
    Vector3(0, 0, 0),
    Vector3(0, 1, 0),
    Vector3(0, 2, 0),
    Vector3(0, 3, 0)
]
v = [
    Vector3(0, 0, 0),
    Vector3(0.5, 0, 0.8),
    Vector3(0.9, 0, -0.4),
    Vector3(0.6, 0, -0.6)
]
dt = 0.001
mass = i -> 1.0
force = lj_potential_forces
steps = 2000
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
    [0.09737654288485667, 0.7887420889546933, 0.5214751803156499],
    [0.9743787172580586, 1.2551728024457112, 0.4061033839318231],
    [1.5416316823754233, 1.815657545994333, -0.19728780411825142],
    [1.3866130574816684, 2.140427562605264, -1.1302907601292107]
])

@test vector_equal(setup.velocities, [
    [0.22170214165089389, 0.48444541940694, 0.5318306598452084],
    [0.35308534346411097, 0.022864444526390852, -0.3355580167319755],
    [0.5589660298465181, 0.13590564532722463, -0.03700640122784894],
    [0.8662464850384826, -0.6432155092605506, -0.35926624188538064]
])
