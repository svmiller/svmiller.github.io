---
title:  “fReE sTuFf fRoM tHe gOvErnMeNt dOeS nOt pLaY wElL iN tHe mIdWeSt”
author: "steve"
date: '2019-07-31'
excerpt: "'Free stuff from the government' actually plays really well in the Midwest, Claire."
layout: post
permalink: null
categories:
  - R
  - Political Science
images: mocking-spongebob.jpg
---





I love waking up to a good 🚮 take in the morning.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">“Free stuff from the government does not play well in the Midwest.” -Claire McCaskill<br><br>1) <a href="https://twitter.com/RashidaTlaib?ref_src=twsrc%5Etfw">@RashidaTlaib</a> + <a href="https://twitter.com/IlhanMN?ref_src=twsrc%5Etfw">@IlhanMN</a> are also from the Midwest.<br><br>2) Medicare and Social Security are both technically “free stuff” and they play very well.<a href="https://t.co/tkFtRoI0W7">pic.twitter.com/tkFtRoI0W7</a></p>&mdash; Waleed Shahid (@_waleedshahid) <a href="https://twitter.com/_waleedshahid/status/1156437346830696448?ref_src=twsrc%5Etfw">July 31, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<!-- {% include image.html url="/images/mocking-spongebob.jpg" caption="Claire..." width=410 align="right" %} -->

Anyone with any experience analyzing the General Social Survey (GSS) data knows this is nonsense. I thought I'd take this opportunity to test run something I'd like to do more on my website: better integrate my R analyses and my graphs into my blog within the [`servr`](https://github.com/yihui/servr) framework.

I'll start by loading my R serialized data frame version of the longitudinal GSS data. In particular, I'll be looking at two questions that have been asked continuously throughout almost the entire duration of the data. The first probes a respondent to think whether [improving the nation's health](https://gssdataexplorer.norc.org/variables/183/vshow) receives too little spending, too much spending, or just the right amount of spending. The second probes the respondent to think say whether [Social Security](https://gssdataexplorer.norc.org/variables/193/vshow) receives too little, too much spending, or just the right amount of spending. From there, a few lines in the tidyverse will produce a graph that shows Claire McCaskill has no idea what she's talking about.

First, let's load the data from my `data` directory, following the two packages on which I lean the most to do any kind of statistical analysis.

```r
library(tidyverse)
library(stevemisc)

GSS <- readRDS("~/Dropbox/data/gss/GSS_spss-2018/gss7218.rds")
```

Then, let's create a data frame from that gets the main stuff we want to highlight if the former U.S. Senator from Missouri is blowing hot air.


```r
GSS %>%
  mutate(regioncondensed = NA,
         regioncondensed = ifelse(region == 8 | region == 9, "West", regioncondensed),
         regioncondensed = ifelse(region == 3 | region == 4, "Midwest", regioncondensed),
         regioncondensed = ifelse(region == 5 | region == 6 | region == 7, "South", regioncondensed),
         regioncondensed = ifelse(region == 1 | region == 2, "Northeast", regioncondensed),
         pid3 = ifelse(partyid %in% c(0, 1,2), "Democrat/Leans Democrat", NA),
         pid3 = ifelse(partyid == 3, "Independent", pid3),
         pid3 = ifelse(partyid %in% c(4,5,6), "Republican/Leans Republican", pid3)) %>%
  select(year, pid3, regioncondensed, natheal, natsoc) %>%
  mutate(nathealtm = carr(natheal, "1:2=0; 3=1"),
         natsoctm = carr(natsoc, "1:2=0; 3=1"),
         nathealtl = carr(natheal, "2:3=0; 1=1"),
         natsoctl = carr(natsoc, "2:3=0; 1=1"),) -> McCaskill
```

From there, a few lines of R code will show that only about five percent of Americans in any region, let alone the Midwest, thinks that the U.S. spends too much on health care or Social Security. Don't misunderstand there's a clear spike in 2010 for the health care item. That's ultimately a post-Obamacare freakout among voters that we know coincided with the rise of the "Tea Party" that rolled into Congress to the detriment of the Democratic majority in the House.


```r
McCaskill %>%  
  group_by(regioncondensed, year) %>%
  summarize(perchealtm = mean(nathealtm, na.rm=T),
            percsoctm = mean(natsoctm, na.rm=T)) %>% 
  group_by(regioncondensed, year) %>%
  gather(Category, value, 3:4) %>% 
  mutate(Category = ifelse(Category == "perchealtm",
                           "Spending Too Much on Health Care",
                           "Spending Too Much on Social Security")) %>%
  ggplot(.,aes(year, value, color=Category, linetype=Category)) +
  theme_steve_web() +
  geom_line(size=1.1) + facet_wrap(~regioncondensed) +
  scale_y_continuous(labels=scales::percent) +
  scale_x_continuous(breaks = seq(1970, 2020, by=4)) +
  scale_color_brewer(palette="Set1") +
  labs(x = "Year",
       y = "Percent of Respondents in a Given Year Who Think the U.S. is Spending Too Much on this Public Good",
       title = "Only About Five Percent of Americans, by Region, Think the U.S. Spends Too Much on Health Care and Social Security",
       subtitle = "Unsurprisingly, the spikes on the health care item in 2010 are entirely Obamacare freakouts that propelled the Tea Party to power.",
       caption = "Data: General Social Survey, 1972-2018")
```

![plot of chunk gss7218-too-much-spending-health-care-social-security](/images/gss7218-too-much-spending-health-care-social-security-1.png)

Further, you can look at this from the perspective of another response of interest: those who think that the government is spending too little on health care or Social Security. Therein, roughly 60-70% of Americans, no matter the region, think the U.S. is spending too little on health care and Social Security.


```r
McCaskill %>%  
  group_by(regioncondensed, year) %>%
  summarize(perchealtl = mean(nathealtl, na.rm=T),
            percsoctl = mean(natsoctl, na.rm=T)) %>% 
  group_by(regioncondensed, year) %>%
  gather(Category, value, 3:4) %>%
  mutate(Category = ifelse(Category == "perchealtl",
                           "Spending Too Little on Health Care",
                           "Spending Too Little on Social Security")) %>%
  ggplot(.,aes(year, value, color=Category, linetype=Category)) +
  theme_steve_web() +
  geom_line(size=1.1) + facet_wrap(~regioncondensed) +
  scale_y_continuous(labels=scales::percent) +
  scale_x_continuous(breaks = seq(1970, 2020, by=4)) +
  scale_color_brewer(palette="Set1") +
  labs(x = "Year",
       y = "Percent of Respondents in a Given Year Who Think the U.S. is Spending Too Little on this Public Good",
       title = "About 60-70% of Americans, by Region, Think the U.S. Spends Too Little on Health Care and Social Security",
       subtitle = "Unsurprisingly, the dips on the health care item in 2010 are entirely Obamacare freakouts that propelled the Tea Party to power.",
       caption = "Data: General Social Survey, 1972-2018")
```

![plot of chunk gss7218-too-little-spending-health-care-social-security](/images/gss7218-too-little-spending-health-care-social-security-1.png)

For something a bit more interesting, we can subset the data to just those respondents in the Midwest and look at the responses of "too little" on this metric. Here, the plots are faceted instead by partisanship on three categories: those who are Democrats or independents (but lean to the Democrats), pure independents, and Republicans (including independent leaners). 

The story remains the same. There's clear partisan variation. Democrats are more enthusiastic than Republicans about ~~public goods~~ sorry, "free stuff from the government", but it's clear that Republicans think the U.S. is spending too little on Social Security and health care. Over 50% of Republicans seem to want more government spending on social programs than typical boilerplate centrist talking points seem to care to admit.


```r
McCaskill %>%  
    filter(regioncondensed == "Midwest") %>%
    group_by(year, pid3) %>% 
    summarize(perchealtl = mean(nathealtl, na.rm=T),
              percsoctl = mean(natsoctl, na.rm=T)) %>%
    filter(!is.na(pid3)) %>%
    group_by(year, pid3) %>%
    gather(Category, value, 3:4) %>%
    mutate(Category = ifelse(Category == "perchealtl",
                             "Spending Too Little on Health Care",
                             "Spending Too Little on Social Security")) %>%
    ggplot(.,aes(year, value, color=Category, linetype=Category)) +
    theme_steve_web() + facet_wrap(~pid3) +
    geom_hline(yintercept = .5, linetype="dashed") +
    geom_line(size=1.1) +
    scale_y_continuous(labels=scales::percent, breaks = c(.3, .4, .5, .6, .7, .8)) +
    scale_x_continuous(breaks = seq(1970, 2020, by=5)) +
    scale_color_brewer(palette="Set1") +
    labs(x = "Year",
         y = "Percent of Midwestern Respondents in a Given Year Who Think the U.S. is Spending Too Little on this Public Good",
         title = "More than 50% of Midwesterners, No Matter Partisanship, Think the U.S. is Spending Too Little on Health Care and Social Security",
         subtitle = "There's a clear partisan difference and Democrats seem to prioritize health care over Social Security.",
         caption = "Data: General Social Survey, 1972-2018")
```

![plot of chunk gss7218-too-little-spending-health-care-social-security-midwest-pid](/images/gss7218-too-little-spending-health-care-social-security-midwest-pid-1.png)

That the bulk of the Midwest has a bent toward the Republican Party says little about the preference of Midwesterners for public goods and social welfare. The majority of Republican voters oppose the core fiscal aims of the Republican Party for social welfare programs, and [this is not new or novel insight](http://svmiller.com/graphs/issp-2016-partisanship-social-spending.pdf). Hamilton Nolan's comment that [the GOP is a parlor trick](https://gawker.com/the-republican-party-is-a-trick-1750147430) resonates well here. Instead, the votes Midwesterners cast en masse for the Republican Party should say more about the other priorities their voters may have and what the GOP promises them despite GOP voters apparent misgivings with the GOP's fiscal policies.
