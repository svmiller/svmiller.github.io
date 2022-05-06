---
title: "Print References/Reading List/Bibliography in Your Syllabus (With Some Style) in R Markdown and {stevemisc}"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2022-01-13'
excerpt: "Here's a more elegant way to format a bibliography/reading list for a syllabus than RefManageR in R Markdown."
layout: post
categories:
  - R
image: "stack-of-journals.png"
---



{% include image.html url="/images/stack-of-journals.png" caption="A stack of things to read." width=350 align="right" %}

It's the start of the semester for a lot of us, which means it's time to create our syllabi and tell students to read things in hopes that they might actually read them. No matter, the point here isn't to repeat a common refrain of university professors that it's difficult to get students to do the readings on the syllabus, [let alone convert them to communism](https://twitter.com/profmusgrave/status/1279252119074242560). The point here is to scratch an itch on how to format a reading list for a syllabus in an elegant way. I think I have a reasonable solution here based on some functionality built into [`{stevemisc}`](http://svmiller.com/stevemisc/) (pending version 1.4).

Here's the basic problem from the perspective of someone who uses R Markdown as an interface to pandoc, and ultimately a wrapper for a LaTeX document designed with my syllabus template in [`{stevetemplates}`](http://svmiller.com/stevetemplates/). Rather, here's the question as a restatement of the problem how does one create a "reading list" in the syllabus in a seamless way that elegantly communicates the pertinent information (i.e. the stuff a student should read for a given week during the semester)? This answer has dogged me for awhile, since there are two basic approaches here of which I'm familiar. None are perfect.

One approach is to make some in-text citations that can then be formatted as a bibliography at the end of the document. One of my professors in grad school recently discovered LaTeX while I was a student there and formatted their syllabus this way. It would look something like this in the LaTeX document.

```latex
\section{Week 1}

\citep{horvath1944, janowicz1950, cassady1955, griffin1974, griffin1975, george1995, smith2006}
```

This would come out looking something like this.

```
Week 1

(Horvath, 1944; Janowicz, 1950; Cassady, 1955; Griffin, 1974, 1975; George, 1995; Smith, 2006)
```

A student would then have to read the syllabus and jump to the bibliography at the very end of the syllabus to figure out what exactly the reading was. That works, but it's unenjoyable.

Another approach would be what I've done for the past few years. This leverages [`{RefManageR}`](https://cran.r-project.org/web/packages/RefManageR/index.html), a master `.bib` file, and R Markdown. Here's a simple illustration based on [my ongoing international conflict class](http://posc3610.svmiller.com/), in which I assign the 3rd edition of [*What Do We Know About War?*](https://www.amazon.com/What-Do-Know-about-War-dp-1538140098/dp/1538140098) as well as John Vasquez' [*The War Puzzle Revisited*](https://www.amazon.com/Revisited-Cambridge-Studies-International-Relations/dp/0521708230). These are given in my convoluted `master.bib` file as "vasquez2009twp" and "mitchellvasquez2021wdwk". If I wanted to display these entries as a bibliography or reading list in my syllabus, I would do something like this. Do note that your chunk option should *always* be set to `"results='asis'"` for any of this to work.


```r
library(RefManageR)

bib <- ReadBib("~/Dropbox/master.bib")
myopts <- BibOptions(bib.style = "authoryear", style="latex", first.inits=FALSE, max.names = 20)

bib[c("vasquez2009twp", "mitchellvasquez2021wdwk")]
#> Mitchell, Sarah McLaughlin and John A. Vasquez, ed.
#> (2021).
#> \emph{What Do We Know about War?}
#> 3rd ed.
#> Lanham, MD: Rowman \& Littlefield.
#> 
#> Vasquez, John A
#> (2009).
#> \emph{The War Puzzle Revisited}.
#> New York, NY: Cambridge University Press.
```

A few things are happening here that make this approach functional, but dissatisfying. Namely, `{RefManageR}` is limited stylistically. It can do some basic formatting, but things are just going to come out looking awkward no matter what. For one, it has no discipline-specific (for me) formatting style. I would like APSA's citation style, but I would settle for Harvard or Chicago. The best I can do is "authoryear", and importantly tell `{RefManageR}` to knock it off (to the best of my abilities) with condensing multiple authors to "et al." or initializing (sic) their names.

So, here's what I think to be a better way, and one that uses some functionality built into the pending version 1.4 of [`{stevemisc}`](http://svmiller.com/stevemisc/). I'll be using a toy data set that comes in this package too. This is `stevepubs`. `stevepubs` is a data frame of my publications (in print and forthcoming), mostly my journal articles. This leverages the awesomeness of the [`{bib2df}`](https://cran.r-project.org/web/packages/bib2df/index.html) package (itself a dependency of [`{stevemisc}`](http://svmiller.com/stevemisc/). For quick context, here is how I created this data frame.

```r
library(tidyverse)
library(bib2df)
library(stevemisc)

bib <- bib2df("~/Dropbox/master.bib")

bib %>%
  filter(COMMENT == "citemyshit") %>%
  arrange(YEAR) %>%
  select(where(~!all(is.na(.x)))) %>%
  select(-COMMENT, -TIMESTAMP, -OWNER) -> stevepubs
```

And here is what this data frame looks like.


```r
stevepubs
#> # A tibble: 19 × 12
#>    CATEGORY  BIBTEXKEY  AUTHOR BOOKTITLE  JOURNAL  NUMBER PAGES PUBLISHER TITLE 
#>    <chr>     <chr>      <list> <chr>      <chr>    <chr>  <chr> <chr>     <chr> 
#>  1 ARTICLE   millergib… <chr … <NA>       Conflic… 3      261-… <NA>      "Demo…
#>  2 ARTICLE   giblereta… <chr … <NA>       Compara… 12     1655… <NA>      "Indi…
#>  3 ARTICLE   giblermil… <chr … <NA>       Social … 5      1202… <NA>      "Comp…
#>  4 ARTICLE   giblermil… <chr … <NA>       Journal… 2      258-… <NA>      "Quic…
#>  5 ARTICLE   miller201… <chr … <NA>       Journal… 6      677-… <NA>      "Terr…
#>  6 ARTICLE   giblermil… <chr … <NA>       Journal… 5      634-… <NA>      "Exte…
#>  7 ARTICLE   giblereta… <chr … <NA>       Interna… 4      719-… <NA>      "An A…
#>  8 ARTICLE   miller201… <chr … <NA>       Politic… 2      457-… <NA>      "Econ…
#>  9 ARTICLE   miller201… <chr … <NA>       Conflic… 5      526-… <NA>      "Indi…
#> 10 ARTICLE   miller201… <chr … <NA>       Politic… 4      790-… <NA>      "The …
#> 11 ARTICLE   miller201… <chr … <NA>       Peace E… 1      <NA>  <NA>      "Exte…
#> 12 ARTICLE   miller201… <chr … <NA>       Social … 1      272-… <NA>      "What…
#> 13 ARTICLE   giblereta… <chr … <NA>       Interna… 2      476-… <NA>      "The …
#> 14 INCOLLEC… millereta… <chr … Oxford Re… <NA>     <NA>   <NA>  Oxford U… "Geog…
#> 15 ARTICLE   millerdav… <chr … <NA>       Journal… 2      334-… <NA>      "The …
#> 16 ARTICLE   curtismil… <chr … <NA>       Europea… 2      202-… <NA>      "A (S…
#> 17 ARTICLE   miller202… <chr … <NA>       The Soc… <NA>   <NA>  <NA>      "Econ…
#> 18 ARTICLE   peacescie… <chr … <NA>       Conflic… <NA>   <NA>  <NA>      "~{ \…
#> 19 ARTICLE   miller202… <chr … <NA>       Journal… <NA>   <NA>  <NA>      "A Ra…
#> # … with 3 more variables: VOLUME <chr>, YEAR <chr>, DOI <chr>
```

The workhorse function for doing what I want here is [`print_refs()`](http://svmiller.com/stevemisc/reference/print_refs.html). Here's a brief summary of the arguments in this function.

- `bib`: a valid `.bib` entry, *or* a data frame that (one assumes) was created by the [`{bib2df}`](https://cran.r-project.org/web/packages/bib2df/index.html) package. Either works here.
- `csl`: a CSL file, matching one available in the repository supplied to `cslrepo`, that the user wants to format the references. The default here is "american-political-science-association.csl". Do note that if ".csl" is not supplied here, the functions you assumes you forgot to do this and will attach it on for you.
- `toformat`: the output format wanted by the user. Default is "markdown_strict". "latex" works here as well. I caution against doing too much here. [Check Pandoc's user guide](https://pandoc.org/MANUAL.html) for more information here.
- `cslrepo`: 	a directory of CSL files. Defaults to the one on Github ("https://raw.githubusercontent.com/citation-style-language/styles/master").
- `spit_out`: logical, defaults to TRUE. If TRUE, wraps ("spits out") formatted citations in a `writeLines()` output for the console. If FALSE, returns a character vector.
- `delete_after`: logical, defaults to TRUE. If TRUE, deletes CSL file when it's done. If FALSE, retains CSL for (potential) future use.

## Print Your References

From there, this is a simple matter of just executing `print_refs()`. This would format all the references in `stevepubs` into a full reading list/bibliography.



```r
stevepubs %>% print_refs()
#> Curtis, K. Amber, and Steven V. Miller. 2021. “A (Supra)nationalist
#> Personality? The Big Five’s Effects on Political-Territorial
#> Identification.” *European Union Politics* 22(2): 202–26.
#> 
#> Gibler, Douglas M., Marc L. Hutchison, and Steven V. Miller. 2012.
#> “Individual Identity Attachments and International Conflict: The
#> Importance of Territorial Threat.” *Comparative Political Studies*
#> 45(12): 1655–83.
#> 
#> Gibler, Douglas M., and Steven V. Miller. 2012. “Comparing the Foreign
#> Aid Policies of Presidents Bush and Obama.” *Social Science Quarterly*
#> 93(5): 1202–17.
#> 
#> ———. 2013. “Quick Victories? Territory, Democracies, and Their
#> Disputes.” *Journal of Conflict Resolution* 57(2): 258–84.
#> 
#> ———. 2014. “External Territorial Threat, State Capacity, and Civil War.”
#> *Journal of Peace Research* 51(5): 634–46.
#> 
#> Gibler, Douglas M., Steven V. Miller, and Erin K. Little. 2016. “An
#> Analysis of the Militarized Interstate Dispute (MID) Dataset,
#> 1816-2001.” *International Studies Quarterly* 60(4): 719–30.
#> 
#> ———. 2020. “The Importance of Correct Measurement.” *International
#> Studies Quarterly* 64(2): 476–79.
#> 
#> Miller, Steven V. 2013. “Territorial Disputes and the Politics of
#> Individual Well-Being.” *Journal of Peace Research* 50(6): 677–90.
#> 
#> ———. 2017a. “Economic Threats or Societal Turmoil? Understanding
#> Preferences for Authoritarian Political Systems.” *Political Behavior*
#> 39(2): 457–78.
#> 
#> ———. 2017b. “Individual-Level Expectations of Executive Authority Under
#> Territorial Threat.” *Conflict Management and Peace Science* 34(5):
#> 526–45.
#> 
#> ———. 2017c. “The Effect of Terrorism on Judicial Confidence.” *Political
#> Research Quarterly* 70(4): 790–802.
#> 
#> ———. 2018. “External Territorial Threats and Tolerance of Corruption: A
#> Private/Government Distinction.” *Peace Economics, Peace Science and
#> Public Policy* 24(1).
#> 
#> ———. 2019. “What Americans Think about Gun Control: Evidence from the
#> General Social Survey, 1972-2016.” *Social Science Quarterly* 100(1):
#> 272–88.
#> 
#> ———. “A Random Item Response Model of External Territorial Threat,
#> 1816-2010.” *Journal of Global Security Studies*.
#> 
#> ———. “Economic Anxiety or Ethnocentrism? An Evaluation of Attitudes
#> Toward Immigration in the U.S. From 1992 to 2017.” *The Social Science
#> Journal*.
#> 
#> ———. “ <span class="nocase"> {}peacesciencer{}</span>: An R Package for
#> Quantitative Peace Science Research.” *Conflict Management and Peace
#> Science*.
#> 
#> Miller, Steven V., and Nicholas T. Davis. 2021. “The Effect of White
#> Social Prejudice on Support for American Democracy.” *Journal of Race,
#> Ethnicity, and Politics* 6(2): 334–51.
#> 
#> Miller, Steven V., and Doublas M. Gibler. 2011. “Democracies, Territory,
#> and Negotiated Compromises.” *Conflict Management and Peace Science*
#> 28(3): 261–79.
#> 
#> Miller, Steven V., Jaroslav Tir, and John A. Vasquez. 2020. “Geography,
#> Territory, and Conflict.” In *Oxford Research Encyclopedia of
#> International Studies*, Oxford University Press.
```

If you're working with a "master" `.bib` file, like I typically do, you probably don't want to format *all* those entries in there. However, if you've converted your `.bib` file to a data frame by way of [`{bib2df}`](https://cran.r-project.org/web/packages/bib2df/index.html), you can do some basic filtering on it to get what you want. For example, let's assume I have a week where I'm just going to assign everything of mine that was published in 2017. Here's how you'd do that.


```r
stevepubs %>% filter(YEAR == 2017) %>%  print_refs()
#> Miller, Steven V. 2017a. “Economic Threats or Societal Turmoil?
#> Understanding Preferences for Authoritarian Political Systems.”
#> *Political Behavior* 39(2): 457–78.
#> 
#> ———. 2017b. “Individual-Level Expectations of Executive Authority Under
#> Territorial Threat.” *Conflict Management and Peace Science* 34(5):
#> 526–45.
#> 
#> ———. 2017c. “The Effect of Terrorism on Judicial Confidence.” *Political
#> Research Quarterly* 70(4): 790–802.
```

There's not a lot else on top of that. I have some sister functions I wrote around this as I was experimenting with this---prominently [`filter_refs()`](http://svmiller.com/stevemisc/reference/filter_refs.html) but this should be enough to get started. Consider it the latest tool in my syllabi package, complementing [my template](http://svmiller.com/blog/2016/07/r-markdown-syllabus/) and [calendar](http://svmiller.com/blog/2020/08/a-ggplot-calendar-for-your-semester/).
