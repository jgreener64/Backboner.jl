struct Atom{T} <: AbstractVector{T}
    coords::AbstractVector{T}
    symbol::Symbol

    function Atom{T}(coords::AbstractVector{T}, symbol::Symbol) where T <: Real
        @assert length(coords) == 3 "coords must have 3 coordinates per atom"
        return new{T}(coords, symbol)
    end
end

Atom(coords::AbstractVector{T}, args...) where T = Atom{T}(coords, args...)

Base.summary(a::Atom) = "$(length(a.coords))-element Atom ($(a.symbol))"
Base.show(io::IO, a::Atom{T}) where T = print(io, "Atom($(round.(a.coords, digits=3)), :$(a.symbol))")

@inline Base.size(a::Atom) = size(a.coords)
@inline Base.length(a::Atom) = length(a.coords)

@inline Base.getindex(a::Atom, i...) = a.coords[i...]
@inline Base.setindex!(a::Atom{T}, coords::AbstractVector{T}, i...) where T = (a.coords[i...] .= coords)


abstract type AbstractAtomArray{T <: Real, N} <: AbstractArray{Atom{T}, N} end

const AbstractAtomVector{T} = AbstractAtomArray{T, 1}
const AbstractAtomMatrix{T} = AbstractAtomArray{T, 2}


struct AtomArray{T <: Real, N, M, A <: AbstractArray{T, M}} <: AbstractAtomArray{T, N}
    coords::A
    symbols::Vector{Symbol}

    function AtomArray{T, N}(
        coords::A,
        symbols::Vector{Symbol} = fill(:unnamed, size(coords, 2))
    ) where {T <: Real, N, M, A <: AbstractArray{T, M}}
        @assert length(symbols) == size(coords, 2) "number of symbols must match number of atoms in first dimension"
        @assert N == M - 1 "dimensionality of coords must be one greater than dimensionality of AtomArray"
        @assert size(coords, 1) == 3 "coords must have 3 coordinates per atom"
        return new{T, N, M, A}(coords, symbols)
    end
end

const AtomVector{T} = AtomArray{T, 1}
const AtomMatrix{T} = AtomArray{T, 2}

@inline AtomArray{T}(coords::AbstractArray{T, M}, args...) where {T, M} = AtomArray{T, M-1}(coords, args...)
@inline AtomArray(coords::AbstractArray{T}, args...) where T = AtomArray{T}(coords, args...)

@inline Base.size(a::AtomArray) = size(a.coords)[2:end]
@inline Base.length(a::AtomArray) = prod(size(a))

@inline Base.:(==)(aa1::AtomArray, aa2::AtomArray) = aa1.coords == aa2.coords
@inline Base.:(≈)(aa1::AtomArray, aa2::AtomArray) = aa1.coords ≈ aa2.coords

@inline getsymbol(symbols::Array{Symbol}, i::Integer) = symbols[mod1(i, length(symbols))]
@inline Base.getindex(aa::AtomArray{T, N}, i::Vararg{Integer, N}) where {T, N} = Atom(aa.coords[:, i...], getsymbol(aa.symbols, LinearIndices(aa)[i...]))
@inline Base.getindex(aa::AtomArray{T, N}, i::Vararg{I, N}) where {T, I, N} = AtomArray(aa.coords[:, i...], [getsymbol(aa.symbols, j) for j in LinearIndices(aa)[first(i)]])

@inline Base.setindex!(aa::AtomArray, coords::AbstractVector, i::Integer) = (aa.coords[:, i] .= coords)
@inline Base.setindex!(aa::AtomArray, coords::AbstractMatrix, I...) = (aa.coords[:, I...] .= coords)