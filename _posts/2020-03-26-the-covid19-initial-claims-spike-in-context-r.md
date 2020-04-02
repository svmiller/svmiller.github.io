---
title: "The COVID-19 Initial Unemployment Claims Spike in Context"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2020-03-26'
excerpt: "The first data on COVID-19's effect on unemployment rates are out and... holy cow."
layout: post
categories:
  - R
image: "woman-mask-la-covid19.jpg"
---



{% include image.html url="/images/woman-mask-la-covid19.jpg" caption="A woman walks wearing a mask to protect herself from the novel coronavirus (COVID-19) in front of a closed theater in Koreatown, Los Angeles, on March 21, 2020. (AFP, GETTY IMAGES)" width=400 align="right" %}


*Last updated: April 02, 2020* 

The U.S. Employment and Training Administration released its weekly update on initial unemployment claims, giving us the first glimpse of the economic implications of the COVID-19 pandemic beyond [the fluctuation we're observing in the stock market](http://svmiller.com/blog/2020/03/dow-jones-no-good-very-bad-day/). And... [yikes](https://www.cnn.com/2020/03/26/economy/unemployment-benefits-coronavirus/index.html).

The data are grisly and some R code will illustrate that. First, here are the packages necessary to put this unemployment claims spike in context. `tidyverse` comes at the fore of my workflow. `stevemisc` is my toy R package, which incidentally has a data set on U.S. recessions (`recessions`) for added context. It should be no surprise that unemployment climbs during these periods. Finally, `fredr` interacts with the Federal Reserve Economic Data maintained by the research division of the Federal Reserve Bank of St. Louis. The API is the easiest and most flexible of any I've used and I wish the IMF's API were as simple. `lubridate` will help us play with dates.

```r
library(tidyverse)
library(stevemisc)
library(fredr)
library(lubridate)
```

The `fredr` call is simple. The initial unemployment claims data has [a series id of "ICSA"](https://fred.stlouisfed.org/series/ICSA) and the data extend to January 1967. Let's grab everything we can.

```r
fredr(series_id = "ICSA",
        observation_start = as.Date("1967-01-01")) -> ICSA
```

Here's what the data looked like before today.


```r
ICSA %>%
  filter(date <= ymd("2020-03-14")) %>%
  ggplot(.,aes(date, value/1000)) +
  theme_steve_web() + post_bg() +
  scale_x_date(date_breaks = "2 years",
               date_labels = "%Y",
               limits = as.Date(c('1965-01-01','2020-04-01'))) +
  geom_rect(data=filter(recessions,year(peak)>1966), inherit.aes=F, 
            aes(xmin=peak, xmax=trough, ymin=-Inf, ymax=+Inf), fill='darkgray', alpha=0.8) +
     geom_line() +
    geom_ribbon(aes(ymin=-Inf, ymax=value/1000),
              alpha=0.3, fill="#619CFF") +
  labs(title = "Initial Unemployment Claims From January 7, 1967 to March 14, 2020",
       subtitle = "Unemployment claims clearly rise during economic contractions with peaks observed during the early 1980s global recession and the Great Recession from 2007-2009.",
       x = "", y = "Unemployment Claims (in Thousands)",
       caption = "Data: U.S. Employment and Training Administration (initial claims), National Bureau of Economic Research (recessions).") 
```

![plot of chunk initial-claims-data-1967-before-covid19](/images/initial-claims-data-1967-before-covid19-1.png)

The peaks in the early 1980s and from 2007 to 2009 are immediately evident. Those periods coincided with global recessions in which the unemployment rate in the U.S. (calculated monthly) [exceeded 10% of the civilian labor force](https://fred.stlouisfed.org/series/UNRATE). 

Now, here's what the data look like as of today.


```r
ICSA %>%
  # change just one line
  filter(date <= ymd("2020-03-21"))  %>% # Commenting out just one line.
  ggplot(.,aes(date, value/1000)) +
  theme_steve_web() + post_bg() +
  scale_x_date(date_breaks = "2 years",
               date_labels = "%Y",
               limits = as.Date(c('1965-01-01','2020-04-01'))) +
  geom_rect(data=filter(recessions,year(peak)>1966), inherit.aes=F, 
            aes(xmin=peak, xmax=trough, ymin=-Inf, ymax=+Inf), fill='darkgray', alpha=0.8) +
     geom_line() +
    geom_ribbon(aes(ymin=-Inf, ymax=value/1000),
              alpha=0.3, fill="#619CFF") +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Initial Unemployment Claims From January 7, 1967 to March 21, 2020",
       subtitle = "The almost 3.3 million unemployment claims dwarfs the unemployment effects of the major recessions in the data.",
       x = "", y = "Unemployment Claims (in Thousands)",
       caption = "Data: U.S. Employment and Training Administration (initial claims), National Bureau of Economic Research (recessions).") 
```

![plot of chunk initial-claims-data-1967-first-week-of-covid19](/images/initial-claims-data-1967-first-week-of-covid19-1.png)

I'll come back and update this when the states roll out their updates, but it does have me thinking about this dire warning from the President of the Federal Reserve Bank of St. Louis.

<center>
<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">JUST IN: Fed&#39;s Bullard says U.S. unemployment rate may hit 30% in the second quarter <a href="https://t.co/kdy6npXQAS">https://t.co/kdy6npXQAS</a></p>&mdash; Bloomberg (@business) <a href="https://twitter.com/business/status/1241812970549755905?ref_src=twsrc%5Etfw">March 22, 2020</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></center>

Standardizing initial claims to the (growing) civilian labor force of the United States lends to some worry that estimate might be too low. Basically, the initial claims as a proportion of the civilian labor force, right now, is **four times** what it was at the peak of the Great Recession and the early 1980s recession. Therein, the unemployment rate was between 10-11%. The extent to which initial claims is a sneak peek of the monthly unemployment rate, 30% might be too low an estimate.

Alas, I'll defer to the President of the FRED's division in St. Louis. He'll know more than me. I just know how to play with the data that his research division releases.

### Update for April 2, 2020

*Gulp.*


```r
ICSA %>%
  # Omit the filter
  #filter(date <= ymd("2020-03-21"))  %>% # Commenting out just one line.
  ggplot(.,aes(date, value/1000)) +
  theme_steve_web() + post_bg() +
  scale_x_date(date_breaks = "2 years",
               date_labels = "%Y",
               limits = as.Date(c('1965-01-01','2020-04-01'))) +
  geom_rect(data=filter(recessions,year(peak)>1966), inherit.aes=F, 
            aes(xmin=peak, xmax=trough, ymin=-Inf, ymax=+Inf), fill='darkgray', alpha=0.8) +
     geom_line() +
    geom_ribbon(aes(ymin=-Inf, ymax=value/1000),
              alpha=0.3, fill="#619CFF") +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Initial Unemployment Claims From January 7, 1967 to the Present",
       subtitle = "The ongoing COVID-19 pandemic makes the initial claims spikes of the early 1980s and mid-2000s almost invisible.",
       x = "", y = "Unemployment Claims (in Thousands)",
       caption = "Data: U.S. Employment and Training Administration (initial claims), National Bureau of Economic Research (recessions).") 
```

![plot of chunk initial-claims-data-1967-starting-with-covid19](/images/initial-claims-data-1967-starting-with-covid19-1.png)

The state-level initial claims data also offer an insight to what COVID-19 has done to unemployment. These indicators seem to lag a week behind the national figures so the most recent national update for today (*gulp*) also comes with more insight to the jarring statistics released last week.

This script will grab the most current data for initial claims for all 50 states.

```r
# Initial claims data
stateclaimsabbs <- paste0(c(state.abb),"ICLAIMS")

sclaims <- tibble()

for (i in 1:length(stateclaimsabbs)) {
  fredr(series_id = stateclaimsabbs[i],
        observation_start = as.Date("1986-01-01")) -> hold_this
    bind_rows(sclaims, hold_this) -> sclaims
}
```

This will show which states were hit the hardest by the spate of unemployment claims starting last week. 

```r
sclaims %>%
  mutate(state = str_sub(series_id, 1, 2)) %>%
  group_by(state) %>%
  mutate(l1_value = lag(value, 1),
         diff = (value - l1_value)/l1_value,
         diff = diff*100) %>%
  slice(n()) %>%
  arrange(-diff)
```

<table id="stevetable">
<caption>COVID-19's First Effect on Unemployment Claims, by State</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> Rank </th>
   <th style="text-align:left;"> State </th>
   <th style="text-align:center;"> Initial Claims (March 21, 2020) </th>
   <th style="text-align:center;"> Initial Claims (March 14, 2020) </th>
   <th style="text-align:center;"> % Change </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:left;"> NH </td>
   <td style="text-align:center;"> 29379 </td>
   <td style="text-align:center;"> 642 </td>
   <td style="text-align:center;"> 4476.17% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:left;"> ME </td>
   <td style="text-align:center;"> 21459 </td>
   <td style="text-align:center;"> 634 </td>
   <td style="text-align:center;"> 3284.7% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> RI </td>
   <td style="text-align:center;"> 35847 </td>
   <td style="text-align:center;"> 1108 </td>
   <td style="text-align:center;"> 3135.29% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> LA </td>
   <td style="text-align:center;"> 72438 </td>
   <td style="text-align:center;"> 2255 </td>
   <td style="text-align:center;"> 3112.33% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:left;"> MN </td>
   <td style="text-align:center;"> 115773 </td>
   <td style="text-align:center;"> 4010 </td>
   <td style="text-align:center;"> 2787.11% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:left;"> OH </td>
   <td style="text-align:center;"> 196309 </td>
   <td style="text-align:center;"> 7046 </td>
   <td style="text-align:center;"> 2686.11% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:left;"> NC </td>
   <td style="text-align:center;"> 94083 </td>
   <td style="text-align:center;"> 3533 </td>
   <td style="text-align:center;"> 2562.98% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:left;"> PA </td>
   <td style="text-align:center;"> 377451 </td>
   <td style="text-align:center;"> 15439 </td>
   <td style="text-align:center;"> 2344.79% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:left;"> MI </td>
   <td style="text-align:center;"> 128006 </td>
   <td style="text-align:center;"> 5338 </td>
   <td style="text-align:center;"> 2298.01% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:left;"> IN </td>
   <td style="text-align:center;"> 59755 </td>
   <td style="text-align:center;"> 2596 </td>
   <td style="text-align:center;"> 2201.81% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:center;"> 10776 </td>
   <td style="text-align:center;"> 472 </td>
   <td style="text-align:center;"> 2183.05% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 12 </td>
   <td style="text-align:left;"> NM </td>
   <td style="text-align:center;"> 18105 </td>
   <td style="text-align:center;"> 869 </td>
   <td style="text-align:center;"> 1983.43% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:center;"> 148452 </td>
   <td style="text-align:center;"> 7449 </td>
   <td style="text-align:center;"> 1892.91% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 14 </td>
   <td style="text-align:left;"> NE </td>
   <td style="text-align:center;"> 15700 </td>
   <td style="text-align:center;"> 795 </td>
   <td style="text-align:center;"> 1874.84% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 15 </td>
   <td style="text-align:left;"> MT </td>
   <td style="text-align:center;"> 15349 </td>
   <td style="text-align:center;"> 817 </td>
   <td style="text-align:center;"> 1778.7% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 16 </td>
   <td style="text-align:left;"> IA </td>
   <td style="text-align:center;"> 40952 </td>
   <td style="text-align:center;"> 2229 </td>
   <td style="text-align:center;"> 1737.24% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:left;"> KY </td>
   <td style="text-align:center;"> 49023 </td>
   <td style="text-align:center;"> 2785 </td>
   <td style="text-align:center;"> 1660.25% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 18 </td>
   <td style="text-align:left;"> VA </td>
   <td style="text-align:center;"> 46277 </td>
   <td style="text-align:center;"> 2706 </td>
   <td style="text-align:center;"> 1610.16% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 19 </td>
   <td style="text-align:left;"> SC </td>
   <td style="text-align:center;"> 31826 </td>
   <td style="text-align:center;"> 2093 </td>
   <td style="text-align:center;"> 1420.59% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:left;"> UT </td>
   <td style="text-align:center;"> 19690 </td>
   <td style="text-align:center;"> 1305 </td>
   <td style="text-align:center;"> 1408.81% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 21 </td>
   <td style="text-align:left;"> NV </td>
   <td style="text-align:center;"> 92298 </td>
   <td style="text-align:center;"> 6356 </td>
   <td style="text-align:center;"> 1352.14% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 22 </td>
   <td style="text-align:left;"> TN </td>
   <td style="text-align:center;"> 38077 </td>
   <td style="text-align:center;"> 2702 </td>
   <td style="text-align:center;"> 1309.22% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 23 </td>
   <td style="text-align:left;"> ND </td>
   <td style="text-align:center;"> 5662 </td>
   <td style="text-align:center;"> 415 </td>
   <td style="text-align:center;"> 1264.34% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 24 </td>
   <td style="text-align:left;"> KS </td>
   <td style="text-align:center;"> 23563 </td>
   <td style="text-align:center;"> 1755 </td>
   <td style="text-align:center;"> 1242.62% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 25 </td>
   <td style="text-align:left;"> ID </td>
   <td style="text-align:center;"> 13586 </td>
   <td style="text-align:center;"> 1031 </td>
   <td style="text-align:center;"> 1217.75% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 26 </td>
   <td style="text-align:left;"> NJ </td>
   <td style="text-align:center;"> 115815 </td>
   <td style="text-align:center;"> 9467 </td>
   <td style="text-align:center;"> 1123.35% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 27 </td>
   <td style="text-align:left;"> OK </td>
   <td style="text-align:center;"> 21926 </td>
   <td style="text-align:center;"> 1836 </td>
   <td style="text-align:center;"> 1094.23% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 28 </td>
   <td style="text-align:left;"> FL </td>
   <td style="text-align:center;"> 74313 </td>
   <td style="text-align:center;"> 6463 </td>
   <td style="text-align:center;"> 1049.82% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 29 </td>
   <td style="text-align:left;"> MD </td>
   <td style="text-align:center;"> 42981 </td>
   <td style="text-align:center;"> 3864 </td>
   <td style="text-align:center;"> 1012.34% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:left;"> MO </td>
   <td style="text-align:center;"> 42246 </td>
   <td style="text-align:center;"> 4016 </td>
   <td style="text-align:center;"> 951.94% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 31 </td>
   <td style="text-align:left;"> IL </td>
   <td style="text-align:center;"> 114114 </td>
   <td style="text-align:center;"> 10870 </td>
   <td style="text-align:center;"> 949.81% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 32 </td>
   <td style="text-align:left;"> WI </td>
   <td style="text-align:center;"> 51031 </td>
   <td style="text-align:center;"> 5190 </td>
   <td style="text-align:center;"> 883.26% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 33 </td>
   <td style="text-align:left;"> TX </td>
   <td style="text-align:center;"> 155426 </td>
   <td style="text-align:center;"> 16176 </td>
   <td style="text-align:center;"> 860.84% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 34 </td>
   <td style="text-align:left;"> SD </td>
   <td style="text-align:center;"> 1761 </td>
   <td style="text-align:center;"> 190 </td>
   <td style="text-align:center;"> 826.84% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 35 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:center;"> 129909 </td>
   <td style="text-align:center;"> 14240 </td>
   <td style="text-align:center;"> 812.28% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 36 </td>
   <td style="text-align:left;"> CO </td>
   <td style="text-align:center;"> 19774 </td>
   <td style="text-align:center;"> 2321 </td>
   <td style="text-align:center;"> 751.96% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 37 </td>
   <td style="text-align:left;"> AZ </td>
   <td style="text-align:center;"> 29348 </td>
   <td style="text-align:center;"> 3844 </td>
   <td style="text-align:center;"> 663.48% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 38 </td>
   <td style="text-align:left;"> CT </td>
   <td style="text-align:center;"> 25100 </td>
   <td style="text-align:center;"> 3440 </td>
   <td style="text-align:center;"> 629.65% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 39 </td>
   <td style="text-align:left;"> WY </td>
   <td style="text-align:center;"> 3653 </td>
   <td style="text-align:center;"> 517 </td>
   <td style="text-align:center;"> 606.58% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 40 </td>
   <td style="text-align:left;"> OR </td>
   <td style="text-align:center;"> 30054 </td>
   <td style="text-align:center;"> 4269 </td>
   <td style="text-align:center;"> 604.01% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 41 </td>
   <td style="text-align:left;"> AK </td>
   <td style="text-align:center;"> 7847 </td>
   <td style="text-align:center;"> 1120 </td>
   <td style="text-align:center;"> 600.62% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 42 </td>
   <td style="text-align:left;"> AR </td>
   <td style="text-align:center;"> 9275 </td>
   <td style="text-align:center;"> 1382 </td>
   <td style="text-align:center;"> 571.13% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 43 </td>
   <td style="text-align:left;"> AL </td>
   <td style="text-align:center;"> 10892 </td>
   <td style="text-align:center;"> 1819 </td>
   <td style="text-align:center;"> 498.79% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 44 </td>
   <td style="text-align:left;"> VT </td>
   <td style="text-align:center;"> 3784 </td>
   <td style="text-align:center;"> 659 </td>
   <td style="text-align:center;"> 474.2% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 45 </td>
   <td style="text-align:left;"> NY </td>
   <td style="text-align:center;"> 79999 </td>
   <td style="text-align:center;"> 14272 </td>
   <td style="text-align:center;"> 460.53% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 46 </td>
   <td style="text-align:left;"> HI </td>
   <td style="text-align:center;"> 8815 </td>
   <td style="text-align:center;"> 1589 </td>
   <td style="text-align:center;"> 454.75% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 47 </td>
   <td style="text-align:left;"> MS </td>
   <td style="text-align:center;"> 5519 </td>
   <td style="text-align:center;"> 1147 </td>
   <td style="text-align:center;"> 381.17% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 48 </td>
   <td style="text-align:left;"> WV </td>
   <td style="text-align:center;"> 3536 </td>
   <td style="text-align:center;"> 865 </td>
   <td style="text-align:center;"> 308.79% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 49 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:center;"> 186333 </td>
   <td style="text-align:center;"> 57606 </td>
   <td style="text-align:center;"> 223.46% </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 50 </td>
   <td style="text-align:left;"> GA </td>
   <td style="text-align:center;"> 12140 </td>
   <td style="text-align:center;"> 5445 </td>
   <td style="text-align:center;"> 122.96% </td>
  </tr>
</tbody>
</table>


Basically, every state was rocked, some more than others. New Hampshire saw the largest increase from March 14 to March 21. Only 642 people in New Hampshire filed a new jobless claim in the March 14 update. That number skyrocketed to 29,379 in the March 21 update. That is a change of over 4,476 percent. There are four curious states at the bottom: Mississippi, West Virginia, California, and Georgia. To be clear, all four had massive increases from the previous week, all at least doubling from the previous week. West Virginia and Mississippi even tripled. However, California stands out as taking more proactive measures quicker than the other three states, which might suggest worse is yet to come for states like Mississippi and Georgia. For example, [Mississippi's governor rejected calls for a lockdown](https://www.jacksonfreepress.com/news/2020/mar/23/governor-rejects-state-lockdown-covid-19-mississip/) on March 23 by claiming the state will "never be China" on the COVID-19 front. Now, it has [the country's highest hospitalization rate for COVID-19](https://mississippitoday.org/2020/04/01/mississippi-has-nations-highest-covid-19-hospitalization-rate/). Georgia's governor [similarly downplayed COVID-19](https://www.vanityfair.com/news/2020/04/georgias-governor-apparently-just-learned-how-coronavirus-works) before finally [rolling out a shelter-in-place order](https://www.gpbnews.org/post/georgia-coronavirus-updates-kemp-orders-shelter-place). The economic consequences of these later measures we're seeing in the Deep South may manifest in subsequent updates.


