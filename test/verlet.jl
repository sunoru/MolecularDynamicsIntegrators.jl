import Random
import Test: @test

import MolecularDynamicsIntegrators: move!, VerletIntegrator
import MolecularDynamicsIntegrators.Bases: Vector3

Random.seed!(2017012811)

N = 3
r = [
    Vector3(0, 0, 0),
    Vector3(0, 1, 0),
    Vector3(0, 1, 1)
]
v = [rand(3) for _ in 1:N]
dt = 0.001
mass = i -> 1.0
force = lj_potential_forces
steps = 2000

setup = VerletIntegrator(r, v, dt, mass, force)

@info "Testing VerletIntegrator..."

for i = 1:steps
    move!(setup)
end

@test vector_equal(setup.positions, [
    [0.9046459496087763, -0.14795147116821855, -0.48311455629751504],
    [1.789111152976618, 2.8612241428150713, 0.27092667944587845],
    [1.611354120760534, 2.865819353671669, 1.8015007201159405]
])
@test vector_equal(setup.velocities, [
    [0.44612166649242696, -0.13022690285766972, -0.29141016315001966],
    [0.8945555764882902, 0.9306120714075277, 0.13546333972293678],
    [0.8118783686922247, 0.9891608441093953, 0.450603245059233]
])
