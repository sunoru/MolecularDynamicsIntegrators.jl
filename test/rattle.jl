import LinearAlgebra: ⋅, norm_sqr

import MolecularDynamicsIntegrators: move!, RattleIntegrator, FixedDistanceConstraint
import MolecularDynamicsIntegrators.Bases: Vector3s, SVector

N = 4
d = 1.0
r = Vector3s{N}(
    [0, 0, 0],
    [0, 1, 0],
    [0, 2, 0],
    [0, 3, 0]
)
v = Vector3s{N}(
    [0, 0, 0],
    [0.5, 0, 0.8],
    [0.9, 0, -0.4],
    [0.6, 0, -0.6]
)
dt = 0.001
mass = i -> 1.0
force = lj_potential_forces
steps = 200
tol = 0.000001
max_iter = 10000
K = 3
gs = SVector{K}(
    FixedDistanceConstraint(1, 2, d),
    FixedDistanceConstraint(2, 3, d),
    FixedDistanceConstraint(3, 4, d),
)

setup = RattleIntegrator(r, v, dt, mass, force, tol, max_iter, gs)

@info "Testing RattleIntegrator..."

function test_constraints(r::Vector3s{N}, v::Vector3s{N}, gs::SVector{K}, tol::Real) where K
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

# @test vector3s_equal(r, Vector3s{N}(
#     [3.25308e-7, 0.000126079, 6.14071e-7],
#     [0.00749998, 1.00003, 0.0119984],
#     [0.0134997, 1.99985, -0.00599898]
# ))
#
# @test vector3s_equal(v, Vector3s{N}(
#     [6.17858e-5, 0.0165069, 0.000117657],
#     [0.499997, 0.00374218, 0.799681],
#     [0.899941, -0.0202491, -0.399799]
# ))
