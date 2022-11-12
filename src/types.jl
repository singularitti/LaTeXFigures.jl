export Figure, Subfigure, TwoSubfigures

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

abstract type AbstractFigure end
struct Figure <: AbstractFigure
    path::String
    caption::String
    label::String
    position::String
    centering::Bool
    options::Base.Pairs
    function Figure(path, caption, label, position, centering, options)
        if !isempty(position)
            @assert all(arg in ('!', 'h', 't', 'b', 'p', 'H') for arg in position)
        end
        for key in keys(options)
            if key ∉ keys(DEFAULT_INCLUDE_GRAPHICS_OPTIONS)
                throw(KeyError(key))
            end
        end
        return new(
            string(path),
            string(caption),
            string(label),
            string(position),
            centering,
            options,
        )
    end
end
function Figure(path; caption="", label="", position="", centering=true, kwargs...)
    return Figure(path, caption, label, position, centering, kwargs)
end

struct Subfigure <: AbstractFigure
    path::String
    w::Float64
    h::Float64
    caption::String
    label::String
    position::String
    centering::Bool
    options::Base.Pairs
    function Subfigure(path, w, h, caption, label, position, centering, options)
        if !isempty(position)
            @assert all(arg in ('c', 't', 'b', 'T', 'B') for arg in position)
        end
        @assert w > 0 && h >= 0
        for key in keys(options)
            if key ∉ keys(DEFAULT_INCLUDE_GRAPHICS_OPTIONS)
                throw(KeyError(key))
            end
        end
        return new(
            string(path),
            w,
            h,
            string(caption),
            string(label),
            string(position),
            centering,
            options,
        )
    end
end
function Subfigure(
    path, w; h=0, caption="", label="", position="", centering=true, kwargs...
)
    return Subfigure(path, w, h, caption, label, position, centering, kwargs)
end

struct TwoSubfigures <: AbstractFigure
    a::Subfigure
    b::Subfigure
    caption::String
    label::String
    position::String
    centering::Bool
    hfill::Bool
    function TwoSubfigures(a, b, caption, label, position, centering, hfill)
        if !isempty(position)
            @assert all(arg in ('!', 'h', 't', 'b', 'p', 'H') for arg in position)
        end
        return new(a, b, string(caption), string(label), string(position), centering, hfill)
    end
end
function TwoSubfigures(a, b; caption="", label="", position="", centering=true, hfill=true)
    return TwoSubfigures(a, b, caption, label, position, centering, hfill)
end
