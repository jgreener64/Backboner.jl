export is_knotted

import StaticArrays: SVector

#=
This file contains an implementation of the KnotFind algorithm, described by Khatib, Weirauch,
and Rohl in 2006, in the paper "Rapid knot detection and application to protein structure prediction"

 1. Take all alphacarbons of a protein backbone.
 2. Sort them using some metric, e.g. distance or area of the triangle formed by three consecutive Cα atoms.
 3. For an individual triple, i-1,i,i+1, if no line segments j,j+1 connecting consecutive Cα atoms
cross through the triangle, then Cα i is removed from the chain.
 4. If any line segment intersects the triangle, then no atom is removed
and the algorithm proceeds to the triangle with the next smallest metric value.
 4. After any Cα is removed, the algorithm returns to the triple with the shortest distance, just in case some segment no longer intersects,
This is repeated until the last triple is reached and simplified, if possible.
 5. When it terminates, the protein contains no knots if there's only one segment left.
 6. Run again with a different metric if the chain is not simplified to make sure it wasn't a false positive.
=#

abstract type TriangleMetric end

abstract type TriangleDistance <: TriangleMetric end
abstract type TriangleArea <: TriangleMetric end

(metric::Type{TriangleDistance})(a::V, ::V, c::V) where V <: AbstractVector{<:Real} = norm(c - a)
(metric::Type{TriangleArea})(a::V, b::V, c::V) where V <: AbstractVector{<:Real} = norm(cross(b - a, c - a)) / 2

(metric::Type{<:TriangleMetric})(points::Vector{V}) where {T <: Real, V <: AbstractVector{T}} = T[metric(points[i:i+2]...) for i in 1:length(points)-2]

function line_segment_intersects_triangle(
    segment_start::V, segment_end::V,
    a::V, b::V, c::V,
) where {T <: Real, V <: AbstractVector{T}}
    segment_vector = segment_end - segment_start
    edge1, edge2 = b - a, c - a
    segment_cross_e2 = cross(segment_vector, edge2)
    det = dot(edge1, segment_cross_e2)
    abs(det) < eps(T) && return false # segment is parallel to triangle
    inv_det = 1.0 / det
    s = segment_start - a
    u = inv_det * dot(s, segment_cross_e2)
    (u < 0 || u > 1) && return false
    s_cross_e1 = cross(s, edge1)
    v = inv_det * dot(segment_vector, s_cross_e1)
    (v < 0 || u + v > 1) && return false
    t = inv_det * dot(edge2, s_cross_e1)
    return eps(T) < t <= 1 # segment intersection
end

function check_intersection(points::Vector{V}, i::Int) where {T <: Real, V <: AbstractVector{T}}
    a, b, c = points[i-1], points[i], points[i+1] 
    for j in 1:length(points)-1
        i-2 <= j <= i+1 && continue
        p1, p2 = points[j], points[j+1]
        line_segment_intersects_triangle(p1, p2, a, b, c) && return true
    end
    return false
end

# for removing an atom from a backbone, and updating adjacent triangles
function remove_atom!(points::Vector{V}, i::Int, metric_values::Vector{T}, metric::Type{<:TriangleMetric}) where {T <: Real, V <: AbstractVector{T}}
    m = length(metric_values)
    triangle_index = i - 1
    triangle_index > 1 && (metric_values[triangle_index-1] = metric(points[i-2], points[i-1], points[i+1]))
    triangle_index < m && (metric_values[triangle_index+1] = metric(points[i-1], points[i+1], points[i+2]))
    deleteat!(points, i)
    deleteat!(metric_values, triangle_index)
    return nothing
end

function simplify!(points::Vector{V}, metric::Type{<:TriangleMetric}) where {T <: Real, V <: AbstractVector{T}}
    metric_values = metric(points) # Vector{T} of length n-2
    while !isempty(metric_values)
        order = sortperm(metric_values) # TODO: calculate once outside while loop, update in `remove_atom!`
        has_removed = false
        for triangle_index in order
            i = triangle_index + 1
            if !check_intersection(points, i)
                remove_atom!(points, i, metric_values, metric)
                has_removed = true
                break
            end
        end
        !has_removed && break # terminate if the chain can't be simplified further
    end
    return points
end

simplify(points::Vector{V}, metric::Type{<:TriangleMetric}) where {T <: Real, V <: AbstractVector{T}} = simplify!(deepcopy(points), metric)

"""
    is_knotted(backbone::Backbone)

Check if a backbone is knotted.
"""
function is_knotted(
    backbone::Backbone,
    metrics = [TriangleDistance, TriangleArea],
)
    points = SVector{3}.(eachcol(backbone)) # convert to StaticArrays for 40x performance lmao
    for metric in metrics
        length(simplify(points, metric)) == 2 && return false
    end
    return true
end
