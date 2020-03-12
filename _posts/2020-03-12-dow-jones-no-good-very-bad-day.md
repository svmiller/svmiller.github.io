---
title: "The Dow Jones' No Good, Very Bad Day, in R Code"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2020-03-12'
excerpt: "Here is some R code contextualizing the Dow Jones' recent slide, because gallows humor is the only thing that keeps me warm at night."
layout: post
categories:
  - R
image: "dow-jones-dude.jpg"
---



{% include image.html url="/images/dow-jones-dude.jpg" caption="That feeling when you realize you're not going to retire until your 70s. (Photo: Spencer Platt/Getty Images)" width=400 align="right" %}

[What he said](https://knowyourmeme.com/memes/shits-on-fire-yo).

Anyway, I'm of the mentality that reading too much into large nominal numbers in the Dow Jones Industrial Average is a fool's errand. The U.S. is absolutely wealthier on the balance now than it was at almost every other point in the Dow Jones' history. It means gains in nominal numbers will be larger. Losses in nominal numbers will be larger as well. 

That said, the Dow Jones' day today was clearly no good, and very bad. You can contextualize that with some basic R code.

First, [my `stevemisc` package](https://github.com/svmiller/stevemisc) has Dow Jones Industrial Average data dating all the way to 1885 in the data frame `DJIA`. I updated it not long ago to include the end of 2019. I haven't added any 2020 observations to it yet, but that is easy to grab with the `quantmod` package. As of writing, the data for March 12, 2020 haven't been loaded yet. However, the close right now is reported at 21,200.62 for today. We can impute that simply.

```r
library(stevemisc)
library(tidyverse)
library(lubridate)
library(quantmod)

getSymbols("^DJI", src="yahoo", from= as.Date("2020-01-01"))

DJI %>% data.frame %>%
  rownames_to_column() %>% tbl_df() %>%
  rename(date = rowname,
         djia = DJI.Close) %>%
  mutate(date = as_date(date)) %>%
  select(date, djia)  -> QDJI

bind_rows(DJIA, QDJI) %>%
  bind_rows(.,tibble(date=as_date("2020-03-12"),
                     djia = 21200.62)) -> DJIA
```

Here would be the worst single-day losses as a percentage loss from the previous trading day's close.


```r
DJIA %>%
  arrange(date) %>%
  mutate(l1_djia = lag(djia, 1),
         percchange = round(((djia - lag(djia,1))/lag(djia, 1))*100, 2)) %>%
  arrange(percchange) %>% head(10) %>%
 kable(., format="html", table.attr='id="stevetable"',
        col.names=c("Date", "DJIA (Close)", "DJIA (Close, Previous)", "% Change"),
        caption = "The Ten Worst Trading Days in Dow Jones History, 1885-2020",
        align=c("l","c","c","c"))
```

<table id="stevetable">
<caption>The Ten Worst Trading Days in Dow Jones History, 1885-2020</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Date </th>
   <th style="text-align:center;"> DJIA (Close) </th>
   <th style="text-align:center;"> DJIA (Close, Previous) </th>
   <th style="text-align:center;"> % Change </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1987-10-19 </td>
   <td style="text-align:center;"> 1738.7400 </td>
   <td style="text-align:center;"> 2246.7400 </td>
   <td style="text-align:center;"> -22.61 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-10-28 </td>
   <td style="text-align:center;"> 260.6400 </td>
   <td style="text-align:center;"> 298.9700 </td>
   <td style="text-align:center;"> -12.82 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-10-29 </td>
   <td style="text-align:center;"> 230.0700 </td>
   <td style="text-align:center;"> 260.6400 </td>
   <td style="text-align:center;"> -11.73 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-12 </td>
   <td style="text-align:center;"> 21200.6200 </td>
   <td style="text-align:center;"> 23553.2207 </td>
   <td style="text-align:center;"> -9.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-11-06 </td>
   <td style="text-align:center;"> 232.1300 </td>
   <td style="text-align:center;"> 257.6800 </td>
   <td style="text-align:center;"> -9.92 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1899-12-18 </td>
   <td style="text-align:center;"> 42.6865 </td>
   <td style="text-align:center;"> 46.7669 </td>
   <td style="text-align:center;"> -8.72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1895-12-20 </td>
   <td style="text-align:center;"> 29.4223 </td>
   <td style="text-align:center;"> 32.1601 </td>
   <td style="text-align:center;"> -8.51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1932-08-12 </td>
   <td style="text-align:center;"> 63.1100 </td>
   <td style="text-align:center;"> 68.9000 </td>
   <td style="text-align:center;"> -8.40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1907-03-14 </td>
   <td style="text-align:center;"> 55.8434 </td>
   <td style="text-align:center;"> 60.8908 </td>
   <td style="text-align:center;"> -8.29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1987-10-26 </td>
   <td style="text-align:center;"> 1793.9300 </td>
   <td style="text-align:center;"> 1950.7600 </td>
   <td style="text-align:center;"> -8.04 </td>
  </tr>
</tbody>
</table>

Here's where the five worst losses since 2017 rank all-time.


```r
DJIA %>%
  arrange(date) %>%
  mutate(l1_djia = lag(djia, 1),
         percchange = ((djia - lag(djia,1))/lag(djia, 1))*100) %>%
  arrange(percchange) %>%
  mutate(rank = seq(1:n())) %>%
  filter(year(date) >= 2017) %>%
  head(5) %>%
  mutate(percchange = round(percchange, 2)) %>%
   kable(., format="html", table.attr='id="stevetable"',
        col.names=c("Date", "DJIA (Close)", "DJIA (Close, Previous)", "% Change", "Rank Among Worst All-Time"),
        caption = "The Five Worst Trading Days Since 2017, Ranked to All-Time Worst Days",
        align=c("l","c","c","c","c"))
```

<table id="stevetable">
<caption>The Five Worst Trading Days Since 2017, Ranked to All-Time Worst Days</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Date </th>
   <th style="text-align:center;"> DJIA (Close) </th>
   <th style="text-align:center;"> DJIA (Close, Previous) </th>
   <th style="text-align:center;"> % Change </th>
   <th style="text-align:center;"> Rank Among Worst All-Time </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2020-03-12 </td>
   <td style="text-align:center;"> 21200.62 </td>
   <td style="text-align:center;"> 23553.22 </td>
   <td style="text-align:center;"> -9.99 </td>
   <td style="text-align:center;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-09 </td>
   <td style="text-align:center;"> 23851.02 </td>
   <td style="text-align:center;"> 25864.78 </td>
   <td style="text-align:center;"> -7.79 </td>
   <td style="text-align:center;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-11 </td>
   <td style="text-align:center;"> 23553.22 </td>
   <td style="text-align:center;"> 25018.16 </td>
   <td style="text-align:center;"> -5.86 </td>
   <td style="text-align:center;"> 42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018-02-05 </td>
   <td style="text-align:center;"> 24345.75 </td>
   <td style="text-align:center;"> 25520.96 </td>
   <td style="text-align:center;"> -4.60 </td>
   <td style="text-align:center;"> 106 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-02-27 </td>
   <td style="text-align:center;"> 25766.64 </td>
   <td style="text-align:center;"> 26957.59 </td>
   <td style="text-align:center;"> -4.42 </td>
   <td style="text-align:center;"> 116 </td>
  </tr>
</tbody>
</table>

This is fine.


