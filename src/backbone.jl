export Backbone

"""
    Backbone{T <: Real} <: AbstractMatrix{T}

The `Backbone` type is designed to efficiently store and manipulate the three-dimensional coordinates of backbone atoms.

# Examples

A `Backbone` can be created from a matrix of coordinates:

```jldoctest
julia> backbone = Backbone(zeros(3, 5)) # 5 atoms with 3 coordinates each
5-element Backbone{Float64}:
 [0.0, 0.0, 0.0]
 [0.0, 0.0, 0.0]
 [0.0, 0.0, 0.0]
 [0.0, 0.0, 0.0]
 [0.0, 0.0, 0.0]

julia> backbone[1] = [1.0, 2.0, 3.0]; # set the first atom's coordinates

julia> backbone
3×5 Backbone{Float64, Matrix{Float64}}:
 1.0  0.0  0.0  0.0  0.0
 2.0  0.0  0.0  0.0  0.0
 3.0  0.0  0.0  0.0  0.0

julia> backbone[1:2] # indexing by range returns a `Backbone` wrapped around a view of the original
3×2 Backbone{Float64, Matrix{Float64}}:
 1.0  0.0
 2.0  0.0
 3.0  0.0
```

Arrays will always be flattened to be a 3xN matrix:

```jldoctest
julia> backbone = Backbone(zeros(3, 3, 4)) # e.g. 3 coordinates per atom, 3 atoms per residue, 4 residues
3×12 Backbone{Float64, Matrix{Float64}}:
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
```
"""
struct Backbone{T <: Real, M <: AbstractMatrix{T}} <: AbstractMatrix{T}
    coords::M

    function Backbone{T, M}(coords::M) where {T <: Real, M <: AbstractMatrix{T}}
        size(coords, 1) == 3 || throw(ArgumentError("Expected the first dimension of coords to have a size of 3"))
        return new{T, M}(coords)
    end
end

Backbone{T}(coords::M) where {T <: Real, M <: AbstractMatrix{T}} = Backbone{T, M}(coords)
Backbone{T}(coords::AbstractArray{T}) where T <: Real = Backbone{T}(reshape(coords, size(coords, 1), :))
Backbone{T}(coords::AbstractArray{<:Real}) where T <: Real = Backbone{T}(convert(Array{T}, coords))
Backbone(coords::AbstractArray{T}) where T <: Real = Backbone{T}(coords)

Backbone{T, M}(::UndefInitializer, n::Integer) where {T <: Real, M <: AbstractMatrix{T}} = Backbone{T, M}(M(undef, 3, n))
Backbone{T}(::UndefInitializer, n::Integer) where T = Backbone{T, Matrix{T}}(undef, n)
Backbone{T}() where T = Backbone{T}(undef, 0)

@inline Base.size(backbone::Backbone) = size(backbone.coords)
@inline Base.getindex(backbone::Backbone, i, j) = backbone.coords[i, j]
@inline Base.view(backbone::Backbone, i, j) = view(backbone.coords, i, j)
@inline Base.setindex!(backbone::Backbone, v, i, j) = (backbone.coords[i, j] .= v)

@inline Base.length(backbone::Backbone) = size(backbone, 2)
@inline Base.getindex(backbone::Backbone, indices::AbstractVector{Int}) = Backbone(backbone.coords[:, indices])
@inline Base.view(backbone::Backbone, indices::AbstractVector{Int}) = Backbone(view(backbone.coords, :, indices))