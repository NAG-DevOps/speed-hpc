#!/encs/bin/bash

GENERATED_ON=`date`
OUTFILE="software-list"

# Generate the LaTeX version first
cat > "$OUTFILE.tex" << LATEX_HEADER
% -----------------------------------------------------------------------------
% $0
\section{Software Installed On Speed}
\label{sect:software-details}

This is s generated section by a script; last updated on \textit{$GENERATED_ON}.
We hae two major software trees: Scientific Linux 7 (EL7), which is
outgoing, and AlmaLinux 9 (EL9), after major synchronization of software
packages is complete, we will stop maintaining the EL7 tree and
will migrade the remaining nodes to EL9.

NOTE: this list does not include packages installed directly on the OS (yet).

% -----------------------------------------------------------------------------
\subsection{EL7}
\label{sect:software-el7}

Not all packages are intended for HPC, but the common tree is available
on Speed as well as teaching lab desktops.

\begin{itemize}
LATEX_HEADER

ls -1 /encs/ArchDep/x86_64.EL7/pkg/ \
  | egrep -v HIDE \
  | sed 's/^/\\item \\verb|/g' \
  | sed 's/$/|/g' \
  >> "$OUTFILE.tex"

cat >> "$OUTFILE.tex" << LATEX_EL9_HEADER
\end{itemize}

% -----------------------------------------------------------------------------
\subsection{EL9}
\label{sect:software-el9}

\begin{itemize}
LATEX_EL9_HEADER

ls -1 /encs/ArchDep/x86_64.EL9/pkg/ \
  | egrep -v HIDE \
  | sed 's/^/\\item \\verb|/g' \
  | sed 's/$/|/g' \
  >> "$OUTFILE.tex"


cat >> "$OUTFILE.tex" << LATEX_FOOTER
\end{itemize}

% EOF
LATEX_FOOTER

# Get .md version of the same from LaTeX
pandoc -s "$OUTFILE.tex" -o "$OUTFILE.md"

# EOF
