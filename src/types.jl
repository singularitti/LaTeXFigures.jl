export Figure, Subfigure, TwoSubfigures, here, top, bottom, page, override, Here

const DEFAULT_INCLUDE_GRAPHICS_OPTIONS = (
    angle=0,
    origin="c",
    width=0,
    height=0,
    totalheight=0,
    keepaspectratio=false,
    scale=1,
    clip=false,
    draft=false,
    type="eps",
    ext="eps",
    read="eps",
    quiet=true,
    interpolate=false,
)

"""
    Position(n)

Represent the position of the figure, available values are `here`, `top`, `bottom`,
`page`, `override`, `Here`.
"""
@enum Position here top bottom page override Here

abstract type AbstractFigure end
"""
    Figure(path, caption, label, position, centering, options)

Represent a single figure.
"""
struct Figure <: AbstractFigure
    path::String
    caption::String
    label::String
    position::Vector{Position}
    centering::Bool
    options::Base.Pairs
    function Figure(path, caption, label, position, centering, options)
        for key in keys(options)
            if key ∉ keys(DEFAULT_INCLUDE_GRAPHICS_OPTIONS)
                throw(KeyError(key))
            end
        end
        return new(
            string(path), string(caption), string(label), position, centering, options
        )
    end
end
function Figure(path; caption="", label="", position=Position[], centering=true, kwargs...)
    return Figure(path, caption, label, position, centering, kwargs)
end
"""
    Subfigure(path, w, h, caption, label, position, centering, options)

Represent a subfigure within a figure.
"""
struct Subfigure <: AbstractFigure
    path::String
    w::Float64
    h::Float64
    caption::String
    label::String
    position::Vector{Position}
    centering::Bool
    options::Base.Pairs
    function Subfigure(path, w, h, caption, label, position, centering, options)
        @assert w > 0 && h >= 0
        for key in keys(options)
            if key ∉ keys(DEFAULT_INCLUDE_GRAPHICS_OPTIONS)
                throw(KeyError(key))
            end
        end
        return new(
            string(path), w, h, string(caption), string(label), position, centering, options
        )
    end
end
function Subfigure(
    path, w; h=0, caption="", label="", position=Position[], centering=true, kwargs...
)
    return Subfigure(path, w, h, caption, label, position, centering, kwargs)
end
"""
    TwoSubfigures(a, b, caption, label, position, centering, hfill)

Represent a figure with two subfigures `a` and `b`.
"""
struct TwoSubfigures <: AbstractFigure
    a::Subfigure
    b::Subfigure
    caption::String
    label::String
    position::Vector{Position}
    centering::Bool
    hfill::Bool
    function TwoSubfigures(a, b, caption, label, position, centering, hfill)
        return new(a, b, string(caption), string(label), position, centering, hfill)
    end
end
function TwoSubfigures(
    a, b; caption="", label="", position=Position[], centering=true, hfill=true
)
    return TwoSubfigures(a, b, caption, label, position, centering, hfill)
end

function Base.string(position::Position)
    if position == override
        return "!"
    elseif position == here
        return "h"
    elseif position == top
        return "t"
    elseif position == bottom
        return "b"
    elseif position == page
        return "p"
    elseif position == Here
        return "H"
    else
        throw(ArgumentError("this should never happen!"))
    end
end
Base.string(positions::Vector{Position}) = '[' * join(string.(positions)) * ']'
