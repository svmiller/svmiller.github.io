---
title: Moving from Beamer to R Markdown
author: steve
layout: post
permalink: /blog/2015/02/moving-from-beamer-to-r-markdown/
categories:
  - R
  - Workflow
tags:
  - Beamer
  - LaTeX
  - Markdown
  - R
---
I&#8217;ve been using LaTeX for document rendering for over five years. No one else in my department at the time used it, beyond [my friend Joe][1] (who introduced it to me). There was no pressure from my department to learn it, only a curiosity on my end for the benefits of it. The transition to LaTeX came with a concurrent transition to its sister package Beamer, which renders Powerpoint-styled presentations. Both have numerous advantages over their Microsoft equivalents.

However, I never particularly cared for Beamer. At least, I found LaTeX&#8217;s document preparation system more intuitive than Beamer&#8217;s slides preparation system. Using both will lead to proficiency, but Beamer markup remains ugly and a chore to write.

Look at it this way. Almost the entirety of a LaTeX document is the content itself whereas it seems half (if not more) of a Beamer document is markup. Take, for example, this sample code from a lecture slide for one of my classes.

<pre>\frame{
 \frametitle{Examples of States and Non-States}
Here are some examples of a state and non-states by this classification.
 \begin{itemize}
 \item Examples are drawn from Sarkees and Wayman (2010).
 \end{itemize}
\begin{table}[ht]
 \scriptsize
 \centering
 \begin{tabular}{l c c c c c c c} 
 \hline\hline %inserts double horizontal lines
 Entity & Territory & Population & Recognition & Sovereign & Independence & State? \\ [0.5ex] 
 %heading
 \hline % inserts single horizontal line
 & & & & & & \\
 USA & Yes & Yes & Yes & Yes & Yes & Yes \\ [1.5ex]
 Vatican & Yes & No & Yes & Yes & Yes & \textbf{No} \\ [1.5ex]
 Confederacy & Yes & Yes & No & Yes & Yes & \textbf{No} \\ [1.5ex]
 Vichy France & Yes & Yes & Yes & No & No & \textbf{No} \\ [1.5ex]
 Ukrainian SSR & Yes & Yes & Yes & Yes & No & \textbf{No} \\ [1.5ex]
 \hline
\end{tabular}
 \end{table}
 }</pre>

That&#8217;s a lot of manual code for one little slide.

I&#8217;ve known about [Markdown][2] language (and [Pandoc][3]) as a substitute for straight Beamer. Markdown language is simple and elegant. Pandoc allows for Markdown to be translated to TeX, and ultimately a Beamer PDF. However, Pandoc is something of a chore to render. [Look at all these extra commands][4] one needs in a terminal to make even minimal changes (e.g. a simple theme, let alone a custom one) to a Pandoc call. I don&#8217;t have time for all that when a simple Cmd-R in [Textmate][5] (or F5 in [Gedit][6]&#8216;s [LaTeX plugin][7]) will do the same thing when the appropriate markup is included in the preamble of the document.

[R Markdown][8] is the best of both worlds. R Markdown allows for elegant Markdown code *and* simple means of stylizing and rendering the slides without a ton of additional commands in the terminal. It took a while to get something that was exactly what I wanted (since R Markdown has its own peculiarities), but I did and offer what follows as a guide for those looking to take advantage of R Markdown.

# Understanding Your Markdown Document

R Markdown uses [YAML][9] for its metadata. It also does so in a manner that&#8217;s more efficient than Pandoc (or, at least, more intuitive for me). Consider my working example below.

<pre>---
title: An Example R Markdown Document
subtitle: (A Subtitle Would Go Here if This Were a Class)
author: Steven V. Miller
date: 
fontsize: 10pt
output:
 beamer_presentation:
# keep_tex: true
# toc: true
 slide_level: 3
 includes:
 in_header: ~/Dropbox/teaching/clemson-beamer-header-simple.txt
 after_body: ~/Dropbox/teaching/table-of-contents.txt
---</pre>

Metadata is always at the top of a R Markdown document. I&#8217;ll explain some important YAML items below, assuming some items (e.g. title, subtitle, date, author, fontsize) are intuitive.

The output section designates how the Markdown language will be processed. You can insert `html_document` if HTML is the desired output, though I&#8217;m assuming the preferred output here is a Beamer PDF.

After `beamer_presentation`, enter a new line, hit the space bar four times and add miscellaneous options. In the working example above, I commented out two options. When `keep_tex` is true, the compiling will also spit out a .tex file of the Markdown document. When `toc` is true, a table of contents is rendered after the title frame. In my case, I don&#8217;t want a .tex output in addition to the PDF (unless I&#8217;m doing some debugging) and I like my table of contents after my slides.<sup><a href="#footnote_0_154" id="identifier_0_154" class="footnote-link footnote-identifier-link" title="This was something I started doing in job market talks in order to field questions back to particular slides more easily.">1</a></sup>

The next option is an important one and it took me a while to figure out what exactly it was doing. `slide_level` determines how many pound signs are required for Markdown to assume you are wanting a new slide. I think the default option is one, but this may be inefficient if you want clear sections and subsections in your presentation. If `slide_level` is three, then Markdown output like this&#8230;

<pre># This is my section
## This is my subsection
### Title of a slide

*Hi mom!*</pre>

&#8230;will look like this standard TeX/Beamer markup.

<pre>\section{This is my section}
\subsection{This is my subsection}
\frame{
\frametitle{Title of a slide}

\textit{Hi mom!}

}</pre>

Since this is how I&#8217;m used to handling Beamer (and I like occasional subsections in my slides and in the table of contents), I set `slide_level` to three.

Next, you can use `in_header` (after `includes:`) to determine what additional packages and style changes you want to include in what would otherwise be the preamble of your Beamer document. This is where you can get creative with stylizing a theme how you want. I also thought it mandatory because Markdown does some things with Beamer that I think are odd (e.g. giving a section title its own slide). Here&#8217;s my standard style file, for your consideration.

<pre>\usepackage{graphicx}
\usepackage{rotating}
%\setbeamertemplate{caption}[numbered]
\usepackage{hyperref}
\usepackage{caption}
\usepackage[normalem]{ulem}
%\mode&lt;presentation&gt;
\usepackage{wasysym}
\usepackage{amsmath}

\setbeamertemplate{navigation symbols}{}
\institute{Department of Political Science}
\titlegraphic{\includegraphics[width=0.3\paperwidth]{\string~/Dropbox/teaching/clemson-academic.png}}
\setbeamertemplate{title page}[empty]

\setbeamerfont{subtitle}{size=\small}

\setbeamercovered{transparent}

\definecolor{clemsonpurple}{HTML}{522D80}
\definecolor{clemsonorange}{HTML}{F66733}

\setbeamercolor{frametitle}{fg=clemsonpurple,bg=white}
\setbeamercolor{title}{fg=clemsonpurple,bg=white}
\setbeamercolor{local structure}{fg=clemsonpurple}
\setbeamercolor{section in toc}{fg=clemsonpurple,bg=white}
% \setbeamercolor{subsection in toc}{fg=clemsonorange,bg=white}
\setbeamercolor{item projected}{fg=clemsonpurple,bg=white}
\setbeamertemplate{itemize item}{\color{clemsonpurple}$\bullet$}
\setbeamertemplate{itemize subitem}{\color{clemsonpurple}\scriptsize{$\bullet$}}
\let\Tiny=\tiny

\AtBeginPart{}
\AtBeginSection{}
\AtBeginSubsection{}
\AtBeginSubsubsection{}
\setlength{\emergencystretch}{0em}
\setlength{\parskip}{0pt}</pre>

Most of these are cosmetic fixes (i.e. representing school colors in my presentations, which you are free to change), but some commands are quite useful. The last two commands in the above code reduce some of R Markdown&#8217;s odd vertical spacing. The four lines above that suppress R Markdown&#8217;s proclivity to create new slides that are just the section titles.

Finally, `after_body` is an optional command that will include whatever you want as slides material after what is otherwise the last slide of your document. Since I like table of contents after the last slide, I have simple .txt file with the following Beamer markup.

<pre>\section[]{}
\frame{\small \frametitle{Table of Contents}
\tableofcontents}</pre>

#  Compiling Your Markdown Document

If you&#8217;re using [Rstudio][10], compiling the R Markdown document is as simple as clicking a few buttons in the script window.

However, I tend to not like using GUIs, even if Rstudio is quite useful. I do love automated scripts, though, especially R scripts in which I don&#8217;t have to specify a working directory. Toward that end, I wrote a simple script that you can treat as executable (assuming you&#8217;re on a Linux or Mac machine) to automatically compile your Markdown documents.

<pre>#! /usr/bin/Rscript --vanilla --default-packages=base,stats,utils
library(knitr)
library(rmarkdown)
file &lt;- list.files(pattern='.Rmd')
rmarkdown::render(file)</pre>

This process assumes you have just one .Rmd file per directory, which should not be a drastic change for LaTeX users. Given LaTeX&#8217;s proclivity to create log files and additional auxiliary files with every compile, LaTeX users (like me) tend to get in the habit of having one directory for each document.

Save that script with a .R extension and allow your Linux or Mac operating system to treat it as executable. You should be good to go after that.

# An Example R Markdown Document

From there, the rest involves learning how simple of a language Markdown is. There are [numerous][11] [cheatsheets][12].

Here&#8217;s a sample document I created in Markdown for illustration purposes. [This is the output][13] from compiling it with my R script.

<pre>---
title: An Example R Markdown Document
subtitle:  (A Subtitle Would Go Here if This Were a Class)
author: Steven V. Miller
date: 
fontsize: 10pt
output:
  beamer_presentation:
#    keep_tex: true
#    toc: true
    slide_level: 3
    includes:
      in_header: ~/Dropbox/teaching/clemson-beamer-header-simple.txt
      after_body: ~/Dropbox/teaching/table-of-contents.txt
---

# Pop Songs and Political Science
## Morning Train

### Sheena Easton and Game Theory

Sheena Easton describes the following scenario for her baby:

1. Takes the morning train
2. Works from nine 'til five
3. Takes another train home again
4. Finds Sheena Easton waiting for him

\bigskip Sheena Easton and her baby are playing a \textcolor{clemsonorange}{zero-sum (total conflict) game}.

- Akin to Holmes-Moriarty game (see: von Neumann and Morgenstern)
- Solution: \textcolor{clemsonorange}{mixed strategy}


## Never Gonna Give You Up

### Rick Astley's Re-election Platform

Rick Astley's campaign promises:

- Never gonna give you up
- Never gonna let you down
- Never gonna run around and desert you
- Never gonna make you cry
- Never gonna say goodbye
- Never gonna tell a lie and hurt you.


\bigskip Whereas these pledges conform to the preferences of the \textcolor{clemsonorange}{median voter}, we expect Congressman Astley to secure re-election.

## Caribbean Queen
### Caribbean Queen and Operation Urgent Fury

In 1984, Billy Ocean released ``Caribbean Queen''.

- Emphasized sharing the same dream
- Hearts beating as one

\bigskip ``Caribbean Queen'' is about the poor execution of Operation Urgent Fury.

- Echoed JCS chairman David Jones' frustrations with military establishment.

\bigskip Billy Ocean is advancing calls for what became the Goldwater-Nichols Act.

- Wanted to take advantage of \textcolor{clemsonorange}{economies of scale}, resolve \textcolor{clemsonorange}{coordination problems} in U.S. military.

## Good Day
### The Good Day Hypothesis

We know the following about Ice Cube's day.

1. The Lakers beat the Supersonics.
2. No helicopter looked for a murder.
3. Consumed Fatburger at 2 a.m.
4. Goodyear blimp: "Ice Cube's a pimp."

\bigskip This leads to two different hypotheses:

- $H_0$: Ice Cube's day is statistically indistinguishable from a typical day.
- $H_1$: Ice Cube is having a good (i.e. greater than average) day.

\bigskip These hypotheses are tested using archival data of Ice Cube's life.



# Rendering This Document
### The Problem of Rendering in Markdown

One big disadvantage to Markdown: compiling.

\bigskip Here's what it would look like from Terminal \medskip


![Markdown Call](markdown-call.png)

\bigskip Nobody got time for that.

### One Alternative: Rstudio

\begin{center}
  \includegraphics[width=1.00\textwidth]{knit-rstudio.png}
\end{center}



### Another Alternative: Rscript

Another option: noninteractive \texttt{Rscript}

- I prefer this option since I tend to not like GUIs.
- Assumes you're on a Linux/Mac system.

Save this to a .R script (call it whatever you like)

- Note that the "s" in "utils" package is cut off in verbatim environment below.


```
#! /usr/bin/Rscript --vanilla --default-packages=base,stats,utils
library(knitr)
library(rmarkdown)
file &lt;- list.files(pattern='.Rmd')
rmarkdown::render(file)
```



Make it executable. Double click or run in Terminal.

- Keep a copy in each directory, but keep only one .Rmd per directory.


# Conclusion
### Conclusion

Beamer markup is messy. Markdown is much more elegant.

- Incorporating R with Markdown makes Markdown that much better.
- Rendering Markdown $\rightarrow$ Beamer requires minimal Rscript example.
 - I provide such a script to accompany this presentation.

</pre>

<ol class="footnotes">
  <li id="footnote_0_154" class="footnote">
    This was something I started doing in job market talks in order to field questions back to particular slides more easily. [<a href="#identifier_0_154" class="footnote-link footnote-back-link">&#8617;</a>]
  </li>
</ol>

 [1]: http://www.joestradam.us/
 [2]: http://en.wikipedia.org/wiki/Markdown
 [3]: http://johnmacfarlane.net/pandoc/
 [4]: http://johnmacfarlane.net/pandoc/demo/example9/templates.html
 [5]: http://macromates.com/
 [6]: https://wiki.gnome.org/Apps/Gedit
 [7]: https://wiki.gnome.org/Apps/Gedit/LaTeXPlugin
 [8]: http://rmarkdown.rstudio.com/
 [9]: http://www.yaml.org/
 [10]: http://rstudio.com
 [11]: https://help.github.com/articles/markdown-basics/
 [12]: http://blog.rstudio.org/2014/08/01/the-r-markdown-cheat-sheet/
 [13]: http://svmiller.com/wp-content/uploads/rmarkdown-example.pdf