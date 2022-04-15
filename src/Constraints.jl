module Constraints

export AbstractConstraint, FixedDistanceConstraint

abstract type AbstractConstraint end

struct FixedDistanceConstraint <: AbstractConstraint
    i::Int
    j::Int
    distance::Float64
end

end
