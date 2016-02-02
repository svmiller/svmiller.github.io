---
title: Syncing Word Values Survey Country Codes with CoW Codes
author: steve
layout: post
permalink: /blog/2015/06/syncing-word-values-survey-country-codes-with-cow-codes/
categories:
  - R
excerpt: "World Values Survey country codes don't sync well with other country classification systems. Here, I use the countrycode package in R and some recoding to sync them."
---



I work with World Values Survey (WVS) data a lot and recently downloaded the [six-wave longitudinal data from WVS][1] (v. 2015-04-18) for a project. Anyone who has worked with WVS before knows WVS country classification is a bit opaque. It is mostly derived from [UN M.49 classification][2], much like [Gleditsch-Ward numbers][3] were mostly derived from [Russett, Singer, and Small (1968)][4] codes. However, WVS' system diverged in important ways from UN M.49 with the progression of time, much like Gleditsch-Ward diverged from the Russett, Singer, and Small system that evolved into the more familiar Correlates of War (CoW) project. Look no further than the former Yugoslavia to see important points of divergence among various country classification systems.

WVS further compounds the opacity of its country classification system with documentation that is not entirely faithful to the data it presents. WVS provides country codes for every available unit in the world even if that unit never appeared or has not appeared yet in a WVS wave (e.g. Srpska Republic, East Germany, Northern Cyprus). Users will find it difficult to obtain just the relevant information for analysis. Further, WVS is somewhat peculiar for having multiple different ways of coding Serbia after the departure of Slovenia and Macedonia from greater Yugoslavia.[^1] Worse yet, this information is sometimes omitted from the documentation WVS provides.

[^1]: Even the incredibly useful `countrycode` package struggles with matching Serbia as successor state to the former Yugoslavia (from a CoW perspective).

The [R code I prove on my Github][5] tries to address this for those who use WVS to understand the contextual (i.e. country-level) influences on individual-level political attitudes. The code is rather simple and makes important use of the `countrycode` package everyone should have installed in R anyway. I'll belabor the code and the contents of this Github directory below.

First, I cannot distribute the 1981-2014 longitudinal data file from WVS. You will have to download that yourself. Notice the file name in the R code is unchanged for transparency's sake. I load this in the R script as an object intuitively titled `WVS`.

I created the `wvsccodes-raw.csv` file from the `WVS_EVS_Integrated_Dictionary_Codebook v_2014_09_22.xls` spreadsheet provided by WVS. That spreadsheet contains a mostly complete list of country codes (see item `S003`), separated by a colon. I copied these to a raw text file, changed the colons to commas, and changed some minor things as well (e.g. changing &#8220;Viet Nam&#8221; to just &#8220;Vietnam&#8221;) before saving to a CSV. I later added rows for Montenegro (wvsccode: 499) and Serbia (wvsccode: 688) when it became apparent that those codes appeared in WVS' data set but were not included in the documentation that WVS provided. I load this in R as `WVSccodes`.

After loading the code to R objects `WVS` and `WVSccodes` rest of the code is a fairly simple merge, and light clean. Observe.

{% highlight r %}
WVS$wvsccode <- WVS$S003
WVS <- WVS[order(WVS$wvsccode), ]

WVS <- merge(WVS, WVSccodes, by=("wvsccode"), all.x=TRUE)

WVStable <- with(WVS, data.frame(wvsccode, country))
WVStable <- WVStable[!duplicated(WVS[, "wvsccode"]), ]
WVStable$ccode <-  countrycode(WVStable$country, "country.name", "cown")

# countrycode still struggles with Serbia after Yugoslavia. Let's fix that manually.
WVStable$ccode[WVStable$country == "Serbia"] <- 345
WVStable$ccode[WVStable$country == "Serbia and Montenegro"] <- 345

write.table(WVStable,file="wvs-cow-ccodes-table.csv",sep=",",row.names=F,na="")
{% endhighlight %}

I provide the finished spreadsheet in the Github directory as well.

I note in the code that you're on your own about Puerto Rico, Palestine, and Hong Kong. CoW does not recognize Puerto Rico and Hong Kong because they are not independent (i.e. they cannot have independent foreign policies). Palestine does not have the level of international recognition necessary for CoW to code it as a state-system member. As a result, these entities will typically lack the type of contextual influences the researcher wants to study. If, for some reason, the researcher wants to keep those countries in the study, I'd recommend ccodes of 6, 667, and 714 for Puerto Rico, Palestine, and Hong Kong, respectively.


 [1]: http://www.worldvaluessurvey.org/WVSDocumentationWVL.jsp
 [2]: https://en.wikipedia.org/wiki/UN_M.49
 [3]: http://privatewww.essex.ac.uk/~ksg/statelist.html
 [4]: http://sitemaker.umich.edu/jdsinger/files/national_political_units_in_the_20th_century.pdf
 [5]: https://github.com/svmiller/wvsccodes