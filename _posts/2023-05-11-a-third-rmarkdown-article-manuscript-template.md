---
title: "A Third Academic R Markdown Article/Manuscript Template"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2023-05-11'
excerpt: "I have a series of templates for R Markdown. This post talks about a third academic article/manuscript template I made."
layout: post
categories:
  - R Markdown
image: "stevetemplates-third-article-template.png"
active: blog
---



{% include image.html url="/images/stevetemplates-third-article-template.png" caption="I did another thing. Here's what that thing looks like." width=400 align="right" %}

I wrote another R Markdown article template for your consideration. I'm going to try to be brief here, padding only to make sure that there's enough text to wrap around the image you see to your right (which gives a rudimentary preview as to what the template looks like). 

I wrote this third R Markdown template for a few reasons. One, I felt like it, which is as good of a reason to do anything. Two, I've encountered a headache in my travels that some journals insist on author *addresses* and not just author affiliations in the title page/abstract section of a paper. This is something of a problem for my preferred workflow because I think of this as somewhat irrelevant information for which there is no good place to put it in my templates. Indeed, [my second article template](http://svmiller.com/blog/2020/09/another-rmarkdown-article-template/) has no real place for this. Third, research in my current department can sometimes be "multi-multi-author" (sic). In other words, there might be like 10 or 20 names on a paper. In my first and second article template, those authors and author affiliations expand vertically and not horizontally. The end result is a lot of potentially wasted white space on a paper. For these types of papers, I'd prefer to expand that information horizontally rather than vertically. Displaying that kind of information in that kind of format could never be done in an aesthetically neat way (i.e. it's just a lot of information to cram into the first page of a paper), but it could be better.

The end result is a new template [derived from Elsevier's design](https://pkgs.rstudio.com/rticles/articles/examples.html#elsevier---elsevier-journal-article), informally getting most of its functionality though inheriting none of its limitations (i.e. I've always found Elsevier's LaTeX "class" to be somewhat restraining). It also borrows from [Samuel Drapeau's `artclcomp` LaTeX class](https://www.mathematik.hu-berlin.de/~drapeau/index.php?id=ressources), itself a fork of Elsevier's LaTeX class that better uses the real estate around the abstract to communicate pertinent information about the authors and the paper. This new template---[`article3`](http://svmiller.com/stevetemplates/reference/article3.html) in [`{stevetemplates}`](http://svmiller.com/stevetemplates/)---is slated for release with an upcoming version 1.0 of that package.

## The YAML

Here's what the YAML would look like. You should be familiar with these by now. My [past](http://svmiller.com/blog/2016/02/svm-r-markdown-manuscript/) [two](http://svmiller.com/blog/2020/09/another-rmarkdown-article-template/) posts on my other R Markdown templates offer places to get started. Do keep in mind that `article3` takes all of the functionality of my second article template and just adds a few things that are ultimately aesthetic.

```yaml
---
output: 
  stevetemplates::article3:
    citation_package: natbib
    dev: cairo_pdf
title: "Yet Another Pandoc Markdown Article Starter and Template"
thanks: "Replication files are available on the author's Github account (http://github.com/svmiller/stevetemplates). **Current version**: May 11, 2023; **Corresponding author**: steven.v.miller@gmail.com. A user who is familiar with my templates may observe some redundancy with the title footnote and information you can include in the author or paper info fields. That point is well-taken. Do with this what you want."
abstract: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eget consectetur diam. Pellentesque id eros auctor, eleifend sem a, sagittis nisi. Nam vel nisi eget metus consectetur hendrerit nec ut justo. Ut metus eros, ullamcorper in condimentum non, eleifend lacinia mi. Cras sodales, arcu eu fringilla efficitur, lorem purus maximus mauris, id volutpat dui lectus non velit. Aliquam scelerisque nulla rutrum facilisis laoreet. Cras tristique et lorem ac feugiat. Duis eu purus eu ante tristique suscipit. Etiam aliquet egestas tortor et scelerisque. Nullam vulputate quam sed diam dictum, vitae pellentesque nisl fermentum. Curabitur ac rutrum lacus. Proin pellentesque, elit et malesuada porttitor, neque velit pretium dui, sit amet fermentum turpis turpis sed felis. Curabitur urna neque, bibendum non fringilla et, accumsan at orci. In blandit mauris urna, ac accumsan urna vehicula a. Phasellus iaculis nisi id nibh euismod malesuada venenatis in elit. Aenean diam mi, dapibus nec egestas sit amet."
keywords: "pandoc, r markdown, knitr, god help me why am I doing this"
author:
- name: Forename diMcPatronymixsonovez
  email: steven.miller@ekohist.su.se
  affil-code: a
  order: 1
- name: Previous Employer
  email: previous@clemson.edu
  affil-code: b
  order: 2
- name: Visiting Lecturer
  email: visitor@illinois.edu
  affil-code: c
  order: 3
- name: A Graduate Student
  email: gstudent@ua.edu
  affil-code: d
  order: 4
- name: Same Employer
  email: same.employer@ekohist.su.se
  affil-code: a
  order: 5
- name: An Undergraduate Student
  email: undergrad.1234@osu.edu
  affil-code: e
  order: 6
affils:
- address: Institutionen för ekonomisk historia och internationella relationer Universitetsvägen 10A, 114 18 Stockholm, Sweden
  code: a
- address: 232 Brackett Hall, Clemson University, Clemson, SC 29634, USA
  code: b
- address: 1407 W Gregory Dr, Urbana, IL 61801, USA
  code: c
- address: Department of Political Science, Box 870213, Tuscaloosa, AL 35487, USA
  code: d
- address: 411 Woody Hayes Dr, Columbus, OH 43210, USA
  code: e
geometry: margin=2.5cm
mainfont: cochineal
fontsize: 11pt
endnote: no
pandocparas: TRUE
remove-emails: FALSE
remove-paper-info: FALSE
paper-info:
  - "*Last updated*: 11 May 2023"
  - "*Word Count*: 10,000 (pinky swear)"
  - "*Github*: [svmiller/stevetemplates](http://github.com/svmiller/stevetemplates)"
---
```

There are a few important features here that are worth clarifying, The `author:` field works much in the same way as the `author:` fields work in my other templates, though maximizing use of the template is asking for just four pieces of information about the author: name, email, an (assumed) alphabetic code indicating an address/affiliation (`affil-code`), and a numeric code to ultimately match with an email (`order`). Admittedly, the numeric code (`order`) is somewhat redundant information that I wish I could automatically generate natively within Pandoc, but Pandoc is somewhat limited on that front and I didn't want to think about a Lua filter for this task.

There is a new field (`affils:`, short for "affiliations") in which you can sync the `affil-code` from the `author:` field to some address for which that code corresponds. This is separate from the `author:` field because LaTeX is somewhat limited in what data set work it can actually do. I was very close to a [`datatool`](https://texdoc.org/serve/datatool/0) solution that makes use of basic Pandoc for loops and [`filecontents`](https://ctan.org/pkg/filecontents?lang=en), though for the life of me could not figure out how to filter that information into anything other than a comma separated list. To be fair, it really is asking too much of LaTeX to do serious data work, so it's any wonder that `datatool` exists at all. No matter, a future update might figure that out. Until then, you'll want to manually sync `code` in the `affils:` field with the `affil-code` in the `author:` field.

The last three entries in the YAML are ultimately optional. The default settings of the template assume you want to display the author emails in the abstract area of the paper. You can disable that with `remove-emails: TRUE`, which will also remove the numeric identifiers as superscripts from the list of authors at the top.[^addresses] You can also remove the "paper info" section with `remove-paper-info: TRUE`. In that section of the abstract, though, you have wide flexibility to say anything you want about the paper. You can say when it was last updated, how many words are in it, what external funding has supported the paper, who the corresponding author is, where replication materials are, and so on. The world is your oyster here, and your use of the section means, perhaps, that you don't need the `thanks:` field to be populated at all in the YAML.

[^addresses]: Note that author addresses are functionally mandatory. If you don't need them in your paper, then you ultimately don't need this template.

Future updates of this template may move some things around. I'd *love* to consolidate the `affils:` section with the `author:` field because I generally don't like YAML bloat in my papers, but that requires me figuring out how to make LaTeX do some rudimentary data management (you know: that thing LaTeX is not built to do). If there are issues, feel free to raise them here or (better yet) as [an issue on the project's Github](https://github.com/svmiller/stevetemplates/issues).
