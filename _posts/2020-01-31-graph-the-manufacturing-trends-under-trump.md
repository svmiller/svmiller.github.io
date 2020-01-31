---
title: "Graphing the Manufacturing Trends Under the Trump Presidency, in R"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2020-01-31'
excerpt: "Stories are increasingly documenting localized recessions emerging in key manufacturing states during the Trump presidency. Here's how to see what that looks like in R."
layout: post
categories:
  - R
image: "trump-hire-buy-american.jpg"
---



{% include image.html url="/images/trump-hire-buy-american.jpg" caption="Global supply chains in 21st century manufacturing are complex if you're smart, but easy if you're an idiot. (Bill Pugliano/Getty Images)" width=400 align="right" %}

1. [Introduction](#introduction)
2. [R Code](#rcode)

### Introduction {#introduction}

Stories like these from [*Bloomberg*](https://www.bloomberg.com/news/features/2019-09-09/a-manufacturing-recession-could-cost-trump-a-second-term?utm_source=pocket-newtab) and [*The Washington Post*](https://www.washingtonpost.com/business/economy/in-manufacturing-midwest-signs-of-trouble-amid-good-times/2019/10/29/f4fd41cc-f118-11e9-89eb-ec56cd414732_story.html) have become near monthly articles in the Trump presidency. The tl;dr, as I tell my students in [my introduction to international relations class](http://posc1020.svmiller.com/), is that Trump's mercantilist worldview is an anachronism in the modern world and with the modern economy operating as it does. Tweeting tariff policy by fiat to "protect" American jobs with the idea of repatriating outsourced jobs home to the United States (and the Rust Belt especially) is a simplistic approach that does more harm than good. With my apologies to [Scott Lincicome](https://twitter.com/scottlincicome), tariffs---then and now---fail to achieve their ideal policy aims and just foster economic chaos and political dysfunction along the way.[ There's a t-shirt for it](https://www.amazon.com/Tariffs-Foster-Political-Dysfunction-2-Sided/dp/B07BDBZ55L) and everything.

The explanations for this are multiple, and I'll try to summarize them here briefly. For one, job outsourcing to areas where labor is cheaper is just one part of the puzzle. You cannot stop firms from maximizing profit and labor is routinely the biggest expense of operating a business. You can physically bar a company from outsourcing jobs to Mexico or China, but you cannot disincentivize a firm from trying to cut labor costs. This is the automation problem. A job that can be automated, will be automated. This is happening everywhere, whether it's robotic arms in manufacturing automobiles or, well, the automated teller machine in banking. This is going to collide with the declining labor share of income phenomenon that is being observed everywhere. Since [it's easier to switch from labor to capital these days](https://ideas.repec.org/a/oup/qjecon/v129y2014i1p61-103.html), the relative price of investment goes down and less income accrues to labor as a result. There's an irony here, though: [manufacturing jobs pay more now than they did previously](https://www.epi.org/publication/manufacturing-still-provides-a-pay-advantage-but-outsourcing-is-eroding-it/) (see slide 28). However, there's lower demand for lower-skill manufacturing jobs. Those wages are accruing to higher-skill labor, for which there's more demand.

The idea behind a naive tariff policy like the one Trump has imposed is to repatriate work and output to the United States. Tariffs impose a cost for a firm wanting to buy a foreign product or a product made of a domestic firm from foreign labor, ideally (and simplistically) disincentivizing them from purchasing it relative to a doemstic firm's domestically made product. Curtailing supply while holding demand constant obviously increases price, which could possibly be profit to be shared with the general public or trickled down to labor. If firms are unable to outsource their labor or consume foreign products, and simplistically/wrongly assuming there's still human work to be done that cannot be automated, then jobs shift from foreign labor to domestic labor for the production of manufacturing outputs. Hire American. Buy American. [There's some underpants gnomes magic working here](https://www.youtube.com/watch?v=tO5sxLapAts), leaving aside that American farms (one of our most prominent export-oriented sectores of the economy) are the front line for the inevatiable response from a country like China.

The problems here are multiple, again underscoring that a mercantilist worldview is rooted in a myopic centuries-since-discreted economic approach that no longer squares with the nature of the modern economy. Part of the problem that these news reports are getting is these tariffs may be artificially prop, say, steel-producing or aluminum-producing firms but they [wreck firms that use these as primary inputs for manufacturing something else](https://www.marketwatch.com/story/trumps-tariffs-will-hurt-the-65-million-us-workers-at-steel-consuming-manufacturers-2018-03-02). It's not just "consumers" that "consume" the object of these tariffs. They're not achieving their primary policy aims. They're fostering economic dysfunction along the way, certainly in key states, without which, Trump cannot secure re-election in 2020.

You can illustrate what's happening here with some R code. the source code for this post is available on [the `_source` directory for my website](https://github.com/svmiller/svmiller.github.io/tree/master/_source), on Github.


### R Code {#rcode}

Here are some R packages you'll need for this post.


```r
library(fredr)
library(tidyverse)
library(stevemisc)
```

Next, use the built-in `state.abb` vector in base R to create two objects that will help us loop through FRED. I'm fairly sure you'll want an API key for this. Mine is stored in my home R directory. We'll create a states data frame later for clarity in merging.



```r
# Manufacting employment
statemfgnabbs <- paste0(c(state.abb),"MFGN")
# Total non-farm employment data
statetotempabbs <- paste0(c(state.abb),"NAN")

data.frame(stateabb = state.abb, statename = state.name) -> states
```

Now, we'll create two empty tibbles, called `Mfgn` and `Nan`, that we're going to amend with manufacturing employment and total employment data. I know I shouldn't be doing loops at this stage in my life, but I don't know of a smarter/sexier way of doing this and it doesn't take too much time for this to run. Feel free to drop a comment if you know of a smarter/sexier/"tidier" way of doing this.


```r
Mfgn <- tibble()
Nan <- tibble()

for (i in 1:length(statemfgnabbs)) {
  fredr(series_id = statemfgnabbs[i],
        observation_start = as.Date("2017-01-01")) -> hold_this
    bind_rows(Mfgn, hold_this) -> Mfgn
}

for (i in 1:length(statetotempabbs)) {
  fredr(series_id = statetotempabbs[i],
        observation_start = as.Date("2017-01-01")) -> hold_this
    bind_rows(Nan, hold_this) -> Nan
}
```

Next, we're going to do some cleaning. I'll annotate what I'm doing in the code below. Of importance: manufacturing is a yearly cycle in a lot of states. [California is illustrative here](https://fred.stlouisfed.org/series/CAMFGN). Evaluating manufacturing policies at the state-level should be done with 12-month lags.


```r
Mfgn %>%
  # rename value to mfgn. "value" is default fredr output
  rename(mfgn = value) %>%
  # scrape stateabb from the series_id. 
  # This works well when you know how series_ids are structured
  mutate(stateabb = stringr::str_sub(series_id, 1, 2)) %>%
  # Left join the unemployment data in, but make sure stateabb aligns
  # get rid of series_id too.
  left_join(., Nan %>%
              mutate(stateabb = stringr::str_sub(series_id, 1, 2)) %>% 
              select(-series_id)) %>%
  # rename value (which came from Nan) to be totempnf
  rename(totempnf = value) %>%
  # Create variable for how much manufacturing is a part of state employment
  mutate(percmfgn = (mfgn/totempnf)*100) %>%
  # left_join with the states data frame, which will have actual state names.
  left_join(., states) %>%
  # reorder the columns
  select(date, stateabb, statename, series_id, everything()) %>%
  # group_by state name
  group_by(statename) %>%
  # calculate mean of how much manufacturing employment matters to state employment
  # Then rank it
  mutate(meanpcmfgn = mean(percmfgn)) %>%
  # Thenk rank it
  ungroup() %>% 
  mutate(rank = dense_rank(desc(meanpcmfgn))) %>% 
  # group by again...
  group_by(statename) %>%
  #  create 12-month difference, a percentage difference
  # And also a variable for if the 12-month difference was negative or not.
  mutate(diff = mfgn - lag(mfgn, 12),
         percdiff = (diff/lag(mfgn, 12))*100,
         neg = ifelse(diff < 0, "Negative", "Positive")) -> Mfgn
```

We can look across manufacturing employment across all 50 states to see where the most growth and contraction has happened after considering the yearly-cyclical nature of the data. I hide the code for formatting the table but it's visible in the `_source` directory. The results show troubling years that seem to cluster in the Midwest, the extent to which the Midwest is home to more manufacturing jobs as a percentage of overall employment. Indiana and Wisconsin saw a contraction of manufacturing jobs in 2019 after controlling for the cyclical nature of manufacturing employment. Even places that were on the balance positive---like Ohio, Michigan, and Illinois---still saw a slowdown in 2019 relative to 2018.


```r
Mfgn %>%
  mutate(year = lubridate::year(date)) %>%
  group_by(statename, year, rank) %>%
  na.omit %>%
  summarize(meandiff = mean(percdiff),
            meandiff = paste0(round(meandiff, 2),"%")) %>%
  ungroup() %>%
  spread(year, meandiff) %>%
  arrange(rank)
```

<table id="stevetable">
<caption>The Average Yearly 12-Month Growth Percentages in Manufacturing Employment in 2018 and 2019</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> State </th>
   <th style="text-align:center;"> Rank </th>
   <th style="text-align:center;"> 2018 </th>
   <th style="text-align:center;"> 2019 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Indiana </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.99% </td>
   <td style="text-align:center;"> -0.19% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Wisconsin </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.75% </td>
   <td style="text-align:center;"> -0.37% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Michigan </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 2.23% </td>
   <td style="text-align:center;"> 0.11% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Iowa </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 3.22% </td>
   <td style="text-align:center;"> 2.45% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kentucky </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 0.66% </td>
   <td style="text-align:center;"> 1.32% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 1.35% </td>
   <td style="text-align:center;"> 1.29% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Arkansas </td>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> 2% </td>
   <td style="text-align:center;"> 1.84% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mississippi </td>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> 0.48% </td>
   <td style="text-align:center;"> 1.3% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ohio </td>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> 1.72% </td>
   <td style="text-align:center;"> 0.52% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kansas </td>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> 2.23% </td>
   <td style="text-align:center;"> 1.38% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> South Carolina </td>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> 2.86% </td>
   <td style="text-align:center;"> 3.08% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tennessee </td>
   <td style="text-align:center;"> 12 </td>
   <td style="text-align:center;"> 1.29% </td>
   <td style="text-align:center;"> 1.83% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Minnesota </td>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:center;"> 0.96% </td>
   <td style="text-align:center;"> -0.26% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> North Carolina </td>
   <td style="text-align:center;"> 14 </td>
   <td style="text-align:center;"> 1.22% </td>
   <td style="text-align:center;"> -0.27% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oregon </td>
   <td style="text-align:center;"> 15 </td>
   <td style="text-align:center;"> 2.57% </td>
   <td style="text-align:center;"> 3.35% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Hampshire </td>
   <td style="text-align:center;"> 16 </td>
   <td style="text-align:center;"> 2.12% </td>
   <td style="text-align:center;"> -0.82% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> South Dakota </td>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:center;"> 3.1% </td>
   <td style="text-align:center;"> 3.55% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nebraska </td>
   <td style="text-align:center;"> 18 </td>
   <td style="text-align:center;"> 1.49% </td>
   <td style="text-align:center;"> 0.19% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Illinois </td>
   <td style="text-align:center;"> 19 </td>
   <td style="text-align:center;"> 2.14% </td>
   <td style="text-align:center;"> 0.68% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Vermont </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:center;"> 0.9% </td>
   <td style="text-align:center;"> 1.86% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Connecticut </td>
   <td style="text-align:center;"> 21 </td>
   <td style="text-align:center;"> 0.99% </td>
   <td style="text-align:center;"> 0.58% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pennsylvania </td>
   <td style="text-align:center;"> 22 </td>
   <td style="text-align:center;"> 1.17% </td>
   <td style="text-align:center;"> -0.81% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Missouri </td>
   <td style="text-align:center;"> 23 </td>
   <td style="text-align:center;"> 2.26% </td>
   <td style="text-align:center;"> 1.54% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Idaho </td>
   <td style="text-align:center;"> 24 </td>
   <td style="text-align:center;"> 2.8% </td>
   <td style="text-align:center;"> 3.03% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Georgia </td>
   <td style="text-align:center;"> 25 </td>
   <td style="text-align:center;"> 1.93% </td>
   <td style="text-align:center;"> 0.72% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Utah </td>
   <td style="text-align:center;"> 26 </td>
   <td style="text-align:center;"> 2.95% </td>
   <td style="text-align:center;"> 3.78% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Washington </td>
   <td style="text-align:center;"> 27 </td>
   <td style="text-align:center;"> 1.32% </td>
   <td style="text-align:center;"> 3.34% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Maine </td>
   <td style="text-align:center;"> 28 </td>
   <td style="text-align:center;"> 1.72% </td>
   <td style="text-align:center;"> 2.41% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oklahoma </td>
   <td style="text-align:center;"> 29 </td>
   <td style="text-align:center;"> 2.92% </td>
   <td style="text-align:center;"> -1.37% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rhode Island </td>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:center;"> -0.24% </td>
   <td style="text-align:center;"> -2.54% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> California </td>
   <td style="text-align:center;"> 31 </td>
   <td style="text-align:center;"> 1.07% </td>
   <td style="text-align:center;"> 0.95% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Texas </td>
   <td style="text-align:center;"> 32 </td>
   <td style="text-align:center;"> 3.31% </td>
   <td style="text-align:center;"> 3.12% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:center;"> 33 </td>
   <td style="text-align:center;"> 0.14% </td>
   <td style="text-align:center;"> 2.01% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Massachusetts </td>
   <td style="text-align:center;"> 34 </td>
   <td style="text-align:center;"> 0% </td>
   <td style="text-align:center;"> -0.49% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> West Virginia </td>
   <td style="text-align:center;"> 35 </td>
   <td style="text-align:center;"> 0.87% </td>
   <td style="text-align:center;"> 1.38% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Virginia </td>
   <td style="text-align:center;"> 36 </td>
   <td style="text-align:center;"> 2.21% </td>
   <td style="text-align:center;"> 2.63% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Arizona </td>
   <td style="text-align:center;"> 37 </td>
   <td style="text-align:center;"> 3.7% </td>
   <td style="text-align:center;"> 4.37% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Jersey </td>
   <td style="text-align:center;"> 38 </td>
   <td style="text-align:center;"> 1.14% </td>
   <td style="text-align:center;"> 1.49% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> North Dakota </td>
   <td style="text-align:center;"> 39 </td>
   <td style="text-align:center;"> 4.69% </td>
   <td style="text-align:center;"> 1.5% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Delaware </td>
   <td style="text-align:center;"> 40 </td>
   <td style="text-align:center;"> 3.02% </td>
   <td style="text-align:center;"> 1.66% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colorado </td>
   <td style="text-align:center;"> 41 </td>
   <td style="text-align:center;"> 2.27% </td>
   <td style="text-align:center;"> 1.21% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New York </td>
   <td style="text-align:center;"> 42 </td>
   <td style="text-align:center;"> -0.49% </td>
   <td style="text-align:center;"> -0.49% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Florida </td>
   <td style="text-align:center;"> 43 </td>
   <td style="text-align:center;"> 2.36% </td>
   <td style="text-align:center;"> 2.65% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Montana </td>
   <td style="text-align:center;"> 44 </td>
   <td style="text-align:center;"> 2.97% </td>
   <td style="text-align:center;"> -0.89% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Maryland </td>
   <td style="text-align:center;"> 45 </td>
   <td style="text-align:center;"> 1.26% </td>
   <td style="text-align:center;"> 0.03% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nevada </td>
   <td style="text-align:center;"> 46 </td>
   <td style="text-align:center;"> 15.73% </td>
   <td style="text-align:center;"> 8.49% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alaska </td>
   <td style="text-align:center;"> 47 </td>
   <td style="text-align:center;"> -6.09% </td>
   <td style="text-align:center;"> 3.38% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Wyoming </td>
   <td style="text-align:center;"> 48 </td>
   <td style="text-align:center;"> 3.98% </td>
   <td style="text-align:center;"> 4.69% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Mexico </td>
   <td style="text-align:center;"> 49 </td>
   <td style="text-align:center;"> 2.22% </td>
   <td style="text-align:center;"> 1.38% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hawaii </td>
   <td style="text-align:center;"> 50 </td>
   <td style="text-align:center;"> -1.36% </td>
   <td style="text-align:center;"> -1.85% </td>
  </tr>
</tbody>
</table>

Yearly summaries don't quite communicate some of what these news reports are saying. In other words, the trends are emerging and more recent months will show that. This graph will communicate how I recommend interpreting the manufacturing employment data in these 12 states of interest. Namely, Texas' shale boom, Florida's robust growth, and California's seasonal manufacturing cycle seem to prop up manufacturing job numbers. There are a lot of states that look like they're struggling. These are incidentally key states for Trump's voting bloc. That's not to say these numbers are sufficient to crack Trump's support base. Indeed, the basic problem is Trump voters in these areas are being compensated with [another form of utility](https://www.vox.com/policy-and-politics/2018/10/16/17980820/trump-obama-2016-race-racism-class-economy-2018-midterm) not implied by theories of pocketbook voting.

Nevertheless, what you see here underscores what these news reports are relaying, and how three of our biggest state economies paper over more worrying trends in some states of bigger political interest.



```r
Mfgn %>%
  filter(stateabb %in% c("IA","IL","IN","OH","MI","WI","PA","MN","NC", "FL","CA", "TX")) %>%
  ggplot(.,aes(date, diff, fill = neg)) + 
  geom_bar(stat="identity", alpha=0.8, color="black") +
  facet_wrap(~statename) +
  theme_steve_web() + post_bg() +
  scale_x_date(date_breaks = "1 year", date_minor_breaks = "1 month", date_labels = "%Y") +
  labs(title = "The 12-Month Difference in Manufacturing Jobs by State, January 2018 to December 2019",
       x = "",
       caption = "Data: U.S. Bureau of Labor Statistics, via Federal Reserve Bank of St. Louis",
       y = "12-month difference in manufacturing jobs (in thousands of persons)",
       subtitle = "Texas' shale boom, Florida's robust growth, and California's seasonal manufacturing cycle seem to prop up manufacturing job numbers. Elsewhere, other states are clearly struggling.") +
  theme(legend.position = "none")
```

![plot of chunk 12-month-difference-manufacturing-across-12-states](/images/12-month-difference-manufacturing-across-12-states-1.png)


