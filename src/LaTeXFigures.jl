module LaTeXFigures

export Figure

struct FigureOptions
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
    function FigureOptions(
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
function FigureOptions(;
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
    return FigureOptions(
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
    position::Symbol
    options::FigureOptions
    path::String
    caption::String
    label::String
    centering::Bool
    function Figure(position, options, path, caption, label, centering)
        @assert position in (:h, :t, :b, :p, :H)
        return new(position, options, path, caption, label, centering)
    end
end
function Figure(path; position=:h, caption="", label="", centering=true, kwargs...)
    return Figure(position, FigureOptions(; kwargs...), path, caption, label, centering)
end

function Base.show(io::IO, figure::Figure)
    println(io, "\\begin{figure}[", string(figure.position), ']')
    if figure.centering
        println(io, "\\centering")
    end
    print(io, "\\includegraphics[")
    default = FigureOptions()
    for option in fieldnames(FigureOptions)
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
