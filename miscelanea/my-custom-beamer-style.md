---
layout: page
title: "My Custom Beamer Style"
permalink: /miscellany/my-custom-clemson-themed-beamer-style/
---

A little while ago, I offered some advice on [moving from Beamer to R Markdown](/blog/2015/02/moving-from-beamer-to-r-markdown/) for rendering presentation slides. Some friends of mine thought my custom Beamer style was quite useful and wanted to know if they could have it and modify it. I present my custom, minimal style below with a few comments to follow.

{% highlight latex %}
{% raw %}
\setbeamertemplate{navigation symbols}{}
\institute{Department of Political Science}
\titlegraphic{\includegraphics[width=0.3\paperwidth]{\string~/Dropbox/teaching/clemson-academic.png}}
\setbeamertemplate{title page}[empty]

\setbeamerfont{subtitle}{size=\small}

\setbeamercovered{transparent}

\definecolor{clemsonpurple}{HTML}{522D80}
\definecolor{clemsonorange}{HTML}{F66733}

\definecolor{uiucblue}{HTML}{003C7D}
\definecolor{uiucorange}{HTML}{F47F24}

\setbeamercolor{frametitle}{fg=clemsonpurple,bg=white}
\setbeamercolor{title}{fg=clemsonpurple,bg=white}
\setbeamercolor{local structure}{fg=clemsonpurple}
\setbeamercolor{section in toc}{fg=clemsonpurple,bg=white}
% \setbeamercolor{subsection in toc}{fg=clemsonorange,bg=white}
\setbeamercolor{footline}{fg=clemsonpurple!50, bg=white}
\setbeamercolor{item projected}{fg=clemsonpurple,bg=white}
\setbeamertemplate{itemize item}{\color{clemsonpurple}$\bullet$}
\setbeamertemplate{itemize subitem}{\color{clemsonpurple}\scriptsize{$\bullet$}}
\let\Tiny=\tiny

\AtBeginPart{}
\AtBeginSection{}
\AtBeginSubsection{}
\AtBeginSubsubsection{}
\setlength{\emergencystretch}{0em} % prevent overfull lines
\setlength{\parskip}{0pt}

\defbeamertemplate*{footline}{my footline}
{
\ifnum \insertpagenumber=1

\leavevmode%
\hbox{%
\begin{beamercolorbox}[wd=\paperwidth,ht=.80ex,dp=1ex,center]{}%
% empty environment to raise height
\end{beamercolorbox}}%
\vskip0pt%
\else

\hspace*{.5cm}\Tiny{%
\hspace*{50pt} \hfill\insertframenumber/\inserttotalframenumber\hspace*{.00cm} \\ \vspace*{5pt}}%

\fi
}
{% endraw %}
{% endhighlight %}

One, you can save yourself quite a bit of markup by punting things like title graphics and institute affiliations to the Beamer style. This assumes (reasonably for academics) that all Beamer presentations given will be academic in nature (either research or teaching). Toward that end, move that information to the Beamer style like I did.

Do note how the title graphic is called. You can specify relative paths in LaTeX/Beamer with `\string~`. If you work between different operating systems like I do (Linux and Mac), this will be quite useful. Unless you’re at Clemson University at with me, you’ll want to find your own university brand graphic. Trust me; your university has at least one, and likely multiple.

Second, you can change colors as you see fit. Consult (again) your university’s official color palette and identity standards. The colors I specify are Clemson’s particular shade of purple ("regalia") and orange ("Clemson orange"), [which I took from here](http://www.clemson.edu/administration/public-affairs/toolbox/standards/colors.html). I also left in [the particular orange and blue of the University of Illinois](http://identitystandards.illinois.edu/graphicstandardsmanual/generalguidelines/colors.html), where I was prior to my arrival at Clemson and where I started working on customizing Beamer templates.

After you’re done specifying colors, make sure to edit the Beamer color calls for particular sections of the slides. A lot of this will be on you to edit as you see fit.

The five lines after the block of code coloring different parts of the Beamer presentation are there to suppress some peculiarities of an R Markdown call.

The definition of my footline is there to include a frame count in the bottom right corner of the slides on all pages except for the title page.

An example document this style will help render is shown below.

{% include embedpdf.html code="/8w0nfgpz54ltsfq/rmarkdown-example.pdf" width=100 height=800 %}

