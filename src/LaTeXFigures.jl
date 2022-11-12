module LaTeXFigures

export Figure, latexformat


struct Figure
    path::String
    caption::String
    label::String
    position::String
    centering::Bool
    options::NamedTuple
    function Figure(path, caption, label, position, centering, options)
        if !isempty(position)
            @assert all(arg in ('!', 'h', 't', 'b', 'p', 'H') for arg in position)
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
    return Figure(path, caption, label, position, centering, NamedTuple(kwargs))
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

end
