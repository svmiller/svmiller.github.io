---
title: "Define Your Own Population; Make Your Own Special Data"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2025-01-24'
excerpt: "Be deliberate in defining your population. It doesn't take much code to create a panel or time-series, but you have to be deliberate in defining your population."
layout: post
categories:
  - Teaching
  - R
image: "pedro-pascal-make-your-own-kind-of-music-meme-crop.jpeg"
active: blog
---



<div class="announcement-box" markdown = "1">
<!-- <div id="focusbox" markdown = "1"> -->


## I Have Other Musings on This That I Want My Students to Read ⤵️

Spiritually, this post is identical to [one more focused on creating dyad- or state-year data](https://svmiller.com/blog/2019/01/create-country-year-dyad-year-from-country-data/) for analyses of international conflict. [`{peacesciencer}` talks a little bit about this](https://svmiller.com/peacesciencer/articles/different-data-types.html) as well. Likewise, I'm assuming some familiarity with state classification systems, which I talk about a bit [on my blog](https://svmiller.com/blog/2021/01/a-tutorial-on-state-classification-systems/) and [for `{peacesciencer}`](https://svmiller.com/peacesciencer/articles/state-systems.html). Wouldn't you know it but my blog has other things for my students to read about [merging data](https://svmiller.com/blog/2021/01/a-tutorial-on-the-join-family-in-r/). [`{peacesciencer}` also talks about this](https://svmiller.com/peacesciencer/articles/joins.html), albeit in a more narrow context.

</div>


{% include image.html url="/images/pedro-pascal-make-your-own-kind-of-music-meme-crop.jpeg" caption="Note quite, but same energy for a lead image. Hot #take: the Bobby Sherman bubblegum pop cover is better." width=425 align="right" %}

<!-- *Last updated: 24 January 2025.*  -->

The idea for this post comes from an uncomfortable encounter with a student recently. The student in question proposed that they were doing a time-series analysis of a country from something like 2000 to 2023. The data were purportedly yearly. They reported an N in their model of over 5,000 observations. That obviously can't be right, but understanding what is "right" may not be so straightforward for students who are leaning on data sets they download to think of their population for them. Let he who is without sin cast the first stone; I was a graduate student myself once. However, the more seasoned I've become with this stuff, the more I've appreciated that taking control of this stuff---with code---is going to make your life a lot easier as a researcher. It'll also, hopefully, help the professor (this professor) avoid the discomfort of having to ask the student why an N of 24 suddenly became an N of over 5,000. Did something go horribly wrong in the merge process, and/or did the left hand not know what the right hand was doing? If you don't know, I'll have to ask. 

This is something of a quick hitter, because I'm repeating myself a fair bit. Here's a table of contents.

1. [What is a "Population" in this Context?](#population)
2. [What's My Population?](#mine)
3. [How Do I Create My Data?](#createdata)
    - [Creating a Panel of State-Years](#stateyears)
    - [Creating a Panel of State-Quarter or State-Months](#statequarters)
    - [Creating a Panel of State-Days](#statedays)
4. [Conclusion: Why Does This Matter?](#conclusion)

Here are the R packages we'll be using. Importantly, `{stevedata}` version 1.5.0 is in development and has the `wb_groups` data that will feature prominently here.

```r
library(tidyverse)
library(stevedata) # forthcoming, v. 1.5.0
library(peacesciencer)
library(WDI)
```

Alrightie, let's get going.

## What is a "Population" in this Context? {#population}

Students for whom this is applicable will probably remember their professor (me) teaching them about how inference is made from a sample to a population. The population parameter might be unknowable in the real world, but our statistical tools make inferential claims by way of ruling out things as incompatible with the data. In the classic case, the population is the thing we want to know about based on samples of it.

The "population" in this context isn't referring to something wholly different, per se, but it's different. Instead, the "population" in this context is the universe of relevant cases we want to describe. If, say, the goal is to make inferences about the five Nordic countries, then the "population" is Sweden, Norway, Finland, Iceland, and Denmark. That population is five units. If, say, the goal is to make inferences about South Asia, then the "population" (per World Bank classifications) is Afghanistan, Bangladesh, Bhutan, India, Maldives, Nepal, Pakistan, and Sri Lanka. That population is eight units. Perhaps missing data creates a subset of that population (i.e. maybe we don't have data on something for Maldives), or we might be interested in just the Scandinavian part of the Nordic countries (which would exclude Finland). 

However, that means the size of the population decreases for these reasons, and never increases. **Your "population" should never increase in your data**.[^bang] Please keep that in mind.

[^bang]: You can obviously toggle this a bit if there is sufficient weirdness in your population. For example, Bangladesh was an exclave of Pakistan before[ a war of liberation](https://en.wikipedia.org/wiki/Bangladesh_Liberation_War) (with assistance from India) created it in December 1971. Thus, there would be no Bangladesh in 1970, but there would be a Bangladesh for about 15 days in 1971. However, that "weirdness" only manifests when we've included a temporal component to how we understand the "population".

This part is simple, certainly for bite-sized "populations" like this. There is an added wrinkle when there is a temporal component to the population. The "population" is observed over some repeated interval of time. For a lot of international relations applications, this is yearly. There is a Sweden in 2020 and a Sweden in 2021. There is an India-Pakistan dyad in 1970 and an India-Pakistan dyad in 1971. Perhaps the most abstract sense, the "population" is unchanged but the underlying data aren't unchanged. Our unit of analysis from this population has changed from "thing" (i.e. states) to "thing-time" (e.g. state-year, state-quarter). 

We need to be super mindful about what that means for the data we're ultimately going to have. It seems daunting, but it really isn't. You just have to know what you're doing and take control over your data-generating process that comes from this.

## What's My Population? {#mine}

I don't know; you tell me.

No, seriously, you tell me and we can proceed from there. I have a suite of data sets in either `{peacesciencer}` or `{stevedata}` that can help you with this. For example, if you were interested in the universe ("population") of Correlates of War states, you can get that from the Correlates of War project (or in `{peacesciencer}`):


``` r
cow_states
#> # A tibble: 243 × 10
#>    stateabb ccode statenme  styear stmonth stday endyear endmonth endday version
#>    <chr>    <dbl> <chr>      <dbl>   <dbl> <dbl>   <dbl>    <dbl>  <dbl>   <dbl>
#>  1 USA          2 United S…   1816       1     1    2016       12     31    2016
#>  2 CAN         20 Canada      1920       1    10    2016       12     31    2016
#>  3 BHM         31 Bahamas     1973       7    10    2016       12     31    2016
#>  4 CUB         40 Cuba        1902       5    20    1906        9     25    2016
#>  5 CUB         40 Cuba        1909       1    23    2016       12     31    2016
#>  6 HAI         41 Haiti       1859       1     1    1915        7     28    2016
#>  7 HAI         41 Haiti       1934       8    15    2016       12     31    2016
#>  8 DOM         42 Dominica…   1894       1     1    1916       11     29    2016
#>  9 DOM         42 Dominica…   1924       9    29    2016       12     31    2016
#> 10 JAM         51 Jamaica     1962       8     6    2016       12     31    2016
#> # ℹ 233 more rows
```

The data here suggest we have a population of 243 cases... except we don't. Do you see from the output that we have duplicate entries for [Cuba](https://en.wikipedia.org/wiki/Provisional_Government_of_Cuba), [Haiti](https://en.wikipedia.org/wiki/United_States_occupation_of_Haiti), and [the Dominican Republic](https://en.wikipedia.org/wiki/Military_Government_of_Santo_Domingo) in the first 10 rows?  Those emerge as artifacts of the United States temporarily eliminating those states by occupying them for a stretch of several years before leaving, which then results in those states reappearing in the state system. You can helpfully see those dates communicated in the data, but it does mean there is an implicit time component in these data. If you wanted the true size of the population, irregarding time, you'd want to subset to unique Correlates of War state codes like this.


``` r
cow_states %>% slice(1, .by=ccode)
#> # A tibble: 217 × 10
#>    stateabb ccode statenme  styear stmonth stday endyear endmonth endday version
#>    <chr>    <dbl> <chr>      <dbl>   <dbl> <dbl>   <dbl>    <dbl>  <dbl>   <dbl>
#>  1 USA          2 United S…   1816       1     1    2016       12     31    2016
#>  2 CAN         20 Canada      1920       1    10    2016       12     31    2016
#>  3 BHM         31 Bahamas     1973       7    10    2016       12     31    2016
#>  4 CUB         40 Cuba        1902       5    20    1906        9     25    2016
#>  5 HAI         41 Haiti       1859       1     1    1915        7     28    2016
#>  6 DOM         42 Dominica…   1894       1     1    1916       11     29    2016
#>  7 JAM         51 Jamaica     1962       8     6    2016       12     31    2016
#>  8 TRI         52 Trinidad…   1962       8    31    2016       12     31    2016
#>  9 BAR         53 Barbados    1966      11    30    2016       12     31    2016
#> 10 DMA         54 Dominica    1978      11     3    2016       12     31    2016
#> # ℹ 207 more rows
```

Thus, we have 217 unique states that have ever existed in the population/universe of Correlates of War states.[^gw] If you use `create_stateyears()` in that package, you'll get that information processed for you in creating state-year data.

[^gw]: You are welcome to read about [some of the peculiarities of this state classification system](https://svmiller.com/peacesciencer/articles/state-systems.html), though it is ubiquitous in the study of inter-state conflict. By far the biggest open questions would concern cases like Germany, Yugoslavia/Serbia, and Yemen. I riff on those a little bit on `{peacesciencer}` and what are the implications of those cases.

Almost none of my students (unfortunately 😢) are interested in the kinds of conflict analyses I've done or typically read, but are generally interested in panel models or time series data that might lean on data made available by the World Bank. However, the World Bank is generous to the point of too generous with the data it makes available. Sometimes a student is really interested in low-income countries, or some geographical region. If you're not explicit with `{WDI}` in grabbing data from the World Bank, [it will grab *everything* for you](https://svmiller.com/blog/2024/10/make-simple-cross-sectional-world-bank-data-wdi/). It's understandable that it does that, because you didn't give it guidance about what to include or exclude.

This would be a good time to [read about the assorted classification systems the World Bank employs](https://datahelpdesk.worldbank.org/knowledgebase/articles/906519-world-bank-country-and-lending-groups). I have a version of these data in `{stevedata}` (forthcoming v. 1.5.0) as `wb_groups`. Here, you can see what are the assorted classification systems and what states are in them.


``` r
wb_groups
#> # A tibble: 2,085 × 4
#>    wbgc  wbgn                        iso3c name            
#>    <chr> <chr>                       <chr> <chr>           
#>  1 AFE   Africa Eastern and Southern AGO   Angola          
#>  2 AFE   Africa Eastern and Southern BWA   Botswana        
#>  3 AFE   Africa Eastern and Southern BDI   Burundi         
#>  4 AFE   Africa Eastern and Southern COM   Comoros         
#>  5 AFE   Africa Eastern and Southern COD   Congo, Dem. Rep.
#>  6 AFE   Africa Eastern and Southern ERI   Eritrea         
#>  7 AFE   Africa Eastern and Southern SWZ   Eswatini        
#>  8 AFE   Africa Eastern and Southern ETH   Ethiopia        
#>  9 AFE   Africa Eastern and Southern KEN   Kenya           
#> 10 AFE   Africa Eastern and Southern LSO   Lesotho         
#> # ℹ 2,075 more rows

wb_groups %>% count(wbgn) %>% data.frame
#>                                                  wbgn   n
#> 1                         Africa Eastern and Southern  26
#> 2                          Africa Western and Central  22
#> 3                                          Arab World  22
#> 4                              Caribbean small states  11
#> 5                      Central Europe and the Baltics  11
#> 6                          Early-demographic dividend  62
#> 7                                 East Asia & Pacific  38
#> 8                    East Asia & Pacific (IDA & IBRD)  23
#> 9         East Asia & Pacific (excluding high income)  22
#> 10                                          Euro area  20
#> 11                              Europe & Central Asia  58
#> 12                 Europe & Central Asia (IDA & IBRD)  23
#> 13      Europe & Central Asia (excluding high income)  18
#> 14                                     European Union  27
#> 15           Fragile and conflict affected situations  39
#> 16             Heavily indebted poor countries (HIPC)  39
#> 17                                        High income  86
#> 18                                          IBRD only  67
#> 19                                   IDA & IBRD total 145
#> 20                                          IDA blend  18
#> 21                                           IDA only  60
#> 22                                          IDA total  78
#> 23                          Late-demographic dividend  54
#> 24                          Latin America & Caribbean  42
#> 25             Latin America & Caribbean (IDA & IBRD)  31
#> 26  Latin America & Caribbean (excluding high income)  23
#> 27       Least developed countries: UN classification  45
#> 28                                Low & middle income 131
#> 29                                         Low income  26
#> 30                                Lower middle income  51
#> 31                         Middle East & North Africa  21
#> 32            Middle East & North Africa (IDA & IBRD)  12
#> 33 Middle East & North Africa (excluding high income)  13
#> 34                                      Middle income 105
#> 35                                      North America   3
#> 36                                       OECD members  38
#> 37                                 Other small states  18
#> 38                        Pacific island small states  11
#> 39                          Post-demographic dividend  38
#> 40                           Pre-demographic dividend  37
#> 41                                 Small states (SST)  40
#> 42                                         South Asia   8
#> 43                            South Asia (IDA & IBRD)   8
#> 44                                 Sub-Saharan Africa  48
#> 45                    Sub-Saharan Africa (IDA & IBRD)  48
#> 46         Sub-Saharan Africa (excluding high income)  47
#> 47                                Upper middle income  54
#> 48                                              World 218
```

Here we again refer to how this section started, but let's assume the population to which we want to infer is "low income countries". We can identify the units in that population with no problem whatsoever.


``` r
wb_groups %>% filter(wbgn == "Low income") 
#> # A tibble: 26 × 4
#>    wbgc  wbgn       iso3c name                    
#>    <chr> <chr>      <chr> <chr>                   
#>  1 LIC   Low income AFG   Afghanistan             
#>  2 LIC   Low income BFA   Burkina Faso            
#>  3 LIC   Low income BDI   Burundi                 
#>  4 LIC   Low income CAF   Central African Republic
#>  5 LIC   Low income TCD   Chad                    
#>  6 LIC   Low income COD   Congo, Dem. Rep.        
#>  7 LIC   Low income ERI   Eritrea                 
#>  8 LIC   Low income ETH   Ethiopia                
#>  9 LIC   Low income GMB   Gambia, The             
#> 10 LIC   Low income GNB   Guinea-Bissau           
#> # ℹ 16 more rows

wb_groups %>% filter(wbgn == "Low income") %>% pull(name)
#>  [1] "Afghanistan"               "Burkina Faso"             
#>  [3] "Burundi"                   "Central African Republic" 
#>  [5] "Chad"                      "Congo, Dem. Rep."         
#>  [7] "Eritrea"                   "Ethiopia"                 
#>  [9] "Gambia, The"               "Guinea-Bissau"            
#> [11] "Korea, Dem. People's Rep." "Liberia"                  
#> [13] "Madagascar"                "Malawi"                   
#> [15] "Mali"                      "Mozambique"               
#> [17] "Niger"                     "Rwanda"                   
#> [19] "Sierra Leone"              "Somalia"                  
#> [21] "South Sudan"               "Sudan"                    
#> [23] "Syrian Arab Republic"      "Togo"                     
#> [25] "Uganda"                    "Yemen, Rep."
```

Perhaps we can anticipate a few issues that might emerge with this population. For example, there is no South Sudan before 2011 and North Korea is a notorious data desert. Since these classifications are current (as of the 2025 fiscal year), we can't say what this population would've looked like in 2005 (beyond the obvious absence of South Sudan). No matter, I want to at least impress that we are being reasonably deliberate about identifying our population outright. Our population might be the universe of Correlates of War states, which we can subset to regions (once your eagle eye identifies how Correlates of War state codes crudely communicate geographical regions). Our population might be low-income countries, which may or may not have some data issues. We're being transparent about identifying populations of interest based on assorted tools at our disposal. Use them to your advantage.

## How Do I Create My Data? {#createdata}

First, you need to identify your population. Let's keep this exercise reasonably simple and focus on South Asia. 


``` r
wb_groups %>% filter(wbgn == "South Asia") -> southAsia

southAsia
#> # A tibble: 8 × 4
#>   wbgc  wbgn       iso3c name       
#>   <chr> <chr>      <chr> <chr>      
#> 1 SAS   South Asia AFG   Afghanistan
#> 2 SAS   South Asia BGD   Bangladesh 
#> 3 SAS   South Asia BTN   Bhutan     
#> 4 SAS   South Asia IND   India      
#> 5 SAS   South Asia MDV   Maldives   
#> 6 SAS   South Asia NPL   Nepal      
#> 7 SAS   South Asia PAK   Pakistan   
#> 8 SAS   South Asia LKA   Sri Lanka
```

As beginners, our eyes gravitate toward the country names. As researchers, they should go to the three-character ISO codes. That's ultimately what the World Bank is (mostly) using for benchmarking their data. That doesn't mean there aren't [some occasional headaches, though](https://svmiller.com/stevedata/reference/wbd_example.html). For example:


``` r
wbd_example %>%
  filter(iso3c == "TUR" | iso3c == "CZE") %>% filter(year %in% c(2000, 2020)) %>% 
  arrange(iso3c, year)
#> # A tibble: 6 × 7
#>   country        iso2c iso3c  year rgdppc lifeexp    hci
#>   <chr>          <chr> <chr> <int>  <dbl>   <dbl>  <dbl>
#> 1 Czechia        CZ    CZE    2000 12312.    75.0 NA    
#> 2 Czech Republic CZ    CZE    2020    NA     NA    0.752
#> 3 Czechia        CZ    CZE    2020 19048.    78.2 NA    
#> 4 Turkiye        TR    TUR    2000  6455.    71.9 NA    
#> 5 Turkey         TR    TUR    2020    NA     NA    0.649
#> 6 Turkiye        TR    TUR    2020 12072.    75.8 NA
```

You can see what happened here, and this came as is from the World Bank.

No matter, let's return to South Asia and take control of our data-generating process. We have our population of interest, but what is our unit of analysis once we add a temporal component? In almost every instance, the temporal unit would be years. Most data of interest to us in the cross-national context is typically aggregated to years. So, let's go from there.

### Creating a Panel of State-Years {#stateyears}

Let's assume we wanted to proceed with a panel of these eight South Asian states from 2000 to 2020. If that's what we wanted, then basic math say we should have 168 (i.e. 21*8) observations for our population of eight cases. We could hope we get that right in Microsoft Excel, or could we do it ourselves based on my 2019 post. I'll be honest that I return to this procedure all the time in creating data sets to analyze.


``` r
southAsia %>%
  rowwise() %>% # thing rowwise
  # below: create an embedded list, as a column, of a sequence from 2000 to 2020
  # This will increment by 1.
  mutate(year = list(seq(2000, 2020, by = 1))) %>% 
  # unnest, to get our panel
  unnest(year)
#> # A tibble: 168 × 5
#>    wbgc  wbgn       iso3c name         year
#>    <chr> <chr>      <chr> <chr>       <dbl>
#>  1 SAS   South Asia AFG   Afghanistan  2000
#>  2 SAS   South Asia AFG   Afghanistan  2001
#>  3 SAS   South Asia AFG   Afghanistan  2002
#>  4 SAS   South Asia AFG   Afghanistan  2003
#>  5 SAS   South Asia AFG   Afghanistan  2004
#>  6 SAS   South Asia AFG   Afghanistan  2005
#>  7 SAS   South Asia AFG   Afghanistan  2006
#>  8 SAS   South Asia AFG   Afghanistan  2007
#>  9 SAS   South Asia AFG   Afghanistan  2008
#> 10 SAS   South Asia AFG   Afghanistan  2009
#> # ℹ 158 more rows
```

If we're thinking ahead to merging data into this panel, it's good to know that we should not ever have more than 168 observations in the data. If that happened, it might be because we did something inadvisable (like merging "Czechia" to "Czech Republic" for both a country name and three-character ISO code).

### Creating a Panel of State-Quarter or State-Months {#statequarters}

There are conceivably more granular periods over which the population to comprise our panel can be observed. While I've yet to get comfortable with the International Monetary Fund's (IMF's) application programming interface (API), at least through R, I know the IMF has data for countries that are more granular than yearly. Generally, some data (like trade, of which I'm aware) are available monthly or quarterly. If we wanted a panel of state-months or state-quarters from 2000 to 2020, we could create it like this. This will lean on `{lubridate}`, which is in `{tidyverse}`.


``` r
# Create state-quarters, one way...
southAsia %>%
  rowwise() %>% # thing rowwise
  mutate(date = list(seq(ymd(20000101),
                         ymd(20201201), 
                         by = "1 quarter"))) %>%
  # unnest, to get our panel
  unnest(date) %>%
  mutate(quarter = quarter(date))
#> # A tibble: 672 × 6
#>    wbgc  wbgn       iso3c name        date       quarter
#>    <chr> <chr>      <chr> <chr>       <date>       <int>
#>  1 SAS   South Asia AFG   Afghanistan 2000-01-01       1
#>  2 SAS   South Asia AFG   Afghanistan 2000-04-01       2
#>  3 SAS   South Asia AFG   Afghanistan 2000-07-01       3
#>  4 SAS   South Asia AFG   Afghanistan 2000-10-01       4
#>  5 SAS   South Asia AFG   Afghanistan 2001-01-01       1
#>  6 SAS   South Asia AFG   Afghanistan 2001-04-01       2
#>  7 SAS   South Asia AFG   Afghanistan 2001-07-01       3
#>  8 SAS   South Asia AFG   Afghanistan 2001-10-01       4
#>  9 SAS   South Asia AFG   Afghanistan 2002-01-01       1
#> 10 SAS   South Asia AFG   Afghanistan 2002-04-01       2
#> # ℹ 662 more rows

# Create state-months.
# You'll notice this is just copy-pasting the above and changing a few things.
southAsia %>%
  rowwise() %>% # thing rowwise
  mutate(date = list(seq(ymd(20000101),
                         ymd(20201201), 
                         by = "1 month"))) %>%
  # unnest, to get our panel
  unnest(date) %>%
  mutate(month = month(date))
#> # A tibble: 2,016 × 6
#>    wbgc  wbgn       iso3c name        date       month
#>    <chr> <chr>      <chr> <chr>       <date>     <dbl>
#>  1 SAS   South Asia AFG   Afghanistan 2000-01-01     1
#>  2 SAS   South Asia AFG   Afghanistan 2000-02-01     2
#>  3 SAS   South Asia AFG   Afghanistan 2000-03-01     3
#>  4 SAS   South Asia AFG   Afghanistan 2000-04-01     4
#>  5 SAS   South Asia AFG   Afghanistan 2000-05-01     5
#>  6 SAS   South Asia AFG   Afghanistan 2000-06-01     6
#>  7 SAS   South Asia AFG   Afghanistan 2000-07-01     7
#>  8 SAS   South Asia AFG   Afghanistan 2000-08-01     8
#>  9 SAS   South Asia AFG   Afghanistan 2000-09-01     9
#> 10 SAS   South Asia AFG   Afghanistan 2000-10-01    10
#> # ℹ 2,006 more rows

# Create state-quarters, another way...
southAsia %>%
  rowwise() %>% # thing rowwise
  mutate(date = list(seq(ymd(20000101),
                         ymd(20201201), 
                         by = "1 month"))) %>%
  # unnest, to get our panel
  unnest(date) %>%
  mutate(month = month(date)) %>%
  filter(month %in% c(1,4,7,10))
#> # A tibble: 672 × 6
#>    wbgc  wbgn       iso3c name        date       month
#>    <chr> <chr>      <chr> <chr>       <date>     <dbl>
#>  1 SAS   South Asia AFG   Afghanistan 2000-01-01     1
#>  2 SAS   South Asia AFG   Afghanistan 2000-04-01     4
#>  3 SAS   South Asia AFG   Afghanistan 2000-07-01     7
#>  4 SAS   South Asia AFG   Afghanistan 2000-10-01    10
#>  5 SAS   South Asia AFG   Afghanistan 2001-01-01     1
#>  6 SAS   South Asia AFG   Afghanistan 2001-04-01     4
#>  7 SAS   South Asia AFG   Afghanistan 2001-07-01     7
#>  8 SAS   South Asia AFG   Afghanistan 2001-10-01    10
#>  9 SAS   South Asia AFG   Afghanistan 2002-01-01     1
#> 10 SAS   South Asia AFG   Afghanistan 2002-04-01     4
#> # ℹ 662 more rows
```

### Creating a Panel of State-Days {#statedays}

It's conceivable, however implausible, that a student might be interested in a panel of state-days. In this case, perhaps the student is interested in daily exchange rates of these eight currencies vis-a-vis the U.S. dollar as their currencies are traded on the foreign exchange market. If so, you're really just changing one line of code to create what you want.


``` r
southAsia %>%
  rowwise() %>% # thing rowwise
  mutate(date = list(seq(ymd(20000101),
                         ymd(20201201), 
                         by = "1 day"))) %>%
  # unnest, to get our panel
  unnest(date)
#> # A tibble: 61,128 × 5
#>    wbgc  wbgn       iso3c name        date      
#>    <chr> <chr>      <chr> <chr>       <date>    
#>  1 SAS   South Asia AFG   Afghanistan 2000-01-01
#>  2 SAS   South Asia AFG   Afghanistan 2000-01-02
#>  3 SAS   South Asia AFG   Afghanistan 2000-01-03
#>  4 SAS   South Asia AFG   Afghanistan 2000-01-04
#>  5 SAS   South Asia AFG   Afghanistan 2000-01-05
#>  6 SAS   South Asia AFG   Afghanistan 2000-01-06
#>  7 SAS   South Asia AFG   Afghanistan 2000-01-07
#>  8 SAS   South Asia AFG   Afghanistan 2000-01-08
#>  9 SAS   South Asia AFG   Afghanistan 2000-01-09
#> 10 SAS   South Asia AFG   Afghanistan 2000-01-10
#> # ℹ 61,118 more rows
```

There is the obvious caveat that these are just every day of all years for eight states in South Asia from 2000 to 2020. It won't communicate days in which the foreign exchange market is closed (though eliminating weekends isn't difficult at all). No matter, if you're getting your exchange rate data from something like `{quantmod}`, that'll become apparent. In which case, days in which the foreign exchange market are closed alter the unit of analysis slightly. They're no longer state-days, but state-trading days.

## Conclusion: Why Does This Matter? {#conclusion}

The banner above this post notes that I've mused on this exact thing six times, and this would be the seventh. I'm repeating myself because I want students to note it takes very little effort to be deliberate in defining the population of interest (in IR applications) *and* takes almost no effort to create the template of the data itself. You should not have to lean on data you download to take care of that for you, because there is no guarantee it will. Data you download doesn't necessarily know the population of interest to you, only the population of interest to the data. Define your population, and you know what you're doing. Define your population, as observed over time, and you have the exact dimensions of your unit of analysis. If something is posing an issue toward creating the full data set of interest, it'll be easier to spot.

I say this because code in `{peacesciencer}` and just about everything I do leans on `left_join()` in `{dplyr}`. I'm a `left_join()` absolutist. Being abundantly clear about the population of interest and creating the data from scratch allows you full control over the data-generating process. It'll also allow you to more efficiently use functions like `WDI()` in `{WDI}`. Observe:


``` r
southAsia$iso3c
#> [1] "AFG" "BGD" "BTN" "IND" "MDV" "NPL" "PAK" "LKA"

WDI(country = southAsia$iso3c,
    indicator = c("gdppc" = "NY.GDP.PCAP.KD"),
    start = 2000, end = 2020) -> wbd

wbd %>% as_tibble() # cool, I know these dimensions match.
#> # A tibble: 168 × 5
#>    country     iso2c iso3c  year gdppc
#>    <chr>       <chr> <chr> <int> <dbl>
#>  1 Afghanistan AF    AFG    2020  528.
#>  2 Afghanistan AF    AFG    2019  558.
#>  3 Afghanistan AF    AFG    2018  553.
#>  4 Afghanistan AF    AFG    2017  563.
#>  5 Afghanistan AF    AFG    2016  564.
#>  6 Afghanistan AF    AFG    2015  566.
#>  7 Afghanistan AF    AFG    2014  575.
#>  8 Afghanistan AF    AFG    2013  581.
#>  9 Afghanistan AF    AFG    2012  569.
#> 10 Afghanistan AF    AFG    2011  525.
#> # ℹ 158 more rows

wbd %>% as_tibble() %>% # trust the three-character ISO codes...
  select(iso3c, year, gdppc) -> wbd

southAsia %>%
  rowwise() %>% # thing rowwise
  # below: create an embedded list, as a column, of a sequence from 2000 to 2020
  # This will increment by 1.
  mutate(year = list(seq(2000, 2020, by = 1))) %>% 
  # unnest, to get our panel
  unnest(year) %>%
  # Everything above was copy-pasted, but's join in our GDP per capita data...
  left_join(., wbd) -> southAsia

southAsia # nailed it
#> # A tibble: 168 × 6
#>    wbgc  wbgn       iso3c name         year gdppc
#>    <chr> <chr>      <chr> <chr>       <dbl> <dbl>
#>  1 SAS   South Asia AFG   Afghanistan  2000  308.
#>  2 SAS   South Asia AFG   Afghanistan  2001  277.
#>  3 SAS   South Asia AFG   Afghanistan  2002  338.
#>  4 SAS   South Asia AFG   Afghanistan  2003  346.
#>  5 SAS   South Asia AFG   Afghanistan  2004  339.
#>  6 SAS   South Asia AFG   Afghanistan  2005  364.
#>  7 SAS   South Asia AFG   Afghanistan  2006  368.
#>  8 SAS   South Asia AFG   Afghanistan  2007  411.
#>  9 SAS   South Asia AFG   Afghanistan  2008  418.
#> 10 SAS   South Asia AFG   Afghanistan  2009  489.
#> # ℹ 158 more rows
```

Notice I trusted the three-character ISO codes to communicate the population of interest to me, and the years to match one-to-one (as they do) with what's in my panel. I just needed the information I want (GDP per capita) and the information that would help me merge into the data frame I'm creating (the three-character ISO code, and importantly the year). Be deliberate, but trust the process. As you learn to trust the process, you'll also get a better idea of what went wrong if/when something does go wrong.
