import MolecularDynamicsIntegrators: move!, RattleIntegrator, FixedDistanceConstraint
import MolecularDynamicsIntegrators.Bases: Vector3s, SVector

N = 3
r = Vector3s{N}(
    [0, 0, 0],
    [0, 1, 0],
    [0, 2, 0]
)
v = Vector3s{N}(
    [0, 0, 0],
    [0.5, 0, 0.8],
    [0.9, 0, -0.4]
)
dt = 0.001
mass = i -> 1.0
force = lj_potential_forces
steps = 15
tolerance = dt ^ 2
max_iter = 10000
K = 2
gs = SVector{K}(
    FixedDistanceConstraint(1, 2, 1.0),
    FixedDistanceConstraint(2, 3, 1.0),
)

setup = RattleIntegrator(r, v, dt, mass, force, tolerance, max_iter, gs)

@info "Testing RattleIntegrator..."

for i = 1:steps
    move!(setup)
end

@test vector3s_equal(r, Vector3s{N}(
    [3.25308e-7, 0.000126079, 6.14071e-7],
    [0.00749998, 1.00003, 0.0119984],
    [0.0134997, 1.99985, -0.00599898]
))

@test vector3s_equal(v, Vector3s{N}(
    [6.17858e-5, 0.0165069, 0.000117657],
    [0.499997, 0.00374218, 0.799681],
    [0.899941, -0.0202491, -0.399799]
))
