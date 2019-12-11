module Utils

import ..Bases: Vector3s, Vector3

@inline function acceleration(forces::Vector3s, m::Function)
    N = length(forces)
    a = zeros(Vector3, N)
    @inbounds for i = 1:N
        a[i] = forces[i] / m(i)
    end
    a
end

end
