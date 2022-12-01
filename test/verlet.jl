using MolecularDynamicsIntegrators: move!, VerletIntegrator

@testset "Verlet" begin
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

    for i = 1:steps
        move!(setup)
    end

    @test setup.positions ≈ [
        [0.012925251233403398, 0.12468008323252931, 0.42136795208804606],
        [0.6118280564741769, 2.5418601972010393, 1.7430189196629002],
        [1.136453017521721, 3.511798489296003, 1.9158143836134611]
    ]
    @test setup.velocities ≈ [
        [-0.006794248644095888, -0.017369573618650585, 0.1533066209776989],
        [0.305914028237079, 0.7709300986005134, 0.8715094598314336],
        [0.581483383021656, 1.335608859882911, 0.5152845468730523]
    ]
end
