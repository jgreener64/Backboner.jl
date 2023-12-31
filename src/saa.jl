import Pkg; Pkg.activate(".")
import StaticArrays: SizedArray

struct SizedArrayArray{S <: Tuple, T, D, N, M, A <: AbstractArray{T, M}} <: AbstractArray{SizedArray{S, T, D}, N}
    data::A

    function SizedArrayArray{S, T, D, N, M, A}(data::A) where {S, T, D, N, M, A}
        @assert length(fieldnames(S)) == D
        @assert D + N == M
        @assert Tuple{size(data)[begin:D]...} == S
        return new{S, T, D, N, M, A}(data)
    end
end

Base.size(a::SizedArrayArray{S, T, D}) where {S, T, D} = size(a.data)[begin+D:end]
Base.length(a::SizedArrayArray) = prod(size(a))

Base.getindex(a::SizedArrayArray{S, T, D, N}, i::Vararg{Int, N}) where {E, S, T, D, N} = SizedArrayArray{S}(a.data[ntuple(_ -> :, D)..., i...])

const SizedScalarArray = SizedArrayArray{Tuple{}}
const SizedVectorArray{S1} = SizedArrayArray{Tuple{S1}}
const SizedMatrixArray{S1, S2} = SizedArrayArray{Tuple{S1, S2}}

SizedArrayArray{S, T, D, N, M}(data::A) where {S, T, D, N, M, A <: AbstractArray{T, M}} = SizedArrayArray{S, T, D, N, M, A}(data)
SizedArrayArray{S, T, D, N}(data::A) where {S, T, D, N, M, A <: AbstractArray{T, M}} = SizedArrayArray{S, T, D, N, M, A}(data)
SizedArrayArray{S, T, D}(data::A) where {S, T, D, M, A <: AbstractArray{T, M}} = SizedArrayArray{S, T, D, M-D, M, A}(data)
SizedArrayArray{S, T}(data::A) where {S, T, M, A <: AbstractArray{T, M}} = SizedArrayArray{S, T, length(fieldnames(S))}(data)
SizedArrayArray{S}(data::A) where {S, T, M, A <: AbstractArray{T, M}} = SizedArrayArray{S, T, length(fieldnames(S))}(data)