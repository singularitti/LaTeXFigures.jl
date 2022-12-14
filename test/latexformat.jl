using Unitful: @u_str

# Examples from https://www.overleaf.com/learn/latex/Inserting_Images
@testset "Test formatting a figure" begin
    @testset "With position" begin
        figure = Figure("Plot"; position=[top], width=8u"cm")
        @test latexformat(figure; indent=' '^4) == raw"""\begin{figure}[t]
            \centering
            \includegraphics[width=8 cm]{Plot}
        \end{figure}"""
    end
    @testset "Without position" begin
        figure = Figure("Plot"; position=[], width=8u"cm")
        @test latexformat(figure; indent=' '^4) == raw"""\begin{figure}
            \centering
            \includegraphics[width=8 cm]{Plot}
        \end{figure}"""
    end
    @testset "Without label" begin
        figure = Figure(
            "spiral";
            caption=raw"Example of a parametric plot ($\sin (x), \cos(x), x$)",
            position=[bottom],
            width=0.5,
        )
        @test latexformat(figure; indent=' '^4) == raw"""\begin{figure}[b]
            \centering
            \includegraphics[width=0.5\textwidth]{spiral}
            \caption{Example of a parametric plot ($\sin (x), \cos(x), x$)}
        \end{figure}"""
    end
    @testset "With label" begin
        figure = Figure(
            "mesh"; caption="a nice plot", label="fig:mesh1", position=[top], width=0.25
        )
        @test latexformat(figure; indent=' '^4) == raw"""\begin{figure}[t]
            \centering
            \includegraphics[width=0.25\textwidth]{mesh}
            \caption{a nice plot}
            \label{fig:mesh1}
        \end{figure}"""
    end
end

# Example from https://tex.stackexchange.com/a/37597
@testset "Test formatting two subfigures" begin
    figure1 = Subfigure("image1", 0.6; caption="A subfigure", label="fig:sub1", width=0.4)
    figure2 = Subfigure("image2", 0.4; caption="A subfigure 2", label="fig:sub2", width=0.6)
    @testset "With `hfill` is `false`" begin
        figure = TwoSubfigures(
            figure1,
            figure2;
            caption="A figure with two subfigures",
            label="fig:test",
            hfill=false,
        )
        @test latexformat(figure; indent=' '^4) == raw"""\begin{figure}
            \centering
            \begin{subfigure}{0.6\textwidth}
                \centering
                \includegraphics[width=0.4\linewidth]{image1}
                \caption{A subfigure}
                \label{fig:sub1}
            \end{subfigure}
            \begin{subfigure}{0.4\textwidth}
                \centering
                \includegraphics[width=0.6\linewidth]{image2}
                \caption{A subfigure 2}
                \label{fig:sub2}
            \end{subfigure}
            \caption{A figure with two subfigures}
            \label{fig:test}
        \end{figure}"""
    end
    @testset "With `hfill` is `true`" begin
        figure = TwoSubfigures(
            figure1,
            figure2;
            caption="A figure with two subfigures",
            label="fig:test",
            hfill=true,
        )
        @test latexformat(figure; indent=' '^4) == raw"""\begin{figure}
            \centering
            \begin{subfigure}{0.6\textwidth}
                \centering
                \includegraphics[width=0.4\linewidth]{image1}
                \caption{A subfigure}
                \label{fig:sub1}
            \end{subfigure}
            \hfill
            \begin{subfigure}{0.4\textwidth}
                \centering
                \includegraphics[width=0.6\linewidth]{image2}
                \caption{A subfigure 2}
                \label{fig:sub2}
            \end{subfigure}
            \caption{A figure with two subfigures}
            \label{fig:test}
        \end{figure}"""
    end
    @testset "Without caption" begin
        figure = TwoSubfigures(figure1, figure2; label="fig:test", hfill=true)
        @test latexformat(figure; indent=' '^4) == raw"""\begin{figure}
            \centering
            \begin{subfigure}{0.6\textwidth}
                \centering
                \includegraphics[width=0.4\linewidth]{image1}
                \caption{A subfigure}
                \label{fig:sub1}
            \end{subfigure}
            \hfill
            \begin{subfigure}{0.4\textwidth}
                \centering
                \includegraphics[width=0.6\linewidth]{image2}
                \caption{A subfigure 2}
                \label{fig:sub2}
            \end{subfigure}
            \label{fig:test}
        \end{figure}"""
    end
    @testset "Without caption and label" begin
        figure = TwoSubfigures(figure1, figure2; hfill=true)
        @test latexformat(figure; indent=' '^4) == raw"""\begin{figure}
            \centering
            \begin{subfigure}{0.6\textwidth}
                \centering
                \includegraphics[width=0.4\linewidth]{image1}
                \caption{A subfigure}
                \label{fig:sub1}
            \end{subfigure}
            \hfill
            \begin{subfigure}{0.4\textwidth}
                \centering
                \includegraphics[width=0.6\linewidth]{image2}
                \caption{A subfigure 2}
                \label{fig:sub2}
            \end{subfigure}
        \end{figure}"""
    end
    @testset "Without captions and labels" begin
        figure1 = Subfigure("image1", 0.6; width=0.4)
        figure2 = Subfigure("image2", 0.4; width=0.6)
        figure = TwoSubfigures(figure1, figure2; hfill=true)
        @test latexformat(figure; indent=' '^4) == raw"""\begin{figure}
            \centering
            \begin{subfigure}{0.6\textwidth}
                \centering
                \includegraphics[width=0.4\linewidth]{image1}
            \end{subfigure}
            \hfill
            \begin{subfigure}{0.4\textwidth}
                \centering
                \includegraphics[width=0.6\linewidth]{image2}
            \end{subfigure}
        \end{figure}"""
    end
end
