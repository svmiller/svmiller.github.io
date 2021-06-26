---
title: "Bootstrap Your Standard Errors in R, the Tidy Way"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2020-03-07'
excerpt: "Here is a how-to on bootstrapping standard errors in R in a flexible way, using some tidyverse-friendly packages like modelr and purrr."
layout: post
categories:
  - R
image: "system-of-a-down.jpg"
---





{% include image.html url="/images/system-of-a-down.jpg" caption="The Toxicity of Heteroskedasticity" width=350 align="right" %}

*Last updated: 28 April 2021* 

This will be another post I wish I can go back in time to show myself how to do when I was in graduate school. It's something I recently taught [my grad class](http://post8000.svmiller.com/) how to do as part of [a lab session](http://post8000.svmiller.com/lab-scripts/ols-diagnostics-lab.html).

Most of my research questions don't have solutions easily amenable to ordinary least squares (OLS) regression, whether because my main outcomes of interest are non-interval or because I'm freely confessing up front that I have important spatial/temporal heterogeneity that is important to model on its own terms. Still, the quantitative policy studies people love OLS and we all learn it first. However, as I caution, a model is only as useful as the assumptions that underpin it. When the assumptions that underpin it are violated, the model's output becomes suspect in some ways.

One of those important assumptions of an OLS model that's easy to violate in a social science application is that of [homoskedasticity](https://en.wikipedia.org/wiki/Homoscedasticity). The flip side of this, in as many words, is that the variability of our variable is unequal across the range of our variables that we believe explain it. This is ["heteroskedasticity."](http://www.statsmakemecry.com/smmctheblog/confusing-stats-terms-explained-heteroscedasticity-heteroske.html) More formally, the deviation between fitted value and the prediction error depends on an *x*-value. We often see this manifest in [a "cone of shame"](https://www.statisticshowto.datasciencecentral.com/wp-content/uploads/2014/02/Heteroscedasticity.jpg), though this is just the most obvious/illustrative way we observe it.  The implications for violating this assumption of homoskedasticity mostly concern our standard errors around our coefficients. They may be too large or too small, which could lead to either a Type 1 or Type 2 error.

There are various "solutions" for heteroskedasticity, which are less "solutions" (since it may hinge on the kind of heteroskedasticity and whether you know it or not). In practice, these solutions are more robustness tests to compare with your standard error estimates derived from a simple OLS model. One of those solutions is "bootstrapping", which was first introduced by [Efron (1979)](https://projecteuclid.org/euclid.aos/1176344552) as an extension of the "jackknife" approach. Briefly, the "jackknife" approach first introduced by [Quenouille (1949)](https://projecteuclid.org/euclid.aoms/1177729989), and given its name by [Tukey (1958)](https://doi.org/10.1214%2Faoms%2F1177706647), is a "leave-one-out" resampling method that recalculates a statistic of interest iteratively until each observation has been removed once. One limitation from this, beyond how tricky it is to adapt to more complex data structures, is jackknifing struggles with smaller data sets and the number of resamples is capped at the number of observations. Bootstrapping, a resampling with replacement approach to calculating statistics of interest (e.g. standard errors from a regression), is far more versatile and flexible.

Bootstrapping, [like Bayesian inference](http://svmiller.com/blog/2019/08/what-explains-union-density-brms-replication/), is another thing that mystified me in graduate school since learning it often meant being bombarded with instruction that cared more about notation than implementation. Learning statistics through Stata confounded matters, mostly because a simple call in a regression did the bootstrapping for you without explaining it (i.e. the reverse problem). Here, I'll hope to make it more transparent and explain what's happening in bootstrapping standard errors that both shows how to do it and explains what bootstrapping is doing.

First, here are the R packages that I will be using for this exercise, followed by a discussion of the data.

```r
library(tidyverse) # main workflow, which has purrr and forcats (IIRC)
library(stevemisc) # misc. functions of interest to me, Steve
library(stevedata) # my toy data package
library(lmtest) # for a Breusch-Pagan test for heteroskedasticity
# library(broom) # for tidying model output, but not directly loaded
library(knitr) # for tables
library(kableExtra) # for pretty tables
library(modelr) # for bootstrap
library(ggrepel) # one-off use for annotating a fitted-residual plot
```

## The Data and the Problem {#data}

The data I'm using are probably familiar to those who learned statistics by Stata. It's some statewide crime data from around 1993 or so that come available in Agresti and Finlay's *Statistical Methods for the Social Sciences* since around its third edition in 1997. I [ganked these data](http://users.stat.ufl.edu/~aa/social/data.html) from the internet and added it to [my `{stevedata}` package](http://svmiller.com/stevedata) as the `af_crime93` data. The data include 51 observations (i.e. 50 states + DC, [which should be a state](https://statehood.dc.gov/)) and you can [read more about it here](http://svmiller.com/stevedata/reference/af_crime93.html). I used this data set for this application because I know in advance these data are going to flunk a Breusch-Pagan test for heteroskedasticity.

Supposed we wanted to explain the violent crime rate per 100,000 people in the population (`violent`) as a function of the percentage of the state with income below the poverty level (`poverty`), the percentage of families in the state headed by a single parent (`single`), the percent of population in metropolitan areas (`metro`), the percentage of the state that is white (`white`), and the percentage of the state that graduated from high school (`highschool`). The ensuing regression formula---and pretty output with help from the `{broom}`, `{knitr}`, and `{kableExtra}` packages---would look like this. The output suggests all but the `white` variable and the `highschool` variable have statistically significant effects. Remember that *p*-value for the `white` variable, since it's hovering around .10. This would be almost statistically significant at a lower threshold that we typically use for smaller data sets.


```r
M1 <- lm(violent ~ poverty + single + metro + white + highschool, af_crime93)
```

<table id="stevetable">
<caption>What Explains the Violent Crime Rate in These Data?</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Term </th>
   <th style="text-align:center;"> Coefficient </th>
   <th style="text-align:center;"> Standard Error </th>
   <th style="text-align:center;"> t-statistic </th>
   <th style="text-align:center;"> p-value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Intercept </td>
   <td style="text-align:center;"> -1795.904 </td>
   <td style="text-align:center;"> 668.788 </td>
   <td style="text-align:center;"> -2.685 </td>
   <td style="text-align:center;"> 0.010 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> % Poverty </td>
   <td style="text-align:center;"> 26.244 </td>
   <td style="text-align:center;"> 11.083 </td>
   <td style="text-align:center;"> 2.368 </td>
   <td style="text-align:center;"> 0.022 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> % Single Family Home </td>
   <td style="text-align:center;"> 109.467 </td>
   <td style="text-align:center;"> 20.360 </td>
   <td style="text-align:center;"> 5.377 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> % Living in Metro Areas </td>
   <td style="text-align:center;"> 7.609 </td>
   <td style="text-align:center;"> 1.295 </td>
   <td style="text-align:center;"> 5.874 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> % White </td>
   <td style="text-align:center;"> -4.483 </td>
   <td style="text-align:center;"> 2.779 </td>
   <td style="text-align:center;"> -1.613 </td>
   <td style="text-align:center;"> 0.114 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> % High School Graduate </td>
   <td style="text-align:center;"> 8.646 </td>
   <td style="text-align:center;"> 7.826 </td>
   <td style="text-align:center;"> 1.105 </td>
   <td style="text-align:center;"> 0.275 </td>
  </tr>
</tbody>
</table>

However, people who report OLS models should also provide some diagnostic tests to explore whether the assumptions of the model hold. One of those assumptions is homoskedasticity, which can be tested with a Breusch-Pagan test from the `{lmtest}` package. Here, the test output is testing a null hypothesis of homoskedastic variances. If the p-value is low enough to your particular threshold---we'll go with *p* < .05---you should reject the null hypothesis of homoskedastic variance and assert you instead have heteroskedastic variances in your model. The output of the Breusch-Pagan test suggests we've violated the assumption of homoskedasticity with these data.


```r
broom::tidy(bptest(M1)) %>%
  kable(., format="html", table.attr='id="stevetable"',
        col.names=c("BP Statistic", "p-value", "Degrees of Freedom", "Method"),
        caption = "A Breusch-Pagan Test for Heteroskedasticity in our Model",
        align=c("c","c","c","l"))
```

<table id="stevetable">
<caption>A Breusch-Pagan Test for Heteroskedasticity in our Model</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> BP Statistic </th>
   <th style="text-align:center;"> p-value </th>
   <th style="text-align:center;"> Degrees of Freedom </th>
   <th style="text-align:left;"> Method </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 15.3974 </td>
   <td style="text-align:center;"> 0.0087926 </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:left;"> studentized Breusch-Pagan test </td>
  </tr>
</tbody>
</table>

A fitted-residual plot will also suggest we don't have neat-looking variances either.

![plot of chunk fitted-resid-plot-crime-data](/images/bootstrap-standard-errors-in-r/fitted-resid-plot-crime-data-1.png)

The implication of this kind of heteroskedasticity is less about our coefficients and more about the standard errors around them. Under these conditions, it makes sense to bootstrap the standard errors to compare them to what the OLS model produces.

## Bootstrapping, the Tidy Way

`{modelr}` and `{purrr}` will make bootstrapping a cinch. Recall that a bootstrap approach is a resampling method, with replacement, that can be done as many times as you want. Since the `af_crime93` dataset is rather small and the model is simple, let's go for a 1,000 bootstrap resamples with `{modelr}`. Let's also set a reproducible seed so anyone following along will get identical results. Do note that `{modelr}` has a separate `bootstrap()` function that will conflict with a different `bootstrap()` function in `{broom}`. I want the `{modelr}` version and situations like this is why I tend to never directly load `{broom}` in my workflow.


```r
set.seed(8675309) # Jenny, I got your number...

af_crime93 %>%
  bootstrap(1000) -> bootCrime
```

The `bootstrap()` function from `{modelr}` created a special [tibble](https://tibble.tidyverse.org/) that contains 1,000 resamples (with replacement, importantly) of our original data. This means some observations in a given resample will appear more than once. You can peek inside these as well. For example, let's look at the first resample and arrange it by state to see how some states appear more than once, and some don't appear at all. Notice some observations appear multiple times. Illinois appears three times in these 51 rows; Colorado is even in there five times! Some states, like Alaska and Wyoming, don't appear at all. That's fine because there's no doubt Alaska and Wyoming will be represented well across the 999 other resamples we're doing and that not every resample is going to have Colorado in it five times.


```r
bootCrime %>% 
  slice(1) %>% # grab the first row in this special tbl
  pull(strap) %>% # focus on the resample, momentarily a full list
  as.data.frame() %>% # cough up the full data
  arrange(state) %>% # arrange by state, for ease of reading
  select(-murder) %>% # this is another DV you could use, but not in this analysis.
  # let's pretty it up now
   kable(., format="html", table.attr='id="stevetable"',
        col.names=c("State", "Violent Crime Rate", "% Poverty", "% Single Family Home",
                    "% Living in Metro Areas", "% White", "% High School Graduate"),
        caption = "The First of Our 1,000 Resamples",
        align=c("l","c","c","c","c","c","c","c"))
```

<table id="stevetable">
<caption>The First of Our 1,000 Resamples</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> State </th>
   <th style="text-align:center;"> Violent Crime Rate </th>
   <th style="text-align:center;"> % Poverty </th>
   <th style="text-align:center;"> % Single Family Home </th>
   <th style="text-align:center;"> % Living in Metro Areas </th>
   <th style="text-align:center;"> % White </th>
   <th style="text-align:center;"> % High School Graduate </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> AL </td>
   <td style="text-align:center;"> 780 </td>
   <td style="text-align:center;"> 17.4 </td>
   <td style="text-align:center;"> 11.5 </td>
   <td style="text-align:center;"> 67.4 </td>
   <td style="text-align:center;"> 73.5 </td>
   <td style="text-align:center;"> 66.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AR </td>
   <td style="text-align:center;"> 593 </td>
   <td style="text-align:center;"> 20.0 </td>
   <td style="text-align:center;"> 10.7 </td>
   <td style="text-align:center;"> 44.7 </td>
   <td style="text-align:center;"> 82.9 </td>
   <td style="text-align:center;"> 66.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:center;"> 1078 </td>
   <td style="text-align:center;"> 18.2 </td>
   <td style="text-align:center;"> 12.5 </td>
   <td style="text-align:center;"> 96.7 </td>
   <td style="text-align:center;"> 79.3 </td>
   <td style="text-align:center;"> 76.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO </td>
   <td style="text-align:center;"> 567 </td>
   <td style="text-align:center;"> 9.9 </td>
   <td style="text-align:center;"> 12.1 </td>
   <td style="text-align:center;"> 81.8 </td>
   <td style="text-align:center;"> 92.5 </td>
   <td style="text-align:center;"> 84.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO </td>
   <td style="text-align:center;"> 567 </td>
   <td style="text-align:center;"> 9.9 </td>
   <td style="text-align:center;"> 12.1 </td>
   <td style="text-align:center;"> 81.8 </td>
   <td style="text-align:center;"> 92.5 </td>
   <td style="text-align:center;"> 84.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO </td>
   <td style="text-align:center;"> 567 </td>
   <td style="text-align:center;"> 9.9 </td>
   <td style="text-align:center;"> 12.1 </td>
   <td style="text-align:center;"> 81.8 </td>
   <td style="text-align:center;"> 92.5 </td>
   <td style="text-align:center;"> 84.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO </td>
   <td style="text-align:center;"> 567 </td>
   <td style="text-align:center;"> 9.9 </td>
   <td style="text-align:center;"> 12.1 </td>
   <td style="text-align:center;"> 81.8 </td>
   <td style="text-align:center;"> 92.5 </td>
   <td style="text-align:center;"> 84.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO </td>
   <td style="text-align:center;"> 567 </td>
   <td style="text-align:center;"> 9.9 </td>
   <td style="text-align:center;"> 12.1 </td>
   <td style="text-align:center;"> 81.8 </td>
   <td style="text-align:center;"> 92.5 </td>
   <td style="text-align:center;"> 84.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CT </td>
   <td style="text-align:center;"> 456 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 10.1 </td>
   <td style="text-align:center;"> 95.7 </td>
   <td style="text-align:center;"> 89.0 </td>
   <td style="text-align:center;"> 79.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:center;"> 686 </td>
   <td style="text-align:center;"> 10.2 </td>
   <td style="text-align:center;"> 11.4 </td>
   <td style="text-align:center;"> 82.7 </td>
   <td style="text-align:center;"> 79.4 </td>
   <td style="text-align:center;"> 77.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FL </td>
   <td style="text-align:center;"> 1206 </td>
   <td style="text-align:center;"> 17.8 </td>
   <td style="text-align:center;"> 10.6 </td>
   <td style="text-align:center;"> 93.0 </td>
   <td style="text-align:center;"> 83.5 </td>
   <td style="text-align:center;"> 74.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FL </td>
   <td style="text-align:center;"> 1206 </td>
   <td style="text-align:center;"> 17.8 </td>
   <td style="text-align:center;"> 10.6 </td>
   <td style="text-align:center;"> 93.0 </td>
   <td style="text-align:center;"> 83.5 </td>
   <td style="text-align:center;"> 74.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GA </td>
   <td style="text-align:center;"> 723 </td>
   <td style="text-align:center;"> 13.5 </td>
   <td style="text-align:center;"> 13.0 </td>
   <td style="text-align:center;"> 67.7 </td>
   <td style="text-align:center;"> 70.8 </td>
   <td style="text-align:center;"> 70.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HI </td>
   <td style="text-align:center;"> 261 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 9.1 </td>
   <td style="text-align:center;"> 74.7 </td>
   <td style="text-align:center;"> 40.9 </td>
   <td style="text-align:center;"> 80.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HI </td>
   <td style="text-align:center;"> 261 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 9.1 </td>
   <td style="text-align:center;"> 74.7 </td>
   <td style="text-align:center;"> 40.9 </td>
   <td style="text-align:center;"> 80.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IA </td>
   <td style="text-align:center;"> 326 </td>
   <td style="text-align:center;"> 10.3 </td>
   <td style="text-align:center;"> 9.0 </td>
   <td style="text-align:center;"> 43.8 </td>
   <td style="text-align:center;"> 96.6 </td>
   <td style="text-align:center;"> 80.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ID </td>
   <td style="text-align:center;"> 282 </td>
   <td style="text-align:center;"> 13.1 </td>
   <td style="text-align:center;"> 9.5 </td>
   <td style="text-align:center;"> 30.0 </td>
   <td style="text-align:center;"> 96.7 </td>
   <td style="text-align:center;"> 79.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ID </td>
   <td style="text-align:center;"> 282 </td>
   <td style="text-align:center;"> 13.1 </td>
   <td style="text-align:center;"> 9.5 </td>
   <td style="text-align:center;"> 30.0 </td>
   <td style="text-align:center;"> 96.7 </td>
   <td style="text-align:center;"> 79.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IL </td>
   <td style="text-align:center;"> 960 </td>
   <td style="text-align:center;"> 13.6 </td>
   <td style="text-align:center;"> 11.5 </td>
   <td style="text-align:center;"> 84.0 </td>
   <td style="text-align:center;"> 81.0 </td>
   <td style="text-align:center;"> 76.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IL </td>
   <td style="text-align:center;"> 960 </td>
   <td style="text-align:center;"> 13.6 </td>
   <td style="text-align:center;"> 11.5 </td>
   <td style="text-align:center;"> 84.0 </td>
   <td style="text-align:center;"> 81.0 </td>
   <td style="text-align:center;"> 76.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IL </td>
   <td style="text-align:center;"> 960 </td>
   <td style="text-align:center;"> 13.6 </td>
   <td style="text-align:center;"> 11.5 </td>
   <td style="text-align:center;"> 84.0 </td>
   <td style="text-align:center;"> 81.0 </td>
   <td style="text-align:center;"> 76.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IN </td>
   <td style="text-align:center;"> 489 </td>
   <td style="text-align:center;"> 12.2 </td>
   <td style="text-align:center;"> 10.8 </td>
   <td style="text-align:center;"> 71.6 </td>
   <td style="text-align:center;"> 90.6 </td>
   <td style="text-align:center;"> 75.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KS </td>
   <td style="text-align:center;"> 496 </td>
   <td style="text-align:center;"> 13.1 </td>
   <td style="text-align:center;"> 9.9 </td>
   <td style="text-align:center;"> 54.6 </td>
   <td style="text-align:center;"> 90.9 </td>
   <td style="text-align:center;"> 81.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KY </td>
   <td style="text-align:center;"> 463 </td>
   <td style="text-align:center;"> 20.4 </td>
   <td style="text-align:center;"> 10.6 </td>
   <td style="text-align:center;"> 48.5 </td>
   <td style="text-align:center;"> 91.8 </td>
   <td style="text-align:center;"> 64.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LA </td>
   <td style="text-align:center;"> 1062 </td>
   <td style="text-align:center;"> 26.4 </td>
   <td style="text-align:center;"> 14.9 </td>
   <td style="text-align:center;"> 75.0 </td>
   <td style="text-align:center;"> 66.7 </td>
   <td style="text-align:center;"> 68.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:center;"> 805 </td>
   <td style="text-align:center;"> 10.7 </td>
   <td style="text-align:center;"> 10.9 </td>
   <td style="text-align:center;"> 96.2 </td>
   <td style="text-align:center;"> 91.1 </td>
   <td style="text-align:center;"> 80.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:center;"> 805 </td>
   <td style="text-align:center;"> 10.7 </td>
   <td style="text-align:center;"> 10.9 </td>
   <td style="text-align:center;"> 96.2 </td>
   <td style="text-align:center;"> 91.1 </td>
   <td style="text-align:center;"> 80.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MD </td>
   <td style="text-align:center;"> 998 </td>
   <td style="text-align:center;"> 9.7 </td>
   <td style="text-align:center;"> 12.0 </td>
   <td style="text-align:center;"> 92.8 </td>
   <td style="text-align:center;"> 68.9 </td>
   <td style="text-align:center;"> 78.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MD </td>
   <td style="text-align:center;"> 998 </td>
   <td style="text-align:center;"> 9.7 </td>
   <td style="text-align:center;"> 12.0 </td>
   <td style="text-align:center;"> 92.8 </td>
   <td style="text-align:center;"> 68.9 </td>
   <td style="text-align:center;"> 78.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ME </td>
   <td style="text-align:center;"> 126 </td>
   <td style="text-align:center;"> 10.7 </td>
   <td style="text-align:center;"> 10.6 </td>
   <td style="text-align:center;"> 35.7 </td>
   <td style="text-align:center;"> 98.5 </td>
   <td style="text-align:center;"> 78.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MN </td>
   <td style="text-align:center;"> 327 </td>
   <td style="text-align:center;"> 11.6 </td>
   <td style="text-align:center;"> 9.9 </td>
   <td style="text-align:center;"> 69.3 </td>
   <td style="text-align:center;"> 94.0 </td>
   <td style="text-align:center;"> 82.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MO </td>
   <td style="text-align:center;"> 744 </td>
   <td style="text-align:center;"> 16.1 </td>
   <td style="text-align:center;"> 10.9 </td>
   <td style="text-align:center;"> 68.3 </td>
   <td style="text-align:center;"> 87.6 </td>
   <td style="text-align:center;"> 73.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NC </td>
   <td style="text-align:center;"> 679 </td>
   <td style="text-align:center;"> 14.4 </td>
   <td style="text-align:center;"> 11.1 </td>
   <td style="text-align:center;"> 66.3 </td>
   <td style="text-align:center;"> 75.2 </td>
   <td style="text-align:center;"> 70.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NC </td>
   <td style="text-align:center;"> 679 </td>
   <td style="text-align:center;"> 14.4 </td>
   <td style="text-align:center;"> 11.1 </td>
   <td style="text-align:center;"> 66.3 </td>
   <td style="text-align:center;"> 75.2 </td>
   <td style="text-align:center;"> 70.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ND </td>
   <td style="text-align:center;"> 82 </td>
   <td style="text-align:center;"> 11.2 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 41.6 </td>
   <td style="text-align:center;"> 94.2 </td>
   <td style="text-align:center;"> 76.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NJ </td>
   <td style="text-align:center;"> 627 </td>
   <td style="text-align:center;"> 10.9 </td>
   <td style="text-align:center;"> 9.6 </td>
   <td style="text-align:center;"> 100.0 </td>
   <td style="text-align:center;"> 80.8 </td>
   <td style="text-align:center;"> 76.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NY </td>
   <td style="text-align:center;"> 1074 </td>
   <td style="text-align:center;"> 16.4 </td>
   <td style="text-align:center;"> 12.7 </td>
   <td style="text-align:center;"> 91.7 </td>
   <td style="text-align:center;"> 77.2 </td>
   <td style="text-align:center;"> 74.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OH </td>
   <td style="text-align:center;"> 504 </td>
   <td style="text-align:center;"> 13.0 </td>
   <td style="text-align:center;"> 11.4 </td>
   <td style="text-align:center;"> 81.3 </td>
   <td style="text-align:center;"> 87.5 </td>
   <td style="text-align:center;"> 75.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OK </td>
   <td style="text-align:center;"> 635 </td>
   <td style="text-align:center;"> 19.9 </td>
   <td style="text-align:center;"> 11.1 </td>
   <td style="text-align:center;"> 60.1 </td>
   <td style="text-align:center;"> 82.5 </td>
   <td style="text-align:center;"> 74.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OR </td>
   <td style="text-align:center;"> 503 </td>
   <td style="text-align:center;"> 11.8 </td>
   <td style="text-align:center;"> 11.3 </td>
   <td style="text-align:center;"> 70.0 </td>
   <td style="text-align:center;"> 93.2 </td>
   <td style="text-align:center;"> 81.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PA </td>
   <td style="text-align:center;"> 418 </td>
   <td style="text-align:center;"> 13.2 </td>
   <td style="text-align:center;"> 9.6 </td>
   <td style="text-align:center;"> 84.8 </td>
   <td style="text-align:center;"> 88.7 </td>
   <td style="text-align:center;"> 74.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PA </td>
   <td style="text-align:center;"> 418 </td>
   <td style="text-align:center;"> 13.2 </td>
   <td style="text-align:center;"> 9.6 </td>
   <td style="text-align:center;"> 84.8 </td>
   <td style="text-align:center;"> 88.7 </td>
   <td style="text-align:center;"> 74.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SD </td>
   <td style="text-align:center;"> 208 </td>
   <td style="text-align:center;"> 14.2 </td>
   <td style="text-align:center;"> 9.4 </td>
   <td style="text-align:center;"> 32.6 </td>
   <td style="text-align:center;"> 90.2 </td>
   <td style="text-align:center;"> 77.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TX </td>
   <td style="text-align:center;"> 762 </td>
   <td style="text-align:center;"> 17.4 </td>
   <td style="text-align:center;"> 11.8 </td>
   <td style="text-align:center;"> 83.9 </td>
   <td style="text-align:center;"> 85.1 </td>
   <td style="text-align:center;"> 72.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TX </td>
   <td style="text-align:center;"> 762 </td>
   <td style="text-align:center;"> 17.4 </td>
   <td style="text-align:center;"> 11.8 </td>
   <td style="text-align:center;"> 83.9 </td>
   <td style="text-align:center;"> 85.1 </td>
   <td style="text-align:center;"> 72.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VA </td>
   <td style="text-align:center;"> 372 </td>
   <td style="text-align:center;"> 9.7 </td>
   <td style="text-align:center;"> 10.3 </td>
   <td style="text-align:center;"> 77.5 </td>
   <td style="text-align:center;"> 77.1 </td>
   <td style="text-align:center;"> 75.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VT </td>
   <td style="text-align:center;"> 114 </td>
   <td style="text-align:center;"> 10.0 </td>
   <td style="text-align:center;"> 11.0 </td>
   <td style="text-align:center;"> 27.0 </td>
   <td style="text-align:center;"> 98.4 </td>
   <td style="text-align:center;"> 80.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VT </td>
   <td style="text-align:center;"> 114 </td>
   <td style="text-align:center;"> 10.0 </td>
   <td style="text-align:center;"> 11.0 </td>
   <td style="text-align:center;"> 27.0 </td>
   <td style="text-align:center;"> 98.4 </td>
   <td style="text-align:center;"> 80.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WI </td>
   <td style="text-align:center;"> 264 </td>
   <td style="text-align:center;"> 12.6 </td>
   <td style="text-align:center;"> 10.4 </td>
   <td style="text-align:center;"> 68.1 </td>
   <td style="text-align:center;"> 92.1 </td>
   <td style="text-align:center;"> 78.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WI </td>
   <td style="text-align:center;"> 264 </td>
   <td style="text-align:center;"> 12.6 </td>
   <td style="text-align:center;"> 10.4 </td>
   <td style="text-align:center;"> 68.1 </td>
   <td style="text-align:center;"> 92.1 </td>
   <td style="text-align:center;"> 78.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WV </td>
   <td style="text-align:center;"> 208 </td>
   <td style="text-align:center;"> 22.2 </td>
   <td style="text-align:center;"> 9.4 </td>
   <td style="text-align:center;"> 41.8 </td>
   <td style="text-align:center;"> 96.3 </td>
   <td style="text-align:center;"> 66.0 </td>
  </tr>
</tbody>
</table>

Now, here's where the magic happens that will show how awesome `{purrr}` is for these things if you take some time to learn it. For each of these 1,000 resamples, we're going to run the same regression from above and store the results in our special tibble as a column named `lm`. Next, we're going to create another column (`tidy`) that tidies up those linear models. Yes, that's actually a thousand linear regressions we're running and saving a tibble. Tibbles are awesome.


```r

bootCrime %>% 
    mutate(lm = map(strap, ~lm(violent ~ poverty + single + metro + white + highschool, 
                     data = .)),
           tidy = map(lm, broom::tidy)) -> bootCrime
```

If you were to call the `bootCrime` object at this stage into the R console, you're going to get a tibble that looks kind of complex and daunting. It is, by the way, but we're going to make some sense of it going forward.


```r
bootCrime
#> # A tibble: 1,000 x 4
#>    strap      .id   lm     tidy            
#>    <list>     <chr> <list> <list>          
#>  1 <resample> 0001  <lm>   <tibble [6 × 5]>
#>  2 <resample> 0002  <lm>   <tibble [6 × 5]>
#>  3 <resample> 0003  <lm>   <tibble [6 × 5]>
#>  4 <resample> 0004  <lm>   <tibble [6 × 5]>
#>  5 <resample> 0005  <lm>   <tibble [6 × 5]>
#>  6 <resample> 0006  <lm>   <tibble [6 × 5]>
#>  7 <resample> 0007  <lm>   <tibble [6 × 5]>
#>  8 <resample> 0008  <lm>   <tibble [6 × 5]>
#>  9 <resample> 0009  <lm>   <tibble [6 × 5]>
#> 10 <resample> 0010  <lm>   <tibble [6 × 5]>
#> # … with 990 more rows
```

If you were curious, you could look at a particular OLS result with the following code. You're wanting to glance inside a list inside a tibble, so the indexing you do should consider that. I'm electing to not spit out the results in this post, but this code will do it.

```r
# here's the first linear regression result
bootCrime$tidy[[1]]

# here's the 1000th one
bootCrime$tidy[[1000]]
```

Now, this is where you're going to start summarizing the results from your thousand regressions. Next, we should pull the tidy lists from the `bootCrime` tibble and "map" over them into a new tibble. This is where the investment into learning `{purrr}` starts to pay off. It would be quite time-consuming to do this in some other way.


```r

bootCrime %>%
  pull(tidy) %>%
  map2_df(., # map to return a data frame
          seq(1, 1000), # make sure to get this seq right. We did this 1000 times.
          ~mutate(.x, resample = .y)) -> tidybootCrime
```

If you're curious, this basically just ganked all the "tidied" output of our 1,000 regressions and binded them as rows to each other, with helpful indices in the `resample` column. Observe:


```r
tidybootCrime
#> # A tibble: 6,000 x 6
#>    term        estimate std.error statistic      p.value resample
#>    <chr>          <dbl>     <dbl>     <dbl>        <dbl>    <int>
#>  1 (Intercept) -1150.      660.      -1.74  0.0886              1
#>  2 poverty        28.7      10.5      2.75  0.00861             1
#>  3 single         71.1      22.3      3.19  0.00260             1
#>  4 metro           8.61      1.28     6.73  0.0000000258        1
#>  5 white          -1.72      2.15    -0.803 0.426               1
#>  6 highschool      1.46      8.11     0.179 0.858               1
#>  7 (Intercept) -1175.      845.      -1.39  0.171               2
#>  8 poverty        51.0      12.6      4.06  0.000193            2
#>  9 single         11.9      28.5      0.418 0.678               2
#> 10 metro           7.92      1.28     6.21  0.000000154         2
#> # … with 5,990 more rows
```

This next code will calculate the standard errors. Importantly, *bootstrap standard errors are the standard deviation of the coefficient estimate for each of the parameters in the model.* That part may not be obvious. It's not the mean of standard errors for the estimate; it's the standard deviation of the coefficient estimate itself.


```r
tidybootCrime %>%
  # group by term, naturally
  group_by(term) %>%
  # This is the actual bootstrapped standard error you want
  summarize(bse = sd(estimate)) -> bseM1
```

When you bootstrap your standard errors under these conditions, you should compare the results of these bootstrapped standard errors with the standard OLS standard errors for the parameters in your model. Here, we'll do it visually. The ensuing plot suggests the standard errors most influenced by the heteroskedasticity in our model are those for the single family home variable and especially the percentage of the state that is white variable. In the former case, the bootstrapping still produced standard errors that could rule out a counterclaim of zero relationship, but the percentage of the state that is white variable becomes much more diffuse when its standard errors are bootstrapped. Sure, the 90% confidence intervals that we're using here (given the small number of observations) would still slightly overlap zero with the OLS estimates, but it was close. It's not close when the standard errors are bootstrapped. We should be cautious about wanting to make an argument for a precise effect there in our model.


```r
broom::tidy(M1) %>%
  mutate(category = "Normal OLS Standard Errors") %>%
  # This will be convoluted, but I know what I'm doing.
  # Trust me; I'm a doctor.
  bind_rows(., broom::tidy(M1) %>% select(-std.error) %>% left_join(., bseM1 %>% rename(std.error = bse))) %>%
  mutate(category = ifelse(is.na(category), "Bootstrapped Standard Errors", category),
         tstat = estimate/std.error,
         pval = 1.645*pt(-abs(tstat),df=45), # dfs from M1
         lwr = estimate - 1.645*std.error,
         upr = estimate + 1.645*std.error) %>%
  filter(term != "(Intercept)") %>% # ignore the intercept
  mutate(term = forcats::fct_recode(term,
                                    "% Poverty" = "poverty",
                                    "% Single Family Home" = "single",
                                    "% Living in Metro Areas" = "metro",
                                    "% White" = "white",
                                    "% High School Graduate" = "highschool")) %>%
   ggplot(.,aes(category, estimate, ymin=lwr, ymax=upr)) + 
  theme_steve_web() + post_bg() +
  geom_pointrange(position = position_dodge(width = 1)) +
  facet_wrap(~term, scales="free_x") +
  geom_hline(yintercept = 0, linetype="dashed") +
  coord_flip() +
  labs(x = "", y="",
       title = "A Comparison of Normal OLS Standard Errors with Bootstrapped Standard Errors",
       subtitle = "A plot like this visualizes how different standard errors could be when adjusted for heteroskedasticity.")
```

![plot of chunk bootstrapped-ses-crime-data](/images/bootstrap-standard-errors-in-r/bootstrapped-ses-crime-data-1.png)

## Conclusion

Once you understand what bootstrapping is, and appreciate how easy it is to do with `{modelr}` and some `{purrr}` magic, you might better appreciate its flexibility. If you have a small enough data set with a simple enough OLS model---which admittedly seems like a relic of another time in political science---bootstrapping with this approach offers lots of opportunities. One intriguing application here is bootstrapping predictions from these 1,000 regressions. In other words, we could hold all but the poverty variable constant, set the poverty variable at a standard deviation above and below its mean, and get predictions across those 1,000 regressions and summarize them accordingly.

Either way, bootstrapping is a lot easier/straightforward than some texts let on. If it's not too computationally demanding (i.e. your data set is small and doesn't present other issues of spatial or temporal clustering), you could do lots of cool things with bootstrapping. The hope is this guide made it easier.
