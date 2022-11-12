module LaTeXFigures

export Figure, Subfigure, latexformat

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

struct Figure
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

struct Subfigure
    path::String
    width::Float64
    height::Float64
    caption::String
    label::String
    position::String
    centering::Bool
    options::Base.Pairs
    function Subfigure(path, width, height, caption, label, position, centering, options)
        if !isempty(position)
            @assert all(arg in ('c', 't', 'b', 'T', 'B') for arg in position)
        end
        @assert width > 0 && height >= 0
        for key in keys(options)
            if key ∉ keys(DEFAULT_INCLUDE_GRAPHICS_OPTIONS)
                throw(KeyError(key))
            end
        end
        return new(
            string(path),
            width,
            height,
            string(caption),
            string(label),
            string(position),
            centering,
            options,
        )
    end
end
function Subfigure(
    path, width; height=0, caption="", label="", position="", centering=true, kwargs...
)
    return Subfigure(path, width, height, caption, label, position, centering, kwargs)
end

function latexformat(figure::Figure; indent=' '^4, newline='\n')
    str = raw"\begin{figure}"
    if !isempty(figure.position)
        str *= string('[', figure.position, ']')
    end
    str *= newline
    if figure.centering
        str *= string(indent, raw"\centering", newline)
    end
    str *= string(indent, raw"\includegraphics")
    if !isempty(figure.options)
        str *= '['
        for (n, (key, value)) in enumerate(pairs(figure.options))
            if n == length(figure.options)
                str *= string(key, '=', value)
            else
                str *= string(key, '=', value, ", ")
            end
        end
        str *= ']'
    end
    str *= string('{', figure.path, '}', newline)
    for (command, arg) in zip((raw"\caption", raw"\label"), (figure.caption, figure.label))
        if !isempty(arg)
            str *= string(indent, command, '{', arg, '}', newline)
        end
    end
    str *= raw"\end{figure}"
    return str
end
function latexformat(figure::Subfigure; indent=' '^4, newline='\n')
    str = string(indent, raw"\begin{subfigure}")
    if !isempty(figure.position)
        str *= string('[', figure.position, ']')
    end
    if !iszero(figure.height)
        str *= string('[', figure.height, "]")
    end
    str *= string('{', figure.width, raw"\textwidth", '}', newline)
    if figure.centering
        str *= string(indent^2, raw"\centering", newline)
    end
    str *= string(indent^2, raw"\includegraphics")
    if !isempty(figure.options)
        str *= '['
        for (n, (key, value)) in enumerate(pairs(figure.options))
            if n == length(figure.options)
                str *= string(key, '=', value)
            else
                str *= string(key, '=', value, ", ")
            end
        end
        str *= ']'
    end
    str *= string('{', figure.path, '}', newline)
    for (command, arg) in zip((raw"\caption", raw"\label"), (figure.caption, figure.label))
        if !isempty(arg)
            str *= string(indent^2, command, '{', arg, '}', newline)
        end
    end
    str *= string(indent, raw"\end{subfigure}")
    return str
end

end
