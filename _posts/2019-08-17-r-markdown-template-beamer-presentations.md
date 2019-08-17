---
title: "An R Markdown Template for Beamer Presentations"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2019-08-17'
excerpt: "I have a series of templates for R Markdown. This post documents my Beamer presentations, and how to use this template as I use it."
layout: post
categories:
  - R Markdown
image: "rick-astley.png"
---



{% include image.html url="/images/rick-astley.png" caption="Congressman Rick Astley makes another pledge on the campaign trail" width=400 align="right" %}


I'll keep the introduction to this post fairly simple. It's back-to-school season for professors, which means it's time to prepare syllabi and lectures for the coming school year. I realized as I was doing some website maintenance that I never formally introduced the most common R Markdown template that I use: [my Beamer template](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-beamer.tex). Over four years ago, I talked a little about [why people should move from Beamer to R Markdown](http://svmiller.com/blog/2015/02/moving-from-beamer-to-r-markdown/) and use the latter as a wrapper for the former. However, I've tweaked my Beamer templates so much since that I should probably describe it more in detail.

Consider this another installment in [my catalog of posts on R Markdown](http://svmiller.com/categories/#R%20Markdown), complementing my suite of templates for things like [academic manuscripts](http://svmiller.com/blog/2016/02/svm-r-markdown-manuscript/), [CVs](http://svmiller.com/blog/2016/03/svm-r-markdown-cv/), [syllabi](http://svmiller.com/blog/2016/07/r-markdown-syllabus/), [Xaringan presentations](http://svmiller.com/blog/2018/02/r-markdown-xaringan-theme/), and [memos](http://svmiller.com/blog/2019/06/r-markdown-memo-template/) (among other templates). You can also skip this and head straight to [my Github repo for all these things](https://github.com/svmiller/svm-r-markdown-templates).

## Getting Started with the YAML

Here is what the YAML will resemble for my standard Beamer presentation.

```yaml
---
title: An Example R Markdown Document
subtitle: (A Subtitle Would Go Here if This Were a Class)
author: Steven V. Miller
institute: Department of Political Science
titlegraphic: /Dropbox/teaching/clemson-academic.png
fontsize: 10pt
output:
 beamer_presentation:
    template: ../svm-latex-beamer.tex
    keep_tex: true
    latex_engine: xelatex # pdflatex also works here
    dev: cairo_pdf # I typically comment this out  if latex_engine: pdflatex
    slide_level: 3
make149: true
mainfont: "Open Sans" # Try out some font options if xelatex
titlefont: "Titillium Web" # Try out some font options if xelatex
---
```

Long-time users of my templates or R Markdown should recognize a fair bit here. Make `title:` the topic of your presentation. `subtitle:` is optional, but try to use it since it looks nice and fleshes out the title page. The `author:` field should be who you are (or me, you're free to make everything about and by me). The `institute:` field should be your department or employer. 

The `titlegraphic:` field should be a relative(-ish) path to a brand marker for your university or employer. LaTeX (as far as I know) is a bit wonky about paths. In my template, I specify this as option like this.

```latex
% \titlegraphic{\includegraphics[width=0.3\paperwidth]{\string~/Dropbox/teaching/clemson-academic.png}} 
% if you want to know what this looks like without it as a Markdown field. 
% -----------------------------------------------------------------------------------------------------
$if(titlegraphic)$\titlegraphic{\includegraphics[width=0.3\paperwidth]{\string~$titlegraphic$}}$endif$
```

Thus, start a relative(-ish) path to your university's "brand" marker, wherever it is on your hard drive. If you're a new student trying to figure this stuff out for the first time and are unaware what I mean by "brand" in the context of universities: trust me; your university has a brand "guideline" and has copious guides to "protecting" the "brand." Your university speaks of itself like a corporation and would hire two dozen Darren Rovells to "protect" and "promote" the "brand" if they haven't already. Don't believe me? Here's my beloved alma mater [trying to file a trademark for the most common word in the English language](https://www.cnn.com/2019/08/14/us/the-ohio-state-university-trademark-trnd/index.html) to protect its "brand" by arguing the most common word in the English language is actually its intellectual property. 

Just search "brand" on your university's website and you should be good to go from there. For what it's worth, the `titlegraphic:` field is optional. You can omit this if you'd like, but then you should make the `institute:` field your university or employer.

The stuff under `output:` is worth belaboring a little bit. `template:` should obviously be where [the actual .tex template](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-beamer.tex) is and `keep_tex:` is optional if you want to keep or discard the intermediate .tex file for the Beamer presentation. Thereafter, you can use the `latex_engine:` option to favor xelatex (as I do now) over pdflatex (which I used to use back when I first created my template). The only real reason for this switch is if you wanted to customize the font options (more on that later). If you set `latex_engine: xelatex`, you should also set `dev: cairo_pdf`. This will allow you to use some fancy fonts in your ggplot graphs.

As a final little note on the stuff under `output:`, I typically set `slide_level: 3` so that three pound signs (###) denote a new slide. Two pound signs are a subsection and one pound sign is a section.

The final set of options are stuff I've added over the years. Most computer screens these days are widescreen, even the computers you'll find in your class room. I want to leverage this space as well as I can. Thus, I created a `make149:` option so my presentations can have a 14:9 aspect ratio. This is optional. Commented out, the presentation would be the default aspect ratio for a Beamer presentation. I'm pretty sure that's 4:3.

Finally, if you've set `latex_engine: xelatex`, why not give yourself some fonts of choice? My main font (`mainfont:`) is [Open Sans](https://fonts.google.com/specimen/Open+Sans) while the title fonts (`titlefont:`, for slides and the title page) is [Titillium Web](https://fonts.google.com/specimen/Titillium+Web). You may recognize these fonts on my website as well. For as much as I just riffed on universities being snobby about their "brand", I suppose I have mine as well.

## Add Your Own Colors to the .tex File

Assuming you don't want your presentations to be ~~orange and purple~~ ahem, ["Clemson Orange" and "Regalia"](https://www.clemson.edu/brand/guide/color.html), head over to [the .tex file](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-beamer.tex) and find the stretch of code you see below.

```latex
% Some optional colors. Change or add as you see fit.
%---------------------------------------------------
\definecolor{clemsonpurple}{HTML}{522D80}
 \definecolor{clemsonorange}{HTML}{F66733}
\definecolor{uiucblue}{HTML}{003C7D}
\definecolor{uiucorange}{HTML}{F47F24}
```

Change or add anything you see fit for your purposes. I always found hex color codes to be intuitive, so that's how I enter them.

You may also want to change the colors for your frame titles and the like. Those are options are listed below.

```latex
% Some optional color adjustments to Beamer. Change as you see fit.
%------------------------------------------------------------------
\setbeamercolor{frametitle}{fg=clemsonpurple,bg=white}
\setbeamercolor{title}{fg=clemsonpurple,bg=white}
\setbeamercolor{local structure}{fg=clemsonpurple}
\setbeamercolor{section in toc}{fg=clemsonpurple,bg=white}
% \setbeamercolor{subsection in toc}{fg=clemsonorange,bg=white}
\setbeamercolor{footline}{fg=clemsonpurple!50, bg=white}
\setbeamercolor{block title}{fg=clemsonorange,bg=white}
```

I'm of the mentality that most Beamer presentations waste precious space with things like overhead or side navigation panels. It's why omit those things entirely, even [the navigation symbols](https://tex.stackexchange.com/questions/686/how-to-get-rid-of-navigation-symbols-in-beamer) (i.e. the tribal arm band tattoo of Beamer presentations).[^cabo] It's more important to make the presentation informative than, well, gaudy. Yeah, I'm especially looking at you, [Palo Alto](http://deic.uab.es/~iblanes/beamer_gallery/individual/PaloAlto-default-default.html). However, I do have a subtle cosmetic touch at the footline that has some of these colors. Go a bit further down until you find this stretch of code and change the Clemson color codes you see.

[^cabo]: Listen; I get it. You've been to [Cabo](https://en.wikipedia.org/wiki/Cabo_San_Lucas), but you didn't need to get that to show everyone you made that trip. In fact, stop showing that thing to me. I didn't ask to see it in the first place.

{% raw %}
```latex
% Allow for those simple two-tone footlines I like. 
% Edit the colors as you see fit.
%--------------------------------------------------
\defbeamertemplate*{footline}{my footline}{%
    \ifnum\insertpagenumber=1
    \hbox{%
        \begin{beamercolorbox}[wd=\paperwidth,ht=.8ex,dp=1ex,center]{}%
      % empty environment to raise height
        \end{beamercolorbox}%
    }%
    \vskip0pt%
    \else%
        \Tiny{%
            \hfill%
		\vspace*{1pt}%
            \insertframenumber/\inserttotalframenumber \hspace*{0.1cm}%
            \newline%
            \color{clemsonpurple}{\rule{\paperwidth}{0.4mm}}\newline%
            \color{clemsonorange}{\rule{\paperwidth}{.4mm}}%
        }%
    \fi%
}
```
{% endraw %}

There are some other final color options here you may want to change if you want to de-Clemson your presentation.

```latex
% Various cosmetic things, though I must confess I forget what exactly these do and why I included them.
%-------------------------------------------------------------------------------------------------------
\setbeamercolor{structure}{fg=blue}
\setbeamercolor{local structure}{parent=structure}
\setbeamercolor{item projected}{parent=item,use=item,fg=clemsonpurple,bg=white}
\setbeamercolor{enumerate item}{parent=item}

% Adjust some item elements. More cosmetic things.
%-------------------------------------------------
\setbeamertemplate{itemize item}{\color{clemsonpurple}$$\bullet$$}
\setbeamertemplate{itemize subitem}{\color{clemsonpurple}\scriptsize{$$\bullet$$}}
\setbeamertemplate{itemize/enumerate body end}{\vspace{.6\baselineskip}} % So I'm less inclined to use \medskip and \bigskip in Markdown.
```

## A Sample R Markdown Slide

Of course, no sample R Markdown Beamer presentation of mine is complete without weirdness. My sample presentation (which shows [what the finished product looks like](https://github.com/svmiller/svm-r-markdown-templates/blob/master/beamer-example/svm-rmarkdown-beamer-example.pdf)) riffs on using pop culture inanities as illustrations of political science concepts, so here's "Rickrolling" toward an illustration of [median voter theorem](https://en.wikipedia.org/wiki/Median_voter_theorem).

```r
### Rick Astley's Re-election Platform

Rick Astley's campaign promises:

- Never gonna give you up.
- Never gonna let you down.
- Never gonna run around and desert you.
- Never gonna make you cry.
- Never gonna say goodbye.
- Never gonna tell a lie and hurt you.

Are these promises (if credible) sufficient to secure re-election?

```

We can visualize median voter theorem accordingly, which pits Congressman Astley's campaign pledges against a hypothetical rival on the distribution of preferences for emotional support.

![plot of chunk rick-astley-never-gonna-give-you-up-median-voter-theorem](/images/rick-astley-never-gonna-give-you-up-median-voter-theorem-1.svg)


According to this graph, Congressman Astley comfortably secures re-election against his rival because his policy package of emotional support is closer to the median voter.

## Replication, and Such

You can find the files to reproduce this presentation [here on my Github](https://github.com/svmiller/svm-r-markdown-templates/tree/master/beamer-example). The template is [here](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-beamer.tex). The R Markdown file of the sample presentation is [here](https://github.com/svmiller/svm-r-markdown-templates/blob/master/beamer-example/svm-rmarkdown-beamer-example.Rmd) and this PDF shows [what the finished product looks like](https://github.com/svmiller/svm-r-markdown-templates/blob/master/beamer-example/svm-rmarkdown-beamer-example.pdf). 


