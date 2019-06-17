---
title: "An R Markdown Template for Memos"
author: "steve"
date: '2019-06-17'
excerpt: "I have a series of templates for R Markdown. Here's one for a memo and a guide on how to use it."
layout: post
permalink: null
categories:
  - R Markdown
---



{% include image.html url="/images/taylor-swift-never-getting-back-together-video.jpg" caption="Taylor Swift here showing the same exasperation when I get asked to do more paperwork." width=410 align="right" %}

I just got asked to prepare a memo for university-related work; fun, right? Who doesn't love more paperwork.

However, I had no convenient template yet for preparing the type of document that was requested of me. The time I prepared the document was effectively the time I spent creating another R Markdown template to share with the world, since that's most of the traffic my website gets anyway.

What follows is a guide on how to use this template and an example of the type of document it produces. It will serve as a compliment to my full suite of R Markdown templates for [academic manuscripts](http://svmiller.com/blog/2016/02/svm-r-markdown-manuscript/), [CVs](http://svmiller.com/blog/2016/03/svm-r-markdown-cv/), [syllabi](http://svmiller.com/blog/2016/07/r-markdown-syllabus/), class presentations [in Beamer](http://svmiller.com/blog/2015/02/moving-from-beamer-to-r-markdown/) or [Xaringan](http://svmiller.com/blog/2018/02/r-markdown-xaringan-theme/), among [other templates](https://github.com/svmiller/svm-r-markdown-templates/).

## The YAML Metadata

The layout for my memo template resembles [my statement template](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-statement.tex), which is one I never fully introduced on my website but it's one that I use for writing a lot of reports for university or professional tasks. You can see it in my [research statement](http://svmiller.com/docs/svm-research-statement.pdf), my [teaching philosophy](http://svmiller.com/docs/svm-teaching-philosophy.pdf), or my [empirical assessment of my own teaching effectivness](http://svmiller.com/docs/svm-teaching-evals.pdf). That template, itself not too far derived from the standard LaTeX template in Pandoc, served as the foundation for what I wanted to do here.

This template should be straightforward if you're accustomed to my other templates. I'll display here the full YAML of the sample document I prepared and pushed to [my Github](https://github.com/svmiller).

```yaml
---
output: 
  pdf_document:
    citation_package: natbib
    keep_tex: false
    latex_engine: pdflatex
    template: svm-latex-memo.tex
fontfamily: mathpazo
fontsize: 11pt
geometry: margin=1in
header-includes:
   - \linespread{1.05}

from: Taylor Swift
to: Jake Gyllenhaal (reportedly)
subject: We Are Never Ever Getting Back Together
date: "`r format(as.Date('2012-08-13'), '%d %B, %Y')`"
memorandum: true
graphics: true
width: .3
logoposition: right
logo: taylor-swift-logo.png
---
```

Ignore everything in the YAML before the space since it's mostly boilerplate stuff for a LaTeX template in R Markdown. The only thing worth nothing is the `template:` field should point to wherever you're hosting my memo template.

There YAML items after the artificial space I introduced for clarity contain the meat of the template and are patterned off (but do not require) [the `texMemo` LaTeX class](https://www.sharelatex.com/templates/52fcde0834a287a85245b4a2). The `from:` field will be the name of the author and the `to:` field, very ["reportedly" in this context](https://www.huffpost.com/entry/taylor-swifts-we-are-never-ever-song-jake-gyllenhaal_n_1858318), will be the recipient of the memo. The `subject:` field will be the title of the memo and the `date:` field will be, well, the date. These fields are not required for the template to execute, but, in the absence of these fields, why are you writing a memo?

The next few items concern some optional items. By default, my template does not have a centered title that says "MEMORANDUM." If you want that, specify `memorandum:` as a field and put "true" as a value. If you do not want this, comment it out, omit it ouright, or substitute "false" for "true" in that field. Again, the default is that there is no such title that says "MEMORANDUM."

The last items are there if you want to add a logo to the top right of your memo. First, and most importantly, specify `graphics: true` if you want a logo. If you do not do this as a first step, the rendering will fail. The next two fields will concern, intuitively, width and placement of your logo. The default width is 30% of the textwidth of the document and the default logo position is to the right of the document. The `width:` field will take any value between 0 and 1 and the `logoposition:` field will take entries of "left", "center", or "right".

Finally, specify your logo in the `logo:` field. The default is to assume your logo is in the same directory as the R Markdown document. You can always adjust this if you are comfortable with relative paths in R Markdown.

Also, yes I know this Taylor Swift logo was from the period before she released Red. I just find this logo better for this purpose.

You can find this template in [the usual directory on my Github](https://github.com/svmiller/svm-r-markdown-templates). Here is a link to [the template](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-memo.tex), [the R Markdown file](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-memo-example.Rmd), and [the rendered example](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-memo-example.pdf).

A screenshot of the template in action follows.

![](/images/svm-memo-example-screenshot.png)
