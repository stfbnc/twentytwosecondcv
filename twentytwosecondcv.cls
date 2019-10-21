\ProvidesClass{twentytwosecondcv}[2019/10/20 CV class]
\LoadClass{article}
\NeedsTeXFormat{LaTeX2e}

%----------------------------------------------------------------------------------------
%	 REQUIRED PACKAGES
%----------------------------------------------------------------------------------------

\RequirePackage[sfdefault]{ClearSans}
\RequirePackage[T1]{fontenc}
\RequirePackage{tikz}
\usetikzlibrary{arrows}
\RequirePackage{xcolor}
\RequirePackage[absolute,overlay]{textpos}
\RequirePackage{ragged2e}
\RequirePackage{etoolbox}
\RequirePackage{ifmtarg}
\RequirePackage{ifthen}
\RequirePackage{pgffor}
\RequirePackage{marvosym}
\RequirePackage{parskip}
\RequirePackage{fontawesome}
\RequirePackage[export]{adjustbox}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

%----------------------------------------------------------------------------------------
%	 COLOURS
%----------------------------------------------------------------------------------------

\definecolor{white}{RGB}{255,255,255}
\definecolor{gray}{HTML}{4D4D4D}
\definecolor{sidecolor}{HTML}{E7E7E7}
\definecolor{mainblue}{HTML}{0E5484}
\definecolor{maingray}{HTML}{B9B9B9}

\colorlet{skillbg}{black!25}
\colorlet{wheelchartlabelcolor}{black}
\colorlet{wheeltextcolor}{black!80!white}

%----------------------------------------------------------------------------------------
%	 MISC CONFIGURATIONS
%----------------------------------------------------------------------------------------

\renewcommand{\bfseries}{\color{gray}} % Make \textbf produce coloured text instead

\pagestyle{empty} % Disable headers and footers

\setlength{\parindent}{0pt} % Disable paragraph indentation

%----------------------------------------------------------------------------------------
%	 SIDEBAR DEFINITIONS
%----------------------------------------------------------------------------------------

\setlength{\TPHorizModule}{1cm} % Left margin
\setlength{\TPVertModule}{1cm} % Top margin

\newlength\imagewidth
\newlength\imagescale
\pgfmathsetlength{\imagewidth}{4.5cm}
\pgfmathsetlength{\imagescale}{\imagewidth/600}

\newlength{\TotalSectionLength} % Define a new length to hold the remaining line width after the section title is printed
\newlength{\SectionTitleLength} % Define a new length to hold the width of the section title
\newcommand{\profilesection}[1]{%
	\setlength\TotalSectionLength{\linewidth}% Set the total line width
	\settowidth{\SectionTitleLength}{\huge #1 }% Calculate the width of the section title
	\addtolength\TotalSectionLength{-\SectionTitleLength}% Subtract the section title width from the total width
	\addtolength\TotalSectionLength{-2.22221pt}% Modifier to remove overfull box warning
	\vspace{8pt}% Whitespace before the section title
	{\color{black!80} \huge #1 \rule[0.15\baselineskip]{\TotalSectionLength}{1pt}}% Print the title and auto-width rule
}

% Define custom commands for CV info
\newcommand{\cvdate}[1]{\renewcommand{\cvdate}{#1}}
\newcommand{\cvmail}[1]{\renewcommand{\cvmail}{#1}}
\newcommand{\cvnumberphone}[1]{\renewcommand{\cvnumberphone}{#1}}
\newcommand{\cvaddress}[1]{\renewcommand{\cvaddress}{#1}}
\newcommand{\cvsite}[1]{\renewcommand{\cvsite}{#1}}
\newcommand{\cvgithub}[1]{\renewcommand{\cvgithub}{#1}}
\newcommand{\cvlinkedin}[1]{\renewcommand{\cvlinkedin}{#1}}
\newcommand{\aboutme}[1]{\renewcommand{\aboutme}{#1}}
\newcommand{\profilepic}[1]{\renewcommand{\profilepic}{#1}}
\newcommand{\cvname}[1]{\renewcommand{\cvname}{#1}}
\newcommand{\cvjobtitle}[1]{\renewcommand{\cvjobtitle}{#1}}

% Command for printing the contact information icons
\newcommand*\icon[1]{\tikz[baseline=(char.base)]{\node[shape=circle,draw,inner sep=1pt, fill=mainblue,mainblue,text=white] (char) {#1};}}

% Command for printing languages skill
\newcommand{\cvicon}[1]{\makebox[1em]{\color{mainblue} #1}}
\newcommand{\flag}[1]{\centering\includegraphics[width=1em]{#1}}

\newcommand\languages[1]{ 
	\renewcommand{\languages}{
		\foreach \a/\b/\c/\d in {#1}{
			\hspace{\a} \cvicon{\b} ~ \raisebox{0.3\height}{\c} \hfill
			\foreach \x in {1,...,5}{
				\space
				{\ifnumgreater{\x}{\d}{\color{skillbg}}{\color{mainblue}}
				\raisebox{0.5\height}{\scriptsize\faCircle}
				}
			}\par
		}	
	}
}

\newcommand\wheelchart[4]{
	\renewcommand{\wheelchart}{
    		\def\outerradius{#1}
    		\def\innerradius{#2}
    		% Calculate total
    		\pgfmathsetmacro{\totalnum}{0}
    		\foreach\value/\colour/\name in {#3} {
        			\pgfmathparse{\value+\totalnum}
        			\global\let\totalnum=\pgfmathresult
    		}
		\hspace{-1em}
    		\begin{tikzpicture}

      		% Calculate the thickness and the middle line of the wheel
      		\pgfmathsetmacro{\wheelwidth}{\outerradius-\innerradius}
      		\pgfmathsetmacro{\midradius}{(\outerradius+\innerradius)/2}

      		% Rotate so we start from the top
      		\begin{scope}[rotate=-90]
      		% Loop through each value set. \cumnum keeps track of where we are in the
      		% wheel                
      		\pgfmathsetmacro{\cumnum}{0}
      		\foreach \value/\width/\colour/\name in {#3} {
            		\pgfmathsetmacro{\newcumnum}{\cumnum + \value/\totalnum*360}

            		% Calculate the percent value
           		 \pgfmathsetmacro{\percentage}{\value/\totalnum*100}
            		% Calculate the mid angle of the colour segments to place the labels
            		\pgfmathsetmacro{\midangle}{-(\cumnum+\newcumnum)/2}

            		% This is necessary for the labels to align nicely
            		\pgfmathparse{
               			(-\midangle>180?"west":"east")
           		 } \edef\textanchor{\pgfmathresult}
            		\pgfmathparse{
               			(-\midangle>180?"flush left":"flush right")
            		} \edef\textalign{\pgfmathresult}
            		\pgfmathsetmacro\labelshiftdir{1-2*(-\midangle<180)}

            		% Draw the color segments. Somehow, the \midrow units got lost, so
            		% we add 'pt' at the end. Not nice...
            		\filldraw[draw=white,fill=\colour] 
	            		(-\cumnum:\outerradius) 
	            		arc (-\cumnum:-(\newcumnum):\outerradius) 
	            		-- (-\newcumnum:\innerradius) 
	            		arc (-\newcumnum:-(\cumnum):\innerradius) 
	            		-- cycle;

            		% Draw the data labels
            		\draw [*-,thin,wheelchartlabelcolor] node [append after command={
		          	(\midangle:\midradius pt) -- 
 	  	        		(\midangle:\outerradius + 1ex) -- 
		          	(\tikzlastnode)}] at (\midangle:\outerradius + 1ex) [
		          	xshift=\labelshiftdir*0.5cm,inner sep=1ex, 
		          	outer sep=0pt, 
		          	text width=\width,
		          	anchor=\textanchor,
		          	align=\textalign,
		          	font=\small,
		          	text=wheeltextcolor
	          	]{\name};
            		% Set the old cumulated angle to the new value
            		\global\let\cumnum=\newcumnum
        		}
      		\end{scope}
    		\end{tikzpicture}\par
	}
}

% Command for printing skill progress bars
\newcommand\skills[1]{ 
	\renewcommand{\skills}{
		\begin{tikzpicture}
			\foreach [count=\i] \x/\y in {#1}{
				\draw[fill=maingray,maingray] (0,\i) rectangle (6,\i+0.4);
				\draw[fill=white,mainblue](0,\i) rectangle (\y,\i+0.4);
				\node [above right] at (0,\i+0.4) {\x};
			}
		\end{tikzpicture}
	}
}

% Command for printing skills text
\newcommand\skillstext[1]{ 
	\renewcommand{\skillstext}{
		\begin{flushleft}
			\vspace{0.2em}
			\foreach [count=\i] \x in {#1}{ 
				\hspace{0.2em} $\bullet$ \x\\
				\vspace{0.3em}
			}
		\vspace{0.3em}
		\end{flushleft}
	}
}

%----------------------------------------------------------------------------------------
%	 SIDEBAR LAYOUT
%----------------------------------------------------------------------------------------

\newcommand{\makeprofile}{
	\begin{tikzpicture}[remember picture,overlay]
   		\node [rectangle, fill=sidecolor, anchor=north, minimum width=9cm, minimum height=\paperheight+1cm] (box) at (-5cm,0.5cm){};
	\end{tikzpicture}

	%------------------------------------------------

	\begin{textblock}{6}(0.5, 0.2)
			
		%------------------------------------------------
		
		\ifthenelse{\equal{\profilepic}{}}{}{
			\begin{center}
				\begin{tikzpicture}[x=\imagescale,y=-\imagescale]
					\clip (600/2, 567/2) circle (567/2);
					\node[anchor=north west, inner sep=0pt, outer sep=0pt] at (0,0) {\includegraphics[width=\imagewidth]{\profilepic}};
				\end{tikzpicture}
			\end{center}
		}

		%------------------------------------------------

		{\Huge\color{mainblue}\cvname}

		%------------------------------------------------

		{\Large\color{black!80}\cvjobtitle}

		%------------------------------------------------

		\renewcommand{\arraystretch}{1.75}
		\begin{tabular}{p{0.5cm} @{\hskip 0.5cm}p{5cm}}
			\ifthenelse{\equal{\cvdate}{}}{}{\textsc{\Large\icon{\Info}} & \cvdate\\}
			\ifthenelse{\equal{\cvaddress}{}}{}{\textsc{\Large\icon{\Letter}} & \cvaddress\\}
			\ifthenelse{\equal{\cvnumberphone}{}}{}{\textsc{\Large\icon{\Telefon}} & \cvnumberphone\\}
			\ifthenelse{\equal{\cvsite}{}}{}{\textsc{\Large\icon{\Mundus}} & \cvsite\\}
			\ifthenelse{\equal{\cvmail}{}}{}{\textsc{\large\icon{@}} & \href{mailto:\cvmail}{\cvmail}\\}
			\ifthenelse{\equal{\cvlinkedin}{}}{}{\textsc{\large\icon{\faLinkedin}} & \cvlinkedin\\}
			\ifthenelse{\equal{\cvgithub}{}}{}{\textsc{\large\icon{\faGithub}} & \cvgithub}
		\end{tabular}

		%------------------------------------------------
		
		\ifthenelse{\equal{\aboutme}{}}{}{
			\profilesection{About me}
			\begin{flushleft}
				\aboutme
			\end{flushleft}
		}

		%------------------------------------------------
		
		\profilesection{Languages}

		\languages
		
		%------------------------------------------------

		\profilesection{Skills}

		\skillstext
		\wheelchart
			
		%------------------------------------------------
			
	\end{textblock}
}

%----------------------------------------------------------------------------------------
%	 COLOURED SECTION TITLE BOX
%----------------------------------------------------------------------------------------

% Command to create the rounded boxes around the first three letters of section titles
\newcommand*\round[2]{%
	\tikz[baseline=(char.base)]\node[anchor=north west, draw,rectangle, rounded corners, inner sep=1.6pt, minimum size=5.5mm, text height=3.6mm, fill=#2,#2,text=white](char){#1};%
}

\newcounter{colorCounter}
\newcommand{\sectioncolor}[1]{%
	{%
		\round{#1}{
			\ifcase\value{colorCounter}%
			maingray\or%
			mainblue\or%
			maingray\or%
			mainblue\or%
			maingray\or%
			mainblue\or%
			maingray\or%
			mainblue\or%
 			maingray\or%
			mainblue\else%
			maingray\fi%
		}%
	}%
	\stepcounter{colorCounter}%
}

\renewcommand{\section}[1]{
	{%
		\color{gray}%
		\Large\sectioncolor{#1}%
	}
}

\renewcommand{\subsection}[1]{
	\par\vspace{.5\parskip}{%
		\large\color{gray} #1%
	}
	\par\vspace{.25\parskip}%
}

%----------------------------------------------------------------------------------------
%	 LONG LIST ENVIRONMENT
%----------------------------------------------------------------------------------------

\setlength{\tabcolsep}{0pt}

% New environment for the long list
\newenvironment{twenty}{%
	\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}ll}
}{%
	\end{tabular*}
}

\newcommand{\twentyitem}[5]{
	\parbox[t]{0.17\textwidth}{#1\\#2} & \parbox[t]{0.83\textwidth}{
		\textbf{#3}
		\hfill
		{\footnotesize#4}\\
		#5\vspace{\parsep}
	}\\
}

%----------------------------------------------------------------------------------------
%	 SMALL LIST ENVIRONMENT
%----------------------------------------------------------------------------------------

\setlength{\tabcolsep}{0pt}

% New environment for the small list
\newenvironment{twentyshort}{%
	\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}ll}
}{%
	\end{tabular*}
}

\newcommand{\twentyitemshort}[2]{%
	#1&\parbox[t]{0.83\textwidth}{%
		\textbf{\color{black} #2}%
	}\\
}

%----------------------------------------------------------------------------------------
%	 MARGINS AND LINKS
%----------------------------------------------------------------------------------------

\RequirePackage[left=7.6cm,top=0.1cm,right=1cm,bottom=0.2cm,nohead,nofoot]{geometry}

\RequirePackage{hyperref}
