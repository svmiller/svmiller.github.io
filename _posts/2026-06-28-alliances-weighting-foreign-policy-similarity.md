---
title: "Some Comments on (Weighting) Alliance Measures of Foreign Policy Similarity"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2026-06-28'
excerpt: "You can use alliances as a measure of dyadic foreign policy similarity. Just be mindful of what those measures are ultimately communicating. Also be critical of what weighting this information is doing."
layout: post
categories:
  - Political Science
image: "russo-french-alliance.jpg"
active: blog
---




{% include image.html url="/images/russo-french-alliance.jpg" caption="Not all alliances look like the Franco-Russian Alliance. Most Russian alliances don't look like it either." width=350 align="right" %}

I'm preparing for a yearly update of [`{peacesciencer}`](https://svmiller.com/peacesciencer). Peace science data tend to update rather slowly, so this update is more about efficiency and reducing bloat. However, there will be one feature update to the data that I started last year around this time. [`{fpsim}`](https://svmiller.com/fpsim) is a relatively new R package of mine with some toy functions for creating measures of dyadic foreign policy similarity. This functionality is for the most part [already available in `{peacesciencer}`](http://svmiller.com/peacesciencer/reference/add_fpsim.html), but the data will be more current. Alliance coverage will be available through 2018 and UN voting coverage will be available through 2022.

With it, I wanted to riff on something to which I'm deeply indebted to [Frank Häge](https://www.frankhaege.eu/). [His 2011 article in *Political Analysis*](https://www.frankhaege.eu/publication/hage-2011-choice/hage-2011-choice.pdf) is currently the data included in `{peacesciencer}` and the article is the backbone of how I advise people to think about measures of dyadic foreign policy similarity. I wanted to add some comments to what his article communicates that mostly reiterate what I think his main takeaways are. In this case, though, they concern how to think about alliances, and weighting alliance data, for calculating measures of dyadic foreign policy similarity. What I say here is largely supported by his 2011 article, though might be a bit more opinionated or clumsily stated. Briefly: we use alliance data for measures of dyadic foreign policy similarity because we have data on them, not because they are a great source of information in and of themselves for the task at hand. I don't think they're clear measures of dyadic foreign policy similarity because states sign alliances and pledge things for any number of reasons. They are a somewhat anachronistic measure of dyadic foreign policy similarity that doesn't communicate the quantitative information we think they do. Weighting them by system capabilities just introduces one anachronism to another for more current observations. You can still do this. Just be mindful of what you are doing and for what time frame you're doing it.

Here are the R packages I'll be using in this post, even if I'll try not to litter this post with too much R code.

```r
library(tidyverse)     # for most things
library(kableExtra)    # for tables
library(fpsim)         # for measuring dyadic foreign policy similarity
library(peacesciencer) # for data on capabilities
library(stevethemes)   # for my own vanity/themes

theme_set(theme_steve())
```

Here's a table of contents.

1. [Some Caveats About Alliances as Source of Foreign Policy Similarity](#source)
2. [Some Caveats About Treating Alliance Pledges as Ordinal](#ordinal)
3. [Some Caveats About Weighting Alliance Ties by Capabilities](#weighting)
4. [Conclusion](#conclusion)

Alrightie then...

## Some Caveats About Alliances as Source of Foreign Policy Similarity {#source}

Generating measures of dyadic foreign policy similarity impels us to ask what source information should we use to generate such a measure across time and space. If we could play god, return to 1816, and create such a measure in real time to guide us for the next 200+ years, perhaps we could be more flexible in the construction of such a measure. Perhaps an elite- or mass-level survey could approximate "affinity" (if not "similarity") with some kind of average [thermometer rating](https://en.wikipedia.org/wiki/Feeling_thermometer), though the logistics of such an instrument would be so vast it would be an impossibility to create. There's perhaps a content/sentiment analysis of newspaper articles discussing various countries in various newspapers of note (e.g. *Times of London* in the UK, *New York Times* in the United States) that could work.[^noclue] However, there are a lot of assumptions about what makes it to print and who is the intended audience that would need to be addressed in such a measure, which is more about "affinity" than "similarity." If we wanted "similarity", we're stuck in the 19th century where pacific cross-border activity and inter-governmental organizations were only beginning to take off. Technology was both opportunity and limitation. Power politics was the norm and alliances were featured components of a state's foreign policy. Why not use alliances, then? Data on them would take time to marshal, but it's not impossible. In fact, we already have that data.

[^noclue]: I have no earthly idea what each of these newspapers would be in the 19th century for all sovereign states. Would it be *Moskovskiye Vedomosti* in Russia? It was the largest in early 19th century. I'm trying here.

Alliances are peculiar things in the study of international relations. The typical person might offer NATO or the Warsaw Pact if pressed to give an example of an alliance, though those would be far from typical in the world of alliances. For one, the Warsaw Pact had eight members, NATO currently has 32 members, but 86% of alliances in v. 5.1 of [the ATOP data](http://www.atopdata.org/) are bilateral. Pressed to define what alliances do, a person might again reiterate those examples to emphasize the primarily defensive nature of alliances or their so-called "balancing" effects. The [Franco-Russian Alliance](https://en.wikipedia.org/wiki/Franco-Russian_Alliance) might be the ideal type of this kind of logic initially conjured. Born from a changing European situation in which a unified Germany was upending the post-Napoleonic status quo, it was an explicit anti-German alliance in which both sides pledged defense if Germany attacked (or supported the attack) of one of the two members. However, that is again not the full scope of what alliances do. Per ATOP (v. 5.1), only about 35% of all alliances include a defense pledge. 16% of alliances include a pledge of neutrality (in the even of a potential conflict with a third-party not included as a signatory in the agreement). Just over 10% are outright offensive pacts in which signatories pledge conflict against another state or set of states.[^unification] More interestingly, 56% of all alliances pledge non-aggression and 49% pledge to consult in the event of some crisis. In other words, **states often sign what we call alliances precisely because they do not like each other very much.** States can sign alliances for any number of reasons, like [wresting or settling disputed territory from a state after a conflict](https://doi.org/10.1111/0020-8833.00106). Basically, our initial impressions of what alliances "look like" betray what they ultimately do. Earnestly [paraphrasing p. 238 here](https://doi.org/10.1080/03050620213653), alliances are written agreements that states sign to coordinate military policies on issues that could lead to armed conflict. That could even be conflict with the states signing the alliance.

[^unification]: If I remember correctly, a lot of these are concentrated around the wars of Italian and German unification. That was a whole moment in time. It was in all the newspapers.

For an illustration of the myriad reasons states may enter into an alliance, consider the conspicuous case of Russia. Russia is the no. 1 alliance-signer of all time. As of version 5.1 of the data, Russia has been a member of 157 alliances all time sine 1815. That's almost as much as no. 2 (France, 91) and no. 3 (United Kingdom, 69) *combined*. However, a scan of the data highlights the important heterogeneity of alliances and complicates what we think is a nice and clear signal we hope to extract from them. Consider the following table, which lists all 12 alliances that were active for Russia in the second half of the 19th century (1850-1899).

<table id="stevetable">
<caption>Russian Alliances Active from 1850-1899</caption>
 <thead>
  <tr>
   <th style="text-align:center;font-weight: bold;"> ATOP ID </th>
   <th style="text-align:center;font-weight: bold;"> Start Date </th>
   <th style="text-align:center;font-weight: bold;"> End Date </th>
   <th style="text-align:center;font-weight: bold;"> Defense? </th>
   <th style="text-align:center;font-weight: bold;"> Offense? </th>
   <th style="text-align:center;font-weight: bold;"> Neutrality? </th>
   <th style="text-align:center;font-weight: bold;"> Non-Aggression? </th>
   <th style="text-align:left;font-weight: bold;"> Consultation? </th>
   <th style="text-align:center;font-weight: bold;"> Active Military Support? </th>
   <th style="text-align:center;font-weight: bold;"> States </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1080 </td>
   <td style="text-align:center;"> Sep. 18, 1833 </td>
   <td style="text-align:center;"> Jul. 2, 1853 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> Austria-Hungary </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1085 </td>
   <td style="text-align:center;"> Sep. 19, 1833 </td>
   <td style="text-align:center;"> Jun. 3, 1854 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Austria-Hungary </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1215 </td>
   <td style="text-align:center;"> Mar. 3, 1859 </td>
   <td style="text-align:center;"> Nov. 10, 1859 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> France </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1230 </td>
   <td style="text-align:center;"> Feb. 8, 1863 </td>
   <td style="text-align:center;"> Feb. 28, 1863 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Prussia/Germany </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1310 </td>
   <td style="text-align:center;"> May. 6, 1873 </td>
   <td style="text-align:center;"> Jul. 13, 1878 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Prussia/Germany </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1315 </td>
   <td style="text-align:center;"> Jun. 3, 1873 </td>
   <td style="text-align:center;"> Jul. 13, 1878 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> Austria-Hungary, Prussia/Germany </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1325 </td>
   <td style="text-align:center;"> Jan. 15, 1877 </td>
   <td style="text-align:center;"> Mar. 3, 1878 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> Austria-Hungary </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1340 </td>
   <td style="text-align:center;"> Jun. 18, 1881 </td>
   <td style="text-align:center;"> Jun. 18, 1887 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> Austria-Hungary, Prussia/Germany </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1370 </td>
   <td style="text-align:center;"> Jun. 18, 1887 </td>
   <td style="text-align:center;"> Jun. 18, 1890 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> Prussia/Germany </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1380 </td>
   <td style="text-align:center;"> Aug. 27, 1891 </td>
   <td style="text-align:center;"> Nov. 8, 1917 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> France </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1385 </td>
   <td style="text-align:center;"> Dec. 27, 1893 </td>
   <td style="text-align:center;"> Nov. 8, 1917 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> France </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1395 </td>
   <td style="text-align:center;"> Jun. 3, 1896 </td>
   <td style="text-align:center;"> Jun. 17, 1900 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> China </td>
  </tr>
</tbody>
</table>



A few interesting patterns emerge here. For one, these alliances were overwhelmingly focused on Russia's immediate neighbors following the third and final partition of Poland. Of these 12, five included Austria-Hungary and an additional three were conducted with just Germany (or its predecessor state, Prussia). Russian relations with both states weren't always hostile at this point, but were complicated to say the least. [The 1833 Treaty of Münchengrätz](https://www.jstor.org/stable/23032802) was an important signal of joint Austrian-Russian cooperation on the issue of the Ottoman Empire and its ongoing decline. That would be the simple story of that alliance, and one that maps nicely to the information we think alliances communicate to those of us interested in dyadic foreign policy similarity. The Franco-Russian alliance (ATOP ID: 1385) would communicate the same thing. However, this treaty importantly had to at least partly repair relations between the two that soured as a result of the Greek war of independence and reiterate the major coordination problem (also involving Prussia/Germany) that came from conspiring Poland out of existence. The dates don't exactly line up as I remember reading about it, but ATOP ID no. 1315 looks like [The League of Three Emperors](https://en.wikipedia.org/wiki/League_of_the_Three_Emperors). This three-party pact signals cooperation on the issue of the former/current Poland, but it also belies the somewhat massive misgivings all three states had with each other near this point. [Austria-Hungary and Prussia/Germany had just fought a war in 1866](https://en.wikipedia.org/wiki/Austro-Prussian_War) and its leadership was more than worried about the implications of an aggressive German ethnonationalism for its multinational empire of which ethnic Germans were just one part. It was an alliance with only the pretense of foreign policy similarity. The fallout of this league's final rupture was [renewed combat for Russia against the Ottoman Empire](https://en.wikipedia.org/wiki/Russo-Turkish_War_(1877%E2%80%931878)), which enraged the Austrians enough to make [common cause with Germany](https://en.wikipedia.org/wiki/Dual_Alliance_(1879)) immediately thereafter (no matter [the renewal of the league in 1881](https://wwi.lib.byu.edu/index.php/The_Three_Emperors%27_League)). That Austrian-German dual alliance from 1879 expanded to the so-called [Triple Alliance in 1882](https://en.wikipedia.org/wiki/Triple_Alliance_(1882)) when Italy joined for a multilateral defense pact. Yes, *that* Italy, famously good friends with Austria-Hungary at this moment in time. In these cases, and the fall-out cases, Russian alliances communicate dyadic foreign policy similarity as much as they're signaling diplomatic misgivings and dyadic foreign policy dissimilarity.

Contrast Russian alliance behavior in the second half of the 19th century with all Russian alliances that were active as of through 2000. Note that just two of these 61 cases are no longer active. ATOP ID no. 4300 was a Russian-Turkmenistani alliance that ended on April 23, 2002, ostensibly replaced by ATOP ID no. 5000. ATOP ID no. 4385 ended on July 16, 2001 and was seemingly replaced by ATOP ID no. 4980. I've condensed a few of the more massive multilateral ones for sake of legibility.

<table id="stevetable">
<caption>Russian Alliances Active as of or Through 2000</caption>
 <thead>
  <tr>
   <th style="text-align:center;font-weight: bold;"> ATOP ID </th>
   <th style="text-align:center;font-weight: bold;"> Start Date </th>
   <th style="text-align:center;font-weight: bold;"> Defense? </th>
   <th style="text-align:center;font-weight: bold;"> Neutrality? </th>
   <th style="text-align:center;font-weight: bold;"> Non-Aggression? </th>
   <th style="text-align:center;font-weight: bold;"> Consultation? </th>
   <th style="text-align:center;font-weight: bold;"> Active Military Support? </th>
   <th style="text-align:left;font-weight: bold;"> States </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 3740 </td>
   <td style="text-align:center;"> Aug. 1, 1975 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> <a href="https://en.wikipedia.org/wiki/Helsinki_Accords">Helsinki Accords</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3755 </td>
   <td style="text-align:center;"> Feb. 24, 1976 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> <a href="https://en.wikipedia.org/wiki/Treaty_of_Amity_and_Cooperation_in_Southeast_Asia">Treaty of Amity and Cooperation in Southeast Asia</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3765 </td>
   <td style="text-align:center;"> Oct. 8, 1976 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Angola </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3775 </td>
   <td style="text-align:center;"> Mar. 31, 1977 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Mozambique </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3835 </td>
   <td style="text-align:center;"> Nov. 20, 1978 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Ethiopia </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3880 </td>
   <td style="text-align:center;"> Oct. 8, 1980 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Syria </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3890 </td>
   <td style="text-align:center;"> May. 13, 1981 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Congo - Brazzaville </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4010 </td>
   <td style="text-align:center;"> Nov. 9, 1990 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Germany </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4055 </td>
   <td style="text-align:center;"> Jul. 29, 1991 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Lithuania </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4115 </td>
   <td style="text-align:center;"> Dec. 6, 1991 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Hungary </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4145 </td>
   <td style="text-align:center;"> Jan. 20, 1992 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Finland </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4170 </td>
   <td style="text-align:center;"> Feb. 7, 1992 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> France </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4220 </td>
   <td style="text-align:center;"> May. 15, 1992 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> <a href="https://en.wikipedia.org/wiki/Collective_Security_Treaty_Organization">Collective Security Treaty</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4230 </td>
   <td style="text-align:center;"> May. 22, 1992 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Poland </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4235 </td>
   <td style="text-align:center;"> May. 25, 1992 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> Kazakhstan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4240 </td>
   <td style="text-align:center;"> May. 25, 1992 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Turkey </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4245 </td>
   <td style="text-align:center;"> May. 30, 1992 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> Uzbekistan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4255 </td>
   <td style="text-align:center;"> Jun. 10, 1992 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> Kyrgyzstan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4265 </td>
   <td style="text-align:center;"> Jun. 17, 1992 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> United States </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4270 </td>
   <td style="text-align:center;"> Jun. 19, 1992 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Canada </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4300 </td>
   <td style="text-align:center;"> Jul. 31, 1992 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> Turkmenistan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4305 </td>
   <td style="text-align:center;"> Aug. 4, 1992 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Bulgaria </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4365 </td>
   <td style="text-align:center;"> Nov. 19, 1992 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> South Korea </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4385 </td>
   <td style="text-align:center;"> Dec. 18, 1992 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> China </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4395 </td>
   <td style="text-align:center;"> Jan. 20, 1993 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Mongolia </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4400 </td>
   <td style="text-align:center;"> Jan. 22, 1993 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> <a href="https://en.wikipedia.org/wiki/CIS_Charter">Charter of the Commonwealth of Independent States</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4415 </td>
   <td style="text-align:center;"> Jan. 28, 1993 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> India </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4470 </td>
   <td style="text-align:center;"> May. 25, 1993 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> Tajikistan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4485 </td>
   <td style="text-align:center;"> Jun. 30, 1993 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Greece </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4500 </td>
   <td style="text-align:center;"> Aug. 26, 1993 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Czechia </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4505 </td>
   <td style="text-align:center;"> Aug. 26, 1993 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Slovakia </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4560 </td>
   <td style="text-align:center;"> Mar. 2, 1994 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Uzbekistan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4568 </td>
   <td style="text-align:center;"> Apr. 8, 1994 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Colombia </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4570 </td>
   <td style="text-align:center;"> Apr. 12, 1994 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Spain </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4605 </td>
   <td style="text-align:center;"> Jun. 16, 1994 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Vietnam </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4635 </td>
   <td style="text-align:center;"> Oct. 14, 1994 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Italy </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4675 </td>
   <td style="text-align:center;"> Feb. 21, 1995 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Belarus </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4810 </td>
   <td style="text-align:center;"> Apr. 26, 1996 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> <a href="https://en.wikipedia.org/wiki/Shanghai_Cooperation_Organisation">Treaty on Deepening Military Trust in Border Regions</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4865 </td>
   <td style="text-align:center;"> Apr. 2, 1997 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> Belarus </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4875 </td>
   <td style="text-align:center;"> May. 31, 1997 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Ukraine </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4885 </td>
   <td style="text-align:center;"> Jul. 3, 1997 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Azerbaijan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4890 </td>
   <td style="text-align:center;"> Aug. 29, 1997 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> Armenia </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4896 </td>
   <td style="text-align:center;"> Nov. 27, 1997 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Panama </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4897 </td>
   <td style="text-align:center;"> Sep. 25, 1997 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Ecuador </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4940 </td>
   <td style="text-align:center;"> Feb. 9, 2000 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> North Korea </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4957 </td>
   <td style="text-align:center;"> Sep. 13, 2000 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Guatemala </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4958 </td>
   <td style="text-align:center;"> Sep. 14, 2000 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Paraguay </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4968 </td>
   <td style="text-align:center;"> Mar. 12, 2001 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Iran </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4980 </td>
   <td style="text-align:center;"> Jul. 16, 2001 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> China </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4990 </td>
   <td style="text-align:center;"> Nov. 19, 2001 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Moldova </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5000 </td>
   <td style="text-align:center;"> Apr. 23, 2002 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Turkmenistan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5035 </td>
   <td style="text-align:center;"> Jul. 4, 2003 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Romania </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5045 </td>
   <td style="text-align:center;"> Jun. 16, 2004 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Uzbekistan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5075 </td>
   <td style="text-align:center;"> Nov. 14, 2005 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> Uzbekistan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6020 </td>
   <td style="text-align:center;"> Aug. 16, 2007 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> China, Kazakhstan, Kyrgyzstan, Tajikistan, Uzbekistan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6070 </td>
   <td style="text-align:center;"> Nov. 11, 2013 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Kazakhstan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7005 </td>
   <td style="text-align:center;"> Jun. 15, 2016 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Guyana </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7015 </td>
   <td style="text-align:center;"> Feb. 28, 2017 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Honduras </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7030 </td>
   <td style="text-align:center;"> Oct. 2, 2017 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Turkmenistan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7045 </td>
   <td style="text-align:center;"> Sep. 25, 2018 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Belize </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7050 </td>
   <td style="text-align:center;"> Sep. 28, 2018 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Dominica </td>
  </tr>
</tbody>
</table>



I will defer to the Russia or alliance expert in how they read this information, if they would like to interject, but here would be my reading of this information as an IR scholar and someone thinking about what this information means for measures of dyadic foreign policy similarity. The historical Russia may have used alliances to deal with complicated questions involving rivals and would-be enemies, or to signal some kind of focused foreign policy hive mind in the case of the Franco-Russian alliance. The modern Russia seems to increasingly use alliances as a means of bilateral relations management. The information one might extract from the 1997 alliance with Belarus seems pretty straightforward, but should we understand the spate of non-aggression pledges Russia and China offer to each other as equivalent to ones made to Italy in 1994? Should [the Treaty on Basic Relations between the Russian Federation and Belize](https://www.google.com/search?q=Treaty+on+Basic+Relations+between+the+Russian+Federation+and+Belize+2018)[^info] be understood as an equivalent non-aggression pledge to the one Russia apparently made to Uzbekistan in 2004? Or Moldova in 2001? Simply, I do not think a non-aggression pledge from Russia today mean the same thing it did from Russia 150 years ago. Alliances may be more prevalent today than they were 150 years ago, but the information we may hope to extract from them changes considerably. There is a similar comment to be made about the absence of a formal defense pledge between Russia and China in these data, as there is between Russia and Armenia from Aug. 29, 1997 through 2018. A similar theme would emerge concerning the absence of an alliance of any form between Israel and the United States as of 1991, even though the increased similarity between both is quite evident over the past 30 years.

To return to the motivating question of why we should use alliances as information about dyadic foreign policy similarity, the answer seems to collapse to a basic and dissatisfying answer of "because we have data on them." The simple story we like to tell about alliances betrays the myriad and heterogeneous reasons why states sign them. The standard prism by which we think of what alliances set out to accomplish [have never been faithful to what they actually do](https://svmiller.com/blog/2025/04/stephen-a-smith-ir-scholarship/#fn:walt1985), and I can raise [an identical complaint about the simplistic stories about arms races](https://svmiller.com/blog/2025/08/simple-tests-for-arms-races-war/#parabellum). Alliances have never really said what we want them to say about dyadic foreign policy similarity, and I do not think they say the same thing across time and space. Alliances are more common today, but their salience may arguably be less than what it was before the world wars. If we ignore how noisy of a measure they were, I still think they are a somewhat anachronistic measure of dyadic foreign policy similarity. If you need to do something with observations before 1946, that information is available and I won't impugn its use. Just be mindful of what you think you're doing with it.

[^info]: If you wanted to spelunk the Russian Ministry of Foreign Affairs, you may find the exact text of this treaty. I'm reluctant to link to it, though.

## Some Caveats About Treating Alliance Pledges as Ordinal {#ordinal}

My misgivings about treating alliance pledges as communicating some kind of ordinal information are *much* spicier than my misgivings about using them as source information for measures of dyadic foreign policy similarity. I brought this up previously in [a 2021 blog post related to this topic](https://svmiller.com/blog/2021/11/calculate-tau-b-alliances-in-r/).

> What follows is a gigantic caveat since I’ve always hated this train of thought when I was first reading about it in graduate school, even if it never occurred to me how to operationalize Tau-b with the data. Calculating Tau-b like this builds in an assumption that you can construct an ordinal measure of an alliance commitment. The basic train of thought is defense > (neutrality AND/OR non-aggression) > entente > no alliance at all. In their article, Signorino and Ritter (1999) go to great lengths to acknowledge why this is problematic but you should do it anyway. Häge offers the more reasonable take that you should not at all do this and instead use one of his binary measures since you should not think of alliance pledges as ordinal in any way in this typology. `{peacesciencer}` basically follows Häge’s recommendation and encourages [sensible defaults](http://svmiller.com/peacesciencer/reference/add_fpsim.html#arguments), even if less sensible defaults are available in the data Häge calculated.

I would welcome the reader to dig into the data and read about the conceptualization and operationalization of alliance pledges to better understand this point. I am not terribly inclined to challenge an argument that a mutual defense pledge is "more" than a pledge of non-aggression or consultation, but is that pledge conditional on a particular third-party? Does it come with a pledge of active military support? That would be useful information to consider in evaluating such a pledge. I would, however, challenge a claim that a neutrality pledge is equivalent to a non-aggression pledge. They are categorically different commitments allies make to each other. The first identifies a third party from which one of the signatories pledges neutrality in the event of a conflict involving the signatory and the third party. The other routinely captures contentious questions involving the allies *themselves* or, potentially, generic pledges of a bilateral relationship with nothing else interesting happening (in the case of the Russia-Belize non-aggression pledge from 2018). I'm also not sold on an argument that a neutrality or non-aggression pledge is "more" than a pledge of consultation (or "entente" in the CoW data). It might vary from case to case, but a more aggressive critic could just as well read that a pledge of consultation in the event of a crisis may suggest a stronger commitment to diplomacy than forgoing the use of force as an option. It's at least promising diplomacy first. A critical reader well-versed in the alliance literature is free to balk at that interpretation, and I'm not offering it myself, but the counterclaim under contention here is that non-aggression is "more" than consultation. They could just as well be equivalent. Further, the illustrative case of Russia above suggests that the presence of an alliance, even (especially?) non-aggression pledges, often signal more foreign policy dissimilarity than the absence of an alliance.

You really should not interpret pledges as communicating ordinal information or that the alliance data permit the construction of an ordered-categorical scale based on pledges included in an alliance. A simple binary indicator communicating whether there is some kind of agreement will have to do, given the circumstances.

## Some Caveats About Weighting Alliance Ties by Capabilities {#weighting}

One particular measure of dyadic foreign policy similarity---[Signorino and Ritter's (1999)](https://doi.org/10.1111/0020-8833.00113) *S*---offered a means capture how important some alliance ties were. Whereas their measure is a measure of "distance" while Kendall's Tau-b is more of a measure of the net probability of concordance for an ordered set of observations, their formula permits elevating some ties as more important than others. Using the (questionably) valued alliance data, you could potentially weight these alliances by the target states' capabilities. The obvious choice here would be the Composite Index of National Capabilities (CINC) measure from the Correlates of War project. 

Take Table 6 of Signorino and Ritter (1999), for example. This table is included in [`{fpsim}`](https://svmiller.com/fpsim/) as `gmyrus14`. In the following data frame, `gmy` communicates the alliance portfolio for Germany in 1914 for all European states at this time and `rus` communicates the alliance portfolio for Russia for all European states at this time. The `syscap` communicates the CINC score Signorino and Ritter report for the state in the `state` column, proportional to all of Europe. Further, each state is maximally committed to defending itself.


``` r
gmyrus14
#> # A tibble: 20 × 4
#>    state syscap   gmy   rus
#>    <chr>  <dbl> <dbl> <dbl>
#>  1 GMY     0.25     3     0
#>  2 RUS     0.21     0     3
#>  3 UKG     0.2      0     1
#>  4 FRN     0.08     0     3
#>  5 AUH     0.08     3     0
#>  6 ITA     0.05     3     1
#>  7 BEL     0.03     0     0
#>  8 SPN     0.03     0     0
#>  9 TUR     0.02     0     0
#> 10 NTH     0.01     0     0
#> 11 SWD     0.01     0     0
#> 12 RUM     0.01     3     0
#> 13 POR     0.01     0     0
#> 14 SWZ     0.01     0     0
#> 15 GRC     0        0     0
#> 16 DEN     0        0     0
#> 17 YUG     0        0     0
#> 18 BUL     0        0     0
#> 19 NOR     0        0     0
#> 20 ALB     0        0     0
```

We can reproduce the second part of their Table 6 below with functions in `{fpsim}` and arrive at the basic takeaway they report. Kendall's Tau-b suggests almost no association and their unweighted *S* score suggests a moderate level of similarity. However, much of that is arguably a function of their agreement for some of the most inconsequential system members (for whom neither had an alliance). Weighted by the target state's CINC score (to elevate the "important" system members in Europe), a moderate degree of dissimilarity emerges. There would be more face validity in such a measure, given the world war that followed between the two.


``` r
# Tau-b...
taub(gmyrus14$gmy, gmyrus14$rus)
#> [1] 0.03031695
# Unweighted *S* measure, absolute distances (actually the default in srs())
srs(gmyrus14$gmy, gmyrus14$rus, distances = 'absolute')
#> [1] 0.4
# Weighted *S* measure, absolute distances, by CINC
srs(gmyrus14$gmy, gmyrus14$rus, distances = 'absolute', weights = gmyrus14$syscap)
#> [1] -0.46
```

On paper, this is reasonable. However, its application is rather questionable upon further review. For one, consider what comprises a CINC score. A CINC score is (unarguably?) our most common quantitative measure of power in the international system. Formally, you'd construct it as follows.


$$
CINC_{it} = \frac{tpr_{it} + upr_{it} + ispr_{it} + ecr_{it} + mer_{it} + mpr_{it}}{6}
$$

..where:

- $$tpr_{it}$$ = total population ratio of country *i* in year *t*
- $$upr_{it}$$ = total urban population ratio of country *i* in year *t*
- $$ispr_{it}$$ = iron and steel production ratio of country *i* in year *t*
- $$ecr_{it}$$ = primary energy consumption ratio of country *i* in year *t*
- $$mer_{it}$$ = military expenditure ratio of country *i* in year *t*
- $$mpr_{it}$$ = military personnel ratio of country *i* in year *t*

If, say, a hypothetical country has 100% of the world's population, 100% of the world's urban population, produces 100% of the world's iron and steel, consumes 100% of the world's energy, and is 100% of the world's expenditure and personnel, their CINC score would be 1. In these data, the absolute most powerful a state has ever been was the United States in 1945. Its CINC score of .384 suggests that the United States at the tail end of World War 2 was about 38.4% of the entire international system's latent and actual capacity for war. Tuvalu in 2012 has the minimum CINC score of about 0.000000244. Both would make sense, prima facie.

I like this measure a fair bit for what I think it ultimately is. This is a 19th century measure of "power" and to what extent a state in the 19th century could marshal enough resources to the battlefield given the then-timely questions of what industrialization and urbanization were doing for a country's growth. ["Post-industrialization"](https://en.wikipedia.org/wiki/Post-industrial_society), I'm not sure this measure conveys the same kind of information it did in the 19th century. Consider the following plot, which identifies the top 10 states by CINC scores for 1816 (start of the data), 1850, 1900, 1950, 2000, and 2016 (end of the data).

![plot of chunk cinc-scores-1816-2016](/images/alliances-weighting-foreign-policy-similarity/cinc-scores-1816-2016-1.png)

I welcome alternative interpretations here, but I'm gathering more face validity in a much smaller, much more European system in the 19th century driven by questions of industrialization and accelerated urbanization. I see less face validity over time, especially as the measure seems to elevate the countries with the much larger populations. There is a reasonable question to ask the "Rise of China" and whether we believe that has since happened, quantitatively. I'm not sure we should have reason to believe it happened by 2000. I also don't believe we have reason to think that Brazil is more powerful than the United Kingdom, even though we will have to concede that Brazil has around three times the population of the United Kingdom. Since CINC is unweighted, those two population measures are a third of the measure that follows. I already think alliances are an anachronistic measure for a measure of dyadic foreign policy similarity in the present. Weighting the measure by a CINC score introduces another anachronism to it, like a hat on a hat.

There are other peculiarities too. The data on capabilities has always been historically skewed to the right. Very few states have proportionally that much weight. As the state system has expanded in size (i.e. as empires ended), the relative weight at the top necessarily decreases. For example, the top 3 states in capabilities in 1816 (the United Kingdom, Russia, and France) combined for 61.8% of capabilities in a system of just 23 states. In 2016, the top three states (China, the United States, and India) combined for 45% of capabilities in a system of 195 states. Even then, the concentration at the top is rather impressive, and worrisome for a measure like this. Except for a stretch from 1990 to 2008, more than 50% of the system's capabilities are concentrated in the top five in any given year.[^sixseven] Under those circumstances, the dyadic foreign policy similarity of Israel and Jordan in 1950 is much more about how they agree on India than it is about how they agree on Egypt.

[^sixseven]: The top six would push the cumulative measure of power at the top over 50% for 1990, 1991, and 2000-2008. The top seven would capture the remaining years in the 1990s.

The right skew implies, and the data certainly illustrate, that most states---especially new states, themselves typically small states---possess almost no capabilities relative to the international system. In 1816, 11 of 23 sovereign states had less than 1% of capabilities proportional to the international system. That's about 48% of the system in that year. In 2016, 176 of 195 states had less than 1% of capabilities. That's over 90% of the system. I'm not sure I'm comfortable with discarding that much information to identify the more "important" cases.

If you read Signorino and Ritter (1999), you'll be sympathetic to what weighting is trying to do. It's trying to identify the "important" foreign policy ties and downweight irrelevant foreign policy ties/concordance/agreement. However, I echo Häge (2011) that weighting measures of dyadic foreign policy similarity is a second-best solution. It's second-best to other metrics that better model chance-corrected agreement that he offers, like Cohen's (1960, 1968) kappa or Scott's (1955) pi. Weighting by capabilities just discards too much information and gives too much weight to great powers and/or states that are conspicuously high on capabilities (e.g. India). It relies on what I feel is an anachronistic measure of power to weight what I think is also an anachronistic source of information for measuring dyadic foreign policy similarity.

## Conclusion {#conclusion}

Here are the basic takeaways for people interested in measuring dyadic foreign policy similarity across time and space. For one, alliances are not a great source of information for dyadic foreign policy similarity. They are an *available* source of information for dyadic foreign policy similarity, but not a great source of information. I think this importantly follows because our standard prism for thinking about what alliances do and why states sign them have never squared with the reality of what alliances actually are and what they do. States often sign alliances because they are *dissimilar* in their foreign policy. Further, resist any and all urges to believe alliances communicate quantitative information, or even ordinal information. The most you can do, given the circumstances, is identify whether states agree that some target is important enough to merit an agreement of some form. That's about it. Further, alliances are already an anachronistic source of information for dyadic foreign policy, and a questionable at that. Weighting by capabilities introduces yet another anachronism that does not scale well to the present. It's arguably better than not weighting at all, but it is not better than measures like Cohen's (1960, 1968) kappa or Scott's (1955) pi for a chance-corrected measure of agreement. Use one of those, and, of those, use Cohen's kappa. Scott's (1955) pi builds in a strong assumption that the baseline propensity of forming a tie in a dyad is the same for both members. Either one is better than *S* or Tau-b.
