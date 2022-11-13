using LaTeXFigures
using Documenter

DocMeta.setdocmeta!(LaTeXFigures, :DocTestSetup, :(using LaTeXFigures); recursive=true)

makedocs(;
    modules=[LaTeXFigures],
    authors="singularitti <singularitti@outlook.com> and contributors",
    repo="https://github.com/singularitti/LaTeXFigures.jl/blob/{commit}{path}#{line}",
    sitename="LaTeXFigures.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://singularitti.github.io/LaTeXFigures.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => [
            "Installation guide" => "installation.md",
        ],
        "API Reference" => "public.md",
        "Developer Docs" => [
            "Contributing" => "developers/contributing.md",
            "Style Guide" => "developers/style.md",
        ],
        "Troubleshooting" => "troubleshooting.md",
    ],
)

deploydocs(;
    repo="github.com/singularitti/LaTeXFigures.jl",
)
