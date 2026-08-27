-- ======================================================================
-- snippet.lua  -  snippet definitions
--
-- Register with  ae.snippet(trigger, body).  In insert mode type the
-- trigger (the bare word, WITHOUT a leading backslash) then press <tab>:
-- the word is replaced by the body and the cursor jumps to $1. <tab>
-- moves to the next stop, <s-tab> back; $0 is the final resting place.
--
-- Body syntax:  $1 $2 $3 ... are tabstops, $0 is the last stop.
--   ${1:label} is accepted too, but the label is NOT inserted (each stop
--   is just an empty position you type into).
--
-- TWO IMPORTANT NOTES for this editor's snippet engine:
--   * Triggers are GLOBAL, not per-file-type. Every snippet is available
--     in every buffer, so the tex / vesti sets below use distinct triggers
--     (vesti ones are prefixed with "v") to avoid clobbering each other.
--   * There is no placeholder mirroring: a number repeated like $1 ... $1
--     is two independent empty stops, not a copy. So environment snippets
--     give the opening and closing names separate stops ($1 and the next).
--
-- LaTeX is full of backslashes, which are escape characters in normal Lua
-- strings, so the multi-line bodies use long-bracket strings [==[ ... ]==]
-- where backslashes and newlines are literal.
-- ======================================================================

-- ----------------------------------------------------------------------
-- Rust (the original examples)
-- ----------------------------------------------------------------------
ae.snippet("fn",  "fn ${1:name}(${2:args}) -> ${3:()} {\n    $0\n}", "rs")
ae.snippet("for", "for ${1:i} in ${2:iter} {\n    $0\n}", "rs")
ae.snippet("if",  "if ${1:cond} {\n    $0\n}", "rs")
ae.snippet("pln", 'println!("$1", $2);$0', "rs")

-- ae.snippet also takes an optional filetype list, so one trigger can expand
-- differently per language (a filetype-specific entry beats a global one):
--   ae.snippet("fn", "fn $1($2) {\n    $0\n}", "rs")
--   ae.snippet("fn", "def $1($2):\n    $0",     "py")

-- ----------------------------------------------------------------------
-- TeX / LaTeX  (.tex, .latex)
-- ----------------------------------------------------------------------

-- document skeleton
ae.snippet("doc", [==[
\documentclass{$1}
\begin{document}
$0
\end{document}]==])

-- a generic environment: $1 opens it, $3 closes it (no mirroring), $2 body
ae.snippet("beg", [==[
\begin{$1}
    $2
\end{$3}]==])

-- common fixed-name environments (no name to retype)
ae.snippet("eq", [==[
\begin{equation}
    $0
\end{equation}]==])

ae.snippet("align", [==[
\begin{align}
    $0
\end{align}]==])

ae.snippet("itm", [==[
\begin{itemize}
    \item $0
\end{itemize}]==])

ae.snippet("enum", [==[
\begin{enumerate}
    \item $0
\end{enumerate}]==])

ae.snippet("fig", [==[
\begin{figure}[$1]
    \centering
    \includegraphics[width=$2\textwidth]{$3}
    \caption{$4}
    \label{fig:$5}
\end{figure}
$0]==])

-- sectioning and inline commands
ae.snippet("sec",  [==[\section{$1}$0]==])
ae.snippet("sub",  [==[\subsection{$1}$0]==])
ae.snippet("ssub", [==[\subsubsection{$1}$0]==])
ae.snippet("bf",   [==[\textbf{$1}$0]==])
ae.snippet("it",   [==[\textit{$1}$0]==])
ae.snippet("tt",   [==[\texttt{$1}$0]==])
ae.snippet("frac", [==[\frac{$1}{$2}$0]==])
ae.snippet("sq",   [==[\sqrt{$1}$0]==])
ae.snippet("im",   [==[\($1\)$0]==])           -- inline math
ae.snippet("dm",   [==[\[\n    $0\n\]]==])     -- display math
ae.snippet("ref",  [==[\ref{$1}$0]==])
ae.snippet("cite", [==[\cite{$1}$0]==])

-- ----------------------------------------------------------------------
-- vesti  (.ves) - a LaTeX preprocessor: docclass / startdoc / useenv { }
-- (triggers prefixed with "v" so they coexist with the LaTeX set)
-- ----------------------------------------------------------------------
local TEX = "tex,latex,ves"
ae.snippet("be", [==[\[
    $1
\]
$0]==],                                       TEX)  -- display math

-- ----------------------------------------------------------------------
-- AUTO-EXPANDING snippets (no <tab>): they fire the instant the trigger is
-- typed. ae.autosnippet(trigger, body [, filetypes]); filetypes is a
-- comma-separated extension list, omitted = every buffer. Word-like triggers
-- (letters) only fire at a word boundary, so "MK" expands after a space but
-- not inside a word; symbol triggers (like "//") fire anywhere. NOTE: there
-- is no math-mode detection, so these expand anywhere in the file.
-- ----------------------------------------------------------------------
ae.autosnippet("MK",  "$$1$$0",                 TEX)  -- inline math:  MK -> $|$
