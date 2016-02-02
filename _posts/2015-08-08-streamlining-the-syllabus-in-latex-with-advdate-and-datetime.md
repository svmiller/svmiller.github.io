---
title: Streamlining the Syllabus in LaTeX with advdate and datetime
author: steve
layout: post
permalink: /blog/2015/08/streamlining-the-syllabus-in-latex-with-advdate-and-datetime/
categories:
  - LaTeX
---

I got tired of manually getting dates right for each week of the semester in the reading list section of the syllabus, so I found a way to make LaTeX do that.

<!--more-->

'Tis the season for academics to be finalizing new syllabi for the upcoming academic year.

Generally, academics do not change syllabi for their courses much from one semester to the next. This is intuitive in political science. For example, my belief about what constitutes core scholarship in [inter-state conflict][1] does not budge much. Students in every version of the class I have taught are assigned [Maoz and Russett (1993)][2] and [Fearon (1995)][3], to name just two examples. The next time I teach an upper-division class on the topic, the new batch of students will read the same basic materials.

Experienced professors instead spend more time with monotonous features of the syllabus. Dates for midterms and exams change. Perhaps [the university must have a Thursday night football game][4] that leads to a canceled class. The academic conference schedule may adjust a class date here or there.

Put another way, I spend more time staring at the LaTeX code in my syllabus making sure the dates coincide with the reading list for the week and that those square with the academic calendar for the semester than I do anything else about the syllabus. That is time I would rather spend doing anything else.

After doing some digging, I found a way to get LaTeX to automatically generate a template for a reading list that I could easily port from one syllabus to the next, across semesters. I discuss this below and link to a template and code for the syllabus [on my GitHub][5].

This procedure requires two packages in LaTeX that should already be installed if the reader installed everything. `advdate` will help us automatically advance in days while `datetime` will help us generate peculiar date formats.

In the preamble of your LaTeX document (i.e. before `\begin{document}`), place the following code.

{% highlight latex %}
\usepackage[mmddyyyy]{datetime}
\usepackage{advdate}
\newdateformat{syldate}{\twodigit{\THEMONTH}/\twodigit{\THEDAY}}
\newsavebox{\MONDAY}\savebox{\MONDAY}{Mon}% Mon

\newcommand{\week}[1]

 \paragraph*{\kern-2ex\quad #1, \syldate{\today} - \AdvanceDate[4]\syldate{\today}:}% Set heading \quad #1
 \ifdim\wd1=\wd\MONDAY
 \AdvanceDate[7]
 \else
 \AdvanceDate[7]
 \fi%
}
{% endhighlight %}

Notice that line that begins with `\paragraph{`? I like paragraph commands in LaTeX to embolden the dates on the reading list and place the subject material of the week next to it. If you want, you can replace `\paragraph` with `\section`, though that has some implications for what happens next.

Next, venture to the part of your document where your reading list will be rendered and enter the following.

{% highlight latex %}
\SetDate[10/08/2015]
\week{Week 01} Introduction
\week{Week 02} Some Topic
...
\week{Week 15}
{% endhighlight %}

The `\SetDate `command starts **a week before the first Monday of the first week of class**. If you used `\section` in lieu of `\paragraph`, enter the date of **the first Monday of the first week of class**. I wish I knew why this was, but I think it&#8217;s because `\paragraph` is something akin to a &#8220;child&#8221; field in LaTeX while `\section` is akin to a &#8220;parent&#8221; field. Thus, the &#8220;child&#8221; field prematurely advances a week.

Enter as many weeks as you wish, as you can see in my example code.

When you're done, you&#8217;ll get a PDF that looks like this.

{% include embedpdf.html code="8ziqc5ray2denf9/syllabus-template.pdf" width=100 height=800 %}

Code is available [on my GitHub][5].

 [1]: http://svmiller.com/teaching/posc-3610-international-politics-in-crisis/
 [2]: http://www.jstor.org/stable/2938740?seq=1#page_scan_tab_contents
 [3]: http://www.jstor.org/stable/2706903
 [4]: http://www.seminoles.com/ViewArticle.dbml?DB_OEM_ID=32900&ATCLID=209569314
 [5]: https://github.com/svmiller/syllabus-template
