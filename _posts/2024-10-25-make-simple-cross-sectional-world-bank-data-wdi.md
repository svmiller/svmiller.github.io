---
title: "Make Simple Cross-Sectional Data with World Bank Data (from {WDI})"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2024-10-25'
excerpt: "It really doesn't take much effort to do some simple things in {WDI}, like creating a cross-sectional data set for an undergraduate paper."
layout: post
categories:
  - Teaching
  - R
image: "mr-jim-business.jpg"
active: blog
---



<div class="announcement-box" markdown = "1">
<!-- <div id="focusbox" markdown = "1"> -->


## This Post Assumes Some Familiarity with `{WDI}` ⤵️

My undergraduate students reading this post, thinking about potential topics for their quantitative methods course or their C-papers, should read my earlier tutorial on [how to use the `{WDI}` package in R](http://svmiller.com/blog/2021/02/gank-world-bank-data-with-wdi-in-r/).

</div>


{% include image.html url="/images/mr-jim-business.jpg" caption="There's no business like Mr. Jim Business" width=450 align="right" %}

<!-- *Last updated: 28 October 2024.*  -->


Students in my quantitative methods class are (ideally) having to think about their end-of-the-course short papers and their BA theses that will (ideally!) make use of some of the methods and techniques I teach them. Part of that entails thinking of a question that can be answered with these methods and finding data to explore. That naturally draws the student to the World Bank, which [contains a nice repository of data](https://data.worldbank.org/) on a whole host of topics. If you're interested in topics of economic development, population growth, corruption, education levels---or almost anything else in the cross-national context---the World Bank's DataBank has you covered. 

What's less nice is how a student would think to obtain the data that interests them. The student might end up at a portal like [this one](https://databank.worldbank.org/source/world-development-indicators). They'd have to fumble through what exact database they want, select what countries they want and over what time period, and then download the data to an Excel file. The Excel file would be less than appetizing to look at, having years as columns with unhelpful columns like `X2010` for an observation in the year 2010. This particular format might overwhelm the student if they wanted to add anything to it, especially if they had the whole international system along with assorted regional or economic groups.

There's a better way, I promise. Use the `{WDI}` package in R, and consult [this previous guide of mine](http://svmiller.com/blog/2021/02/gank-world-bank-data-with-wdi-in-r/). All you need are the `{WDI}` package, an idea of what you want, and the knowledge of how the World Bank communicates indicators to you. The `{WDI}` package will get what you want and some assorted "tidy" verbs will convert what `{WDI}` returns to a simple cross-sectional data set for you to explore.

First, here are the R packages I'll be using. My students should have all these installed by virtue of the course description, except for the `{WDI}` package.

```r
library(tidyverse)    # for most things
library(stevedata)    # v. 1.4, for country_isocodes
library(stevemisc)    # for lag_at()
library(WDI)          # the star of the show for this post
library(modelsummary) # for the regression table at the end.
library(tinytable)    # OPTIONAL, for you: for customizing the regression table at the end.
```

Here's a table of contents.

1. [An Applied Example: Some Economic Indicators and the "Doing Business" Project](#example)
2. [Convert a Panel to a Cross-Section (From "Easiest" to "Still Easy (but with Five More Lines of Code)")](#convert)
    - [Easiest: Subset to a Single Year (e.g. Most Recent Year)](#easiest)
    - [Also Easy: Lag the IVs a Year, then Subset](#alsoeasy)
    - [Still Easy (but with Five More Lines of Code): Fill Based on Most Recent Available Year](#stilleasy)
3. [A Simple Regression, and a Conclusion](#regression)


## An Applied Example: Some Economic Indicators and the "Doing Business" Project {#example}

[My previous guide](http://svmiller.com/blog/2021/02/gank-world-bank-data-with-wdi-in-r/) mentioned that I had a PhD student from my time at Clemson University that was interested in the following indicators available on the World Bank. These are [access to electricity (as a percent of the population)](https://data.worldbank.org/indicator/EG.ELC.ACCS.ZS) [`EG.ELC.ACCS.ZS`], the [current account balance](https://data.worldbank.org/indicator/BN.CAB.XOKA.GD.ZS) [`BN.CAB.XOKA.GD.ZS`], the ["ease of doing business" score](https://data.worldbank.org/indicator/IC.BUS.DFRN.XQ) [`IC.BUS.DFRN.XQ`], the [consumer price index](https://data.worldbank.org/indicator/FP.CPI.TOTL.ZG) [`FP.CPI.TOTL.ZG`], and the [interest rate spread](https://data.worldbank.org/indicator/FR.INR.LNDP) [`FR.INR.LNDP`]. Here's where I'll note, especially as I don't want students want simply mimicking me: *I forget why my student wanted these indicators. I only remember that he wanted them (and that he was interested in Sub-Saharan Africa).* Thus, I can tell you what these assorted variables are, and even point you to [the Doing Business project](https://archive.doingbusiness.org/en/doingbusiness) for more information on what that particular estimate is communicating.[^edb] However, I don't know what relationship he was interested in exploring, but you should definitely know [what you're doing and why you're doing it](http://svmiller.com/blog/2024/05/assorted-tips-for-student-theses/#whatareyoudoing). Just because what follows is theoretically thoughtless doesn't mean it's permission for you to do the same. However, what follows is fine for the intended purpose: teaching students how to make simple cross-sectional data sets from data made available by the World Bank.

[^edb]: The statement announcing [the discontinuation of the Doing Business project](https://www.worldbank.org/en/news/statement/2021/09/16/world-bank-group-to-discontinue-doing-business-report) casts considerable doubt on whether these data should be used whatsoever.

Now, let's fire up the `WDI()` function knowing what information we want from the World Bank. Here's the function we're going to call, and let me explain more after the code block. 


``` r
WDI(indicator = c("aepp" = "EG.ELC.ACCS.ZS", # access to electricity
                  "cab" = "BN.CAB.XOKA.GD.ZS", # current account balance
                  "edb" = "IC.BUS.DFRN.XQ", # ease of doing business
                  "cpi" = "FP.CPI.TOTL.ZG", # CPI
                  "irs" = "FR.INR.LNDP"), # interest rate spread
    start = 2014, end = 2019,
    country = country_isocodes$iso3c) %>% 
  as_tibble() -> rawData
```



First, the `indicator` argument in the `WDI()` function takes the indicators of interest, as stored by the World Bank. [The guide I wrote in 2021](http://svmiller.com/blog/2021/02/gank-world-bank-data-with-wdi-in-r/) should communicate how you could minimally use the `indicator` argument in this function, though I'm doing what the package author recommends doing if you know you're going to be renaming your columns anyway. In the above function, we're grabbing the access to electricity indicator (`EG.ELC.ACCS.ZS`) and, once we do, we're going to assign it to a column called `aepp`. Likewise, we're going to grab the current account balance indicator (`BN.CAB.XOKA.GD.ZS`) and assign it to a column called `cab`. From there, you should be able to see how to do this for the three remaining columns.

Next, let's think a little bit about what we're doing here. For this case, let's treat the ease of doing business score as our dependent variable (i.e. the thing we want to explain). I can see from [exploring the World Bank's data repository](https://data.worldbank.org/indicator/IC.BUS.DFRN.XQ) that the Doing Business project was [discontinuned as of Sept. 16, 2021](https://www.worldbank.org/en/news/statement/2021/09/16/world-bank-group-to-discontinue-doing-business-report). The most recent year for which it has data is 2019. Knowing these are somewhat recent projects, and I'm interested in a simple cross-sectional analysis, it would be a waste of time to ask for information from too far before the most recent year. Thus, I want to focus on just a few years: let's say 2014 to 2019. That will explain the arguments of `start = 2014` and `end = 2019` you see in the code above.

Finally, let's not overwhelm ourselves with what `WDI()` will return without any additional guidance. `WDI()` works primarily with ISO codes, but, by default, it will return *everything* for which it could plausibly have data. This includes countries (e.g. Sweden, the United States, Mexico) but also assorted regional groupings (e.g. North America, Latin America & the Caribbean), organizational groupings (e.g. European Union, OECD states), economic groupings (e.g. [HIPCs](https://en.wikipedia.org/wiki/Heavily_indebted_poor_countries), [LDCs](https://en.wikipedia.org/wiki/Least_developed_countries)), and even the world (among some others). This would be a good opportunity to both [know your state classification systems](http://svmiller.com/blog/2021/01/a-tutorial-on-state-classification-systems/) and [know the population of cases you ultimately want to describe](http://svmiller.com/peacesciencer/articles/state-systems.html). You probably care just about sovereign states ("countries"), so why ask for the other stuff? By default, `WDI()` will get that for you unless you supply something different in the `country` argument.

That's one such reason why I have [the `country_isocodes` data set in `{stevedata}`](http://svmiller.com/stevedata/reference/country_isocodes.html) to allow for some convenient subsetting. Here's a simple summary of that data set.


``` r
country_isocodes
#> # A tibble: 249 × 4
#>    iso2c iso3c iso3n name                
#>    <chr> <chr> <chr> <chr>               
#>  1 AW    ABW   533   Aruba               
#>  2 AF    AFG   004   Afghanistan         
#>  3 AO    AGO   024   Angola              
#>  4 AI    AIA   660   Anguilla            
#>  5 AX    ALA   248   Åland Islands       
#>  6 AL    ALB   008   Albania             
#>  7 AD    AND   020   Andorra             
#>  8 AE    ARE   784   United Arab Emirates
#>  9 AR    ARG   032   Argentina           
#> 10 AM    ARM   051   Armenia             
#> # ℹ 239 more rows
```

The `country` argument in `WDI()` takes either two-character or three-character ISO codes and returns all observations included in what you asked. If you wanted just the United States, Canada, and Mexico, it would be something like `country = c("US", "MX", "CA")` or the three-character equivalent of `country = c("USA", "MEX", "CAN")`. In our simple example, however, it's anything in the `iso2c` column in the `country_isocodes` data. Be forewarned, that `WDI()` is verbose, and will alert you to anything it can't find in the World Bank data (e.g. the World Bank has no data for Åland Islands), though the warning message that is returned (and suppressed here) is just a warning and not an error, per se.

Run the above `WDI()` function and this is what will come back.[^slow]

[^slow]: If you snooped on the source code for this post, you'd see that I saved the output of this function to a data set and work with that for this post. It's great that this API exists, but accessing it can be a bit slow. With that in mind, it might be wise to consider this the kind of "raw data" you'd have for a project and keep it stored somewhere to process to "clean" data. See some posts of mine ([here](http://svmiller.com/blog/2022/09/steveproj-stevetemplates-targets-workflow-example/) and [here](http://svmiller.com/blog/2021/03/handle-academic-projects-steveproj-make/)) for what I call this "data-laundering" approach to project management.


``` r
rawData
#> # A tibble: 1,290 × 9
#>    country     iso2c iso3c  year  aepp    cab   edb    cpi   irs
#>    <chr>       <chr> <chr> <int> <dbl>  <dbl> <dbl>  <dbl> <dbl>
#>  1 Afghanistan AF    AFG    2014  89.5 -15.8   NA    4.67  NA   
#>  2 Afghanistan AF    AFG    2015  71.5 -21.9   39.3 -0.662 NA   
#>  3 Afghanistan AF    AFG    2016  97.7 -15.0   38.9  4.38  NA   
#>  4 Afghanistan AF    AFG    2017  97.7 -19.0   37.1  4.98  NA   
#>  5 Afghanistan AF    AFG    2018  93.4 -21.6   44.2  0.626 NA   
#>  6 Afghanistan AF    AFG    2019  97.7 -20.2   44.1  2.30  NA   
#>  7 Albania     AL    ALB    2014 100   -10.8   NA    1.63   6.06
#>  8 Albania     AL    ALB    2015 100    -8.60  58.1  1.90   6.48
#>  9 Albania     AL    ALB    2016  99.9  -7.59  64.2  1.28   5.90
#> 10 Albania     AL    ALB    2017  99.9  -7.54  66.8  1.99   5.45
#> # ℹ 1,280 more rows
```

Some basic exploration of the output will show that there often observations for which we have no data whatsoever on a key indicator, like interest rate spreads for Afghanistan or Austria, the consumer price index for Argentina and Eritrea, or the current account balance for Chad. Some have situational missingness (e.g. four years of missing data of interest rate spreads for Bahrain, three years of the consumer price index for Tajikistan). One observation, American Samoa, has no information whatsoever and should not be included.

## Convert a Panel to a Cross-Section (From "Easiest" to "Still Easy (but with Five More Lines of Code)") {#convert}

The data created above and assigned to an object called `rawData` is what we'd call a "panel" in the social sciences. "Panels" are individual observations observed over (effectively) the same period of time. There are a few options for converting such a panel to what we'd call a "cross-section" (i.e. observations all gathered at (around) the same time, with no temporal component). These range from "easiest" to "still easy (but with five more lines of code)".


### Easiest: Subset to a Single Year (e.g. Most Recent Year) {#easiest}

The easiest would be a simple subset of the panel to a single year of observation. In the data created above, this would be a simple matter of selecting the data to, say, 2019 (which would incidentally be the most recent year).


``` r
rawData %>% 
  filter(year == 2019) -> Option1

Option1
#> # A tibble: 215 × 9
#>    country             iso2c iso3c  year  aepp     cab   edb   cpi   irs
#>    <chr>               <chr> <chr> <int> <dbl>   <dbl> <dbl> <dbl> <dbl>
#>  1 Afghanistan         AF    AFG    2019  97.7 -20.2    44.1  2.30 NA   
#>  2 Albania             AL    ALB    2019 100    -7.91   67.7  1.41  5.78
#>  3 Algeria             DZ    DZA    2019  99.5  -8.76   48.6  1.95  6.25
#>  4 American Samoa      AS    ASM    2019  NA    NA      NA   NA    NA   
#>  5 Andorra             AD    AND    2019 100    18.0    NA   NA    NA   
#>  6 Angola              AO    AGO    2019  45.6   7.25   41.3 17.1  12.9 
#>  7 Antigua and Barbuda AG    ATG    2019 100    -6.51   60.3  1.43  7.03
#>  8 Argentina           AR    ARG    2019 100    -0.780  59.0 NA    20.0 
#>  9 Armenia             AM    ARM    2019 100    -7.06   74.5  1.44  3.66
#> 10 Aruba               AW    ABW    2019 100     2.50   NA    4.26  3.5 
#> # ℹ 205 more rows

Option1 %>%
  na.omit
#> # A tibble: 99 × 9
#>    country             iso2c iso3c  year  aepp    cab   edb   cpi   irs
#>    <chr>               <chr> <chr> <int> <dbl>  <dbl> <dbl> <dbl> <dbl>
#>  1 Albania             AL    ALB    2019 100   -7.91   67.7  1.41  5.78
#>  2 Algeria             DZ    DZA    2019  99.5 -8.76   48.6  1.95  6.25
#>  3 Angola              AO    AGO    2019  45.6  7.25   41.3 17.1  12.9 
#>  4 Antigua and Barbuda AG    ATG    2019 100   -6.51   60.3  1.43  7.03
#>  5 Armenia             AM    ARM    2019 100   -7.06   74.5  1.44  3.66
#>  6 Australia           AU    AUS    2019 100    0.350  81.2  1.61  3.54
#>  7 Azerbaijan          AZ    AZE    2019 100    8.70   78.5  2.61  7.59
#>  8 Bahamas, The        BS    BHS    2019 100   -2.65   59.9  2.49  3.66
#>  9 Bangladesh          BD    BGD    2019  92.2 -0.839  45.0  5.59  2.78
#> 10 Belarus             BY    BLR    2019 100   -1.93   74.3  5.60  2.52
#> # ℹ 89 more rows
```

The above code shows that we have 215 cross-sectional units, but any regression model we employ on these data would have just 99 observations because of missing data either in what's going to be our dependent variable (the ease of doing business score for Andorra), or independent variables (e.g. the consumer price index for Argentina), or both (e.g. American Samoa).

No matter, this is the path of the absolute least resistance for converting a panel to a cross-section. You can't fail with this route, but the effort required to do this matches the effort that went into thinking about the desirability of this option.

### Also Easy: Lag the IVs a Year, then Subset {#alsoeasy}

There are two things that present themselves in our data that are teachable moments. First, this isn't the kind of class where I can spam the word "endogeneity" at students, but some basic logic suggests it's perilous to treat the ease of doing business score in 2019 as a function of the interest rate spread in 2019. Both are observed (effectively) at the same time. Discerning causal relationships is hard enough as it is, and it's why practitioners like to lag independent variables by a time period (year, in this case). We can at least say with confidence that 2018 observations can only affect 2019 observations (in the dependent variable), and that 2019 cannot affect 2018.[^yeahiknow] [My recent discussion of Mitchell's (1968) analysis](http://svmiller.com/blog/2024/10/inequality-insurgency-south-vietnam-1968-statistical-analysis/) of inequality and government control in South Vietnam comes with an appreciation that even he was aware of this. His analysis is careful to make sure everything that could possibly explain South Vietnamese control of its provinces in 1965 is observed *before* 1965.

[^yeahiknow]: Yeah, concerns for causal identification are not so easily dismissed by simple year lags, but that's a topic for another class.

First, let's take a look at New Zealand as a proof of concept for some of the information gain we're going to get by a year lag.


``` r
rawData %>% filter(iso2c == "NZ")
#> # A tibble: 6 × 9
#>   country     iso2c iso3c  year  aepp   cab   edb   cpi   irs
#>   <chr>       <chr> <chr> <int> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 New Zealand NZ    NZL    2014   100 -3.09  NA   1.23   1.79
#> 2 New Zealand NZ    NZL    2015   100 -2.62  87.1 0.293  2.03
#> 3 New Zealand NZ    NZL    2016   100 -2.13  87.2 0.646  1.79
#> 4 New Zealand NZ    NZL    2017   100 -2.81  87.0 1.85   1.46
#> 5 New Zealand NZ    NZL    2018   100 -4.05  87.0 1.60  -3.26
#> 6 New Zealand NZ    NZL    2019   100 -2.79  86.8 1.62  NA
```

New Zealand has missing data for the interest rate spread in 2019, but the panel is otherwise complete for the other observations. Taking a year lag allows us to keep New Zealand in our data.

I have a suite of functions---[my so-called `_at()` functions](http://svmiller.com/stevemisc/reference/at.html)---for doing single functions to multiple columns all in one fell swoop. `lag_at()`, in this case, creates lagged variables with a prefix of `l[o]_` where `o` corresponds with the order of the lag. The default here is 1, as we want just a single year lag. We can (and must make sure) to specify these are grouped data, so we're not lagging Albania's observation of a current account balance in 2014 based on Afghanistan's observation in 2019.

Let's observe what this does.


``` r
rawData %>% 
  lag_at(c("aepp", "cab", "cpi", "irs"),
        .by = iso2c)
#> # A tibble: 1,290 × 13
#>    country     iso2c iso3c  year  aepp    cab   edb    cpi   irs l1_aepp l1_cab
#>    <chr>       <chr> <chr> <int> <dbl>  <dbl> <dbl>  <dbl> <dbl>   <dbl>  <dbl>
#>  1 Afghanistan AF    AFG    2014  89.5 -15.8   NA    4.67  NA       NA    NA   
#>  2 Afghanistan AF    AFG    2015  71.5 -21.9   39.3 -0.662 NA       89.5 -15.8 
#>  3 Afghanistan AF    AFG    2016  97.7 -15.0   38.9  4.38  NA       71.5 -21.9 
#>  4 Afghanistan AF    AFG    2017  97.7 -19.0   37.1  4.98  NA       97.7 -15.0 
#>  5 Afghanistan AF    AFG    2018  93.4 -21.6   44.2  0.626 NA       97.7 -19.0 
#>  6 Afghanistan AF    AFG    2019  97.7 -20.2   44.1  2.30  NA       93.4 -21.6 
#>  7 Albania     AL    ALB    2014 100   -10.8   NA    1.63   6.06    NA    NA   
#>  8 Albania     AL    ALB    2015 100    -8.60  58.1  1.90   6.48   100   -10.8 
#>  9 Albania     AL    ALB    2016  99.9  -7.59  64.2  1.28   5.90   100    -8.60
#> 10 Albania     AL    ALB    2017  99.9  -7.54  66.8  1.99   5.45    99.9  -7.59
#> # ℹ 1,280 more rows
#> # ℹ 2 more variables: l1_cpi <dbl>, l1_irs <dbl>
```

Notice `lag_at()` takes a character vector corresponding with the columns for which the user wants lags and creates new columns with that lagged information. Because we wanted just a lag of order 1 (i.e. the default), we get four new columns of `l1_aepp`, `l1_cab`, `l1_cpi`, and `l1_irs` corresponding with the first-order lags of access to electricity, current account balance, consumer price index, and interest rate spread (respectively).

Now that we see what it does, let's do our second option. Notice how easy this is, but it's just two more lines of code. The second extra line is optional (because it's using the `select()` column to do column management).



``` r
rawData %>% 
  lag_at(c("aepp", "cab", "cpi", "irs"),
        .by = iso2c) %>%
  select(country:year, edb, l1_aepp:l1_irs) %>%
  filter(year == 2019) -> Option2

Option2 %>%
  na.omit
#> # A tibble: 102 × 9
#>    country             iso2c iso3c  year   edb l1_aepp   l1_cab l1_cpi l1_irs
#>    <chr>               <chr> <chr> <int> <dbl>   <dbl>    <dbl>  <dbl>  <dbl>
#>  1 Albania             AL    ALB    2019  67.7   100    -6.70     2.03   5.18
#>  2 Algeria             DZ    DZA    2019  48.6    99.6  -8.69     4.27   6.25
#>  3 Angola              AO    AGO    2019  41.3    45.3   9.32    19.6   13.8 
#>  4 Antigua and Barbuda AG    ATG    2019  60.3   100   -14.0      1.21   7.32
#>  5 Armenia             AM    ARM    2019  74.5    99.9  -7.23     2.52   4.13
#>  6 Australia           AU    AUS    2019  81.2   100    -2.23     1.91   3.28
#>  7 Azerbaijan          AZ    AZE    2019  78.5   100    12.7      2.27   7.17
#>  8 Bahamas, The        BS    BHS    2019  59.9   100    -8.84     2.27   3.41
#>  9 Bangladesh          BD    BGD    2019  45.0    86.9  -2.21     5.54   2.99
#> 10 Belarus             BY    BLR    2019  74.3    99.3   0.0381   4.87   2.78
#> # ℹ 92 more rows
```

This approach gains us three more observations because of missingness in 2019. `anti_join()` will tell us what these observations are.


``` r
anti_join(Option2 %>% na.omit, Option1 %>% na.omit)
#> # A tibble: 3 × 9
#>   country     iso2c iso3c  year   edb l1_aepp l1_cab l1_cpi l1_irs
#>   <chr>       <chr> <chr> <int> <dbl>   <dbl>  <dbl>  <dbl>  <dbl>
#> 1 Chile       CL    CHL    2019  72.6   100    -4.48   2.43   1.48
#> 2 New Zealand NZ    NZL    2019  86.8   100    -4.05   1.60  -3.26
#> 3 Uganda      UG    UGA    2019  60.0    41.9  -6.33   2.62  10.5
```

While it's not always the case you "gain" more observations with this route, it happens to be the case that we do *and* we demonstrate that we've thought through a rudimentary concern in the social sciences. In our data, 2018 can only explain ("cause") variation in 2019, and not the other way around.

### Still Easy (but with Five More Lines of Code): Fill Based on Most Recent Available Year {#stilleasy}

We could alternatively take a page out of what I see [the Quality of Government project](https://www.gu.se/en/quality-government) doing with [its cross-sectional data](https://www.gu.se/en/quality-government/qog-data/data-downloads/standard-dataset). In their data, as of Jan. 2024, observations are included from 2020. If 2020 is not available, it will take 2021. If no data exist for 2021, it'll take 2019. No matter, the cross-sectional data frame is effectively one that "fills" to a referent year based on what's available on the referent year, or surrounding it.

That seems like a mouthful, but let's take a look at Japan to get an idea what we want to do.


``` r
rawData %>% filter(iso2c == "JP")
#> # A tibble: 6 × 9
#>   country iso2c iso3c  year  aepp   cab   edb    cpi    irs
#>   <chr>   <chr> <chr> <int> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 Japan   JP    JPN    2014   100 0.742  NA    2.76   0.804
#> 2 Japan   JP    JPN    2015   100 3.07   77.5  0.795  0.737
#> 3 Japan   JP    JPN    2016   100 3.94   77.9 -0.127  0.744
#> 4 Japan   JP    JPN    2017   100 4.12   78.0  0.484  0.673
#> 5 Japan   JP    JPN    2018   100 3.52   78.0  0.989 NA    
#> 6 Japan   JP    JPN    2019   100 3.45   78.0  0.469 NA

rawData %>% 
  lag_at(c("aepp", "cab", "cpi", "irs"),
        .by = iso2c) %>%
  select(country:year, edb, l1_aepp:l1_irs) %>%
  filter(iso2c == "JP")
#> # A tibble: 6 × 9
#>   country iso2c iso3c  year   edb l1_aepp l1_cab l1_cpi l1_irs
#>   <chr>   <chr> <chr> <int> <dbl>   <dbl>  <dbl>  <dbl>  <dbl>
#> 1 Japan   JP    JPN    2014  NA        NA NA     NA     NA    
#> 2 Japan   JP    JPN    2015  77.5     100  0.742  2.76   0.804
#> 3 Japan   JP    JPN    2016  77.9     100  3.07   0.795  0.737
#> 4 Japan   JP    JPN    2017  78.0     100  3.94  -0.127  0.744
#> 5 Japan   JP    JPN    2018  78.0     100  4.12   0.484  0.673
#> 6 Japan   JP    JPN    2019  78.0     100  3.52   0.989 NA
```

Japan is missing an interest rate spread variable for 2019 and 2018. Because the first-order lag of the interest rate spread variable (`l1_irs`) for 2019 wants an observation from 2018 (that it does not have), this becomes an NA and Japan would drop from our cross-sectional analysis. However, we could just simply fill the most recent observation for Japan (2017) as a plug-in for the interest rate spread variable from 2018. There will be occasions where this might be less than desirable, but it's perfectly fine for a case like this.[^ven]

[^ven]: In our data, Venezuela loses a consumer price index observation for 2018 and 2019 after observing 255% in 2017. Using 2017 to fill in 2018 may borrow trouble (i.e. this is Venezuela we're talking about and the inflation for that year was likely [*much* worse than it was in 2017](https://www.statista.com/statistics/1392580/annual-average-consumer-price-index-venezuela/)). However, consumer price indices already behave poorly in the linear model context. Perhaps imputing 2017 for 2018 is a bad idea, but it wouldn't be the worst idea to just infer that there is a hyperinflation crisis in Venezuela that you could discern from imputing an observation for 2018 from 2017. Use your head with the data limitations in mind.

Thus, the third option here is to complement the first-order lags with a group-by fill using the `fill()` function in `{tidyr}`. To the best of my knowledge, `fill()` doesn't recognize the `.by` argument like other so-called "tidy" verbs, but it does work with the deprecated `group_by()` method. Observe the gains in available data for analysis we'll get from this method.


``` r
# Reminder of how many observations we have in the first method
nrow(rawData %>% filter(year == 2019) %>% na.omit)
#> [1] 99

rawData %>%
  # Step 1: lag_at(), .by our group
  lag_at(c("aepp", "cab", "cpi", "irs"),
         .by = iso2c) %>%
  # Step 2: group_by() our group
  group_by(iso2c) %>%
  # Step 3: fill down the first-order lags.
  fill(l1_aepp:l1_irs,
       .direction = "down") %>%
  #  Step 4: practice safe group_by()
  ungroup() %>%
  # Step 5: select what we want, though this is basically optional
  select(country:year, edb, l1_aepp:l1_irs) %>%
  # Step 6: filter to most recent year (2019)
  filter(year == 2019) -> Option3

Option3 %>% na.omit
#> # A tibble: 123 × 9
#>    country             iso2c iso3c  year   edb l1_aepp l1_cab l1_cpi l1_irs
#>    <chr>               <chr> <chr> <int> <dbl>   <dbl>  <dbl>  <dbl>  <dbl>
#>  1 Albania             AL    ALB    2019  67.7   100    -6.70   2.03   5.18
#>  2 Algeria             DZ    DZA    2019  48.6    99.6  -8.69   4.27   6.25
#>  3 Angola              AO    AGO    2019  41.3    45.3   9.32  19.6   13.8 
#>  4 Antigua and Barbuda AG    ATG    2019  60.3   100   -14.0    1.21   7.32
#>  5 Armenia             AM    ARM    2019  74.5    99.9  -7.23   2.52   4.13
#>  6 Australia           AU    AUS    2019  81.2   100    -2.23   1.91   3.28
#>  7 Azerbaijan          AZ    AZE    2019  78.5   100    12.7    2.27   7.17
#>  8 Bahamas, The        BS    BHS    2019  59.9   100    -8.84   2.27   3.41
#>  9 Bahrain             BH    BHR    2019  76.0   100    -6.44   2.09   4.17
#> 10 Bangladesh          BD    BGD    2019  45.0    86.9  -2.21   5.54   2.99
#> # ℹ 113 more rows
```

This method nets us a more inclusive list than the other two methods, using recent data to "fill", where necessary, from recent years to account for more immediately missing data. Notice there are other options in the `.direction` argument, though I'm deliberate in selecting "down" to make sure only past observations can stand in for more current observations (i.e. I won't grab an observation from 2017 to fill in for 2016).

## A Simple Regression, and a Conclusion {#regression}

For the sake an end-of-the-course paper in [my BA-level quantitative methods course](http://ir3-2.svmiller.com/), I'd be happy with any one of these options that makes use of data from the World Bank's data bank (by way `{WDI}`), though the last of them would impress me the most. I'll only offer the caveat that there is no guarantee that all three of these would produce identical results.

Again assuming we want to explain variation in the ease of doing business score as a function of the other indicators we got, three simple linear models will result in results that aren't identical. Observe.

```r
M1 <- lm(edb ~ aepp + cab + cpi + irs, Option1)
M2 <- lm(edb ~ l1_aepp + l1_cab + l1_cpi + l1_irs, Option2)
M3 <- lm(edb ~ l1_aepp + l1_cab + l1_cpi + l1_irs, Option3)

modelsummary(list("Subset: 2019" = M1,
                  "Subset: 2019 (w/ IV Lags)" = M2,
                  "Subset: 2019 (w/ IV Lags and Fills)" = M3),
             stars = TRUE,
             title = "The Covariates of the Ease of Doing Business in 2019",
             coef_map = c(
               "aepp" = "Access to Electricity",
               "l1_aepp" = "Access to Electricity",
               "cab" = "Current Account Balance",
               "l1_cab" = "Current Account Balance",
               "cpi" = "Consumer Price Index",
               "l1_cpi" = "Consumer Price Index",
               "irs" = "Interest Rate Spread",
               "l1_irs" = "Interest Rate Spread"
             ),
             gof_map = c("nobs", "r.squared", "adj.r.squared"))
```

<div class="tinytable">

<!-- preamble start -->

    <script>
      function styleCell_44uxoemfnlwxxh0ybgzi(i, j, css_id) {
        var table = document.getElementById("tinytable_44uxoemfnlwxxh0ybgzi");
        table.rows[i].cells[j].classList.add(css_id);
      }
      function insertSpanRow(i, colspan, content) {
        var table = document.getElementById('tinytable_44uxoemfnlwxxh0ybgzi');
        var newRow = table.insertRow(i);
        var newCell = newRow.insertCell(0);
        newCell.setAttribute("colspan", colspan);
        // newCell.innerText = content;
        // this may be unsafe, but innerText does not interpret <br>
        newCell.innerHTML = content;
      }
      function spanCell_44uxoemfnlwxxh0ybgzi(i, j, rowspan, colspan) {
        var table = document.getElementById("tinytable_44uxoemfnlwxxh0ybgzi");
        const targetRow = table.rows[i];
        const targetCell = targetRow.cells[j];
        for (let r = 0; r < rowspan; r++) {
          // Only start deleting cells to the right for the first row (r == 0)
          if (r === 0) {
            // Delete cells to the right of the target cell in the first row
            for (let c = colspan - 1; c > 0; c--) {
              if (table.rows[i + r].cells[j + c]) {
                table.rows[i + r].deleteCell(j + c);
              }
            }
          }
          // For rows below the first, delete starting from the target column
          if (r > 0) {
            for (let c = colspan - 1; c >= 0; c--) {
              if (table.rows[i + r] && table.rows[i + r].cells[j]) {
                table.rows[i + r].deleteCell(j);
              }
            }
          }
        }
        // Set rowspan and colspan of the target cell
        targetCell.rowSpan = rowspan;
        targetCell.colSpan = colspan;
      }
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(0, 0, 'tinytable_css_idcy4cdcsl9hkpvgptuc6z') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(0, 1, 'tinytable_css_id1m8psvlxffk62lsxrebd') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(0, 2, 'tinytable_css_id1m8psvlxffk62lsxrebd') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(0, 3, 'tinytable_css_id1m8psvlxffk62lsxrebd') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(1, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(1, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(1, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(1, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(2, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(2, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(2, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(2, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(3, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(3, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(3, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(3, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(4, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(4, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(4, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(4, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(5, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(5, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(5, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(5, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(6, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(6, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(6, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(6, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(7, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(7, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(7, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(7, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(8, 0, 'tinytable_css_idqh2qg3euchhthzdd7itg') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(8, 1, 'tinytable_css_idxy0p17gyh1hil5w3zbeo') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(8, 2, 'tinytable_css_idxy0p17gyh1hil5w3zbeo') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(8, 3, 'tinytable_css_idxy0p17gyh1hil5w3zbeo') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(9, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(9, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(9, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(9, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(10, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(10, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(10, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(10, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(11, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(11, 1, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(11, 2, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(11, 3, 'tinytable_css_ide6wauwoupl37iyqzwzjn') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(12, 0, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(12, 1, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(12, 2, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
window.addEventListener('load', function () { styleCell_44uxoemfnlwxxh0ybgzi(12, 3, 'tinytable_css_idlnnpr4bpkj1zi9xt2gtm') })
    </script>

    <style>
    .table td.tinytable_css_idcy4cdcsl9hkpvgptuc6z, .table th.tinytable_css_idcy4cdcsl9hkpvgptuc6z {  text-align: left;  border-bottom: solid 0.1em #d3d8dc; }
    .table td.tinytable_css_id1m8psvlxffk62lsxrebd, .table th.tinytable_css_id1m8psvlxffk62lsxrebd {  text-align: center;  border-bottom: solid 0.1em #d3d8dc; }
    .table td.tinytable_css_idlnnpr4bpkj1zi9xt2gtm, .table th.tinytable_css_idlnnpr4bpkj1zi9xt2gtm {  text-align: left; }
    .table td.tinytable_css_ide6wauwoupl37iyqzwzjn, .table th.tinytable_css_ide6wauwoupl37iyqzwzjn {  text-align: center; }
    .table td.tinytable_css_idqh2qg3euchhthzdd7itg, .table th.tinytable_css_idqh2qg3euchhthzdd7itg {  border-bottom: solid 0.05em black;  text-align: left; }
    .table td.tinytable_css_idxy0p17gyh1hil5w3zbeo, .table th.tinytable_css_idxy0p17gyh1hil5w3zbeo {  border-bottom: solid 0.05em black;  text-align: center; }
    </style>
    <div class="container">
      <table class="table table-borderless" id="tinytable_44uxoemfnlwxxh0ybgzi" style="width: auto; margin-left: auto; margin-right: auto;" data-quarto-disable-processing='true'>
        <thead>
        <caption>The Covariates of the Ease of Doing Business in 2019</caption>
              <tr>
                <th scope="col"> </th>
                <th scope="col">Subset: 2019</th>
                <th scope="col">Subset: 2019 (w/ IV Lags)</th>
                <th scope="col">Subset: 2019 (w/ IV Lags and Fills)</th>
              </tr>
        </thead>
        <tfoot><tr><td colspan='4'>+ p < 0.1, * p < 0.05, ** p < 0.01, *** p < 0.001</td></tr></tfoot>
        <tbody>
                <tr>
                  <td>Access to Electricity  </td>
                  <td>0.194***</td>
                  <td>0.167***</td>
                  <td>0.206*** </td>
                </tr>
                <tr>
                  <td>                       </td>
                  <td>(0.042) </td>
                  <td>(0.040) </td>
                  <td>(0.033)  </td>
                </tr>
                <tr>
                  <td>Current Account Balance</td>
                  <td>0.171+  </td>
                  <td>0.344***</td>
                  <td>0.210*   </td>
                </tr>
                <tr>
                  <td>                       </td>
                  <td>(0.091) </td>
                  <td>(0.091) </td>
                  <td>(0.092)  </td>
                </tr>
                <tr>
                  <td>Consumer Price Index   </td>
                  <td>-0.013  </td>
                  <td>-0.202+ </td>
                  <td>-0.156***</td>
                </tr>
                <tr>
                  <td>                       </td>
                  <td>(0.036) </td>
                  <td>(0.109) </td>
                  <td>(0.035)  </td>
                </tr>
                <tr>
                  <td>Interest Rate Spread   </td>
                  <td>-0.603**</td>
                  <td>-0.516**</td>
                  <td>-0.491***</td>
                </tr>
                <tr>
                  <td>                       </td>
                  <td>(0.179) </td>
                  <td>(0.156) </td>
                  <td>(0.143)  </td>
                </tr>
                <tr>
                  <td>Num.Obs.               </td>
                  <td>99      </td>
                  <td>102     </td>
                  <td>123      </td>
                </tr>
                <tr>
                  <td>R2                     </td>
                  <td>0.379   </td>
                  <td>0.460   </td>
                  <td>0.454    </td>
                </tr>
                <tr>
                  <td>R2 Adj.                </td>
                  <td>0.353   </td>
                  <td>0.437   </td>
                  <td>0.436    </td>
                </tr>
        </tbody>
      </table>
    </div>
<!-- hack to avoid NA insertion in last line --> 

</div>

As the composition of the sample changes, so too do the test statistics. It's also the difference of thresholds of significance for the current account balance and consumer price index variables. I'll withhold comment about the advisability of this exact regression given the above caveat that this applied example is purposely thoughtless.[^ddd]

[^ddd]: For example, it would make sense to transform some of these variables. The consumer price index will always have a grotesque scale in a cross-national context, the interest rate spread and current account balance have similar quirks, and the access to electricity tops at 100% (which concerns over 30% of observations). Think carefully about what you're doing and why you're doing it.

I'll clarify here that this isn't supposed to be a serious analysis. Rather, it's supposed to be a tutorial that guides students on how to use `{WDI}` to do some introductory analyses that are suitable for their current level. Come armed with questions that you can answer with data, and think critically about what you want to do and why you want to do it. Using `{WDI}` and doing some basic lags/fills are quite simple by comparison. It's just a few lines of code.
