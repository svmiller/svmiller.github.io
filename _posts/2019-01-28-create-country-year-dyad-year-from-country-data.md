---
title: "Create Country-Year and (Non)-Directed Dyad-Year Data With Just a Few Lines in R"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2019-01-28'
excerpt: A few lines in R (thanks to {tidyverse} functionality) can create the basic country-year and dyad-year data frames you need for international conflict research.
layout: post
permalink: null
categories:
  - R
  - Political Science
---






*Last updated: 19 June 2021. This post became the basis for [`{peacesciencer}`](http://svmiller.com/peacesciencer), which you can now install on CRAN. The processes described here ultimately became `create_dyadyears()` and `create_stateyears()` in that package. Please check out the package's website for its continued development.*

{% include image.html url="/images/authagraph.jpg" caption="The most accurate map in the world, just 'cause." width=450 align="right" %}



<!-- {% include image.html url="/images/authagraph.jpg" caption="The most accurate map in the world, just 'cause." width=450 align="right" %} -->

I'm writing this mostly as a note to myself since I have to remind myself how I do this every time I do it.

The long and short of this post is I remember being in grad school and working with international conflict data (mostly [Correlates of War](http://correlatesofwar.org/)) and creating a lot of country-year and dyad-year data sets to analyze questions of interest to the earlier research I did with [my adviser](http://dmgibler.people.ua.edu/). Works in this line of research include country-year-level analyses of [territorial threat, state capacity, and civil war](http://dmgibler.people.ua.edu/state-capacity.html) and directed dyad-year analyses on host of questions of interest to the democratic peace research agenda: namely if [democratic conflict selection advantages](http://jcr.sagepub.com/content/57/2/258.full) and [democratic dispute resolution](http://cmp.sagepub.com/content/28/3/261) are epiphenomenal to [territorial peace](http://dmgibler.people.ua.edu/territorial-peace).

I also remember [EUGene](http://www.eugenesoftware.org/), an invaluable program at the time that could seamlessly generate non-directed dyad-year conflict data, directed dyad-year conflict data, and country-year data, complete with several covariates and conflict data of interest to the researcher, in just minutes. Yet my professional development occurred at a juncture when EUGene started to lose some of its value. The causes here were multiple and the reader should not interpret this as the fault of the developers. For one, EUGene existed only as a Windows binary. I got proficient at installing [Wine](https://www.winehq.org/) and using it to make EUGene install on my Linux desktop (and later my Macbook). Yet, this is a tedious extra step. Further, EUGene was limited to the data it had and still mostly served its original purpose: to facilitate analyses and replications of analyses from the 1990s still indebted to version 2.1 of the Correlates of War Militarized Interstate Dispute (MID) data. Updates that could incorporate newer conflict data (i.e. the update to version 3 in 2004 and version 4 in 2014) and the [revisions my adviser and I were proposing](https://academic.oup.com/isq/article-abstract/60/4/719/2918882/An-Analysis-of-the-Militarized-Interstate-Dispute?redirectedFrom=fulltext) to the MID data lagged behind user demand for these features. Thus, I had to figure out how to do what EUGene was previously doing for me.

Fortunately, I learned a few lines of R code can create country-year and dyad-year panel data frames from basic country-level information as the remainder of this post will show. The lines necessary to create this code became even fewer when `{plyr}` gave way to `{dplyr}` in my workflow. All the user needs is [the Correlates of War State System Membership data](http://correlatesofwar.org/data-sets/state-system-membership). I'll be using v2016 but any version should be fine for this purpose.

Read in the data (wherever you stored it) into your R session and load the `tidyverse` package before it.

```r
library(tidyverse)
States <- read_csv("~/Dropbox/data/cow/states/states2016.csv")
```


## Country-Year Data

The following code will create a simple country-year data frame that a user can populate with country-year-level data of interest (e.g. civil war data, various IPE data). I'll annotate the code below so the reader can see what it's doing.

```r
States %>%
  # This mutate command below is optional.
  # Basically: the data extend to 2016. If you want to extend it to the most recent year, change it.
  # If you don't need it (i.e. most CoW conflict data end in 2010), leave it alone or comment it out.
  mutate(endyear = ifelse(endyear == 2016, 2018, endyear)) %>%
  # Prepare the pipe to think rowwise. If you don't, the next mutate command will fail.
  rowwise() %>%
  # Create a list in a tibble that we're going to expand soon.
  mutate(year = list(seq(styear, endyear))) %>%
  # Unnest the list, which will expand the data.
  unnest() %>%
  # Arrange by ccode, year, just to be sure.
  arrange(ccode, year) %>%
  # Select just the ccode, year
  select(ccode, statenme, year) %>%
  # Make sure there are no duplicate country-year observations.
  # There shouldnt' be. But be sure.
  # Finally: assign to object.
  distinct(ccode, statenme, year) -> CY
```

As a proof of concept, here are all the years for Grand Duchy of Mecklenburg-Schwerin in the the Correlates of War State System Membership data. These years would coincide with its emergence as a state system member on Jan. 1, 1843 to its elimination as an independent state upon its entry into [the North German Confederation](https://en.wikipedia.org/wiki/North_German_Confederation). This alliance was an effective concession of state sovereignty by [Fredrich Franz II](https://en.wikipedia.org/wiki/Frederick_Francis_II,_Grand_Duke_of_Mecklenburg-Schwerin) to Prussia.


```r
CY %>% filter(ccode == 280) %>%
  kable(., format="html",
        table.attr='id="stevetable"',
        caption = "A Simple Country-Year Panel for Mecklenburg Schwerin, 1843-1867",
        align=c("c","l","c"))
```

<table id="stevetable">
<caption>A Simple Country-Year Panel for Mecklenburg Schwerin, 1843-1867</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> ccode </th>
   <th style="text-align:left;"> statenme </th>
   <th style="text-align:center;"> year </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1843 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1844 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1845 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1846 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1847 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1848 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1849 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1850 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1851 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1852 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1853 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1854 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1855 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1856 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1857 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1858 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1859 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1860 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1861 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1862 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1863 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1864 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1865 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1866 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 280 </td>
   <td style="text-align:left;"> Mecklenburg Schwerin </td>
   <td style="text-align:center;"> 1867 </td>
  </tr>
</tbody>
</table>

## Directed Dyad-Year Data

Directed dyad-year data are useful when the researcher is interested in, say, conflict onsets in a given dyad-year and it is important who initiates the dispute. In this interpretation, "France-Germany, 1911" and "Germany-France, 1911" are importantly different observations because Germany initiated the Agadir Crisis (MID#0315) against France and that distinction matters. There is likely an application of directed dyad-year panel frames for IPE researchers interested in, say, directional trade flows. However, I've never done an analysis like this before.

The code to create directed dyad-year data from the Correlates of War State System Membership data is remarkably easy to do.

```r
States %>% 
  # Select just the stuff we need
  select(ccode, styear, endyear) %>% 
  # Expand the data, create two ccodes as well
  expand(ccode1=ccode, ccode2=ccode, year=seq(1816,2016)) %>% 
  # Filter out where ccode1 == ccode2
  filter(ccode1!=ccode2) %>% 
  # When you're merging into dyad-year data, prepare to do it twice.
  # Basically: merge in data (here, minimally: the info from the `States` data) for ccode1
  left_join(., States, by=c("ccode1"="ccode")) %>%
  # ...and filter out cases where the years don't align.
  filter(year >= styear & year <= endyear) %>%
  # Get rid of styear and endyear to do it again.
  select(-styear,-endyear) %>% 
  # And do it again, this time for ccode2
  left_join(., States, by=c("ccode2"="ccode")) %>%
  # Again, filter out cases where years don't align.
  filter(year >= styear & year <= endyear) %>%
  # And select just what we need.
  select(ccode1, ccode2, year) -> DDY
```

I want to belabor a few points about the nature of the directed dyad-year data I just created.

First, when populating a dyad-year (directed or non-directed) panel data frame with some covariates (e.g. Polity data, GDP data, whatever), be prepared to merge in data "twice." That is, the data frame with which the user is primarily working is dyad-year, but the data the user wants to add into the dyad-year panel frame are country-year (e.g. the Polity score for France or Prussia/Germany in 1826, 1827, 1828, and so on). Thus, the user will need to merge it "twice" by first recoding the country-year country code variable to be something like `ccode1`. Merge and that assigns the data to pertain to `ccode1` in the dyad-year data. Rename the country-year country code variable again to be something like `ccode2`. Repeat, and that assigns the data to pertain to `ccode2` in the dyad-year data.

For what it's worth, the `left_join()` function in `{dplyr}` is sophisticated enough to allow you to merge on two different keys. That's what the `by` field is doing in the `left_join()` part of the piped chain of functions above.

Second, the filtering of the years will make sure the user is not left with any observations where the countries did not exist at the same time. For example, Kuwait and Baden were never independent states at the same time. That is an important detail. Obviously states like Belize and Wuerttemberg can't have a conflict with each other when they never existed at the same time.

Third, the data take no consideration of whether the dyads here are ["politically relevant"](https://www.jstor.org/stable/3176286?seq=1#page_scan_tab_contents) or ["politically active"](https://journals.sagepub.com/doi/10.1080/07388940500503804). They are universal. This means two things. One, this is a *long* data set. 1,912,350 rows long. It's also why I dropped out all other columns to avoid the data frame consuming too much memory in R for this simple exercise.

The user may want to apply some case exclusion rules like "political relevance" or "political activity" before merging in other data because there are a lot of irrelevant dyads. That will start to devour memory in the R session pretty quickly. When I discuss [this topic](http://posc3610.svmiller.com/opportunity-conflict/posc3610-lecture-opportunity-conflict.pdf) with [my students](http://posc3610.svmiller.com/), I always bring up my favorite dyad---Mongolia-Nigeria---because the probability of conflict between both states, let alone a fatal MID, is effectively zero even if the thought experiment of what such a fatal conflict would resemble will have your brain wandering to weird places.

However, Mongolia-Nigeria are in this data set, as are Nigeria-Mongolia.


```r
DDY %>%
  filter(ccode1 %in% c(475, 712) & ccode2 %in% c(475, 712)) %>%
  filter(year <= 1970) %>%
  mutate(statenme1 = countrycode::countrycode(ccode1, "cown", "country.name"),
         statenme2 = countrycode::countrycode(ccode2, "cown", "country.name")) %>%
  select(ccode1, ccode2, statenme1, statenme2, year) %>%
  kable(., format="html",
        table.attr='id="stevetable"',
        caption = "A Simple Directed Dyad-Year Panel for Mongolia and Nigeria, 1960-1970",
        align=c("c","c","l","l","c"))
```

<table id="stevetable">
<caption>A Simple Directed Dyad-Year Panel for Mongolia and Nigeria, 1960-1970</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> ccode1 </th>
   <th style="text-align:center;"> ccode2 </th>
   <th style="text-align:left;"> statenme1 </th>
   <th style="text-align:left;"> statenme2 </th>
   <th style="text-align:center;"> year </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1960 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1961 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1962 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1963 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1964 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1965 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1966 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1967 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1968 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1969 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1970 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1960 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1961 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1962 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1963 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1964 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1965 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1966 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1967 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1968 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1969 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:center;"> 1970 </td>
  </tr>
</tbody>
</table>

Again, this will create universal directed dyad-year data. It's imperative for the user to make reasonable case exclusion rules on top of that. There may be a reason to have a dyad like Mongolia-Nigeria, Belize-Botswana, or Estonia-Trinidad and Tobago in the data, no matter how rarely those countries interact. However, that's for the user to justify in the analysis section of the paper s/he will write.

## Non-Directed Dyad-Year Data

Non-directed dyad-year data are (I think) the most common form of dyad-year analyses of inter-state conflict. In other words, the distinction between who initiated a MID versus who was targeted in a MID is irrelevant. It does not matter that Germany initiated a MID against France in 1911 in Agadir. It only matters that there was one, especially between those two countries at that point in time.

In practice, creating non-directed dyad-year data means `ccode1` is whichever state has the lower `ccode` in the dyad. That means the United States (`ccode == 2`) will always be first in any non-directed dyad in which it is a party and Samoa (`ccode == 990`) will never be first in any non-directed dyad in which it is a member.

Once you understand that distinction, creating a non-directed dyad-year data frame from the directed dyad-year data frame is simple.

```r
DDY %>% filter(ccode2 > ccode1) -> NDY
```

It's that simple. Notice the Mongolia-Nigeria directed dyad drops out because Mongolia has the higher country code.


```r
NDY %>%
  filter(ccode1 %in% c(475, 712) & ccode2 %in% c(475, 712)) %>%
  filter(year <= 1970) %>%
  mutate(statenme1 = countrycode::countrycode(ccode1, "cown", "country.name"),
         statenme2 = countrycode::countrycode(ccode2, "cown", "country.name")) %>%
  select(ccode1, ccode2, statenme1, statenme2, year) %>%
  kable(., format="html",
        table.attr='id="stevetable"',
        caption = "A Simple Non-Directed Dyad-Year Panel for Mongolia and Nigeria, 1960-1970",
        align=c("c","c","l","l","c"))
```

<table id="stevetable">
<caption>A Simple Non-Directed Dyad-Year Panel for Mongolia and Nigeria, 1960-1970</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> ccode1 </th>
   <th style="text-align:center;"> ccode2 </th>
   <th style="text-align:left;"> statenme1 </th>
   <th style="text-align:left;"> statenme2 </th>
   <th style="text-align:center;"> year </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1960 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1961 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1962 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1963 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1964 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1965 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1966 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1967 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1968 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1969 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 475 </td>
   <td style="text-align:center;"> 712 </td>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Mongolia </td>
   <td style="text-align:center;"> 1970 </td>
  </tr>
</tbody>
</table>

