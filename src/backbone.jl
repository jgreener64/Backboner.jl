export Backbone, remove_column, has_missing_ss

struct Backbone{A, T <: Real} <: AbstractVector{Chain{A, T}}
    chains::Vector{Chain{A, T}}

    function Backbone(chains::Vector{Chain{A, T}}) where {A, T}
        @assert length(unique([chain.id for chain in chains])) == length(chains)
        return new{A, T}(chains)
    end
end

@inline Base.size(bb::Backbone) = size(bb.chains)
@inline Base.length(bb::Backbone) = length(bb.chains)
@inline Base.getindex(bb::Backbone, i) = bb.chains[i]

Base.summary(bb::Backbone{A, T}) where {A, T} = "Backbone{$A, $T} with $(length(bb)) chains"

function remove_column(backbone::Backbone{A, T}, i::Integer) where {A, T}
    new_chains = Vector{Chain{A-1, T}}()
    for chain in backbone
        push!(new_chains, remove_column(chain, i))
    end
    return Backbone(new_chains)
end

function has_missing_ss(backbone::Backbone)
    return any(has_missing_ss, backbone)
end