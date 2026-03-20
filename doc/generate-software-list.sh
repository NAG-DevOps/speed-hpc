#!/encs/bin/bash

# Generates .tex and .md versions of the software list
# Serguei Mokhov

GENERATED_ON=`date`
OUTFILE="software-list"

# Generate the LaTeX version first
cat > "$OUTFILE.tex" << LATEX_HEADER
% -----------------------------------------------------------------------------
% $0
\section{Software Installed On Speed}
\label{sect:software-list}

This is a generated section by a script; last updated on \textit{$GENERATED_ON}.
We have two major software trees:
AlmaLinux 9 (EL9), and
Scientific Linux 7 (EL7), which is outgoing, and only available for legacy reasons.
We stopped maintaining the EL7 tree after
having migrated all the nodes to EL9.

EL9 packages come in the following flavours:
%
\begin{itemize}
\item
EL9 \texttt{/encs/pkg} -- traditionally manually installed/compiled
\item
EasyBuild EL9 -- using the same EasyBuild tool Alliance Canada use for software compilation
\end{itemize}
%
Both are are available through \tool{modules}.

\noindent
\textbf{NOTE:} this list does not include packages installed directly on the OS (yet).
LATEX_HEADER

cat >> "$OUTFILE.tex" << LATEX_EL9_HEADER
% -----------------------------------------------------------------------------
\subsection{EL9 (/encs/pkg)}
\label{sect:software-el9}

\scriptsize
\begin{multicols}{3}
\begin{itemize}
LATEX_EL9_HEADER

ls -1 /encs/ArchDep/x86_64.EL9/pkg/ \
  | egrep -v HIDE \
  | sed 's/^/\\item \\verb|/g' \
  | sed 's/$/|/g' \
  >> "$OUTFILE.tex"

cat >> "$OUTFILE.tex" << LATEX_EB_HEADER
\end{itemize}
\end{multicols}
\normalsize

% -----------------------------------------------------------------------------
\subsection{EB (EL9)}
\label{sect:software-eb}

\scriptsize
\begin{multicols}{3}
\begin{itemize}
LATEX_EB_HEADER

/encs/pkg/EasyBuild/root/./list.sh > /dev/null 2>&1

cat eb-list.txt | sed 's/^/\\item \\verb|/g' | sed 's/$/|/g' >> "$OUTFILE.tex"
rm -f eb-list.txt

cat >> "$OUTFILE.tex" << LATEX_FOOTER
\end{itemize}
\end{multicols}
\normalsize

% -----------------------------------------------------------------------------
\subsection{EL7 (legacy)}
\label{sect:software-el7}

Not all packages are intended for HPC, but the common tree is available
on Speed as well as teaching labs' desktops.

\scriptsize
\begin{multicols}{3}
\begin{itemize}
LATEX_FOOTER

ls -1 /encs/ArchDep/x86_64.EL7/pkg/ \
  | egrep -v HIDE \
  | sed 's/^/\\item \\verb|/g' \
  | sed 's/$/|/g' \
  >> "$OUTFILE.tex"

cat >> "$OUTFILE.tex" << LATEX_EL7_FOOTER
\end{itemize}
\end{multicols}
\normalsize

% EOF
LATEX_EL7_FOOTER

# Get .md version of the same from LaTeX
pandoc -s "$OUTFILE.tex" -o "$OUTFILE.md"

# EOF
