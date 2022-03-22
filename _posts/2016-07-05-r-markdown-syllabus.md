---
title: "Automatically Do (Just About) Everything in Your Syllabus with R Markdown"
author: steve
layout: post
permalink:
categories:
  - R Markdown
excerpt: "I have a series of templates for R Markdown. Here's one for an syllabus. I offer a guide on how to use it."
image: "itsinsyllabus.gif"
---

{% include announcebox.html announce="An Updated Version of This Template is in <a href='http://svmiller.com/stevetemplates'><code class='highlighter-rouge'>{stevetemplates}</code></a> ⤵️" text="This template is available in <a href='http://svmiller.com/stevetemplates'><code class='highlighter-rouge'>{stevetemplates}</code></a>, an R package that includes all my R Markdown templates. The version of <a href='http://svmiller.com/stevetemplates/reference/syllabus.html'>the template available in the package</a> is slightly modified/improved from what I present here. Issues with this template can be best addressed on <a href='https://github.com/svmiller/stevetemplates'>the project's Github</a>." %}


{% include image.html url="/images/itsinsyllabus.gif" caption="Via PhD Comics, naturally." width=450 align="right" %}

This will be the latest in [my series](http://svmiller.com/categories/#R%20Markdown) of tutorials for making the most of [R Markdown](http://rmarkdown.rstudio.com/). [My repository](https://github.com/svmiller/svm-r-markdown-templates) already has R Markdown LaTeX templates for [academic manuscripts](http://svmiller.com/blog/2016/02/svm-r-markdown-manuscript/), [CVs](http://svmiller.com/blog/2016/03/svm-r-markdown-cv/), and [personal statements](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-statement.tex) (e.g. teaching statement, research statement). The syllabus is the next step.

I've bemoaned [elsewhere on my blog](http://svmiller.com/blog/2015/08/streamlining-the-syllabus-in-latex-with-advdate-and-datetime/) that the syllabus is more tedious than it is creative or imaginative. Long-time professors don't waiver much in their views about what constitutes core material. This leaves the professor wanting to do just a few things in crafting the syllabus.

1. Conform the skeleton of the syllabus with the peculiar dates for the semester (e.g. conference travel days, semester holidays).
2. Seamlessly render bibliographic citations for required readings and course material assigned in a given week.

R Markdown can do both these things and more. The syllabus template I designed will generate a fancy LaTeX syllabus (in PDF form) with just a few R packages and custom functions. I'll start first with a description of the YAML metadata.

## The YAML Metadata

The YAML metadata starts every R Markdown document and provides basic information for the document the user wants to generate. My template (`svm-latex-syllabus.tex`) adds a few other custom fields as well.

```yaml
---
output: 
  pdf_document:
    keep_tex: true
    fig_caption: yes
    latex_engine: pdflatex
    template: ~/Dropbox/miscelanea/svm-r-markdown-templates/svm-latex-syllabus.tex
geometry: margin=1in

title: "POSC 0000: A Class with an R Markdown Syllabus"
author: Steven V. Miller
date: "Fall 2016"

email: "svmille@clemson.edu"
web: "svmiller.com/teaching"
officehours: "W 09:00-11:30 a.m."
office: "230A Brackett Hall"
classroom: "*online*"
classhours: "TR 02:00-03:45 p.m."

fontfamily: mathpazo
fontsize: 11pt
header-includes:
   - \linespread{1.05}
---
```

The entries after `output:` are fairly standard and some are optional. I prefer to set `keep_tex: true` to generate a raw .tex file with the finished PDF because I find it useful for debugging. I also like to make sure `latex_engine` is set to `pdflatex` even if it's probably default with the `pdf_document` option. I also like to make sure the margins are set to one inch on all sides with the `geometry` entry.

The next three entries coincide with what LaTeX users will recognize as the `\maketitle` call for a PDF document. `title` is the title of the course. I prefer to keep the department initials and course number in it as well. `author` should be the name of the professor while `date` should be the semester.

The next six fields coincide with entries in a table shortly after the title, author, and date. These should be intuitive. Put the professor's e-mail, course website, office hours, office, classroom, and class hours to fill out the basic course information. It will eventually look like this.

{% include image.html url="/images/rmarkdown-syllabus-title.png" caption="The title of my R Markdown syllabus template." width=800 align="center" %}

The final three entries are optional as well. I prefer the `mathpazo` font family for LaTeX and like to set the size of the font to 11pt. `mathpazo` also looks better with a linespread of 1.05, which is why I set to include that in the header.

## Automatically Render Dates in R Markdown

My previous LaTeX syllabi included [LaTeX hacks](http://svmiller.com/blog/2015/08/streamlining-the-syllabus-in-latex-with-advdate-and-datetime/) to automatically render dates in the syllabus. It's even easier to do it in R and R Markdown. It also requires less markup.

Put the following code in an R "chunk" somewhere in your R Markdown document (preferably near the top).

```r
mon <- as.Date("2016-08-15")

advdate <- function(obj, adv) {
 tmon <- obj + 7*(adv-1)
 tfri <- obj + 4 + 7*(adv-1)
 tmon <- format(tmon, format="%m/%d")
 tfri <- format(tfri, format="%m/%d")
 zadv <- sprintf("%02d", adv)
 tmp <- paste("Week ",zadv,sep='',", ", tmon," - ",tfri)
 return(tmp)
}
```

The code itself is fairly simple. First set the first Monday of the first week of the semester. This is August 15, 2016 of the upcoming fall semester for me at Clemson University. Whatever it is for you, set it in `YYYY-MM-DD` format.

The `advdate` function I wrote is a simple hack. It identifies the date object you give it, jumps ahead however many weeks you want, and advances it five days (which should be Friday if you set it at Monday). It returns a character object that will say something like `Week 01, 08/15 - 08/19`.

Notice what I do with this function within my R Markdown syllabus. I hide it in a subsection block, follow it with a colon and a description of the week's readings. Here's the actual code in my R Markdown document.

```r
##  `r advdate(mon, 6)`: Keep

##  `r advdate(mon, 7)`: Going

##  `r advdate(mon, 8)`: Down

##  `r advdate(mon, 9)`: the

##  `r advdate(mon, 10)`: Line

##  `r advdate(mon, 11)`: Until

##  `r advdate(mon, 12)`: You

## `r advdate(mon, 13)`: Are

##  `r advdate(mon, 14)`: Done

##  `r advdate(mon, 15)`: with

##  `r advdate(mon, 16)`: your

##  `r advdate(mon, 17)`: Syllabus 
```

The reader can see what this will look like in the PDF I embed at the end of the post. It's also available on my Github repository.

## Render Bibliographic Citations with Your .bib File

LaTeX' virtue is its ability to flawlessly handle end-of-the-paper references. It curiously struggles with *full* mid-document bibliographic citations like professors typically want in their syllabi. `bibentry` is the package to use in these situations but it works with so few styles.

[RefManageR](https://cran.r-project.org/web/packages/RefManageR/index.html) is a lot more flexible. It also requires minimal markup.

Here's what it looks like with my personal .bib file. Place the following code as an R chunk somewhere in your R Markdown document. You can place it in the same chunk as the `advdate` function.

```r
library(RefManageR)
bib <- ReadBib("~/Dropbox/master.bib") # Change to whatever is your .bib file
myopts <- BibOptions(bib.style = "authoryear", style="latex", first.inits=FALSE, max.names = 20)
```
The syntax to use it is fairly simple. Let's say my syllabus has required readings of R. Harrison Wagner's (2007) [*War and the State*](http://www.press.umich.edu/224960/war_and_the_state) and John Vasquez' (2009) [*The War Puzzle Revisited*](http://www.cambridge.org/us/academic/subjects/politics-international-relations/international-relations-and-international-organisations/war-puzzle-revisited). Telling my students that in my syllabus is as easy as finding the two bibtexkeys in my .bib file and telling R to print/display them from the BibEntry object (i.e. `bib`).

{% highlight r %}

## Required Readings

```{r, echo = FALSE, results="asis"} 
bib["vasquez2009twp", "wagner2007ws"]
``` 
{% endhighlight %}

This will generate the following LaTeX code that R Markdown will ultimately compile into your finished PDF.

```latex
\section{Required Readings}\label{required-readings}

\inputencoding{utf8} Vasquez, John A (2009).
\emph{The War Puzzle Revisited}. New York, NY: Cambridge University
Press.

\inputencoding{utf8} Wagner, R. Harrison (2007).
\emph{War and the State: The Theory of International Politics}. Ann
Arbor, MI: The University of Michigan Press.
```

[RefManageR](https://cran.r-project.org/web/packages/RefManageR/index.html) is useful for those of us wedded to our .bib files but it's far from a panacea. [RefManageR](https://cran.r-project.org/web/packages/RefManageR/index.html) has a limited number of styles too, which may not satisfy political scientists (in particular) who want APSA style citations. [rcrossref](https://cran.r-project.org/web/packages/rcrossref/index.html) can do this but it requires (to the best of my knowledge) [DOI numbers](http://www.crosscite.org/cn/) and it will not know how to italicize things like the book or journal title.

## Do Even More in R Markdown

The reader can see some of the other things I do with R Markdown in my syllabus. I prominently embed some R code to model the bivariate relationship between attendance and grades to induce my students to attend class. You can see how I dynamically report this relationship in [the .Rmd file](https://github.com/svmiller/svm-r-markdown-templates) I upload to [my Github](http://github.com/svmiller).

Here's what a finished PDF syllabus will look like with my template.

{% include embedpdf.html code="um7nm66o7iancqe/svm-rmarkdown-syllabus-example.pdf" width=100 height=800 %}
