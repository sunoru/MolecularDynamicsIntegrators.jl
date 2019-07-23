module Bases

import Base: @propagate_inbounds, @boundscheck

import StaticArrays: SVector, SMatrix, MVector

const RealType = Float64

const Nullable{T} = Union{Nothing, T}

const Vector3 = SVector{3, RealType}
const Matrix3 = SMatrix{3, 3, RealType}
const Vector3s = Vector{Vector3}

end
