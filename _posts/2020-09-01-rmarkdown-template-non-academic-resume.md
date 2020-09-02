---
title: "An R Markdown Template for a Non-Academic Résumé"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2020-09-01'
excerpt: "I have a series of templates for R Markdown. This post talks about my template for non-academic résumés."
layout: post
categories:
  - R Markdown
image: "rick-martel-crop.jpg"
---



{% include image.html url="/images/rick-martel-crop.jpg" caption="You can read the pin, right?" width=250 align="right" %}

<style>
img[src*='#center'] { 
    display: block;
    margin: auto;
}
</style>



I had the thought recently that I should prepare a non-academic résumé template for two reasons. To start, one of my most popular R Markdown templates is [my CV template](http://svmiller.com/blog/2016/03/svm-r-markdown-cv/), but the typical consumer of [my R Markdown templates](https://github.com/svmiller/svm-r-markdown-templates) is likely(?) not an academic. This would make the overall layout of my CV template a poor fit for what should be communicated to non-academic employers. Second, I have some polite reservations about [the trajectory of higher education in the United States given the ongoing pandemic](https://www.nature.com/articles/d41586-020-01518-y) and I should give myself at least some flexibility. Thus, the time I spent preparing a non-academic résumé was also the time I spent tweaking underlying TeX code into a template.

Consider this another installment in [my catalog of posts on R Markdown](http://svmiller.com/categories/#R%20Markdown), complementing my suite of templates for things like [academic manuscripts](http://svmiller.com/blog/2016/02/svm-r-markdown-manuscript/), [CVs](http://svmiller.com/blog/2016/03/svm-r-markdown-cv/), [syllabi](http://svmiller.com/blog/2016/07/r-markdown-syllabus/), [Beamer presentations](http://svmiller.com/blog/2019/08/r-markdown-template-beamer-presentations/), [Xaringan presentations](http://svmiller.com/blog/2018/02/r-markdown-xaringan-theme/), and [memos](http://svmiller.com/blog/2019/06/r-markdown-memo-template/) (among other templates). You can also skip this and head straight to [my Github repo for all these things](https://github.com/svmiller/svm-r-markdown-templates).

## Getting Started with the YAML

Here is what the YAML will resemble for my non-academic résumé. For clarity, the inspiration and underlying code for this template is patterned off three things. The first is [Grant McDermott](https://grantmcdermott.com/)'s lecture notes (for how he used Pandoc's [fenced_divs](https://pandoc.org/MANUAL.html#extension-fenced_divs). The second is [the Alta CV template](https://github.com/liantze/AltaCV), the main inspiration and layout for this template. The third is [Mike DeCrescenzo](https://mikedecr.github.io/)'s simplified presentation of the Alta CV template in his personal résumé. For those curious, the subject of the résumé was my favorite professional wrestler from my youth. The YAML will be belabored after the chunk of code that introduces it.

```yaml
---
title: "Résumé"
author: "Rick Martel"
date: "8/31/2020"
output: 
  pdf_document:
    latex_engine: xelatex
    keep_tex: true
    dev: cairo_pdf
    template: ../svm-latex-resume.tex
fontawesome: TRUE
# How can we get a hold of you?
email: FanServices@wwe.com
phone: 833-225-5993
location: "Cocoa Beach, FL (or Montréal, QC)"
github: svmiller
web: wwe.com/superstars/rick-martel
twitter: "@rickmartelWWE"
linkedin: "steven-miller-05b6851b3"
geometry: "top=.5in, left =.5in, right=.5in, bottom=.75in"
mainfont: cochineal
sansfont: Fira Sans
# monofont: Fira Code # I want to use this, but seems to choke on @
urlcolor: blue
fontsize: 11pt

includephoto: TRUE
myphoto: rick-martel-crop.jpg
# shift: "7in,-.25in" # this is default
photobigness: 1.75cm
# photozoom: ".2\textwidth" # this is default
---
```

The first three fields are unproblematic. `title:` is used for PDF bookmarking whereas the `author:` field should be your name. Right now, `date:` doesn't do anything but I intend to bring in some [`fancyhdr`](https://ctan.org/pkg/fancyhdr?lang=en) magic in LaTeX to give the user the option of including a "last updated" field in the footer of the résumé.

The `output:` field is also standard fare for long-time users of my templates. I only offer the caveat that I wrote this with the explicit idea of building it around `xelatex`. I wanted to bring in [the Fira family of fonts](https://fonts.google.com/specimen/Fira+Sans) into this template (a la Grant McDermott's lecture notes and Mike DeCrescenzo's example). I also wrote it to be used with the `fontawesome` package as well. You should at least have TeXLive 2015 for this template.[^fontawesome5]

[^fontawesome5]: [I mentioned on Twitter](https://twitter.com/stevenvmiller/status/1298645134469476354) that [the `fontawesome5` package](http://mirrors.ibiblio.org/CTAN/fonts/fontawesome5/doc/fontawesome5.pdf) features even more functionality and I will probably transition everything to that once I finally update my TeX version. However, that will come when I finally have to upgrade my current LTS version of Ubuntu (and, thus, re-install LaTeX). I am generally loathe to do this unless I categorically must do this.

Next, the user should specify some important features about themselves. I have two rows in this template for various contact information and personal information. The first row is more general information for what an employer should know about you. These are the email address, a telephone number where you can be reached, and your location. You can specify your exact street address here if you'd like. The second row is more about links to various things about you on the web. In other words, what is your website, Twitter handle, LinkedIn profile, and Github? All of these are basically optional, but you should ask yourself why you're using an R Markdown template if you don't have a website or Github. :P

The final entries after that are some cosmetic stuff of importance to me. For one, I adjusted the margins (`geometry:`) to be .5 inches on all sides except the bottom. Therein, that margin is .75 inches. That gives a little bit more space to note things like the page number (and, going forward, some information about when the résumé was last updated). I also adjusted the `mainfont:` to be [the Cochineal fonts](https://ctan.org/pkg/cochineal?lang=en) and for my `sansfont:` to be Fira Sans. I had thought about adjusting the monospaced fonts (`monofont:`) to be Fira Code, but Fira Code doesn't want to play nice with some characters (prominently the `@` character). Monospaced fonts feature prominently in the social links specified earlier. Adjust some other default Pandoc/R Markdown (e.g. `urlcolor:` and `fontsize:`) to taste.

The final set of options are for whether the user wants to include a photo of themselves in their résumé. `\usepackage{tikz}` is doing all the heavy lifting here and I'll confess up front I had to hack at this until it made sense to me. The user will want to play with these options and tweak it in YAML until they get something they like. Here's how I can best explain what's happening here.

First, `includephoto:` specifies whether the user wants to include a photo of themselves. If `includephoto: TRUE`, the user *must* specify the name of the file to be included as their photo in the `myphoto:` field. The user should probably also keep this in the same directory as the .Rmd file. Therein, the user should mess with some of the options available. First, the default photo size (`photobigness:`) is 1.5cm. The default scaling/"zoom" in `photozoom:` is `.2\textwidth`, which I found works best for my interests. If the user wants to mess with these, s/he may want to also adjust the `shift:` setting. By default, the photo "shifts" 7 inches left to right and -.25 inches (i.e. moving top to bottom). If the photo thumbnail is smaller, the user may want to shift the image further to the right. If it's bigger than 1.75cm (as it is here), s/he should shift it a further left (e.g. 6.5 inches instead of 7 inches) and should adjust the top to bottom shift to be more negative (sic). For best performance, the photo of the user should be as close to a square as possible. Therein, `tikz` magic will make it a circle.


## A Flexible Multi-Column Layout for Your Résumé

The body of the résumé leverages Pandoc's [fenced_divs](https://pandoc.org/MANUAL.html#extension-fenced_divs) and the user is free to populate the résumé as s/he sees fit. Here is be the basic skeleton.

```markdown
:::::: {.columns}
::: {.column width="60%" data-latex="{0.60\textwidth}"}

# Professional Experience

Lorem ipsum...


:::
::: {.column width="2%" data-latex="{0.02\textwidth}"}
\


:::
:::::: {.column width="38%" data-latex="{0.38\textwidth}"}

# Education

Lorem ipsum...

:::
::::::

```

Of note: `:::::: {.columns}` specifies the creation of two or more columns and that last `::::::` ends that environment. The first column is 60% in width relative to the `\textwidth` (see: `geometry:`) and should probably be the meat of the résumé outlining relevant professional experience. The second column is a glorified column separator, just 2% in width, that creates simple padding between the two main columns. The third column, 38% in width, should outline some auxiliary stuff of note (like the applicant's education and skill set).

All told, the ensuing template will produce a document like this. [Here's a link](https://github.com/svmiller/svm-r-markdown-templates/blob/master/resume-example/svm-resume-example.pdf) to it as well.



![](../../../../../../images/rick-martel-fake-cv-svm-rmarkdown-resume.png#center)


## Limitations, Replication, and Such

There are two limitations right now---none damning---but should be of interest to the user. First,  Pandoc's [fenced_divs](https://pandoc.org/MANUAL.html#extension-fenced_divs) aren't great with page breaks (as far as I know). Thus, the user may want to be mindful about the content of their columns and create a new page for when they know content will spill over. This is a simple one-page résumé right now. It's easily extended, but the user should do it manually and the sample .Rmd file includes some commented code on how to do this. Second, I intend to adjust a few things going forward, prominently the footer where I can make an option for noting when the résumé was last updated. The Github repo will show more updates.

You can find the files to reproduce this presentation [here on my Github](https://github.com/svmiller/svm-r-markdown-templates/tree/master/resume-example). The template is [here](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-resume.tex). The R Markdown file of the sample presentation is [here](https://github.com/svmiller/svm-r-markdown-templates/blob/master/resume-example/svm-resume-example.Rmd) and this PDF shows [what the finished product looks like](https://github.com/svmiller/svm-r-markdown-templates/blob/master/resume-example/svm-resume-example.pdf). 


