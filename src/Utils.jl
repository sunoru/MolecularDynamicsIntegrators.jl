module Utils

@inline function acceleration(forces::Vector{T}, m::Function) where T
    N = length(forces)
    a = zeros(T, N)
    @inbounds for i = 1:N
        a[i] = forces[i] / m(i)
    end
    a
end

end
