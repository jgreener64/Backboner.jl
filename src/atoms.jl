struct VectorArray{L, T, N, M, A <: AbstractArray{T, M}} <: AbstractArray{AbstractVector{T}, N}
    data::A

    function VectorArray{L, T, N, M, A}(data::A) where {T, N, M, A <: AbstractArray{T, M}}
        @assert size(data, 1) == L
        @assert M == N + 1
        return new{L, T, N, M, A}(data)
    end
end

VectorArray{L, T, N, M}(data::A) where {L, T, N, M, A <: AbstractArray{T, M}} = VectorArray{L, T, N, M, A}(data)
VectorArray{L, T, N}(data::A) where {L, T, N, M, A <: AbstractArray{T, M}} = VectorArray{L, T, N, M, A}(data)
VectorArray{L, T}(data::A) where {L, T, M, A <: AbstractArray{T, M}} = VectorArray{L, T, M-1, M, A}(data)
VectorArray{L}(data::A) where {L, T, M, A <: AbstractArray{T, M}} = VectorArray{L, T, M-1, M, A}(data)
VectorArray(data::A) where {T, M, A <: AbstractArray{T, M}} = VectorArray{size(data, 1), T, M-1, M, A}(data)

Base.size(vector_array::VectorArray) = size(vector_array.data)[2:end]
Base.length(vector_array::VectorArray) = prod(size(vector_array))

Base.getindex(vector_array::VectorArray{T, N}, i::Vararg{Integer, N}) where {T, N} = vector_array.data[:, i...]
Base.getindex(vector_array::VectorArray{T, N}, i::Vararg{I, N}) where {T, N, I} = VectorArray(vector_array.data[:, i...])

const VectorVector{T} = VectorArray{3, T, 1, 2}
const VectorMatrix{T} = VectorArray{3, T, 2, 3}

const AtomArray = VectorArray{3}
const AtomVector{T} = AtomArray{T, 1, 2}
const AtomMatrix{T} = AtomArray{T, 2, 3}