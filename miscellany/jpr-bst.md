---
layout: page
title: "Journal of Peace Research *.bst File"
permalink: /miscellany/journal-of-peace-research-bst-file/
---

{% include image.html url="/images/jpr-cover.png" caption="Journal of Peace Research." width=590 align="center" %}


> **Last Update: October 19, 2015**. I thank [Allan Dafoe](http://www.allandafoe.com/), [Jillienne Haglund](http://www.jill-haglund.com/), [Peter Rudloff](http://peterrudloff.net/), and [Baobao Zhang](http://politicalscience.yale.edu/people/baobao-zhang) for their contributions and correcting various errors in previous versions of this style file. Feel free to e-mail me at [svmille@clemson.edu](mailto:svmille@clemson.edu) if you find anything that is not compliant with *Journal of Peace Research* standards. As of March 5, 2014, I've been aware that the style is not fully compliant with the journal's standards when the number of authors is greater than three. I would like to find a work-around for this, but I lack the time and resources.

The *[Journal of Peace Research][1]* (JPR) routinely publishes some of the most interesting and substantively important quantitative research in international relations. Its [rising "impact ranking"][2] reflects the journal's interest to both policymakers and social scientists alike, and across the world.

I recently had the privilege of having [a manuscript of mine][3] accepted for publication at JPR. However, it proved to be somewhat difficult to tailor my LaTeX document to JPR's formatting requirements. The journal itself does not have many resources for LaTeX users to facilitate authors with formatting.

This file will address the biggest obstacle for the LaTeX user in meeting JPR's formatting requirements: the references section. JPR's reference style is APA-like, but with important divergences. The *.bst file I created should help authors quickly, and effectively, format their references to conform to JPR's style.

[jpr.bst][4]

A few notes on this *.bst file follow.

  * Everything in this *.bst file meets JPR's formatting requirements as of 2012. If something has changed in JPR's formatting style for citations and references, I would not be aware of it.
  * I am not what anyone would call a BibTeX expert. I took the `newapa.bst` file that is standard with most BibTeX installations and hacked at it until I got what I wanted. You should use it with that in mind.
  * This *.bst file will allow for the following citations: `ARTICLE`, `BOOK`, `INCOLLECTION`, and `UNPUBLISHED`. Fortunately, those are the four most common citations in political science research.
  * If you wish, you can install this in your main LaTeX directory. I choose to keep it free-standing and call it manually in the document. This is my example at the end of my *.tex file.

{% highlight latex %}
\bibliographystyle{/home/steve/Dropbox/jpr}
\bibliography{/home/steve/Dropbox/master}
{% endhighlight %}

  * I also use `natbib` to handle in-text citations. You should include this in the preamble of your *.tex document.


{% highlight latex %}
{% raw %}
\usepackage[compress]{natbib}
\setcitestyle{aysep={,},citesep={;}}
{% endraw %}
{% endhighlight %}

  * You should probably include these additional commands in the preamble of your *.tex document to address other JPR formatting issues.

{% highlight latex %}
{% raw %}
\usepackage{caption}
\usepackage{titlesec}
\captionsetup{labelsep = period}
\renewcommand{\bibname}{References}
\setcounter{secnumdepth}{0}
\titleformat*{\subsection}{\itshape}
\renewcommand{\thetable}{\Roman{table}}
{% endraw %}
{% endhighlight %}

  * [Here is an example][5] of the document this *.bst file, and these aforementioned preamble commands, will produce.
  * Don't forget you can program your \*.bib files as well. This \*.bst file will automatically de-capitalize every word in the title of an article after the first word. It knows to re-capitalize the first word of an article following a colon. This is consistent with JPR style. It does not, however, know how to do that with question marks and proper nouns. In your \*.bib file, you can get around this by forcing \*.bst files to pass through text "as is" in your `title` field. Some examples follow, but it's worth reiterating this method is portable to other *.bst files, namely the `apsr.bst` file that most of us probably use as a default. In other words, you should probably do this with your *.bib file entries anyway.


{% highlight latex %}
{% raw %}
@ARTICLE{thies2009cgnr,
author = {Thies, Cameron G},
title = {Conflict, Geography, and Natural Resources: The Political Economy
of State Predation in {A}frica and the {M}iddle {E}ast},
journal = {Polity},
year = {2009},
volume = {41},
pages = {465--488},
number = {4},
}

@ARTICLE{gleditsch2002etgd,
author = {Kristian Skrede Gleditsch},
title = {Expanded Trade and {GDP} Data},
journal = {Journal of Conflict Resolution},
year = {2002},
volume = {46},
pages = {712--724},
number = {5},
}


@ARTICLE{fjeldedesoysa2009ccc,
author = {Hanne Fjelde and Indra de Soysa},
title = {Coercion, Co-optation, or Cooperation? {S}tate Capacity and the Risk
of Civil War, 1961-2004},
journal = {Conflict Management and Peace Science},
year = {2009},
volume = {26},
pages = {5--25},
number = {1},
}
{% endraw %}
{% endhighlight %}

  * <del datetime="2013-07-05T18:46:46+00:00">The biggest limitation of this file, so far, is the handling of middle initials. BibTeX does not appear to have a concept of middle names, or middle initials. If it's not a last name, a suffix, or a preposition preceding a last name (e.g. "von" in German, "van der" in Dutch, "de la" in Spanish), BibTeX thinks it's a first name. LaTeX users, subconsciously, work around this by including a middle initial punctuated by a period in their *.bib file. We see middle names and middle initials, but BibTeX sees a second first name that is a continuation of a first name, simply separated by a space. This matters to JPR's treatment of middle initials, which JPR does not allow to be punctuated with periods. As of right now, the only effective way around this is to manually remove periods after middle initials in your *.bib file.</del>
  * I found a near perfect solution for the issue on July 5, 2013. In this new version, the *.bst file **will** automatically separate middle names from first names and abbreviate the middle initial without punctuating it with a period. If, however, you encounter an author with two first names in their professional name, you can still force it through using brackets. Here is an example:

{% highlight latex %}
{% raw %}
@ARTICLE{cheibub1998prec,
author = {{Jos\'{e} Antonio} Cheibub},
title = {Political Regimes and the Extractive Capacity of Governments: Taxation
in Democracies and Dictatorships},
journal = {World Politics},
year = {1998},
volume = {50},
pages = {349--376},
number = {3},
}
{% endraw %}
{% endhighlight %}

  * However, this will not work if you encounter an author with an abbreviated first name and full middle name (e.g. J. David Singer). That may come in a future update. In the interim, maybe we can pass that buck to JPR's copy editors.
  * This file can be freely distributed under a creative commons license. I only ask for a cheers and appropriate attribution to my website if you find it useful. Feel free to let me know if it helped you. More importantly, let me know if you can think of a way to improve it. I'm more than willing to listen to feedback. Shoot me an e-mail with any input you may have on improving the file.

 [1]: http://jpr.sagepub.com/
 [2]: https://www.facebook.com/peaceresearch/posts/484292444973034
 [3]: http://jpr.sagepub.com/content/early/2013/06/13/0022343313484954
 [4]: https://github.com/svmiller/jpr-bst-file/blob/master/jpr.bst
 [5]: https://www.dropbox.com/s/cp4tu5ob2chesig/miller2013tdpi.pdf

