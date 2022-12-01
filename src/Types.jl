module Types

export AbstractIntegrator, move!, current_positions, current_velocities, set_state!,
    IntegratorParameters

abstract type AbstractIntegrator end

move!(::AbstractIntegrator) = error("Unimplemented")

current_positions(::AbstractIntegrator) = error("Unimplemented")
current_velocities(::AbstractIntegrator) = error("Unimplemented")
set_state!(::AbstractIntegrator, rs, vs) = error("Unimplemented")

abstract type IntegratorParameters end

end
