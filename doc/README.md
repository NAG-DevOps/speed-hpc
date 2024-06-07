# User Manual and Related Files

Our base manual is written in LaTeX.

- `speed-manual.tex` -- is the main file
- `speed-manual.tcp` -- if you use TeXnicCenter on Windows
- `speed-manual.pdf` -- periodically rendered PDF file
- `Makefile` -- to build on Linux or macOS
    - `make` -- to compile the PDF manual
    - `make html` -- to compile HTML manual
- [`web/`](web/) -- HTML manual, produced off these LaTeX sources
- [.devcontainer/](.devcontainer/) -- a devcontainer for building LaTeX manual in Visual Studio Code, see its README inside

