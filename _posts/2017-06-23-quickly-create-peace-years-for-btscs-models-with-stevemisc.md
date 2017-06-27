---
title: "Quickly Create Peace Years for BTSCS Models with sbtscs in stevemisc"
author: steve
layout: post
date: "2017-06-26"
permalink:
categories:
  - R
excerpt: "I have my first attempt at an R package, stevemisc, available on my github. It can help you quickly generate peace years for BTSCS models."
---



Scholars may find themselves needing to control for temporal dependence in their analysis of event data. International relations scholars know this problem well. It arises when the likelihood of an event occurring---prominently: a militarized interstate dispute (MID) in the IR literature---depends, in part, on the time since the last event. Longer "peace spells" beget a decreasing likelihood of the onset of a MID whereas short "peace spells" make states more prone to another MID onset. Contrast India-Pakistan with, say, USA-Canada.

Dave Armstrong's `DAMisc` package provides a useful function for creating these peace years, but my own research encounters problems with implementation. Both are related. One, the function is slow when used on a large data set. The time to estimate increases noticeably with larger data frames that get into the hundreds of thousands. 

Further, it throws an error---and I don't know why---when a lot of cross-sectional units don't have an event onset. Scholars who work with Correlates of War data know this problem well. It's the "rare event" problem that confounds simple maximum likelihood estimation. In a "politically relevant" sampling frame, MIDs still occur less than 5% of the time. If, for some reason, you want to flood your sampling frame with politically irrelevant cross-sections (e.g. Mongolia-Nigeria, Belize-Botswana), the data get into the hundreds of thousands and the likelihood of an event dips to around .5% of the data. This comment is more a critique of our most commonly used event data in international relations than it is of the `btscs` function, but many "peace science" folks in our discipline will still encounter this problem.

This leads to some frustrating coding problems. The `btscs` function is slow to run and will sometimes throw an error when a large number of cross-sections don't have events. I created my `sbtscs` function, for which I fully confess I liberally copied a large part of Dave Armstrong's code, for my own research. You may find it useful too.

Let me first note some of the problems I routinely encounter when trying to create peace-years in R. First, here's the `btscs` function in the `DAMisc` package. Observe what happens when I try to run it on a non-directed, politically-irrelevant dyad-year sampling frame of the Gibler-Miller-Little (GML) MID data.




```r
library(DAMisc)
library(RCurl)
library(tidyverse)

data <- getURL("https://raw.githubusercontent.com/svmiller/gml-mid-data/master/gml-ndy.csv")
NDY <- read.csv(text = data) %>% tbl_df()

NDY %>%
    mutate(midongoing = ifelse(is.na(midongoing),0, 1),
           midonset = ifelse(is.na(midonset), 0, 1),
           dyad = as.numeric(paste0("1",sprintf("%03d", ccode1), 
                                    sprintf("%03d", ccode2)))) %>%
    arrange(dyad,year) %>%
    select(ccode1, ccode2, dyad, year, midongoing, midonset, dispnum3) %>%
  as.data.frame() -> NDY

# this_wont_work <- btscs(NDY, "midongoing", "year", "dyad")
#  Error in if (x[j] == 0 & x[(j - 1)] == 0) { : 
# missing value where TRUE/FALSE needed 
```

My `sbtscs` (vainly: steve's btscs function) will run, and run pretty quick.


```r
library(stevemisc)
NDYpy <- sbtscs(NDY, midongoing, year, dyad) %>% tbl_df()
head(NDYpy)
```

```
## # A tibble: 6 x 8
##   ccode1 ccode2    dyad  year midongoing midonset dispnum3 spell
##    <int>  <int>   <dbl> <int>      <dbl>    <dbl>    <int> <dbl>
## 1      2     20 1002020  1920          0        0       NA     0
## 2      2     20 1002020  1921          0        0       NA     1
## 3      2     20 1002020  1922          0        0       NA     2
## 4      2     20 1002020  1923          0        0       NA     3
## 5      2     20 1002020  1924          0        0       NA     4
## 6      2     20 1002020  1925          0        0       NA     5
```

Further, there is a major speed advantage to `sbtscs` since it leans on `dplyr` to handle the cross-sections without events.


```r
NDY %>% filter(ccode1 <= 110) -> Guyana1

system.time(PY1 <- sbtscs(Guyana1, midongoing, year, dyad))
```

```
##    user  system elapsed 
##   1.143   0.042   1.189
```

```r
system.time(PY2 <- btscs(Guyana1, "midongoing", "year", "dyad"))
```

```
##    user  system elapsed 
##   12.85   13.57   26.53
```

```r
identical(PY1$spell, PY2$spell)
```

```
## [1] TRUE
```

Feel free to yell at me on [my Github](https://github.com/svmiller). Whereas this is my first hack at programming, I'm all-ears for feedback.
