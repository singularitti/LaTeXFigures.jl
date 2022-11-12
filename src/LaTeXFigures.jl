module LaTeXFigures

export Figure

struct IncludeGraphicsOptions
    angle::Float64
    origin::Symbol
    width::Number
    height::Number
    totalheight::Number
    keepaspectratio::Bool
    scale::Float64
    clip::Bool
    draft::Bool
    type::String
    ext::String
    read::String
    quiet::Bool
    interpolate::Bool
    function IncludeGraphicsOptions(
        angle,
        origin,
        width,
        height,
        totalheight,
        keepaspectratio,
        scale,
        clip,
        draft,
        type,
        ext,
        read,
        quiet,
        interpolate,
    )
        @assert origin in (:c, :tr)
        @assert width >= zero(width) && height >= zero(height)
        return new(
            angle,
            origin,
            width,
            height,
            totalheight,
            keepaspectratio,
            scale,
            clip,
            draft,
            type,
            ext,
            read,
            quiet,
            interpolate,
        )
    end
end
function IncludeGraphicsOptions(;
    angle=0,
    origin=:c,
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
    return IncludeGraphicsOptions(
        angle,
        origin,
        width,
        height,
        totalheight,
        keepaspectratio,
        scale,
        clip,
        draft,
        type,
        ext,
        read,
        quiet,
        interpolate,
    )
end

struct Figure
    path::String
    caption::String
    label::String
    position::String
    centering::Bool
    options::IncludeGraphicsOptions
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
    return Figure(
        path, caption, label, position, centering, IncludeGraphicsOptions(; kwargs...)
    )
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
