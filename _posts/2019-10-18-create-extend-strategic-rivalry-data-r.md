---
title: "Create and Extend Strategic (International) Rivalry Data in R"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2019-10-18'
excerpt: "A few lines in R (thanks to {tidyverse}) can take raw rivalry data from Thompson and Dreyer (2012) and create some usable data frames for conflict research."
layout: post
categories:
  - R
  - Political Science
image: "bettanier-black-spot-1887.jpg"
---





{% include announcebox.html announce="This Functionality is Now in <a href='http://svmiller.com/peacesciencer'><code class='highlighter-rouge'>{peacesciencer}</code></a> ⤵️" text="The processes described here have been included in <a href='http://svmiller.com/peacesciencer'><code class='highlighter-rouge'>{peacesciencer}</code></a>, an R package for the creation of all kinds of peace science data. The <a href='http://svmiller.com/stevemisc/reference/strategic_rivalries.html'><code class='highlighter-rouge'>strategic_rivalries</code></a> data frame is still in <a href='http://svmiller.com/stevemisc'><code class='highlighter-rouge'>{stevemisc}</code></a> as a legacy. A slightly modified version is included in <a href='http://svmiller.com/peacesciencer'><code class='highlighter-rouge'>{peacesciencer}</code></a> as the <code class='highlighter-rouge'>td_rivalries</code> data. You can add strategic rivalry data to state-year or dyad-year data in <a href='http://svmiller.com/peacesciencer'><code class='highlighter-rouge'>{peacesciencer}</code></a> with the <a href='http://svmiller.com/peacesciencer/reference/add_strategic_rivalries.html'><code class='highlighter-rouge'>add_strategic_rivalries()</code></a> function. Please check out the website for <a href='http://svmiller.com/peacesciencer'><code class='highlighter-rouge'>{peacesciencer}</code></a> for updates on its continued development." %}


{% include image.html url="/images/bettanier-black-spot-1887.jpg" caption="Alfred Bettanier's (1887) painting stylizes the Franco-German enmity and its focal point at the 'black spot' of Alsace-Lorraine." width=400 align="right" %}


This is another one of those things I find myself doing from time to time in my research so it might be advisable to write it down and remember how to do it.

Rivalries are an important concept in the quantitative study of international conflict. This relates to one of the more important takeaways from the data on inter-state disputes: they're not randomly assigned across dyads. A few dyads are [disproportionately responsible for large conflicts and wars](https://www.amazon.com/Bound-Struggle-Strategic-Evolution-International/dp/0472112740). I use the India-Pakistan dyad in [my upper-division conflict course](http://posc3610.svmiller.com/) as an illustration of this phenomenon. The dyad was created in 1947 following the contentious partition of British Raj along ill-defined Radcliffe Line. War immediately followed for [the cause of territorial consolidation](http://svmiller.com/blog/2015/04/some-psfrustrations-from-an-ir-perspective/) and relations have been tense ever since. Indeed, India and Pakistan have had four wars since their mutual creation and have been in a MID (often a fatal MID) [around 70% of their existence](https://github.com/svmiller/posc3610/blob/master/recurrent-conflict/posc3610-lecture-recurrent-conflict.pdf). The rivalry scholarship in international relations argues these previous crises lead to the emergence of rivalry relationships in which states view each other as threats and compete against each other. This makes future crises more likely. 

There are a number of ways of identifying rivalry relationships. Most classic rivalry scholarship identified rivalries based on past disputes. [Diehl and Goertz (2000)](https://muse.jhu.edu/book/7260), for example, develop a rivalry classification that depends on the volume of MIDs in a given window of time. However useful, this "dispute-density" approach uses past dispute history to predict future disputes in a matter not unlike how [roll call votes in the past are use to predict roll call votes in the future](https://www.jstor.org/stable/2669306). Any observed relationship might simply be a tautology.

For that reason, I've been to drawn to [Thompson's (2000)](https://www.jstor.org/stable/3096060?seq=1#metadata_info_tab_contents) and later [Thompson and Dreyer's (2012)](https://www.amazon.com/Handbook-International-Rivalries-Correlates-War/dp/0872894878) "diplomatic history" approach. Herein, researchers look into diplomatic relations to see how states interact with each other, whether diplomatic communiqués treat the other side as threats, and whether military exercises target the other side with that in mind. This approach might be more "perceptive" than the dispute-density approach but it is at least conceptually distinct from the phenomenon we want rivalry to explain (i.e. conflict recurrence).

However, the ensuing data are less of a data set one can download and more a history of rivalry relationships that Thompson and Dreyer summarize in [their book](https://www.amazon.com/Handbook-International-Rivalries-Correlates-War/dp/0872894878). Nevertheless, the appendix of their book, and a few lines of R code, can create some data sets to use in our standard dyad-year modeling approach to conflict onset.

1. [The (Raw) Data](#rawdata)
2. [Prep the Data](#prepdata)
3. [Create (Non)-Directed Rivalry Year Data](#createrivalryyear)

## The (Raw) Data {#rawdata}

I scanned Thompson and Dreyer's (2012) book at the appendix and created a spreadsheet that I make available in [my `{stevemisc}` package](http://svmiller.com/stevemisc) as a data object titled `strategic_rivalries`. Alternatively, a .csv of the data [is available here](https://gist.github.com/svmiller/63dace4aa5a00eddce307d964c7bac23). Let's load that raw data and take a gander at it. The data are purposely minimal right now because it's a quick scan of the information from the appendix. The goal is to record it in a spreadsheet and extend it later.


```r
# library(tidyverse)
# library(stevemisc)
data("strategic_rivalries")

# alternatively:
# strategic_rivalries <- read_csv("https://gist.githubusercontent.com/svmiller/63dace4aa5a00eddce307d964c7bac23/raw/3941ed5654cff77dc4509ff7b81e664cf8b0875e/strategic_rivalries.csv")

strategic_rivalries %>%
  head(5) %>%
    kable(., format="html",
        table.attr='id="stevetable"',
        caption = "The First Five Rows of the Strategic Rivalry Data",
        align=c("c","l","l", "l", "l", "c","c","l","c","c","c"))
```

<table id="stevetable">
<caption>The First Five Rows of the Strategic Rivalry Data</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> rivalryno </th>
   <th style="text-align:left;"> rivalryname </th>
   <th style="text-align:left;"> sidea </th>
   <th style="text-align:left;"> sideb </th>
   <th style="text-align:left;"> styear </th>
   <th style="text-align:center;"> endyear </th>
   <th style="text-align:center;"> region </th>
   <th style="text-align:left;"> type1 </th>
   <th style="text-align:center;"> type2 </th>
   <th style="text-align:center;"> type3 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> Austria-France </td>
   <td style="text-align:left;"> Austria </td>
   <td style="text-align:left;"> France </td>
   <td style="text-align:left;"> 1494 </td>
   <td style="text-align:center;"> 1918 </td>
   <td style="text-align:center;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> positional </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:left;"> Austria-Ottoman Empire </td>
   <td style="text-align:left;"> Austria </td>
   <td style="text-align:left;"> Ottoman Empire </td>
   <td style="text-align:left;"> 1494 </td>
   <td style="text-align:center;"> 1908 </td>
   <td style="text-align:center;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> positional </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> France-Spain </td>
   <td style="text-align:left;"> France </td>
   <td style="text-align:left;"> Spain </td>
   <td style="text-align:left;"> 1494 </td>
   <td style="text-align:center;"> 1700 </td>
   <td style="text-align:center;"> European GPs </td>
   <td style="text-align:left;"> positional </td>
   <td style="text-align:center;"> spatial </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Britain-France 1 </td>
   <td style="text-align:left;"> Great Britain </td>
   <td style="text-align:left;"> France </td>
   <td style="text-align:left;"> 1494 </td>
   <td style="text-align:center;"> 1716 </td>
   <td style="text-align:center;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> positional </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:left;"> Ottoman Empire-Spain </td>
   <td style="text-align:left;"> Ottoman Empire </td>
   <td style="text-align:left;"> Spain </td>
   <td style="text-align:left;"> 1494 </td>
   <td style="text-align:center;"> 1585 </td>
   <td style="text-align:center;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> positional </td>
   <td style="text-align:center;"> NA </td>
  </tr>
</tbody>
</table>


`rivalryno` is a unique rivalry number that starts at 1 and ends at 197. `rivalryname` is the name of the rivalry that Thompson and Dreyer give this particular observation. In most cases, it's a simple concatenation of the two participants in an alphabetical order. Cases where there are multiple rivalries in a given dyad will have numbers next to them (e.g. Britain-Spain 1, Britain-Spain 2). `sidea` and `sideb` are the participants in the rivalry. The rivalry data are non-directed but `sidea` is whatever country comes first alphabetically. `styear` and `endyear` are the start year and end year (respectively) for the rivalry. Ongoing rivalries have a right bound of 2010, but could conceivably be extended to the present year in almost every case.

`region` is where Thompson and Dreyer code the rivalry as occurring. These regions that Thompson and Dreyer describe are multiple and mostly consistent across time and space, but users interested in regional rivalries may want to explore these locations and standardize them further. For example, the "Germany-United States 2" rivalry (1933-1945) and "Russia-United States 2" (2007-present) rivalries are both in "Multiple" regions despite some different focal points between the two whereas the "Russia-United States 1" (1945-1989) rivalry is in the "Global" region. Of note: European great power rivalries have their own region ("European GPs").

Finally, `type1`, `type2`, and `type3` variables describe the nature of the rivalry and what it concerned, in order of importance. Not every rivalry has a second or third dimension, but every rivalry must have a primary dimension coded in the `type1` variable. There are four categories of rivalry in the Thompson and Dreyer (2012) data. "Spatial" rivalries are contested over the control of territory, broadly defined. The Armenia-Azerbaijan rivalry (1991-present) is a good example of an exclusively spatial rivalry since most of the relationship concerns Nagorno-Karabakh. "Posiitonal" rivalries are competitions for relative shares of influence in a region. The Iran-Israel rivalry (1979-present) is a good example of an exclusively positional rivalry since the concern largely hinges on Israel's misgivings about Iran's aspirations in the region after the overthrow of the Shah in 1979. "Ideological" rivalries are relationships where two sides contest virtues of competing economic/political systems. The "Costa Rica-Nicaragua 2" (1948-1990) rivalry is the only exclusively ideological rivalry in the data. Therein, democratic Costa Rica and Marxist Nicaragua actively advocated regime change for the other side. "Interventionary" rivalries are new types of rivalries that Thompson and Dreyer introduce to this project. These are relationships in which states intrude into the internal affairs of other states for sake of leverage in the other state's decision-making. They are often done without clear spatial, positional, or even ideological reasons. The concept borrows from [Cliffe's (1999) discussion of "mutual intervention"](https://www.jstor.org/stable/3993184?seq=1#metadata_info_tab_contents) in the Horn of Africa and it should be no surprise that all interventionary rivalries in the data are located in Central Africa or East Africa.

Many rivalries have a second dimension but very few have three dimensions. The West Germany-East Germany rivalry (1949-1973) is an accessible three-dimensional rivalry in this data. Therein, the rivalry was primarily ideological (`type1`), but had a secondary positional aspect (`type2`) and a minimal, but still important, spatial/territorial element (`type3`) on top of that.

There is more coding necessary to get the most use out of these data, but the raw data can already communicate some basic descriptive statistics about strategic rivalries. For example, here are the the 10 longest rivalries in the data. It's unsurprising that the top seven are European great power rivalries. 


```r
strategic_rivalries %>%
  mutate(duration = (endyear - styear)+1) %>%
  arrange(-duration) %>%
  head(10) %>%
  select(rivalryname, styear, endyear, region, type1, duration) %>%
  kable(., format="html",
    table.attr='id="stevetable"',
    caption = "The Ten Longest Rivalries in the History of the World",
    align=c("l","c","c","l","l","c"))
```

<table id="stevetable">
<caption>The Ten Longest Rivalries in the History of the World</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> rivalryname </th>
   <th style="text-align:center;"> styear </th>
   <th style="text-align:center;"> endyear </th>
   <th style="text-align:left;"> region </th>
   <th style="text-align:left;"> type1 </th>
   <th style="text-align:center;"> duration </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Austria-France </td>
   <td style="text-align:center;"> 1494 </td>
   <td style="text-align:center;"> 1918 </td>
   <td style="text-align:left;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> 425 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Austria-Ottoman Empire </td>
   <td style="text-align:center;"> 1494 </td>
   <td style="text-align:center;"> 1908 </td>
   <td style="text-align:left;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> 415 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ottoman Empire-Russia </td>
   <td style="text-align:center;"> 1668 </td>
   <td style="text-align:center;"> 1918 </td>
   <td style="text-align:left;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> 251 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ottoman Empire-Venice </td>
   <td style="text-align:center;"> 1494 </td>
   <td style="text-align:center;"> 1717 </td>
   <td style="text-align:left;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> 224 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Britain-France 1 </td>
   <td style="text-align:center;"> 1494 </td>
   <td style="text-align:center;"> 1716 </td>
   <td style="text-align:left;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> 223 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> France-Spain </td>
   <td style="text-align:center;"> 1494 </td>
   <td style="text-align:center;"> 1700 </td>
   <td style="text-align:left;"> European GPs </td>
   <td style="text-align:left;"> positional </td>
   <td style="text-align:center;"> 207 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> France-Prussia </td>
   <td style="text-align:center;"> 1756 </td>
   <td style="text-align:center;"> 1955 </td>
   <td style="text-align:left;"> European GPs </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> 200 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colombia-Venezuela </td>
   <td style="text-align:center;"> 1831 </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:left;"> South America </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> 180 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Britain-Russia </td>
   <td style="text-align:center;"> 1778 </td>
   <td style="text-align:center;"> 1956 </td>
   <td style="text-align:left;"> European GPs </td>
   <td style="text-align:left;"> positional </td>
   <td style="text-align:center;"> 179 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bolivia-Chile </td>
   <td style="text-align:center;"> 1836 </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:left;"> South America </td>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> 175 </td>
  </tr>
</tbody>
</table>

We can also do a basic summary of the distribution of rivalries by primary rivalry type. The modal category is clearly spatial rivalry, which coincides with over 45% of all primary rivalry types. Positional rivalries over relative shares of influence in a region are the next most common. The least common rivalry type is interventionary. These are rivalries exclusive to Sub-Saharan Africa.



```r

strategic_rivalries %>% group_by(type1) %>% 
  summarize(n = n()) %>% ungroup() %>%
  arrange(-n) %>%
  mutate(percent = paste0(mround(n/sum(n)),"%")) %>%
  kable(., format="html",
        table.attr='id="stevetable"',
        caption = "The Distribution of Rivalries by Primary Rivalry Type, 1494-2010",
        align = c("l","c","c"))
```

<table id="stevetable">
<caption>The Distribution of Rivalries by Primary Rivalry Type, 1494-2010</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> type1 </th>
   <th style="text-align:center;"> n </th>
   <th style="text-align:center;"> percent </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> spatial </td>
   <td style="text-align:center;"> 89 </td>
   <td style="text-align:center;"> 45.18% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> positional </td>
   <td style="text-align:center;"> 65 </td>
   <td style="text-align:center;"> 32.99% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ideological </td>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:center;"> 15.23% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> interventionary </td>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:center;"> 6.6% </td>
  </tr>
</tbody>
</table>

## Prep the Data {#prepdata}

A user will need to prep the data a little to get some usable dyad-year data from this raw list of strategic rivalries. Importantly, the data are non-directed but the dyad is "ordered" alphabetically rather than by a numeric coding system (a la Correlates of War [CoW] state system membership). This will make for some headaches in standard dyad-year data because Portugal (ccode: 235) precedes Spain (ccode: 230) in the rivalry list, but will never precede Spain in a non-directed dyad-year design that relies on CoW system membership data.

Fortunately, [the `{countrycode}` package](https://cran.r-project.org/web/packages/countrycode/index.html) is great for this. We'll first convert `sidea` and `sideb` to a `ccodea` and `ccodeb`. The package will take care of almost everything here, though there are a few caveats that I'll highlight in the code below.


```r
require(countrycode)

strategic_rivalries %>%
  mutate(ccodea = countrycode(sidea, "country.name", "cown"),
         ccodeb = countrycode(sideb, "country.name", "cown")) -> strategic_rivalries

# Austria is "Austria" in the rivalry data, but Austria-Hungary before it.
# We'll fix some of this a bit later too.
strategic_rivalries$ccodea[strategic_rivalries$sidea == "Austria"] <- 300
# Prussia doesn't appear as a partial matching term for successor state Germany
strategic_rivalries$ccodea[strategic_rivalries$sidea == "Prussia"] <- 255 
# countrycode instinctively gives Germany's ccode to West Germany
strategic_rivalries$ccodea[strategic_rivalries$sidea == "West Germany"] <- 260 
# Ottoman Empire doesn't appear as a matching term for successor state Turkey
strategic_rivalries$ccodea[strategic_rivalries$sidea == "Ottoman Empire"] <- 640
# Silly error, but countrycode doesn't know between Vietnams
strategic_rivalries$ccodea[strategic_rivalries$sidea == "North Vietnam"] <- 816


strategic_rivalries$ccodeb[strategic_rivalries$sideb == "Ottoman Empire"] <- 640
# Note: I'm creating this since Venice never appears in the CoW data. I won't ever use it.
# You probably won't either.
strategic_rivalries$ccodeb[strategic_rivalries$sideb == "Venice"] <- 324 
strategic_rivalries$ccodeb[strategic_rivalries$sideb == "Prussia"] <- 255
# countrycode always struggles with Serbia as successor state to Yugoslavia.
strategic_rivalries$ccodeb[strategic_rivalries$sideb == "Serbia"] <- 345 
```

Next, we'll create a `ccode1` and `ccode2` variable that makes these non-directed. The lower country code will always appear first.


```r

strategic_rivalries %>%
  mutate(ccode1 = ifelse(ccodeb > ccodea, ccodea, ccodeb),
         ccode2 = ifelse(ccodeb > ccodea, ccodeb, ccodea)) -> strategic_rivalries
```


## Create (Non)-Directed Rivalry-Year Data {#createrivalryyear}

The process of extending these rivalry data into rivalry-year data is effectively identical to what I showed in my guide on [how to create country-year, non-directed dyad-year, and directed dyad-year data](http://svmiller.com/blog/2019/01/create-country-year-dyad-year-from-country-data/). People who have read that guide will see what is happening; `rowwise()` and `unnest()` are doing all the heavy-lifting here. Do note we need a quick fix for that one Austrian rivalry that actually extends past 1918.


```r
# NRY: non-directed rivalry-years

strategic_rivalries %>%
  # We don't need these two columns and they'll only get in the way.
  select(-ccodea, -ccodeb) %>%
  # Prepare the pipe to think rowwise. If you don't, the next mutate command will fail.
  rowwise() %>%
  # Create a list in a tibble that we're going to expand soon.
  mutate(year = list(seq(styear, endyear))) %>%
  # Unnest the list, which will expand the data.
  unnest() %>%
  # Minor note: ccode change for Austria, post-1918 for rivalryno 79.
  mutate(ccode1 = ifelse(ccode1 == 300 & year >= 1919, 305, ccode1)) -> NRY

```

This dynamic document isn't also creating non-directed dyad-year data, but merging non-directed *rivalry*-year data into non-directed *dyad*-year data is easy since there would be common keys of `ccode1`, `ccode2`, and `year`. It would look like this.

```r
# Assume an object (NDY) has complete non-directed dyad-year data.
# See: svmiller.com/blog/2019/01/create-country-year-dyad-year-from-country-data/

NRY %>%
  # Let's just select stuff we may want since we don't want too huge a data frame.
  select(ccode1, ccode2, year, type1:type3) %>%
  # Simple mutate: every row means there's an ongoing rivalry. Duh.
  mutate(ongorivalry = 1) %>%
  # And left_join...
  left_join(NDY, .) %>%
  # if ongorivalry is NA, it's actually zero
  mutate(ongorivalry = ifelse(is.na(ongorivalry), 0, ongorivalry)) -> NDY
```

That's it. Doing this takes a table of 197 rivalries in Thompson and Dreyer's appendix, entered to a spreadsheet in about 30 minutes (if I recall that effort correctly), saved as an R data set, and extends it into rivalry-year data to be quickly merged into dyad-year data. Just a few lines of R code from `{tidyerse}` with some light maintenance from the `{countrycode}` package are all you need.



