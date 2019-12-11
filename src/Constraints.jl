module Constraints

import ..Bases: RealType

export AbstractConstraint, FixedDistanceConstraint

abstract type AbstractConstraint end

struct FixedDistanceConstraint <: AbstractConstraint
    i::Int
    j::Int
    distance::RealType
end

end
