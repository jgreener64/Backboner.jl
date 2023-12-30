export AbstractBackbone, Backbone, BackboneView

using ElasticArrays

const ElasticAtomArray{T, N} = AtomArray{T, N, M, A} where {M, A <: ElasticArray{T, M}}
const ElasticAtomVector{T} = ElasticAtomArray{T, 1}
const ElasticAtomMatrix{T} = ElasticAtomArray{T, 2}

abstract type AbstractBackbone{T <: Real} <: AbstractAtomVector{T} end


struct Backbone{T} <: AbstractBackbone{T}
    atoms::ElasticAtomVector{T}
    bonds::ChainedBonds{T}

    function Backbone{T}(atomarray::AtomArray{T}) where T
        atoms = AtomVector{T}(ElasticArray(reshape(atomarray.coords, 3, :)))
        bonds = ChainedBonds(atoms)
        return new{T}(atoms, bonds)
    end
end

Backbone{T}(coords::AbstractArray{T}) where T = Backbone{T}(AtomArray{T}(coords))
Backbone(coords::AbstractArray{T}) where T = Backbone{T}(coords)

@inline Base.size(backbone::Backbone) = size(backbone.atoms)
@inline Base.length(backbone::Backbone) = length(backbone.atoms)

@inline Base.getindex(backbone::Backbone, i::Integer) = backbone.atoms[i]
@inline Base.getindex(backbone::Backbone, r::AbstractVector{<:Integer}) = Backbone(backbone.atoms[I])


struct BackboneView{T} <: AbstractBackbone{T}
    original::Backbone{T}
    indices::AbstractVector{<:Integer}

    function BackboneView{T}(original::Backbone{T}, indices::AbstractVector{<:Integer}) where T
        checkbounds(original, indices)
        return new{T}(original, indices)
    end
end

@inline Base.size(backbone::BackboneView) = length(backbone.indices)
@inline Base.length(backbone::BackboneView) = size(backbone.indices)

@inline Base.getindex(backbone::BackboneView, i::Integer) = backbone.original[backbone.indices[i]]
@inline Base.getindex(backbone::BackboneView, I...) = BackboneView(backbone.original, backbone.indices[I...])
