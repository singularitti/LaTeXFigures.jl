module LaTeXFigures

export Figure


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

function Base.show(io::IO, figure::Figure)
    println(io, "\\begin{figure}[", string(figure.position), ']')
    if figure.centering
        println(io, "\\centering")
    end
    print(io, "\\includegraphics[")
    default = IncludeGraphicsOptions()
    for option in fieldnames(IncludeGraphicsOptions)
        value = getfield(figure.options, option)
        if getfield(figure.options, option) != getfield(default, option)
            print(io, string(option), '=', string(value), ", ")
        end
    end
    println(io, "]{", figure.path, '}')
    println(io, "\\caption{", figure.caption, '}')
    println(io, "\\label{", figure.label, '}')
    println(io, "\\end{figure}")
    return nothing
end

end
