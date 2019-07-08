import Random
import Test: @test

import MolecularDynamicsIntegrators: move!, VerletIntegrator
import MolecularDynamicsIntegrators.Bases: Vector3s

Random.seed!(2017012811)

N = 3
r = Vector3s{N}(
    [0, 0, 0],
    [0, 1, 0],
    [0, 1, 1]
)
v = rand(Vector3s{N})
dt = 0.001
mass = i -> 1.0
force = lj_potential_forces
steps = 15

setup = VerletIntegrator(r, v, dt, mass, force)

@info "Testing VerletIntegrator..."

for i = 1:steps
    move!(setup)
end

@test vector3s_equal(r, Vector3s{N}(
    [0.00710061, 0.00400043, 0.00116091],
    [0.0134183, 1.01396, 0.00203195],
    [0.0117694, 1.00888, 1.00123]
))

@test vector3s_equal(v, Vector3s{N}(
    [0.473348, 0.258312, 0.0690382],
    [0.894556, 0.930612, 0.135463],
    [0.784652, 0.600622, 0.0901549]
))
