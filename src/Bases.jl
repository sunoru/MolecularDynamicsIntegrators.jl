module Bases

import Base: @propagate_inbounds, @boundscheck

import StaticArrays: SVector, SMatrix, MVector, dimension_mismatch_fail

const RealType = Float64

const Nullable{T} = Union{Nothing, T}

const Vector3 = SVector{3, RealType}
const Matrix3 = SMatrix{3, 3, RealType}
const Vector3s{N} = MVector{N, Vector3}

@inline make_vector(x::Vector3s) = x
@inline function make_vector(x::AbstractVector)
    m = length(x)
    Vector3s{m}(x)
end
@inline function make_vector(x::AbstractMatrix)
    m, _ = size(x)
    convert(Vector3s{m}, x)
end

@inline make_svector(x::AbstractVector) = SVector{length(x)}(x)

@propagate_inbounds function convert(::Type{V}, x::AbstractMatrix) where {V <: Vector3s}
    m, n = size(x)
    @boundscheck if m !== length(V) || n !== 3
        throw(DimensionMismatch("expected input matrix of size $(length(SA))x3, got size $(m)x$(n)"))
    end
    @inbounds V([x[i, :] for i in 1:m])
end

end
