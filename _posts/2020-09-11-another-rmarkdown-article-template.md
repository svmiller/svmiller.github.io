---
title: "Another Academic R Markdown Article/Manuscript Template"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2020-09-11'
excerpt: "I have a series of templates for R Markdown. This post talks about another academic article/manuscript template I made."
layout: post
categories:
  - R Markdown
image: "new-rmd-article-template.png"
---

{% include announcebox.html announce="An Updated Version of This Template is in <a href='http://svmiller.com/stevetemplates'><code class='highlighter-rouge'>{stevetemplates}</code></a> ⤵️" text="This template is available in <a href='http://svmiller.com/stevetemplates'><code class='highlighter-rouge'>{stevetemplates}</code></a>, an R package that includes all my R Markdown templates. The version of <a href='http://svmiller.com/stevetemplates/reference/article2.html'>the template available in the package</a> is slightly modified/improved from what I present here. Issues with this template can be best addressed on <a href='https://github.com/svmiller/stevetemplates'>the project's Github</a>." %}


{% include image.html url="/images/new-rmd-article-template.png" caption="I did another thing. Here's what it looks like." width=500 align="right" %}

<style>
img[src*='#center'] { 
    display: block;
    margin: auto;
}
</style>




I wrote another R Markdown article template for your consideration. I'm going to try to be brief here, padding only to make sure that there's enough text to wrap around the image you see to your right (which gives a rudimentary preview as to what the template looks like). 

I wrote another R Markdown template for a few reasons. One, I felt like it. Two, I wanted to write another article template that better resembles the default Pandoc template. My [other R Markdown article/manuscript](http://svmiller.com/blog/2016/02/svm-r-markdown-manuscript/) is actually a template for an old .tex document that I had that I hacked into an R Markdown template. However, that process leaves a lot of built-in Pandoc/R Markdown goodies (like `xelatex` functionality) on the cutting room floor. This template, instead, takes the default Pandoc template and adds on features to make sure much of the R Markdown/Pandoc functionality remains in tact. Third, I wanted a template that I could better build around `xelatex` functionality, especially custom fonts. My other template struggled on that front. Finally, I wanted just a bit more natural white space in a template. In particular, I wanted a new template that better approximated [the Association for Computing Machinery (ACM) LaTeX templates](https://www.latextemplates.com/template/acm-publications). My previous template tried to mimic it, but I wanted it to do better both in terms of white space and the creative use of sans serif fonts (especially Libertine fonts). I think this new template does that.

## The YAML

Here's what the YAML would look like. You should be familiar with these by now. If not, [my previous post](http://svmiller.com/blog/2016/02/svm-r-markdown-manuscript/) offers more clarification. Keep in mind that most to all of the functionality of the previous template is available in this one. This includes `anonymous:`, `removetitleabstract:`, and `appendix:`.

```yaml
---
output: 
  pdf_document:
    latex_engine: xelatex
    keep_tex: true
    dev: cairo_pdf
    template: ../svm-latex-article2.tex # Put this somewhere where it makes sense, obviously
biblio-style: apsr
title: "Another Pandoc Markdown Article Starter and Template"
thanks: "Replication files are available on the author's Github account (http://github.com/svmiller/svm-r-markdown-templates). **Current version**: September 11, 2020; **Corresponding author**: steven.v.miller@gmail.com."
author:
- name: Steven V. Miller
  affiliation: Clemson University
- name: A Second Author Who Did Less Work
  affiliation: The Ohio State University
- name: A Graduate Student
  affiliation: University of Alabama
abstract: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sit amet libero justo. Pellentesque eget nibh ex. Aliquam tincidunt egestas lectus id ullamcorper. Proin tellus orci, posuere sed cursus at, bibendum ac odio. Nam consequat non ante eget aliquam. Nulla facilisis tincidunt elit. Nunc hendrerit pellentesque quam, eu imperdiet ipsum porttitor ut. Interdum et malesuada fames ac ante ipsum primis in faucibus. Suspendisse potenti. Duis vitae nibh mauris. Duis nec sem sit amet ante dictum mattis. Suspendisse diam velit, maximus eget commodo at, faucibus et nisi. Ut a pellentesque eros, sit amet suscipit eros. Nunc tincidunt quis risus suscipit vestibulum. Quisque eu fringilla massa."
keywords: "pandoc, r markdown, knitr"
date: "September 11, 2020"
geometry: margin=1in
#fontfamily: libertineotf
mainfont: cochineal
sansfont: Linux Biolinum O
fontsize: 11pt
# spacing: double
endnote: no
# pandocparas: TRUE
sansitup: TRUE
---
```

I want to highlight a few things about this particular version of the YAML vis-a-vis the previous version. First, I'm inclined to ask you to ignore `fontfamily:` since I intend to transition from `pdftex` to `xelatex` full-time for my own uses. Thus, I ignore `fontfamily:` and I set my `mainfont:` to be `cochineal` (which looks gorgeous, and I think is available in just `xelatex`). Second, I give the option this time to keep Pandoc's default paragraphs in `pandocparas:`. By default, this is set to FALSE and paragraphs follow standard Anglo-American typography of a first paragraph that's not indented and subsequent paragraphs that are indented 15-17-pts. I split the difference and specify it to 16-pts. If you wish, you can set `pandocparas: TRUE` and get the default Pandoc paragraphs where there is no paragraph indentation whatsoever, but with some white space separating them.

Of particular note, though, are two fields. The first is `sansfont:`, which is a feature that comes with the use of `xelatex`. As a Linux user, I've noted that the sans serif of the libertine font family from the ACM template is basically [the Linux Biolinum O font](https://fonts2u.com/linux-biolinum-o.font) that I think we Linux users get by default. You may as well? No matter, it's [a free download](https://fonts2u.com/linux-biolinum-o.font)  and you may want to install it on your end. The second is `sansitup:`. By default, this is set to FALSE for generalizable functionality for different users who may or may not have this font. I treat Linux Biolinum O as my default sans serif font and call it intermittently as the default sans serif font. If you don't have this sans serif font, I think the default sans serif font looks kinda gaudy and I would not recommend using it. So, I give the user the choice to "sans (it) up" their document. If you don't want to "sans up" your document, the ensuing template will look kinda like this.

{% include image.html url="/images/dont-sans-it-up.png" caption="What it looks like when you don't sans it up." width=664 align="center" %}

<!-- ![](../../../../../../images/dont-sans-it-up.png#center) -->

If you do choose to "sans it up", the template will look like this. This kinda captures the ACM template pretty well (I think). Because italicized sans serif doesn't look quite right, I make these subsections to be bold and the serif subsections called above to be italicized.

{% include image.html url="/images/sans-it-up.png" caption="What it looks like when you decide to sans it up." width=652 align="center" %}

<!-- ![](../../../../../../images/sans-it-up.png#center) -->


The choice is yours. I think both look great.

## Where to Get It

You can find the files to reproduce this presentation [here on my Github](https://github.com/svmiller/svm-r-markdown-templates/tree/master/article2-example). The template is [here](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-article2.tex). The R Markdown file of the sample presentation is [here](https://github.com/svmiller/svm-r-markdown-templates/blob/master/article2-example/svm-article2-example.Rmd) and this PDF shows [what the finished product looks like](https://github.com/svmiller/svm-r-markdown-templates/blob/master/article2-example/svm-article2-example.pdf). 


