---
layout: page
title: Assorted Article Summaries in Political Science/International Relations
permalink: /article-summaries/
image: "edward-james-olmos-stand-deliver.jpg"
active: miscelanea
---

I'm a big proponent of students writing an article summary for every article they read. I so strongly believe this maximizes the learning experience that I build these assignments into the syllabi for my undergraduate courses. My rationale here is largely built from my time in graduate school and stumbling into [the "IR Notes Pool" at Harvard University](http://www.olivialau.org/ir/) from around this time. I started doing this religiously for [my adviser](https://dmgibler.people.ua.edu)'s seminar on international conflict and the experience greatly helped me understand the material I was reading and situate it with other things I was reading.

I offer here an incomplete list of various article summaries I've written through the years. Several were article summaries I wrote in graduate school. A few are article summaries I've written while at Clemson University in order to guide my students about what I think these things should look like. Every article summary has the following format and I believe students should pattern their articles summaries like this.

1. **Introduction/"Abstract"**: Provide a paragraph summary of the article under consideration. This should be about 150-200 words, give or take. If done well, it should resemble the abstract of the paper itself. Use your own words, though.
2. **Literature Review/"Problem"**: What substantive "problem" is the author trying to solve? Basically: what is the research question? Identify this and craft, around that, the author's review of the literature. The article to be summarized is assuredly not the first stab at some substantive problem. Indeed, a lot of article summaries I wrote were about some big questions that had already produced thousands of pages of written material (e.g. "what causes war between states?"). Whatever the case, the student should identify what the author's research question is, what problem is the author trying to solve, and how the author treats what others have done on this exact same topic. Students should read my discussion on [how to do a literature review](http://svmiller.com/blog/2014/11/how-to-do-a-literature-review/) to understand some common framing devices that scholars use.
3. **Analysis/Results**: This section is critical for the student's understanding. Go over the research design/results section in some detail and summarize the data being used, the methodology the author uses, and how the results of the analysis square with what the author is arguing. This is often the hardest stuff for students, especially undergraduates. It means understanding [how to parse a regression table](http://svmiller.com/blog/2014/08/reading-a-regression-table-a-guide-for-students/) and [how to do statistical inference](http://svmiller.com/blog/2020/03/what-explains-british-attitudes-toward-immigration-a-pedagogical-example/). This part is hard for beginners but, trust me, the payoff is worth it.
4. **Conclusion**: Finally, offer two-three paragraphs that summarize what the author did. The student should, at the bare minimum, do two things in some detail here. First: relate the findings to other things you have read. Does the author's article challenge some other finding? Extend it? Confirm it? Make those connections here to scholarship. Second: make connections to "the real world." Basically, no article gets published---ever---if the findings are completely devoid of any connection to some real world event or pattern. Assume you're summarizing an article that says alliances are steps to war. Therein, the overlapping alliance commitments in 1914 are clearly illustrative of this. Assume you're summarizing an article that says alliances are paths to peace. Therein, the Cold War alliance structure is going to support this intuition. This should not be treated as analogous to [Texas sharpshooting](https://yourlogicalfallacyis.com/the-texas-sharpshooter); instead, make sure you can attach a generic argument to some proper nouns even if (ideally) proper nouns should not be the basis for generic arguments.
5. **Critiques (OPTIONAL [for undergraduates])**: This is optional/not required for undergraduates, but *really* good practice and effectively a must for graduate students. Offer some critiques of the article. Is the methodology inadequate for the research question? Are the results born from incomplete evidence? Do you have reason to believe the argument and findings are temporally/spatially limited? No article is ever definitive and the last word on anything. The whole game for graduate students, in particular, is to improve what others have done. Find things that can be improved. Do note that article summaries I offer here will often exclude these comments, but graduate students should still do this (especially for their seminars).


## Article Summaries

The article summaries here were updated for presentation within R Markdown, but I won't change/edit much. Thus, some of what I write here may date back as far as 2007/2008. Keep that in mind.

<ul id="archive">
{% for articlesummaries in site.data.articlesummaries %}
      <li class="archiveposturl">
        <span><a href="{{ site.url }}/svm-article-summaries/{{ articlesummaries.dirname }}/{{ articlesummaries.filename }}.pdf">{{ articlesummaries.title }}</a></span><br>
<span class = "postlower">
<strong>Author:</strong> {{ articlesummaries.author }}<br /><strong>Journal:</strong> {{ articlesummaries.journal }}<br /><strong>Year:</strong> {{ articlesummaries.year }}</span>
      </li>
{% endfor %}
</ul>

