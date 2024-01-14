---
title: "Linear Model Diagnostics by IR Example"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2024-01-11'
excerpt: "Linear model diagnostics for linearity and heteroskedasticity can induce you to make different design choices, which have implications for statistical significance. The example here is the effect of post-conflict justice on net FDI inflows in post-conflict states."
layout: post
categories:
  - R
  - Political Science
image: "2003-08-28-peru-truth-reconciliation-commission.jpg"
active: blog
---



{% include image.html url="/images/2003-08-28-peru-truth-reconciliation-commission.jpg" caption="Peru's Truth and Reconciliation Commission, which ran from 2001 to 2003, was tasked with investigating the human rights abuses committed in the country during its armed conflict with Sendero Luminoso. It may have further signaled to investors that Peru was serious about peace." width=400 align="right" %}

I'm teaching [a first-year MA-level quantitative methods course](http://eh6105.svmiller.com/) at the moment for which the current topic is [linear model diagnostics](http://eh6105.svmiller.com/lab-scripts/ols-diagnostics.html). The particular example that I had time and space to give them resulted in a situation where there were heteroskedastic errors, albeit with no major inferential implications whatsoever. This understandably led a student to ask if there was a case where heteroskedasticity and assorted heteroskedasticity robustness tests resulted in major inferential implications. The best answer you could give is "of course, but you wouldn't know until you checked". I could definitely give [a U.S.-focused example](http://post8000.svmiller.com/lab-scripts/ols-diagnostics-lab.html#Potential_Fixes_for_Heteroskedasticity) that wouldn't resonate with a European audience. However, the time and space I had before starting the class didn't give me time to find an example that students in IR might actually understand. Even then, there aren't many (simple) linear models you encounter in international relations. Most of the things we care about happen or don't (and are thus better modeled through a logistic/probit regression) or have lots of moving pieces (i.e. are panel models) that are outside the bounds of the class.

There is, however, one example to offer. We should all thank [Joshua Alley](https://joshuaalley.github.io/) for beginning to curate [a repository on cross-sectional OLS models](https://github.com/joshuaalley/cross-sectional-ols) around which you can teach in political science and international relations. One of those data sets from a 2012 publication by Benjamin J. Appel and Cyanne E. Loyle [in *Journal of Peace Research*](https://journals.sagepub.com/doi/10.1177/0022343312450044) on the economic benefits of post-conflict justice. This is an interesting paper to read with an intuitive argument and application. They argue that post-conflict states that engage in some kind of post-conflict justice initiative---like truth and reconciliation commissions or reparations---are getting a downstream benefit from it relative to states that do not do this. These states are signaling to outside investors that they are serious about peace, notwithstanding the conflict that would otherwise make them risky investments. As a result, we should expect, and the authors indeed find, that post-conflict states that engage in post-conflict justice institutions have higher levels of net foreign direct investment (FDI) inflows 10 years after a conflict ended compared to post-conflict states that do not have these institutions. Their data is rather bite-sized too: 95 observations of conflict and 10-year windows afterward for a temporal domain around 1970 to 2001.

There's a lot to like about the argument, and certainly the data for pedagogical purposes. It's a rare case of a simple OLS with a straightforward IR application. There's also all sorts of interesting things happening in it that are worth exploring.

Here are the R packages we'll be using for this post.


```r
library(tidyverse)     # for most things
library(stevemisc)     # for helper functions
library(kableExtra)    # for tables
library(stevedata)     # for the data
library(modelsummary)  # for being awesome
library(dfadjust)      # for DF. Adj. standard errors, a la Imbens and Kolesár (2016)
library(stevethemes)   # for my themes
library(lmtest)        # for model diagnostics/summaries
library(sandwich)      # for the majority of standard error adjustments.

theme_set(theme_steve())
```

## The Data and the Model

This simple exercise will just replicate Model 1 of what is their Table I. Here, we're going to set up a simple model whose purpose can be phrased as follows. Appel and Loyle (2012) are proposing that scholars interested in the variation in net FDI inflows have only looked at net FDI inflows from an economic perspective. They're missing an important political perspective (i.e. post-conflict justice institutions). Perhaps we could adequately model an economic indicator like net FDI inflows with important economic correlates, but there's a political element that Appel and Loyle are proposing. However, to justify their political perspective, they need to control for the important economic determinants of net FDI inflows. Perhaps it's reasonably exhaustive to model net FDI inflows as a function of gross domestic product (GDP) per capita (`econ_devel`), GDP (`econ_size`), GDP per capita growth (`econ_growth`, over a 10-year period), capital openness (`kaopen`), exchange rate volatility (`xr`), labor force size (`lf`), and life expectancy for women (`lifeexp`). However, there's still an important political determinant of net FDI inflows---post-conflict justice (`pcj`)---even "controlling" for those things.

Let's explore this with [the `EBJ` data in `{stevedata}`](http://svmiller.com/stevedata/reference/EBJ.html), which is just a reduced form of their replication data. Their Stata code makes clear this is just a simple linear model with no adjustments reported for heteroskedasticity or "robustness". The following code will perfectly reproduce their Model 1 in Table I. `{modelsummary}` will quietly format the results into a regression table. 


```r
M1 <- lm(fdi ~ pcj + econ_devel + econ_size + econ_growth + kaopen + xr + lf + lifeexp, EBJ)
```

<div id ="modelsummary">

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
<caption>A Reproduction of Model 1 in Table I in Appel and Loyle (2012)</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Replication </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Post-conflict Justice </td>
   <td style="text-align:center;"> 1532.608* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (629.400) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Economic Development </td>
   <td style="text-align:center;"> −0.058 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.134) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Economic Size </td>
   <td style="text-align:center;"> 0.000* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.000) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Economic Growth </td>
   <td style="text-align:center;"> 0.724 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (21.298) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Capital Openness </td>
   <td style="text-align:center;"> 132.574 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (208.004) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Exchange Rate </td>
   <td style="text-align:center;"> −49.220* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (13.561) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Labor Force </td>
   <td style="text-align:center;"> 14.719 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (25.454) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Life Expectancy (Female) </td>
   <td style="text-align:center;"> 17.395 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (30.288) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Intercept </td>
   <td style="text-align:center;"> −2011.642 </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1.5px">  </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (2677.858) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 95 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.370 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05</td></tr></tfoot>
</table>



</div>

I will leave the reader to compare the results of Model 1 here to Model 1 of Table I in their paper. The basic takeaways are the same. Controlling for the economic determinants of net FDI inflows, there is a statistically significant relationship between post-conflict justice and net FDI inflows among these post-conflict states. Post-conflict states with post-conflict justice institutions have higher levels of net FDI inflows than post-conflict states without them. The estimated difference between them is ~$1532.61. If the true relationship were 0, the probability we observed what we observed would've happened 16 times in a thousand trials, on average.

## Checking the Linearity Assumption

We teach students that one major assumption about the linear model is that the model is both *linear* and *additive*. In other words, the estimate of *y* (here: net FDI inflows) is an additive combination of the regressors (and an error term). The regression lines are assumed to be straight. A first cut to see if this assumption is satisfied is the fitted-residual plot. Plot the model's fitted values on the the *x*-axis and the residuals on the *y*-axis as a scatterplot. By definition, the line of best fit through the data is flat at 0. Ideally, a LOESS smoother agrees with it.


```r
broom::augment(M1) %>%
  ggplot(.,aes(.fitted, .resid)) +
  geom_point() +
  geom_smooth(method="loess") +
  geom_hline(yintercept = 0, linetype ='dashed')
```

![plot of chunk fitted-residual-plot-post-conflict-justice-fdi](/images/linear-model-diagnostics-by-ir-example/fitted-residual-plot-post-conflict-justice-fdi-1.png)

This plot has great informational value as a diagnostic (i.e. it's also suggesting to me I have heteroskedastic errors). Here, it's clearly telling me I have weirdness in my data that suggests non-linearity evident in the model betrays the assumption of linearity. It comes with two caveats, though. For one, a model with just 95 observations isn't going to have a fitted-residual plot that is as easy to decipher as a plot with several hundred observations. Two, the fitted-residual plot will suggests non-linearity but won't tell me where exactly it is.

I have a function in [`{stevemisc}`](http://svmiller.com/stevemisc/) that offers some illustrative evidence of where the non-linearity might be, along with other things that may be worth considering. `linloess_plot()`, by default, will make bivariate comparison's of the model's residuals with all right-hand side variables. It will overlay over it the line of best fit (0 by definition) and a smoother of your choice (default is LOESS). Where the two diverge, it suggests some kind of non-linearity. Trial and error with the function's arguments will produce something that's at least presentable.


```r
linloess_plot(M1, span=1, se=F)
```

![plot of chunk linloess-plot-post-conflict-justice](/images/linear-model-diagnostics-by-ir-example/linloess-plot-post-conflict-justice-1.png)

There's a lot to unpack here (acknowledging that binary IVs will never be an issue here). Ideally, we would have more observations (i.e. the LOESS smoother is going to whine a bit for the absence of data points in certain areas), but it's pointing to some weirdness in several variables. The exchange rate variable mostly clusters near 0, though there are a few anomalous observations that are miles from the bulk of the data. The development, growth, and size variables are all behaving weirdly. For one, it's going to immediately stand out that these variables are on their raw scale. In other words, the economic size variable for the fourth row (for which `ccode == 70` [Mexico]) is 628,418,000,000. It's tough to say anything definitive in the absence of more information (i.e. when exactly is this GDP for Mexico and is it benchmarked to some particular dollar), it's still very obvious this is raw dollars. Curvilinearity is evident in this, but that curvilinearity may not have emerged had this been log-transformed.

Indeed, a lot of what is shown here could've been anticipated by looking at the data first.


```r
EBJ %>%
  select(fdi:lifeexp, -pcj) %>%
  gather(var, val) %>%
  ggplot(.,aes(val)) + geom_density() +
  facet_wrap(~var, scales='free')
```

![plot of chunk density-plots-post-conflict-justice-fdi](/images/linear-model-diagnostics-by-ir-example/density-plots-post-conflict-justice-fdi-1.png)

There are some obvious design choices you could make from this. We should 100% log-transform the GDP and GDP per capita variable. One is obvious, but [has a caveat worth belaboring](https://www.robertkubinec.com/post/logs/) for real variables with 0s. Practitioners would +1-and-log that exchange rate variable and perhaps we can do that here without controversy. Some are less obvious. The economic growth variable and FDI variable both have negative values, so logarithmic transformations without an additive constant are not available to us. The economic growth variable is still mostly fine as a distribution, but has two anomalous values far to the right. The FDI variable has a very interesting distribution. It's almost like [a Student's t-distribution with three or fewer degrees of freedom](http://svmiller.com/blog/2021/02/thinking-about-your-priors-bayesian-analysis/). I have an idea of what I'd like to do with this variable for pedagogical purposes, but I'll save that for another post.

For now, let's do this. Let's log-transform the development and size variables, +1-and-log the exchange rate variable, and just wave our hands at the economic growth variable. If the lin-LOESS plot I introduced above is correct, it's suggesting a square term effect of economic size that we should also model.


```r
EBJ %>%
  log_at(c("econ_devel", "econ_size")) %>%
  mutate(ln_xr = log(xr + 1)) -> EBJ

M2 <- lm(fdi ~ pcj + ln_econ_devel + ln_econ_size + 
           I(ln_econ_size^2) + econ_growth + kaopen + ln_xr + lf + lifeexp, EBJ)
```

<div id ="modelsummary">

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
<caption>A Reproduction and Re-Analysis of Model 1 in Table I in Appel and Loyle (2012)</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Replication </th>
   <th style="text-align:center;"> With Transformations </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Post-conflict Justice </td>
   <td style="text-align:center;"> 1532.608* </td>
   <td style="text-align:center;"> 1525.326* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (629.400) </td>
   <td style="text-align:center;"> (714.274) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Raw|Logged) Economic Development </td>
   <td style="text-align:center;"> −0.058 </td>
   <td style="text-align:center;"> 237.485 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.134) </td>
   <td style="text-align:center;"> (534.838) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Raw|Logged) Economic Size </td>
   <td style="text-align:center;"> 0.000* </td>
   <td style="text-align:center;"> −8011.586* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (3036.325) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Raw|Logged) Economic Size^2 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 179.995* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (63.760) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Economic Growth </td>
   <td style="text-align:center;"> 0.724 </td>
   <td style="text-align:center;"> 0.903 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (21.298) </td>
   <td style="text-align:center;"> (23.958) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Capital Openness </td>
   <td style="text-align:center;"> 132.574 </td>
   <td style="text-align:center;"> 104.810 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (208.004) </td>
   <td style="text-align:center;"> (242.793) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Raw|Logged) Exchange Rate </td>
   <td style="text-align:center;"> −49.220* </td>
   <td style="text-align:center;"> −527.487 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (13.561) </td>
   <td style="text-align:center;"> (400.773) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Labor Force </td>
   <td style="text-align:center;"> 14.719 </td>
   <td style="text-align:center;"> 26.098 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (25.454) </td>
   <td style="text-align:center;"> (29.833) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Life Expectancy (Female) </td>
   <td style="text-align:center;"> 17.395 </td>
   <td style="text-align:center;"> 11.338 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (30.288) </td>
   <td style="text-align:center;"> (42.936) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Intercept </td>
   <td style="text-align:center;"> −2011.642 </td>
   <td style="text-align:center;"> 85152.614* </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1.5px">  </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (2677.858) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (36439.112) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.370 </td>
   <td style="text-align:center;"> 0.207 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05</td></tr></tfoot>
</table>



</div>

The results here suggest that there was non-linearity evident in the original data, and that it's just not a curvilinear relationship between economic size and net FDI inflows. There's proportionality as well, some of which could've been anticipated. The GDP ("size") and GDP per capita ("development") variables are the largest nominal value possible (raw dollars to the dollar). In most applications, those would be log-transformed. The exchange rate variable could also be reasonably +1 and logged as well. Perhaps assorted other transformations in light of other peculiarities (e.g. the growth variable and the dependent variable itself) may have different implications, but even doing these transformations are sufficient to find a strong curvilinear effect of economic size and to find no discernible (proportional) effect of the exchange rate variable.

### What to Do About Non-Constant Error Variance (Heteroskedasticity)

The fitted-residual plot will often give you a pretty good indication about non-constant error variance (heteroskedasticity) if you have enough observations. It's a little harder to parse with the number of observations we have. No matter, we have a formal test diagnostic---the Breusch-Pagan test---for heteroskedasticity in the regression model. The test itself analyzes patterns/associations in the residuals as a function of the regressors, returning a test statistic (with a *p*-value) based on the extent of associations it sees. High enough test statistic with some *p*-value low enough (for whatever evidentiary threshold floats your boat) suggests heteroskedastic errors. I'm fairly sure we're going to see that here in both our models.


```r
bptest(M1)
#> 
#> 	studentized Breusch-Pagan test
#> 
#> data:  M1
#> BP = 50.535, df = 8, p-value = 3.225e-08
bptest(M2)
#> 
#> 	studentized Breusch-Pagan test
#> 
#> data:  M2
#> BP = 24.48, df = 9, p-value = 0.003603
```

I am not terribly surprised, especially since we did not touch the dependent variable (which is often, but certainly not always, the culprit in these situations). Here's where we reiterate that the problem of heteroskedasticity is less about the line and more about the uncertainty around the line. That uncertainty is suspect, which has ramifications for those important tests you care about (i.e. tests of statistically significant associations). Thus, you need to do something to convince me that any inferential takeaways you'd like to report are not a function of this violation of the linear model with its OLS estimator.

You have options, and I'll level with you that I think the bulk of these reduce to throwing rocks at your model to see how sensitive the inferences you'd like to report are. So, let's go over them and start with the replication model reported by Appel and Loyle (2012) in their first model in Table I. If you were learning this material by reference to a by-the-books statistics textbook, their recommendation is weighted least squares (WLS) in this situation. Weighted least squares takes the offending model, extracts its residuals and fitted values, regresses the absolute value of the residuals on the fitted values in the original model. It then extracts those second fitted values, squares them, and divides 1 over them. Those are then supplied as weights to the offending linear model once more for re-estimation.

But wait, there's more. If you were learning statistics by reference to an econometrics textbook, it might balk at the very notion of doing this. Their rationale would be something as follows. If the implication of heteroskedasticity is that the lines are fine and the errors are wrong, it's a lament that the weighted least squares approach is almost guaranteed to re-draw lines to equalize the variance in errors. If the lines are fine and the errors are wrong, the errors of the offending model can be recalibrated based on information from the variance-covariance matrix to adjust for this. Here, you have several options for so-called "heteroskedasticity consistent (HC)" standard errors. Sometimes, it seems like you have too many options. The "default" (if you will) was introduced by White (1980) as an extension of earlier work by Eicker (1963) and Huber (1967). Sometimes known as "Huber-White" standard errors, or `HC0` in formula syntax, this approach adjusts the model-based standard errors using the empirical variability of the model residuals. *But wait, there's even more*. There are three competing options for these heteroskedasticity-consistent standard errors: `HC1`, `HC2`, and `HC3`. With a large enough sample, all three don't differ too much from each other (as far as I understand it). I'll focus on two of the three, though. The first is `HC1`, which is generally recommended for small samples. The second is `HC3`, which would be what I'd call "Stata" standard errors because these are the default "robust" standard errors you'd get if you were using that software. For fun, we can also provide so-called Bell-McCaffrey degrees-of-freedom adjusted (DF. Adj.) robust standard errors following the recommendations of [Imbens and Kolesár (2016)](https://direct.mit.edu/rest/article-abstract/98/4/701/58336/Robust-Standard-Errors-in-Small-Samples-Some?redirectedFrom=fulltext).

And yes, there's even more than that. If I were presented this hypothetical situation with 95 observations and all the computing power I could ever want, [I would 100% bootstrap this](http://svmiller.com/blog/2020/03/bootstrap-standard-errors-in-r/). You have plenty of options here. The simple bootstrap resamples, with replacement, from the data to create some number of desired replicates against which the model is re-estimated. Given enough replicates, the mean of the coefficients converges on the original coefficient but the standard deviation of the coefficient from those replicates is the new standard error. You judge statistical significance from that. There are several other bootstrapping approaches, but here's just two more. The first is a bootstrapped from the residuals. Sometimes called a "Bayesian" or "fractional" bootstrap, this approach leaves the regressors at their fixed values and resamples the residuals and adds them to the response variable. A spiritually similar approach, the so-called "wild" bootstrap, multiplies the residuals by response variable once they have been multiplied by a random variable. By default, this is [a Rademacher distribution](https://en.wikipedia.org/wiki/Rademacher_distribution).

You could do all this mostly from the `vcov*` family of functions in the `{sandwich}` package, combined with `coeftest()` from `{lmtest}`. The reproducible seed is for funsies since there's bootstrap resampling happening here as well. We'll go with 500 replicates (which is what the `R` argument is doing).


```r
set.seed(8675309)
summary(M1)
wls(M1) # from {stevemisc}
coeftest(M1,  vcovHC(M1,type='HC0'))
coeftest(M1,  vcovHC(M1,type='HC1'))
coeftest(M1,  vcovHC(M1,type='HC3'))
dfadjustSE(M1) # from {dfadjust}
coeftest(M1,  vcovBS(M1, R = 500))
coeftest(M1,  vcovBS(M1, type='residual', R = 500))
coeftest(M1,  vcovBS(M1, type='wild', R = 500))
```

A better approach is to have `{modelsummary}` do all this for you, which is happening under the hood here.

<div id ="modelsummary">

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto; font-size: 12px; margin-left: auto; margin-right: auto;" class="table table">
<caption style="font-size: initial !important;">A Reproduction and Re-Analysis of Model 1 in Table I in Appel and Loyle (2012) with Adjustments for Heteroskedasticity</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> M1 </th>
   <th style="text-align:center;"> WLS </th>
   <th style="text-align:center;"> HC0 </th>
   <th style="text-align:center;"> HC1 </th>
   <th style="text-align:center;">  HC3 </th>
   <th style="text-align:center;"> DF. Adj. </th>
   <th style="text-align:center;"> Bootstrap </th>
   <th style="text-align:center;"> Resid. Boot. </th>
   <th style="text-align:center;"> Wild Boot. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Post-conflict Justice </td>
   <td style="text-align:center;"> 1532.608* </td>
   <td style="text-align:center;"> 532.046 </td>
   <td style="text-align:center;"> 1532.608 </td>
   <td style="text-align:center;"> 1532.608 </td>
   <td style="text-align:center;"> 1532.608 </td>
   <td style="text-align:center;"> 1532.608 </td>
   <td style="text-align:center;"> 1532.608 </td>
   <td style="text-align:center;"> 1532.608* </td>
   <td style="text-align:center;"> 1532.608 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (629.400) </td>
   <td style="text-align:center;"> (1371.693) </td>
   <td style="text-align:center;"> (927.378) </td>
   <td style="text-align:center;"> (974.696) </td>
   <td style="text-align:center;"> (1371.693) </td>
   <td style="text-align:center;"> (1116.830) </td>
   <td style="text-align:center;"> (930.624) </td>
   <td style="text-align:center;"> (555.819) </td>
   <td style="text-align:center;"> (952.559) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Economic Development </td>
   <td style="text-align:center;"> −0.058 </td>
   <td style="text-align:center;"> 0.056 </td>
   <td style="text-align:center;"> −0.058 </td>
   <td style="text-align:center;"> −0.058 </td>
   <td style="text-align:center;"> −0.058 </td>
   <td style="text-align:center;"> −0.058 </td>
   <td style="text-align:center;"> −0.058 </td>
   <td style="text-align:center;"> −0.058 </td>
   <td style="text-align:center;"> −0.058 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.134) </td>
   <td style="text-align:center;"> (0.224) </td>
   <td style="text-align:center;"> (0.143) </td>
   <td style="text-align:center;"> (0.150) </td>
   <td style="text-align:center;"> (0.224) </td>
   <td style="text-align:center;"> (0.175) </td>
   <td style="text-align:center;"> (0.210) </td>
   <td style="text-align:center;"> (0.128) </td>
   <td style="text-align:center;"> (0.132) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Economic Size </td>
   <td style="text-align:center;"> 0.000* </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000+ </td>
   <td style="text-align:center;"> 0.000+ </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000+ </td>
   <td style="text-align:center;"> 0.000* </td>
   <td style="text-align:center;"> 0.000+ </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.000) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Economic Growth </td>
   <td style="text-align:center;"> 0.724 </td>
   <td style="text-align:center;"> 1.695 </td>
   <td style="text-align:center;"> 0.724 </td>
   <td style="text-align:center;"> 0.724 </td>
   <td style="text-align:center;"> 0.724 </td>
   <td style="text-align:center;"> 0.724 </td>
   <td style="text-align:center;"> 0.724 </td>
   <td style="text-align:center;"> 0.724 </td>
   <td style="text-align:center;"> 0.724 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (21.298) </td>
   <td style="text-align:center;"> (24.239) </td>
   <td style="text-align:center;"> (10.858) </td>
   <td style="text-align:center;"> (11.412) </td>
   <td style="text-align:center;"> (24.239) </td>
   <td style="text-align:center;"> (15.643) </td>
   <td style="text-align:center;"> (20.781) </td>
   <td style="text-align:center;"> (20.893) </td>
   <td style="text-align:center;"> (11.128) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Capital Openness </td>
   <td style="text-align:center;"> 132.574 </td>
   <td style="text-align:center;"> 48.862 </td>
   <td style="text-align:center;"> 132.574 </td>
   <td style="text-align:center;"> 132.574 </td>
   <td style="text-align:center;"> 132.574 </td>
   <td style="text-align:center;"> 132.574 </td>
   <td style="text-align:center;"> 132.574 </td>
   <td style="text-align:center;"> 132.574 </td>
   <td style="text-align:center;"> 132.574 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (208.004) </td>
   <td style="text-align:center;"> (296.297) </td>
   <td style="text-align:center;"> (246.782) </td>
   <td style="text-align:center;"> (259.374) </td>
   <td style="text-align:center;"> (296.297) </td>
   <td style="text-align:center;"> (269.078) </td>
   <td style="text-align:center;"> (275.786) </td>
   <td style="text-align:center;"> (211.499) </td>
   <td style="text-align:center;"> (248.941) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Exchange Rate </td>
   <td style="text-align:center;"> −49.220* </td>
   <td style="text-align:center;"> 5.207 </td>
   <td style="text-align:center;"> −49.220+ </td>
   <td style="text-align:center;"> −49.220 </td>
   <td style="text-align:center;"> −49.220 </td>
   <td style="text-align:center;"> −49.220 </td>
   <td style="text-align:center;"> −49.220 </td>
   <td style="text-align:center;"> −49.220* </td>
   <td style="text-align:center;"> −49.220+ </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (13.561) </td>
   <td style="text-align:center;"> (59.095) </td>
   <td style="text-align:center;"> (29.017) </td>
   <td style="text-align:center;"> (30.497) </td>
   <td style="text-align:center;"> (59.095) </td>
   <td style="text-align:center;"> (38.458) </td>
   <td style="text-align:center;"> (88.112) </td>
   <td style="text-align:center;"> (11.189) </td>
   <td style="text-align:center;"> (28.015) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Labor Force </td>
   <td style="text-align:center;"> 14.719 </td>
   <td style="text-align:center;"> 4.360 </td>
   <td style="text-align:center;"> 14.719 </td>
   <td style="text-align:center;"> 14.719 </td>
   <td style="text-align:center;"> 14.719 </td>
   <td style="text-align:center;"> 14.719 </td>
   <td style="text-align:center;"> 14.719 </td>
   <td style="text-align:center;"> 14.719 </td>
   <td style="text-align:center;"> 14.719 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (25.454) </td>
   <td style="text-align:center;"> (21.943) </td>
   <td style="text-align:center;"> (17.191) </td>
   <td style="text-align:center;"> (18.069) </td>
   <td style="text-align:center;"> (21.943) </td>
   <td style="text-align:center;"> (19.106) </td>
   <td style="text-align:center;"> (19.928) </td>
   <td style="text-align:center;"> (25.090) </td>
   <td style="text-align:center;"> (17.760) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Life Expectancy (Female) </td>
   <td style="text-align:center;"> 17.395 </td>
   <td style="text-align:center;"> 2.913 </td>
   <td style="text-align:center;"> 17.395 </td>
   <td style="text-align:center;"> 17.395 </td>
   <td style="text-align:center;"> 17.395 </td>
   <td style="text-align:center;"> 17.395 </td>
   <td style="text-align:center;"> 17.395 </td>
   <td style="text-align:center;"> 17.395 </td>
   <td style="text-align:center;"> 17.395 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (30.288) </td>
   <td style="text-align:center;"> (26.121) </td>
   <td style="text-align:center;"> (16.125) </td>
   <td style="text-align:center;"> (16.948) </td>
   <td style="text-align:center;"> (26.121) </td>
   <td style="text-align:center;"> (19.815) </td>
   <td style="text-align:center;"> (24.037) </td>
   <td style="text-align:center;"> (30.291) </td>
   <td style="text-align:center;"> (15.941) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Intercept </td>
   <td style="text-align:center;"> −2011.642 </td>
   <td style="text-align:center;"> −402.067 </td>
   <td style="text-align:center;"> −2011.642 </td>
   <td style="text-align:center;"> −2011.642 </td>
   <td style="text-align:center;"> −2011.642 </td>
   <td style="text-align:center;"> −2011.642 </td>
   <td style="text-align:center;"> −2011.642 </td>
   <td style="text-align:center;"> −2011.642 </td>
   <td style="text-align:center;"> −2011.642 </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1.5px">  </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (2677.858) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (2100.212) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (1517.895) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (1595.344) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (2100.212) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (1747.984) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (1927.093) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (2686.032) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (1573.992) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.370 </td>
   <td style="text-align:center;"> 0.241 </td>
   <td style="text-align:center;"> 0.370 </td>
   <td style="text-align:center;"> 0.370 </td>
   <td style="text-align:center;"> 0.370 </td>
   <td style="text-align:center;"> 0.370 </td>
   <td style="text-align:center;"> 0.370 </td>
   <td style="text-align:center;"> 0.370 </td>
   <td style="text-align:center;"> 0.370 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05</td></tr></tfoot>
</table>



</div>

There's a lot happening here, and we should be initially skeptical of the model with such an evident problem of skew in the economic size and development variables. No matter, this approach suggests what approach you employ for acknowledging and dealing with the heteroskedasticity in your model has important implications for the statistical (in)significance you may like to report. The post-conflict justice variable is significant only in the replication model and the residual bootstrapping approach. The economic size variable is insignificant in the WLS, HC3, and DF. Adj. approach. The exchange rate variable is significant in only in the original model, the model with Huber-White standard errors (HC0), and two of the three bootstrapping approaches.

We can do the same thing to the second model, which offers logarithmic transformations of economic development, economic size, and the exchange rate variable (in addition to the square term of economic size). 

<div id ="modelsummary">

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto; font-size: 12px; margin-left: auto; margin-right: auto;" class="table table">
<caption style="font-size: initial !important;">Another Re-Analysis of Appel and Loyle (2012) with Adjustments for Heteroskedasticity</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;">  M2 </th>
   <th style="text-align:center;"> WLS </th>
   <th style="text-align:center;"> HC0 </th>
   <th style="text-align:center;"> HC1 </th>
   <th style="text-align:center;">  HC3 </th>
   <th style="text-align:center;"> DF. Adj. </th>
   <th style="text-align:center;"> Bootstrap </th>
   <th style="text-align:center;"> Resid. Boot. </th>
   <th style="text-align:center;"> Wild Boot. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Post-conflict Justice </td>
   <td style="text-align:center;"> 1525.326* </td>
   <td style="text-align:center;"> 480.933 </td>
   <td style="text-align:center;"> 1525.326 </td>
   <td style="text-align:center;"> 1525.326 </td>
   <td style="text-align:center;"> 1525.326 </td>
   <td style="text-align:center;"> 1525.326 </td>
   <td style="text-align:center;"> 1525.326 </td>
   <td style="text-align:center;"> 1525.326* </td>
   <td style="text-align:center;"> 1525.326 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (714.274) </td>
   <td style="text-align:center;"> (1389.818) </td>
   <td style="text-align:center;"> (1135.250) </td>
   <td style="text-align:center;"> (1200.173) </td>
   <td style="text-align:center;"> (1389.818) </td>
   <td style="text-align:center;"> (1255.379) </td>
   <td style="text-align:center;"> (1198.794) </td>
   <td style="text-align:center;"> (632.009) </td>
   <td style="text-align:center;"> (1118.279) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Logged Economic Development </td>
   <td style="text-align:center;"> 237.485 </td>
   <td style="text-align:center;"> −199.705 </td>
   <td style="text-align:center;"> 237.485 </td>
   <td style="text-align:center;"> 237.485 </td>
   <td style="text-align:center;"> 237.485 </td>
   <td style="text-align:center;"> 237.485 </td>
   <td style="text-align:center;"> 237.485 </td>
   <td style="text-align:center;"> 237.485 </td>
   <td style="text-align:center;"> 237.485 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (534.838) </td>
   <td style="text-align:center;"> (520.918) </td>
   <td style="text-align:center;"> (432.055) </td>
   <td style="text-align:center;"> (456.764) </td>
   <td style="text-align:center;"> (520.918) </td>
   <td style="text-align:center;"> (472.807) </td>
   <td style="text-align:center;"> (509.681) </td>
   <td style="text-align:center;"> (491.713) </td>
   <td style="text-align:center;"> (448.304) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Logged Economic Size </td>
   <td style="text-align:center;"> −8011.586* </td>
   <td style="text-align:center;"> −1501.301 </td>
   <td style="text-align:center;"> −8011.586 </td>
   <td style="text-align:center;"> −8011.586 </td>
   <td style="text-align:center;"> −8011.586 </td>
   <td style="text-align:center;"> −8011.586 </td>
   <td style="text-align:center;"> −8011.586 </td>
   <td style="text-align:center;"> −8011.586* </td>
   <td style="text-align:center;"> −8011.586 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (3036.325) </td>
   <td style="text-align:center;"> (6955.913) </td>
   <td style="text-align:center;"> (5589.389) </td>
   <td style="text-align:center;"> (5909.037) </td>
   <td style="text-align:center;"> (6955.913) </td>
   <td style="text-align:center;"> (6228.081) </td>
   <td style="text-align:center;"> (5975.243) </td>
   <td style="text-align:center;"> (3107.540) </td>
   <td style="text-align:center;"> (5466.750) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Logged Economic Size^2 </td>
   <td style="text-align:center;"> 179.995* </td>
   <td style="text-align:center;"> 34.710 </td>
   <td style="text-align:center;"> 179.995 </td>
   <td style="text-align:center;"> 179.995 </td>
   <td style="text-align:center;"> 179.995 </td>
   <td style="text-align:center;"> 179.995 </td>
   <td style="text-align:center;"> 179.995 </td>
   <td style="text-align:center;"> 179.995* </td>
   <td style="text-align:center;"> 179.995 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (63.760) </td>
   <td style="text-align:center;"> (153.167) </td>
   <td style="text-align:center;"> (123.255) </td>
   <td style="text-align:center;"> (130.304) </td>
   <td style="text-align:center;"> (153.167) </td>
   <td style="text-align:center;"> (137.249) </td>
   <td style="text-align:center;"> (131.544) </td>
   <td style="text-align:center;"> (65.556) </td>
   <td style="text-align:center;"> (120.363) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Economic Growth </td>
   <td style="text-align:center;"> 0.903 </td>
   <td style="text-align:center;"> 5.926 </td>
   <td style="text-align:center;"> 0.903 </td>
   <td style="text-align:center;"> 0.903 </td>
   <td style="text-align:center;"> 0.903 </td>
   <td style="text-align:center;"> 0.903 </td>
   <td style="text-align:center;"> 0.903 </td>
   <td style="text-align:center;"> 0.903 </td>
   <td style="text-align:center;"> 0.903 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (23.958) </td>
   <td style="text-align:center;"> (21.520) </td>
   <td style="text-align:center;"> (9.468) </td>
   <td style="text-align:center;"> (10.009) </td>
   <td style="text-align:center;"> (21.520) </td>
   <td style="text-align:center;"> (13.772) </td>
   <td style="text-align:center;"> (16.901) </td>
   <td style="text-align:center;"> (21.151) </td>
   <td style="text-align:center;"> (9.405) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Capital Openness </td>
   <td style="text-align:center;"> 104.810 </td>
   <td style="text-align:center;"> 146.835 </td>
   <td style="text-align:center;"> 104.810 </td>
   <td style="text-align:center;"> 104.810 </td>
   <td style="text-align:center;"> 104.810 </td>
   <td style="text-align:center;"> 104.810 </td>
   <td style="text-align:center;"> 104.810 </td>
   <td style="text-align:center;"> 104.810 </td>
   <td style="text-align:center;"> 104.810 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (242.793) </td>
   <td style="text-align:center;"> (309.297) </td>
   <td style="text-align:center;"> (262.045) </td>
   <td style="text-align:center;"> (277.030) </td>
   <td style="text-align:center;"> (309.297) </td>
   <td style="text-align:center;"> (284.372) </td>
   <td style="text-align:center;"> (289.418) </td>
   <td style="text-align:center;"> (227.233) </td>
   <td style="text-align:center;"> (273.986) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Logged Exchange Rate </td>
   <td style="text-align:center;"> −527.487 </td>
   <td style="text-align:center;"> −23.880 </td>
   <td style="text-align:center;"> −527.487 </td>
   <td style="text-align:center;"> −527.487 </td>
   <td style="text-align:center;"> −527.487 </td>
   <td style="text-align:center;"> −527.487 </td>
   <td style="text-align:center;"> −527.487 </td>
   <td style="text-align:center;"> −527.487 </td>
   <td style="text-align:center;"> −527.487 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (400.773) </td>
   <td style="text-align:center;"> (579.782) </td>
   <td style="text-align:center;"> (412.935) </td>
   <td style="text-align:center;"> (436.550) </td>
   <td style="text-align:center;"> (579.782) </td>
   <td style="text-align:center;"> (484.176) </td>
   <td style="text-align:center;"> (479.507) </td>
   <td style="text-align:center;"> (402.422) </td>
   <td style="text-align:center;"> (402.086) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Labor Force </td>
   <td style="text-align:center;"> 26.098 </td>
   <td style="text-align:center;"> 14.134 </td>
   <td style="text-align:center;"> 26.098 </td>
   <td style="text-align:center;"> 26.098 </td>
   <td style="text-align:center;"> 26.098 </td>
   <td style="text-align:center;"> 26.098 </td>
   <td style="text-align:center;"> 26.098 </td>
   <td style="text-align:center;"> 26.098 </td>
   <td style="text-align:center;"> 26.098 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (29.833) </td>
   <td style="text-align:center;"> (26.041) </td>
   <td style="text-align:center;"> (21.609) </td>
   <td style="text-align:center;"> (22.845) </td>
   <td style="text-align:center;"> (26.041) </td>
   <td style="text-align:center;"> (23.664) </td>
   <td style="text-align:center;"> (25.434) </td>
   <td style="text-align:center;"> (25.869) </td>
   <td style="text-align:center;"> (21.805) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Life Expectancy (Female) </td>
   <td style="text-align:center;"> 11.338 </td>
   <td style="text-align:center;"> 22.923 </td>
   <td style="text-align:center;"> 11.338 </td>
   <td style="text-align:center;"> 11.338 </td>
   <td style="text-align:center;"> 11.338 </td>
   <td style="text-align:center;"> 11.338 </td>
   <td style="text-align:center;"> 11.338 </td>
   <td style="text-align:center;"> 11.338 </td>
   <td style="text-align:center;"> 11.338 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (42.936) </td>
   <td style="text-align:center;"> (25.646) </td>
   <td style="text-align:center;"> (20.351) </td>
   <td style="text-align:center;"> (21.515) </td>
   <td style="text-align:center;"> (25.646) </td>
   <td style="text-align:center;"> (22.537) </td>
   <td style="text-align:center;"> (27.335) </td>
   <td style="text-align:center;"> (38.024) </td>
   <td style="text-align:center;"> (20.538) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Intercept </td>
   <td style="text-align:center;"> 85152.614* </td>
   <td style="text-align:center;"> 15469.080 </td>
   <td style="text-align:center;"> 85152.614 </td>
   <td style="text-align:center;"> 85152.614 </td>
   <td style="text-align:center;"> 85152.614 </td>
   <td style="text-align:center;"> 85152.614 </td>
   <td style="text-align:center;"> 85152.614 </td>
   <td style="text-align:center;"> 85152.614* </td>
   <td style="text-align:center;"> 85152.614 </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1.5px">  </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (36439.112) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (76889.954) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (61649.423) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (65175.048) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (76889.954) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (68759.859) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (66377.553) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (37504.039) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (60299.811) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 95 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.207 </td>
   <td style="text-align:center;"> 0.726 </td>
   <td style="text-align:center;"> 0.207 </td>
   <td style="text-align:center;"> 0.207 </td>
   <td style="text-align:center;"> 0.207 </td>
   <td style="text-align:center;"> 0.207 </td>
   <td style="text-align:center;"> 0.207 </td>
   <td style="text-align:center;"> 0.207 </td>
   <td style="text-align:center;"> 0.207 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05</td></tr></tfoot>
</table>



</div>

A similar story will still emerge. What statistical significance you'd like to report is sensitive to the heteroskedasticity in the original model and how you elected to acknowledge it and deal with it. Post-conflict justice and the economic size variables are significant in only one of the adjustments (incidentally: the residual bootstrap).

## Conclusion

The point here isn't to chastise past scholarship or deride the work done by others. It's also not to litigate whether there's value to post-conflict justice institutions. Sometimes there's value---normative value---in making amends for past wrongs and broadcasting what exactly those wrongs were irregarding whether there's a downstream benefit in which investors part with their money and send it to you. The point is instead that heteroskedasticity, and how you elect to deal with it, can matter a great deal to your test statistics. You should always look at your data. You should also make reasoned design choices about the inputs into the regression model and what they might mean for the outputs you'd like to report from the regression model. If they're that sensitive to a model that violates an important assumption, and to a particular approach that deals with it, it may be worth noting the results are potentially a function of these choices.
