---
title: 'Make Your Presentations Fun in Xaringan'
author: steve
layout: post
date: "2018-02-03"
permalink:
categories:
  - R Markdown
excerpt: "I have a series of templates for R Markdown. Here's one for a Xaringan presentation. I offer a guide on how to use it."
---


{% include image.html url="/images/sheena-easton-morning-train.jpg" caption="It's better to re-purpose Sheena Easton's '9 to 5' (or 'Morning Train') as describing a total-conflict game a la 'Holmes-and-Moriarty' or 'matching pennies.'" width=325 align="right" %}

This will be the latest in [my series](http://svmiller.com/categories/#R%20Markdown) of tutorials for making the most of [R Markdown](http://rmarkdown.rstudio.com/). [My repository](https://github.com/svmiller/svm-r-markdown-templates) already has R Markdown LaTeX templates for [academic manuscripts](http://svmiller.com/blog/2016/02/svm-r-markdown-manuscript/), [CVs](http://svmiller.com/blog/2016/03/svm-r-markdown-cv/), [personal statements](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-latex-statement.tex) (e.g. teaching statement, research statement), and [syllabi](http://svmiller.com/blog/2016/07/r-markdown-syllabus/). Here, I offer a CSS theme for Xaringan.

## What is Xaringan? Why Use It?

[Xaringan](https://github.com/yihui/xaringan) is Yihui Xie's pet project for creating slideshows with [remark.js](http://remarkjs.com/).  You can use `devtools` in R to install the package:

```r
devtools::install_github('yihui/xaringan')
```

From there, Rstudio users can get started by going to the menu and selecting: `File -> New File -> R Markdown -> From Template -> Ninja Presentation`. You'll get a standard R Markdown document that you can compile by pressing the `Knit` button.

The "why" part is a little more interesting. Part of the answer here is that this slideshow presentation is quite popular among R Markdown users and so the justification for creating a presentation that conforms to my style hinges largely on that kind of circular explanation. You should use it because people use it.

That's not satisfying, so another answer to the question hinges on what Xaringan can do relative to my standard approach of using R Markdown to knit to Beamer. Xaringan knits to HTML and provides the user considerable flexibility in what the slideshow can present. If you have an interactive presentation, like `leaflet` maps or a Shiny app, you won't adequately present those using a Beamer PDF. Further, maybe you're the kind of presenter that likes to liven things up using GIFs. To the best of my knowledge, GIFs are non-starters in Beamer PDFs. They're unnecessary for communicating information. All the same, they might be the presenter's style. Beamer won't help but Xaringan will.

## Getting Started

Xaringan will look familiar to those proficient in Pandoc or those who use R Markdown for other outlets. Here's what the YAML will look like with a few comments to follow.

```yaml
title: "Steve's Xaringan Presentation"
subtitle: "POSC 0000 -- It Would Be Cool If This Were an Actual Class Presentation"
author: "Steven V. Miller<br /> <br /> <br /> Department of Political Science"
output:
  xaringan::moon_reader:
    css: ["default", "~/Dropbox/miscelanea/svm-r-markdown-templates/svm-xaringan-style.css"]
    lib_dir: libs
    nature:
      highlightStyle: github
      highlightLines: true
      countIncrementalSlides: false
```

`title` and `subtitle` should be intuitive. Do notice what I did with the `author` field. Xaringan, to the best of my knowledge, doesn't allow you to casually add new fields to YAML like you could with any of my other LaTeX templates. Toward that end, I'd have to fudge Xie's package and re-purpose it as something different to download. I'd rather not do that even though I would love to add an `institute` field like I have for my Beamer presentations. All the same, some manual HTML (i.e. three HTML line breaks `<br />`) have the same effect.

Pay careful attention to the `css` entry underneath `output`. You can specify a relative path to the CSS [from my Github](https://github.com/svmiller/svm-r-markdown-templates/blob/master/svm-xaringan-style.css). You can place it in the same directory or place it in the same directory as my other stuff (if you've been using it). Just make sure the relative path is correct. 

There's one additional comment I want to add about the CSS file. Open it and find these lines:

```css
.title-slide {
	background-color: #fff;
  background-image: url(/home/steve/Dropbox/teaching/clemson-academic.png);
	background-position: center bottom 170px;
	background-size: 30%;
	border-bottom: 0px solid  #522D80;
	box-shadow:  0 55px 0 #fff;
}
```

See that `background-image` line? Change it. Or even get rid of it if you don't want it. I like to have a horizontal university logo near the bottom of all my presentations so I included that. However, it's highly unlikely you and I share the same university affiliation. Change it to whatever you like though, I should add, I think horizontal/rectangular logos work better here than a square logo. 

## Is Xaringan Different From R Markdown?

Yes, a little. Xaringan has the following features that deviate a little from R Markdown you may be using for ioslides or Beamer. It wasn't obvious to me at first but I think I mostly figured out the following differences.

- Slide breaks are `---` whereas they're automatically inferred from `slide_level` in a Beamer presentation. Don't forget that.
- `--` can have the same effect of hiding content until the next click on the keyboard or your presentation clicker.
- You can be quite liberal with HTML, CSS, and different styles. You'll notice I created a `fullscale` class in addition to other classes (e.g. `center` and `bottom`, or even `inverse`) you can call into your presentation. Use them as you like them.

## So What Fun Stuff Can You Do With Xaringan?

Well, [here's my presentation using Xaringan](http://svmiller.com/miscellany/svm-xaringan-example.html#1). Long story short, you can have all sorts of fun. Click on the following frame and start clicking right to see the presentation if you don't want to follow the link in the first sentence in this paragraph.

<iframe src="http://svmiller.com/miscellany/svm-xaringan-example.html" class="gde-frame" style="height: 400px; width: 100%; border: none;" scrolling="yes"></iframe>

I'll probably fudge some CSS later but it's functional now. Let me know if you find it useful.