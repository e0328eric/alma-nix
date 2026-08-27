%%==============================================================================

%% This class has a copywrite to Coprime --- Ver : 3.02
%% Email Address : almagest0328@gmail.com
%% Encoded by UTF-8
%
%% coprime Class, First Release Date : 2018/06/31
%
%% Ver 2.00b : 18/06/31 --- Release in Class mod
%
%% Ver 2.10b : 18/07/11 --- Big Update! (First using Key macro to make a class)
%% Ver 2.11b : 18/07/11 --- Delete \spaceskip to solve the issue which is auto line skip error
%% Ver 2.12b : 18/07/14 --- Add cleveref package
%% Ver 2.13b : 18/07/17 --- Add fouridx package
%
%% Ver 2.20b : 18/08/05 --- Geometry and Babel options can be fully used!
%
%% Ver 2.30b : 18/08/06 --- Add no capitalization of title
%% Ver 2.31b : 18/08/06 --- Fix a bug where head of last page is different with others
%% Ver 2.32b : 18/08/20 --- Add multirow package
%
%% Ver 2.40b : 18/10/06 --- Add cleveref package and add two new commands: \contradiction and \not
%
%% Ver 2.50b : 18/10/09 --- Reedit font names
%% Ver 2.51b : 18/10/15 --- Make \idx command
%% Ver 2.52b : 18/10/16 --- Fix the error of \es and add \converge command
%% Ver 2.53b : 18/10/17 --- Add accent package and make \accent command
%% Ver 2.54b : 18/11/02 --- Add fancythm option (But this has some error...)
%% Ver 2.55b : 18/11/03 --- Fix the error when fancythm is off
%% Ver 2.56b : 18/11/03 --- Now, to use easily, TTReport envionment is deleted. Use \setting instead.
%			    Also, delete \accent command and add leqno class option.
%% Ver 3.00b : 18/11/05 --- Huge Update!!! Change the name to KUReport
%% Ver 3.01b : 18/11/05 --- Now you can edit head using \sethead. There is a bug when the foot line
%%                          is on. Add hangul option too
%% Ver 3.02b : 18/11/07 --- Change base geometry to fix the problem of \setfoot
%% Ver 3.03b : 18/11/08 --- Reedit font commands
%% Ver 3.04b : 18/11/10 --- Use article class instead of amsart class. And... something else lol
%% Ver 3.05b : 18/11/10 --- Fix \C command which caused the error and babel bold issue
%% Ver 3.06b : 18/11/11 --- Adding multicol option and package
%% Ver 3.07b : 18/11/13 --- More Fancy Theorem box
%% Ver 3.08b : 18/12/09 --- Add version option and add TTReport environment
%
%% Ver 3.10b : 18/12/10 --- Edit the class slightly and fix the bug
%% Ver 3.11b : 18/12/12 --- Change the math font. Add \ds command and define \bbb{1} as \ds{1}.
%%                           If you want to use stix font, downgrade the version of this package.
%% Ver 3.12b : 18/12/13 --- Use mathabx font in final
%
%% Ver 3.20b : 18/12/13 --- Making \not command perfectly!
%% Ver 3.21b : 18/12/13 --- Bug fix
%
%% Ver 3.30b : 18/12/15 --- Make a new command : \Matrix
%
%% Ver 0.0.0 : 18/12/19 --- Change the class with LaTeX3 Language. Class name is changed and fancythm fixed
%% Ver 0.0.1 : 18/12/29 --- Add stix2-type 1 font, delete mathabx font
%% Ver 0.0.2 : 19/01/05 --- Fixed \usegeometry, \setbabel and \sethyperlink issues
%
%% Ver 0.1.0 : 19/01/21 --- Can be used in LuaTeX but not XeTeX
%% Ver 0.1.1 : 19/01/23 --- Fix the issue when using hyperlink option
%% Ver 0.1.2 : 19/02/22 --- Edit the \Matrix command
%
%% Ver 1.0.0 : 19/02/25 --- Major Update!
%
%% Ver 1.1.0 : 19/02/28 --- Make the titlepage
%% Ver 1.1.1 : 19/03/06 --- Fix bugs.
%% Ver 1.1.2 : 19/03/15 --- Delete hangul and hanja options
%
%% Ver 1.2.0 : 19/03/17 --- Add reference environment to use bibtex easely
%% Ver 1.2.1 : 19/03/22 --- Fix the bug when .bib file made although the reference environment
%	      .  	   does not active and change the default code of \Matrix command
%% Ver 1.2.2 : 19/03/28 --- Add etoolbox package which makes command more efficiently
%% Ver 1.2.3 : 19/04/16 --- Edit fancythm style
%% Ver 1.2.4 : 19/06/24 --- Fix some issues of fancythm style
%% Ver 1.2.5 : 19/07/20 --- Fix some issues when using LuaTeX engine
%
%% Ver 2.0.0 : 19/07/22 --- Remake class to work well when using LuaTeX
%
%% Ver 3.0.0 : 19/10/24 --- Huge Updates!
%% Ver 3.0.1 : 19/11/06 --- Change latex engine to run coprime. XeTeX and LuaTeX works.
%% Ver 3.0.2 : 19/12/22 --- Add luaotfload and luacode packages and fix some minor bug
%% Ver 3.0.3 : 25/07/02 --- Change default font side to 10pt
%% Ver 3.0.4 : 25/07/19 --- Add new font

%===============================================================================

% LaTeX Format and Define Class Name
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3, xparse, l3keys2e}
\ProvidesExplClass {coprime} {2025/07/19} {3.0.4} {Copywrite to Coprime}

% Define Version Constant
\tl_const:Nn \c__current_version_tl {3.0.4}

%Declare Booleans
\bool_new:N \g_custom_titlepage_bool
\bool_new:N \g_foot_edit_bool
\bool_new:N \g_geometry_used_bool
\bool_new:N \g_head_edit_bool
\bool_new:N \g_hyperlink_used_bool
\bool_new:N \g_multicolumn_end_bool
\bool_new:N \g_multicolumn_end_star_bool
\bool_new:N \g_title_author_empty_bool
\bool_set_true:N \g_title_author_empty_bool
\bool_new:N \g_version_new_bool
\bool_set_true:N \g_version_new_bool

%Declare Most Important!
\tl_new:N \title_tl
\tl_new:N \author_tl
\tl_new:N \date_tl
\fp_new:N \baseline_fp
\sys_if_engine_pdftex:TF
{
    \fp_set:Nn \baseline_fp {1.06}
}
{
    \fp_set:Nn \baseline_fp {1.02}
}
\dim_new:N \parindent_dim
\dim_new:N \parskip_dim
\dim_set:Nn \parindent_dim {10pt}
\dim_set:Nn \parskip_dim {0em}

%Declare Dimention
\dim_new:N \font_size_dim
\dim_set:Nn \font_size_dim {10pt}

%Interchanging Control Sequence
\cs_new:Npn \cop_change_commds:N #1
{
    \cs_new:cn
}

%Declare Options
\keys_define:nn {coprime-main-options}
{
    fancythm .bool_set:N = \g_fancythm_bool,
    fontsize .code:n = {\dim_set:Nn \font_size_dim {#1}},
    fontsize .default:n = 11pt,
    geometry .bool_set:N = \g_geometry_bool,
    hyperlink .bool_set:N = \g_hyperlink_bool,
    item .bool_set:N = \g_item_bool,
    korean .bool_set:N = \g_korean_bool,
    leqno .bool_set:N = \g_leqno_bool,
    multicol .bool_set:N = \g_multicol_bool,
    nobreak .bool_set:N = \g_nobreak_bool,
    stix .bool_set:N = \g_stix_bool,
    erewhon .bool_set:N = \g_erewhon_bool,
    table .bool_set:N = \g_table_bool,
    tikz .bool_set:N = \g_tikz_bool,
    twoside .bool_set:N = \g_twoside_bool,
    version .tl_set:N = \c__edited_version_tl,
    8pt .code:n = {\dim_set:Nn \font_size_dim {8pt}},
    9pt .code:n = {\dim_set:Nn \font_size_dim {9pt}},
    10pt .code:n = {\dim_set:Nn \font_size_dim {10pt}},
    11pt .code:n = {\dim_set:Nn \font_size_dim {11pt}},
    12pt .code:n = {\dim_set:Nn \font_size_dim {12pt}},
    13pt .code:n = {\dim_set:Nn \font_size_dim {13pt}},
}

\keys_set:nn {coprime-main-options}
{
    version = \c__current_version_tl,
}

\ProcessKeysOptions{coprime-main-options}

%reqno vs leqno
\bool_if:NTF \g_leqno_bool
	{%
		\LoadClass[leqno]{article}
	}
	{%
		\LoadClass{article}
	}

% Raise Error when the tex engine is not either pdf or lua
\sys_if_engine_ptex:T
{
    \ClassError{coprime}{Use~'pdftex',~'xetex',~or~'luatex'~engine}{}
}

\sys_if_engine_uptex:T
{
    \ClassError{coprime}{Use~'pdftex',~'xetex',~or~'luatex'~engine}{}
}

% Import some packages
\bool_if:NTF \g_nobreak_bool
{
    \bool_if:NTF \g_stix_bool
    {
        \RequirePackage[nobreak,stix]{coprime-math}
    }
    {
    \bool_if:NTF \g_erewhon_bool
    {
        \RequirePackage[nobreak,erewhon]{coprime-math}
    }
    {
        \RequirePackage[nobreak]{coprime-math}
    }
    }
}
{
    \bool_if:NTF \g_stix_bool
    {
        \RequirePackage[stix]{coprime-math}
    }
    {
    \bool_if:NTF \g_erewhon_bool
    {
        \RequirePackage[erewhon]{coprime-math}
    }
    {
        \RequirePackage{coprime-math}
    }
    }
}

\RequirePackage{coprime-reference}
\RequirePackage{anyfontsize}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{xcolor}

\sys_if_engine_luatex:T
{
    \RequirePackage{luaotfload}
    \RequirePackage{luacode}
}


%Korean Usepackage
\bool_if:NT \g_korean_bool
{%
    \RequirePackage{kotex}
    %\sys_if_engine_pdftex:F
    %{
    %    \setmainhangulfont{Batang}
    %}
}

\bool_if:NT \g_fancythm_bool
{%
    \RequirePackage{fancythm}
}


%Item Option
\bool_if:NT \g_item_bool
{%
    \RequirePackage{outlines}
    \RequirePackage{enumitem}
}

%Table Option
\bool_if:NT \g_table_bool
{%
    \RequirePackage{longtable}
    \RequirePackage{multirow}
    \RequirePackage{array}
    \RequirePackage{hhline}
}

%Setting Geometry
\tl_set:Nn \tl_Margin_Setup {a4paper, margin = 1.3in, includeheadfoot, footskip = .4in}
\NewDocumentCommand{\setgeometry}{m}{
	\bool_set_true:N \g_geometry_used_bool
	\bool_if:NTF \g_geometry_bool
    {%
        \tl_if_blank:nTF {#1}
        {%
            \ClassWarning{coprime}{Setting~basic~geometry~option~instead.}
        }
        {%
            \tl_set:Nn \tl_Margin_Setup {#1}
        }
    }
    {%
        \ClassError{coprime}
            {Add~'geometry'~option~to~use~this~command}
            {Add~'geometry'~option~to~use~this~command}
    }
	\RequirePackage[\tl_use:N \tl_Margin_Setup]{geometry}
}
\bool_if:NF \g_geometry_bool
	{%
		\RequirePackage[\tl_use:N \tl_Margin_Setup]{geometry}
	}

%Cleveref and Hyperref Package
\tl_gset:Nn \tl_Hyperlink_Setup {colorlinks = true, urlcolor = black!50!cyan, citecolor = magenta, linkcolor = blue}
\NewDocumentCommand{\sethyperlink}{m}{%
	\bool_set_true:N \g_hyperlink_used_bool
	\bool_if:NTF \g_hyperlink_bool
        {%
            \tl_if_blank:nTF {#1}
            {%
                \ClassWarning{coprime}{Setting~basic~hyperlink~option~instead.}
            }
            {%
                \tl_gset:Nn \tl_Hyperlink_Setup {#1}
            }
        }
        {%
            \ClassError{coprime}
                {Add~'hyperlink'~option~to~use~this~command}
                {Add~'hyperlink'~option~to~use~this~command}
        }
            \RequirePackage[\tl_use:N \tl_Hyperlink_Setup]{hyperref}
            \RequirePackage{fancythm}
}
\bool_if:NF \g_hyperlink_bool
{%
    \RequirePackage{fancythm}
}
%Tikz
\newif\ifuse@tikz
\bool_if:NTF \g_tikz_bool {\use@tikztrue} {\use@tikzfalse}
\ExplSyntaxOff
\ifuse@tikz
	\RequirePackage{tikz, tikz-3dplot, tikz-cd}
        \usetikzlibrary{intersections, calc, positioning, patterns, arrows.meta, decorations.markings}
\fi
\ExplSyntaxOn

%Multicolumn
\bool_if:NT \g_multicol_bool {\RequirePackage{multicol}}

\NewDocumentCommand{\begincol}{sO{2}}{%
	\bool_if:NTF \g_multicol_bool
    {%
        \IfBooleanTF{#1}
        {%
            \begin{multicols*}{#2}
            \bool_set_true:N \g_multicolumn_end_star_bool
        }
        {%
            \begin{multicols}{#2}
            \bool_set_true:N \g_multicolumn_end_bool
        }
    }
    {%
    \ClassError{coprime}
        {Add~'multicol'~option~to~use~this~command}
        {Add~'multicol'~option~to~use~this~command}
    }
}
\NewDocumentCommand{\endcol}{s}{%
	\bool_if:NTF \g_multicol_bool
    {%
        \IfBooleanTF{#1}
        {%
            \end{multicols*}
            \bool_set_false:N \g_multicolumn_end_star_bool
        }
        {%
            \end{multicols}
            \bool_set_false:N \g_multicolumn_end_bool
        }
    }
    {%
        \ClassError{coprime}
            {Add~'multicol'~option~to~use~this~command}
            {Add~'multicol'~option~to~use~this~command}
    }
}

% Font Settings
\newcommand\nano{\fontsize{0.454\font_size_dim}{1.3em}\selectfont}
\newcommand\micro{\fontsize{0.545\font_size_dim}{1.3em}\selectfont}
\renewcommand\tiny{\fontsize{0.636\font_size_dim}{1.3em}\selectfont}
\renewcommand\scriptsize{\fontsize{0.727\font_size_dim}{1.3em}\selectfont}
\renewcommand\footnotesize{\fontsize{0.818\font_size_dim}{1.3em}\selectfont}
\renewcommand\small{\fontsize{0.909\font_size_dim}{1.3em}\selectfont}
\renewcommand\normalsize{\fontsize{\font_size_dim}{1.3em}\selectfont}
\renewcommand\large{\fontsize{1.0909\font_size_dim}{1.3em}\selectfont}
\renewcommand\Large{\fontsize{1.2727\font_size_dim}{1.313em}\selectfont}
\renewcommand\LARGE{\fontsize{1.5454\font_size_dim}{1.456em}\selectfont}
\renewcommand\huge{\fontsize{1.8181\font_size_dim}{1.599em}\selectfont}
\renewcommand\Huge{\fontsize{2.2727\font_size_dim}{1.742em}\selectfont}
\newcommand\HUGE{\fontsize{2.7272\font_size_dim}{1.885em}\selectfont}
\newcommand\giant{\fontsize{2.9090\font_size_dim}{2.028em}\selectfont}
\newcommand\Giant{\fontsize{4.3636\font_size_dim}{2.171em}\selectfont}
\newcommand\GIANT{\fontsize{5.8181\font_size_dim}{2.314em}\selectfont}

% Undefine macros
\def\undefined#1{\expandafter\cs_undefine:N\csname #1\endcsname}

%Head and Foot
\NewDocumentCommand{\sethead}{omomomO{0.9pt}}{%
	\IfNoValueTF{#1}{%
		\def\@HA{#2}
	}{%
		\def\@HA{#1}
	}
	\ifx &#2&
		\def\@HB{\@empty}
	\else
		\def\@HB{#2}
	\fi
	\IfNoValueTF{#3}{%
		\def\@HC{#4}
	}{%
		\def\@HC{#3}
	}
	\ifx &#4&
		\def\@HD{\@empty}
	\else
		\def\@HD{#4}
	\fi
	\IfNoValueTF{#5}{%
		\def\@HE{#6}
	}{%
		\def\@HE{#5}
	}
	\ifx &#6&
		\def\@HF{\@empty}
	\else
		\def\@HF{#6}
	\fi
	\rhead[\@HE]{\@HF}
	\chead[\@HC]{\@HD}
	\lhead[\@HA]{\@HB}
	\renewcommand{\headrulewidth}{#7}
	\bool_set_true:N \g_head_edit_bool
}
\NewDocumentCommand{\setfoot}{omomomO{0pt}}{%
	\IfNoValueTF{#1}{%
		\def\@FA{#2}
	}{%
		\def\@FA{#1}
	}
	\ifx &#2&
		\def\@FB{\@empty}
	\else
		\def\@FB{#2}
	\fi
	\IfNoValueTF{#3}{%
		\def\@FC{#4}
	}{%
		\def\@FC{#3}
	}
	\ifx &#4&
		\def\@FD{\@empty}
	\else
		\def\@FD{#4}
	\fi
	\IfNoValueTF{#5}{%
		\def\@FE{#6}
	}{%
		\def\@FE{#5}
	}
	\ifx &#6&
		\def\@FF{\@empty}
	\else
		\def\@FF{#6}
	\fi
	\rfoot[\@FE]{\@FF}
	\cfoot[\@FC]{\@FD}
	\lfoot[\@FA]{\@FB}
	\renewcommand{\footrulewidth}{#7}
	\bool_set_true:N \g_foot_edit_bool
}

\NewDocumentCommand{\defaultheadfoot}{s}{%
	\bool_if:NTF \g_twoside_bool
    {%
        \bool_if:NTF \g_title_author_empty_bool
        {%
            \bool_if:NF \g_head_edit_bool
            {%
                \sethead[\@empty]{\textbf{\tl_use:N \title_tl}}{\@empty}[\textbf{\tl_use:N \title_tl}]{\@empty}[0mm]
            }
            \bool_if:NF \g_foot_edit_bool
            {%
                \setfoot[\textbf{\footnotesize\thepage}]{\@empty}{\@empty}[\@empty]{\textbf{\footnotesize\thepage}}
            }
        }
        {%
            \bool_if:NF \g_head_edit_bool
            {%
                \sethead[\textbf{\thepage}]{\textbf{\tl_use:N \title_tl}}{\@empty}[\textbf{\tl_use:N \title_tl}]{\textbf{\thepage}}
            }
            \bool_if:NF \g_foot_edit_bool
            {%
                \setfoot{\@empty}{\@empty}{\@empty}
            }
        }
    }
    {%
        \bool_if:NTF \g_title_author_empty_bool
        {%
            \bool_if:NF \g_head_edit_bool
            {%
                \sethead{\@empty}{\textbf{\tl_use:N \title_tl}}{\@empty}[0mm]
            }
            \bool_if:NF \g_foot_edit_bool
            {%
                \setfoot{\@empty}{\footnotesize\thepage}{\@empty}
            }
        }
        {%
            \bool_if:NF \g_head_edit_bool
            {%
                \sethead{\@empty}{\textbf{\tl_use:N \title_tl}}{\@empty}
            }
            \bool_if:NF \g_foot_edit_bool
            {%
                \setfoot{\@empty}{\footnotesize\thepage}{\@empty}
            }
        }
    }
    \IfBooleanTF{#1}{\thispagestyle{fancy}}{\pagestyle{fancy}}
}
\def\restoreheadfoot{\defaultheadfoot}

%% Start coprime
% Define \settitle and \setlength commands
\NewDocumentCommand{\settitle}{smmO{\today}}{%
	\IfBooleanT{#1}{\bool_set_true:N \g_custom_titlepage_bool}
	\tl_set:Nn \title_tl {#2}
	\tl_set:Nn \author_tl {#3}
	\tl_set:Nn \date_tl {#4}
	\tl_if_empty:NTF \author_tl
    {%
        \tl_if_empty:NTF \title_tl
        {%
            \bool_set_true:N \g_title_author_empty_bool
        }
        {%
            \bool_set_false:N \g_title_author_empty_bool
        }
    }
    {%
        \bool_set_false:N \g_title_author_empty_bool
    }
}

\NewDocumentCommand{\setting}{}{%
    \ClassError{coprime}{Obsolete~Command}
    {%
        Use~\protect\settitle\space instead.
    }
}
\let\settings\setting

\newcommand{\lensetting}[3]{%
	\tl_if_blank:nF {#1}
    {%
        \fp_set:Nn \baseline_fp {#1}
    }
	\tl_if_blank:nF {#2}
    {%
        \dim_set:Nn \parindent_dim {#2}
    }
	\tl_if_blank:nF {#3}
    {%
        \dim_set:Nn \parskip_dim {#3}
    }
}

% Redefine titlepage envionment
\RenewDocumentEnvironment{titlepage}{}{%
    \setcounter{page}{0}
    \thispagestyle{empty}
    \def\title{\tl_use:N \title_tl}
    \def\author{\tl_use:N \author_tl}
    \def\date{\tl_use:N \date_tl}
}{\newpage\maketitle}

% Setting \AtBeginDocument and \AtEndDocument
\AtBeginDocument{%
	\bool_if:NT \g_geometry_bool
        {%
            \bool_if:NF \g_geometry_used_bool
            {%
                \ClassError{coprime}{Where~is~\protect\setgeometry\space command?}%
                    {%
                        Use~\protect\setgometry\space to~use~"geometry"~option.\MessageBreak
                        Useage~:~\protect\setgometry{options~of~geometry~package}
                    }
                }
        }
	\bool_if:NT \g_hyperlink_bool
        {%
            \bool_if:NF \g_hyperlink_used_bool
            {%
                \ClassError{coprime}{Where~is~\protect\sethyperlink\space command?}%
                    {%
                        Use~\protect\sethyperlink\space to~use~"hyperlink"~option.\MessageBreak
                        Useage~:~\protect\sethyperlink{options~of~hyperref~package}
                    }
            }
        }
    \renewcommand{\baselinestretch}{\fp_use:N \baseline_fp}
	\setlength{\parindent}{\parindent_dim}
	\title{\vspace*{-20pt}\bf{\textsc{\fontsize{1.3\font_size_dim}{1.2em}\selectfont\tl_use:N \title_tl}}\vspace{-7pt}}
	\author{\tl_use:N \author_tl}
	\date{\tl_use:N \date_tl}
	\defaultheadfoot
	\setlength{\headheight}{20pt}
	\setlength{\headsep}{15pt}
	\bool_if:NF \g_custom_titlepage_bool
    {%
        \bool_if:NF \g_title_author_empty_bool
        {%
            \maketitle
        }
    }
	\fontsize{\font_size_dim}{1.3em}\selectfont
        \sys_if_engine_luatex:T
        {
            \def\C{\Cb}
        }
}

\AtEndDocument{%
	\bool_if:NT \g_multicol_bool
    {%
        \bool_if:NT \g_multicolumn_end_bool
        {%
            \end{multicols}
        }
        \bool_if:NT \g_multicolumn_end_star_bool
        {%
            \end{multicols*}
        }
    }
}
