module Types

export AbstractIntegrator, move!, current_positions, current_velocities, set_state!

import ..Bases: RealType, Vector3s, Vector3

# M: Mass function; F: Force function
# Accept mass as a function (index -> value) instead of an array in order to perform better in special
# cases like that all the masses are the same.
abstract type AbstractIntegrator{M <: Function, F <: Function} end


move!(::AbstractIntegrator) = error("Unimplemented")

current_positions(::AbstractIntegrator) = error("Unimplemented")
current_velocities(::AbstractIntegrator) = error("Unimplemented")
set_state!(::AbstractIntegrator, rs::Vector3s, vs::Vector3s) = error("Unimplemented")

end
