export Chain

abstract type AbstractChain{T} end

# could be made into a Vector{Residue} but that would overcomplicate things
"""
    Chain{T}

A chain has an identifier (usually a single letter) and holds the backbone atom coordinates and secondary structure of a protein chain. 
"""
struct Chain{T}
    id::AbstractString
    backbone::Backbone{4,T}
    ssvector::Vector{SecondaryStructure}

    function Chain(
        id::AbstractString,
        backbone::Backbone{4,T},
        ssvector::Union{Nothing, Vector{SecondaryStructure}} = nothing,
    ) where T
        ssvector = isnothing(ssvector) ? fill(MiSSing, length(backbone)) : ssvector
        @assert length(backbone) == length(ssvector) "backbone and ssvector must have the same length"
        return new{T}(id, backbone, ssvector)
    end
end

Base.length(chain::Chain) = length(chain.backbone)
Base.size(chain::Chain) = (length(chain),)

Base.summary(chain::Chain) = "Chain $(chain.id) with $(length(chain)) residues"
Base.show(io::IO, chain::Chain) = print(io, summary(chain))

has_missing_ss(chain::Chain) = has_missing_ss(chain.ssvector)

include("segment.jl")