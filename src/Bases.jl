module Bases

import StaticArrays: SVector, SizedVector

const RealType = Float64

const Nullable{T} = Union{Nothing, T}

const Vector3 = SVector{3, RealType}
const TVector{N, T} = SizedVector{N, T, 1}
const Vector3s{N} = TVector{N, Vector3}

end
