export latexformat

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
            if key == :width
                value = value isa Real ? string(value, raw"\textwidth") : string(value)  # Works for unitful values
            end
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
    if !iszero(figure.h)
        str *= string('[', figure.h, "]")
    end
    str *= string('{', figure.w, raw"\textwidth", '}', newline)
    if figure.centering
        str *= string(indent^2, raw"\centering", newline)
    end
    str *= string(indent^2, raw"\includegraphics")
    if !isempty(figure.options)
        str *= '['
        for (n, (key, value)) in enumerate(pairs(figure.options))
            if key == :width
                value = value isa Real ? string(value, raw"\textwidth") : string(value)  # Works for unitful values
            end
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
function latexformat(figure::TwoSubfigures; indent=' '^4, newline='\n')
    str = raw"\begin{figure}"
    if !isempty(figure.position)
        str *= string('[', figure.position, ']')
    end
    str *= newline
    if figure.centering
        str *= string(indent, raw"\centering", newline)
    end
    str *= join(
        map(
            subfigure -> latexformat(subfigure; indent=indent, newline=newline),
            (figure.a, figure.b),
        ),
        newline * begin
            figure.hfill ? string(indent, raw"\hfill", newline) : ""
        end,
    )
    str *= newline
    for (command, arg) in zip((raw"\caption", raw"\label"), (figure.caption, figure.label))
        if !isempty(arg)
            str *= string(indent, command, '{', arg, '}', newline)
        end
    end
    str *= raw"\end{figure}"
    return str
end
