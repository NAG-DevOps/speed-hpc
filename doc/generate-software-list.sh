#!/encs/bin/bash

GENERATED_ON=`date`
OUTFILE="software-list"

# Generate the LaTeX version first
cat > "$OUTFILE.tex" << LATEX_HEADER
% -----------------------------------------------------------------------------
% $0
\section{Software Installed On Speed}
\label{sect:software-details}

This is a generated section by a script; last updated on \textit{$GENERATED_ON}.
We have two major software trees: Scientific Linux 7 (EL7), which is
outgoing, and AlmaLinux 9 (EL9). After major synchronization of software
packages is complete, we will stop maintaining the EL7 tree and
will migrade the remaining nodes to EL9.

\noindent
\textbf{NOTE:} this list does not include packages installed directly on the OS (yet).

% -----------------------------------------------------------------------------
\subsection{EL7}
\label{sect:software-el7}

Not all packages are intended for HPC, but the common tree is available
on Speed as well as teaching labs' desktops.

\begin{multicols}{3}
\begin{itemize}
LATEX_HEADER

ls -1 /encs/ArchDep/x86_64.EL7/pkg/ \
  | egrep -v HIDE \
  | sed 's/^/\\item \\verb|/g' \
  | sed 's/$/|/g' \
  >> "$OUTFILE.tex"

cat >> "$OUTFILE.tex" << LATEX_EL9_HEADER
\end{itemize}
\end{multicols}

% -----------------------------------------------------------------------------
\subsection{EL9}
\label{sect:software-el9}

\begin{multicols}{3}
\begin{itemize}
LATEX_EL9_HEADER

ls -1 /encs/ArchDep/x86_64.EL9/pkg/ \
  | egrep -v HIDE \
  | sed 's/^/\\item \\verb|/g' \
  | sed 's/$/|/g' \
  >> "$OUTFILE.tex"


cat >> "$OUTFILE.tex" << LATEX_FOOTER
\end{itemize}
\end{multicols}

% EOF
LATEX_FOOTER

# Get .md version of the same from LaTeX
pandoc -s "$OUTFILE.tex" -o "$OUTFILE.md"

# EOF
