module Bases

import StaticArrays: SVector

const RealType = Float64

const Nullable{T} = Union{Nothing, T}

const Vector3 = SVector{3, RealType}
const Vector3s = Vector{Vector3}

end
