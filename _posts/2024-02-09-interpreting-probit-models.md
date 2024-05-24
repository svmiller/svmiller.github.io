---
title: "What the Probit Link is Trying to Tell You (and How You Can Help It)"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2024-02-09'
excerpt: "The probit model returns a peculiar quantity with respect to what you ultimately want to communicate. However, there are a few tricks available to you to make the most of what the probit link is trying to tell you."
layout: post
categories:
  - R
  - Teaching
image: "1946-fisher-bliss.png"
active: blog
---



{% include image.html url="/images/1946-fisher-bliss.png" caption="Ohio State alumnus Chester Bliss (right) formalized and named the intuition behind the 'probit'. Ronald A. Fisher (left) worked with him to devise the MLE method for fitting probit lines to data." width=400 align="right" %}

Teaching an advanced quantitative methods class is leading me deeper into the world of generalized linear models (GLMs) for a curriculum that would otherwise clutch the OLS estimator as if it were a matter of life or death. To assuage students about these GLMs, I've taken some care to communicate what the fitted values of these GLMs are and what the coefficient communicates with respect to these fitted values. In the linear model with its OLS estimator, this is a fairly simple matter. The fitted value is the estimated value of *y* on its provided scale and the regression coefficient communicates the estimated change in *y* on that scale for a one-unit change in *x*. [Logarithmic transformations proportionalize (sic) unit changes](http://svmiller.com/blog/2023/01/what-log-variables-do-for-your-ols-model/), but the linear model is simple. 

Some of our most common GLMs are also not too difficult to grasp, at least for me. The logistic regression model is [deceptively simple in its interpretation](http://post8000.svmiller.com/lab-scripts/logistic-regression-lab.html). The "logit" is the log-transformed odds of *y* being 1 versus 0. Perhaps the "logit" demanded clarification, but its intuitively defined in relation to the odds and probability. Even the Poisson link is [intuitive with a little effort](http://svmiller.com/blog/2023/12/count-models-poisson-negative-binomial/). The fitted value from the Poisson model is the log-transformed mean of events. The regression coefficient is the change in the log-transformed mean of events from some baseline.

The probit link is not so intuitive. Beyond the obvious matters of sign and significance, communicating the immediate output of a probit regression with respect to
what you want to know never made that much sense to me. The logistic regression model has a logarithmic transformation in it, meaning it at least comes with an odds ratio. Models with logged links, like the Poisson and Cox proportional hazard model, have risk/rate ratios that can be estimated from the coefficient. No such quantity is available in the probit link. What then is [the "*z*-score of *y*"](https://www.google.se/books/edition/Linear_Probability_Logit_and_Probit_Mode/z0tmctgE1OYC)? What is a ["probit index"](https://stats.oarc.ucla.edu/stata/dae/probit-regression/)? You know from your stats classes you can use this model if the dependent variable you were handed was a 0 or 1, but why you might want to use it seems to struggle with the important follow-up question. Beyond sign and significance, what is this model telling you with respect to what you want to know?

The student may be forgiven for not enjoying what this particular GLM is trying to tell you. However, it is trying to tell you something, and that "something" kind of makes sense. However, it does require a tiny bit of effort from the researcher. Certainly, it required a bit of effort from me.

Here's a table of contents for navigation.

1. [An Origin Story](#origin)
2. [A Simulation](#simulation)
3. [An Applied Example: Support for Joining the European Union in Norway](#appliedexample)
4. [Conclusion](#conclusion)

Here are R packages I'll be using as well.

```r
library(tidyverse)
library(stevedata)
library(modelsummary)
```

## An Origin Story {#origin}

It might help students to go over the origin story of the probit model because it will inform students of what the pioneers of the probit model were trying to accomplish through this method. I highly recommend [J.S. Cramer's (2004) origin story of the logistic regression](https://www.sciencedirect.com/science/article/abs/pii/S1369848604000676). The tl;dr of this story as it relates to the matter at hand is the normal distribution precedes the formulation of the logistic function. Demographers and researchers interested in the study of population growth were responsible for formulating the intuition of a function for which growth is exponential to a point, after which there is resistance to further growth. However, academic interest in this curve lay dormant as researchers focused more on unpacking the features of the normal distribution. Put in other words: there is basically no learning about the probit model, or the logit model, without also learning of the debate about which to use in the confines of one particular field of study.

Both the probit model and the logistic regression have their applied origins in [bioassay](https://en.wikipedia.org/wiki/Bioassay), especially for what bioassay researchers term "[quantal](https://www.merriam-webster.com/dictionary/quantal) responses". "Bioassay" is the academic study of what dosage is required to kill what organism (think pesticides and poisons) and "quantal response" is a fancy way of saying "binary variable". [Chester Bliss](https://en.wikipedia.org/wiki/Chester_Ittner_Bliss)' contribution to modeling these outcomes was to assume this could be modeled with some insight of what scholars at his time were learning about the normal distribution. For scholars in bioassay at this time interested in what dosage is required to correspond with what percentage mortality, Bliss' solution was to assume that there is an equivalent *Z* that communicates this quantity. That *Z* could be further derived from the cumulative normal distribution that occupied the analytical energies of statisticians at this time. At this point, it might pique the reader's interest to learn this originally wasn't the standard normal distribution with a mean of 0. It was a normal distribution with a mean of 5. [Per Bliss (1935, 138)](https://onlinelibrary.wiley.com/doi/10.1111/j.1744-7348.1935.tb07713.x), this is a kind of hack where an additive constant avoids the discomfort of communicating "negative expected dosages" required to kill an organism. By centering it on 5, the ensuing distribution is almost an impossibility to go beyond either 0 or 10. The "probit", short for "*prob*ability un*it*", is a scaled normal distribution where the quantity communicates a median/midway point at the middle of the scale of percentages/proportions. Take stock of that; the probit quantity was initially anchored to a conversation of proportions/percentages.

The formulation of the logit and the development of the logistic regression after the probit model apparently led to a vigorous debate in this field about what was preferable to use. I don't think this is a debate worth having,[^pickone] but [Joseph Berkson (1951), the firebrand of the logit over the probit](https://www.jstor.org/stable/3001655), makes a pithy comment that what's happening here is rather old: it's curve-fitting (albeit with bounds). Something is happening that is determining whether an event is observed or not. We want to communicate that with respect to a quantity that nicely communicates that: probability. Probability has bounds between 0 and 1, and we need to squeeze whatever that "something" is to respect that. In the case of the logistic regression, we know converting probability to an odds ratio creates a variable that is unbounded on the right, but hard-bound at 0. Taking a natural logarithmic transformation of the odds ratio---the "logit"--- returns an unbounded estimate of the "something" that determines whether an event happens or not. When the logit is $$-\infty$$, the probability is 0. When the logit is $$\infty$$, the probability is 1. The probability has bounds to the left and right, the odds has the bound just to the left, and the logit is unbounded. 

[^pickone]: Pick what you feel comfortable communicating and, [only in unusual circumstances](https://www.cambridge.org/highereducation/books/regression-and-other-stories/DD20DD6C9057118581076E54E40C372C#overview), will choosing one over the other result in any major differences.

Students, including my former self, may not enjoy looking at model syntax when they are first introduced to the topic. However, the principle eventually becomes clear the more you stew on it. The slope of the line should be unbounded but the underlying quantity it communicates---probability in the logistic regression case---has critical bounds that must be respected no matter the transformations of it.[^poissoncase] The logistic regression that we are all (more) comfortable using (than the probit equivalent) does precisely that. It comes with the added benefit of returning a quantity that is more easily connected to the thing we care about: probability. [Odds are relative probabilities](https://en.wikipedia.org/wiki/Odds). They're the ratio of the probability that some outcome will be observed over the probability that some outcome won't be observed. If you know the odds, you know the probabilities. Simple, in the broad scheme of things. The logit is a logarithmic transformation of something that is just two steps removed from what we ultimately want to communicate (the probability that some outcome is observed). 

[^poissoncase]: The Poisson model behaves in a similar way. Conceptually, $$\lambda$$ is [a kind of intensity parameter](http://svmiller.com/blog/2023/12/count-models-poisson-negative-binomial/) determining the mean of events. Since events are counts that can't be negative, the quantity returned in the Poisson model is a logged $$\lambda$$.

But that leaves the probit counterpart in a peculiar position since the quantity it returns is not so neatly connected to the thing we care about (probability). Apparently I was not alone in struggling with this. [D.J. Finney](https://en.wikipedia.org/wiki/D._J._Finney), one of the early textbook writers on probit analysis, concedes this point on p. 25 of the second edition of [*Probit Analysis*](https://www.amazon.com/Probit-Analysis-David-Finney/dp/0521135907).

> A timely warning against attaching too much importance to the probit itself, at the expense of the kill, has been given by Wadley [(Campbell and Moulton, 1943)](https://www.google.se/books/edition/Laboratory_Procedures_in_Studies_of_the/Rg1DAAAAYAAJ), who says: 'The use of transformations carries with it a temptation to regard the transformed function as the real object of study. The original units should be mentioned in any final statement of results.' In essence the probit is no more than a convenient mathematical device for solving the otherwise intractable equations discussed in Appendix II.

The reader will be forgiven for not getting the full context of what Finney is saying here, though the hope is the previous paragraphs provide some context. The early probit researchers were all working on research topics related to the dosage required to kill an organism. The organism dies or doesn't, and a proportion of them die (or don't) when subjected to some level of a dosage. Per Finney (1952, 16-18), we should expect a few features to be apparent in this line of study. The proportions of the sample that die at some dosage should match the proportions of the population that would die at the same dosage, given large trials. That much is garden variety inference. More importantly, and assuming we're talking about poisons/insecticides (as bioassay researchers were) we should expect higher levels of dosage to coincide with higher proportions killed after the dosage. Perhaps then it's little surprise that [Bliss (1935)](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1744-7348.1935.tb07713.x) almost always called this a "susceptibility" and [Finney (1952)](https://www.google.se/books/edition/Probit_Analysis/E5dpAAAAMAAJ?hl=en) almost always calls this phenomenon a "tolerance". The underlying concept is kind of "cumulative", for lack of a better term. Notice how the concept of probability is colliding with proportions and percentages.

Per Bliss (1935, 135-6):

> If Fig. 1, which is the normal curve of error in its most usual form [e.d. he means the standard normal distribution], is assumed, for the moment, to be an ideal representation of the variation in susceptibility, the ordinates will give the number of individual organisms corresponding to each particular individual lethal dose shown  along the base in a graded  series  (assuming that the numbers along the base of the figure are equivalent to actual dosages in one form or another)
> 
> [...]
>
> Consequently, if Fig. 1 [e.d. the standard normal distribution] represents the hypothetical frequency distribution of susceptibility, as measured by the individual lethal dose, any given dose will split the sample of organisms into two categories of dead and alive, whose relative proportion will depend  upon the relation of the dosage to the distribution of susceptibilities. If our dose had happened to come at the point marked z in Fig. 1, the ratio of the dead or more susceptible individuals to the total number in the sample treated---in other words, the percentage killed---would have been the ratio of the uiishaded area to the total area under the curve.

Per Finney (1952, 17-18):

> As a characteristic of the stimulus which can be more easily determined and interpreted, [Trevan has advocated the median lethal dose](https://royalsocietypublishing.org/doi/abs/10.1098/rspb.1927.0030), or as a more general term to include responses other than death, the median effective dose. This is defined as the dose which will produce a response in half the population, and thus from another point of view, is the mean tolerance. If direct measurement of tolerance were possible the mean tolerance of a batch of test subjects would naturally be considered as the chief characteristic of the dose, and there is a strong case for using an estimate of the same quantity in material of the type now under
discussion. The median effective dose may conveniently be referred to as the ED 50, and the more restricted concept of median lethal dose as the LD50. Analogous symbols may be used for doses effective for other proportions of the population, ED 90, for example, being the dose which causes 90% to respond. As
will become apparent in later chapters, by experiment with a fixed
number of test subjects, effective doses in the neighbourhood of
ED 50 can usually be estimated more precisely than those for
more extreme percentage levels, and this characteristic is therefore particularly favoured in expressing the effectiveness of the
stimulus; its chief disadvantage is that in practice, especially in
toxicological work, there is much greater interest attaching to
doses producing nearly 100 % responses than to those producing
only 50%, in spite of the difficulty of estimating the former.

If you're comfortable with the logistic regression, this may seem a little wonky because it's easier to think of the odds as better fixed to the underlying thing you want to communicate. It's not necessarily something that's cumulative as the early probit researchers thought of their estimate. Perhaps that's me being naive or misinformed, but that's how I internalized the topic when I first started getting acclimated to the model. However, it will dawn on you, as it dawned on me, that the logistic regression model has this feature too. It's just less obvious that the logistic regression does this because its quantity (the logit) doesn't seem cumulative at first glance. No matter, any honest interpretation of the logistic model carries with it the same caveat. Whatever you want to communicate as a quantity from a regression coefficient depends on what you specify as a baseline (like a *y*-intercept). Because the concept of the "probit" is a bit more explicit in this, it initially confuses the student to the fact that the probit and the logit are doing the same exact thing.

## A Simulation {#simulation}

I've taken to teaching students and myself more around simulation for assorted GLM links. If you can understand what partial regression coefficients are in the simple case of the linear model (i.e. "all else equal"), then it might make sense to get comfortable with unusual GLM links by way of simulation in the simplest of simple cases.

In this case, let's set up a massive data set of 500,000 observations. Half will be 0s and half will be 1s. To simulate the probit link, we'll set up a simple linear function where the *z*-score is expected to be around 0 when x is 0 and the *z*-score is expected to increase to around .5 (technically around .467) when *x* changes from 0 to 1. Then, we'll simulate binary outcomes *y* of 0 or 1 based on these probabilities. If you remember stuff about the normal distribution, the properties of these data are going to be kind of obvious.


```r
set.seed(8675309)
n <- 500000
tibble(x = c(rep(0, n/2), rep(1, n/2)),
       zstar = pnorm(0 + qnorm(.68)*x),
       y = rbinom(n=n, size=1, prob=zstar)) -> Fake

qnorm(.68) # FYI..
#> [1] 0.4676988

Fake %>%
  summarize(mean_y = mean(y),
            .by = x) %>% data.frame
#>   x   mean_y
#> 1 0 0.498832
#> 2 1 0.680064
```

When *x* is 0, the *z*-score determining the probability that *y* is 1 is also 0. That is: we'd expect about 50% of the observations to 1 because 0 is the midway point of the normal distribution. When *x* is 1, the *z*-score determining the probability that *y* is 1 is changed to around .467. That means we'd expect about 68% of the observations to be 1 when *x* is 1. We know this from the normal distribution because about 68% of the observations are below around .467 on the standard normal distribution.

Now, for funsies, let's square the summaries of the data with what the probit model (and the logit equivalent) will communicate from it. A `{modelsummary}` table comes after the jump.


```r
M1 <- glm(y ~ x, Fake, family=binomial(link='probit'))
M2 <- glm(y ~ x, Fake, family=binomial(link='logit'))
broom::tidy(M1) # Let's see what the probit model parameters actually are.
#> # A tibble: 2 × 5
#>   term        estimate std.error statistic p.value
#>   <chr>          <dbl>     <dbl>     <dbl>   <dbl>
#> 1 (Intercept) -0.00293   0.00251     -1.17   0.243
#> 2 x            0.471     0.00362    130.     0
```

<div id ="modelsummary">
<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
<caption>A Simple Probit and Logit Model</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Probit </th>
   <th style="text-align:center;"> Logit </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> −0.003 </td>
   <td style="text-align:center;"> −0.005 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.003) </td>
   <td style="text-align:center;"> (0.004) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:center;"> 0.471*** </td>
   <td style="text-align:center;"> 0.759*** </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1.5px">  </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.004) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.006) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 500000 </td>
   <td style="text-align:center;"> 500000 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>


</div>

Ignore the sign and significance of the probit model, which we expected. Moving beyond sign and significance is what we want to do. Let's unpack what the model is telling us with respect to the underlying quantities it returns. When *x* is 0, we have the intercept. It's approximately 0, though technically -0.0029277. Wrap that value in a `pnorm()` function and you get a feature we already knew about the data. When *x* is 0, about 50% of the observations are 1.


```r
pnorm(as.vector(coef(M1)[1]))
#> [1] 0.498832
Fake %>% filter(x == 0) %>% summarize(mean = mean(y)) %>% pull()
#> [1] 0.498832
```

We care more about what that coefficient is telling us. When *x* goes from 0 to 1, the *z*-score of *y* changes by about .471. Wrap that in a `pnorm()` function and you get an updated proportion of 1s to 0s in light of the unit change in *x*. However, that updated proportion comes *relative to the baseline, whatever that is*. Here, it's simple because the baseline is basically 0. However, it's a bit deceptive. Extracting the more intuitive probability requires the baseline, and that's true for both the logit and the probit model.


```r
pnorm(as.vector(coef(M1)[2])) # Not it, doesn't include the baseline.
#> [1] 0.6811102
pnorm(as.vector(coef(M1)[1] + coef(M1)[2])) # This is it, includes the baseline, even if it's close to 0.
#> [1] 0.680064
Fake %>% filter(x == 1) %>% summarize(mean = mean(y)) %>% pull()
#> [1] 0.680064
```

In other words, the probit model is conceptually telling you a change in the cumulative factors by which we would expect *y* to be 1. The quantity that corresponds with that is derived from the cumulative normal distribution, which communicates the area under the standard normal curve. Unpacking the model's parameters on its own terms means communicating unit changes in *x* relative to some kind of baseline (i.e. use the intercept; it's the path of least resistance). The probit model is seemingly more explicit in this. However, [the logit model has this quirk too](http://svmiller.com/blog/2020/04/post-estimation-simulation-trump-vote-midwest/). It's just less obvious that it has this, in part because the logit model comes with [this parlor trick](http://post8000.svmiller.com/lab-scripts/logistic-regression-lab.html#The_%E2%80%9CDivide_by_4%E2%80%9D_Rule).


```r
# What it technically is:
plogis(as.vector(coef(M2)[1] + coef(M2)[2]))
#> [1] 0.680064
# Compared to the probit equivalent:
pnorm(as.vector(coef(M1)[1] + coef(M1)[2])) 
#> [1] 0.680064

# But the logit allows this backdoor approximation...
Fake %>% 
  # grouped means...
  summarize(mean = mean(y), .by=x) %>% 
  # difference in p(y=1) for x = 1 and x = 0
  mutate(diff = mean - lag(mean)) %>% 
  # give me what I want...
  na.omit %>% pull()
#> [1] 0.181232

# Can I approximate this by dividing the coef by 4?
as.vector(coef(M2)[2])/4
#> [1] 0.1896845

# Yeah, pretty much.
```

No such parlor trick/approximation is available in the probit model, but technically you'd unpack the logit model the exact same way you would the probit model. The only difference is that of the distribution: logistic vs. cumulative normal. You still need the intercept, or some kind of baseline to make more sense of the model's important parameters.

## An Applied Example: Support for Joining the European Union in Norway {#appliedexample}

Let me give an applied example. [`ESS10NO` in `{stevedata}`](http://svmiller.com/stevedata/reference/ESS10NO.html) is a data set I curated from the European Social Survey regarding attitudes toward European integration in Norway. I created it mostly for a one-off lecture on survey weights for our PhD students, but it has other pedagogical uses for me.

Let's create a reduced version the data that subsets the data to just those born in Norway. We're going to create a dummy variable from the `eu_vote` column, which communicates how the respondent would vote/act if there was another referendum on Norway joining the European Union. Possible responses here are "Remain Outside", "Join EU", "Don't Know", "Not Eligible", "Blank Ballot", "Refuse to Answer, and "Wouldn't Vote". We'll create a simple binary variable from this where those would vote to join the EU are 1 and those would vote to remain outside the European Union are 0. Everything else becomes an NA and is subset from the analysis. The overall proportion of "Join EU" to "Join EU" or "Remain Outside" is about .28. Keep that quantity in mind; you're going to see it again.


```r
ESS10NO %>% 
  filter(eu_vote %in% c("Remain Outside", "Join EU")) %>%
  count(eu_vote) %>%
  mutate(prop = n/sum(n))
#> # A tibble: 2 × 3
#>   eu_vote            n  prop
#>   <chr>          <int> <dbl>
#> 1 Join EU          363 0.280
#> 2 Remain Outside   932 0.720
```

We'll see if we can model attitudes in favor of joining the European Union in Norway as a function of a respondent's age (`agea`, ranges from 15-90), years of education (`eduyrs`, ranges from 0 to 28), household income in deciles [1:10] (`hinctnta`), ideology on an 11-point left-right scale [0:10] (`lrscale`), and a numeric vector [1:10] for if the respondent thinks immigrants undermine or enrich Norway's (higher values = enrich more than undermine).  The point here isn't to come up with a great model on how Norwegians would vote on a referendum to join the European Union. No matter, this is fine for this purpose.

We're also going to median-center all the right-hand side variables and run a second probit model alongside the basic probit model with these median-centered inputs. You'll see why later. `{modelsummary}` will be doing some formatting underneath the hood.


```r
ESS10NO %>% 
  filter(brnnorge == 1) %>%
  mutate(euvotedum = case_when(
    eu_vote == "Join EU" ~ 1,
    eu_vote == "Remain Outside" ~ 0
  )) %>%
  select(idno, region, euvotedum, agea, eduyrs, 
         hinctnta, lrscale, imueclt) -> Data

M3 <- glm(euvotedum ~ agea + eduyrs + hinctnta +
            lrscale + imueclt, Data, family=binomial(link='probit'))

Data %>%
  mutate(across(
    c(agea, eduyrs, hinctnta, lrscale, imueclt),
    ~. - median(., na.rm=T),
    .names = paste0("mc","_{.col}"))) -> Data

M4 <- glm(euvotedum ~ mc_agea + mc_eduyrs + mc_hinctnta +
            mc_lrscale + mc_imueclt, Data, family=binomial(link='probit'))
```

<div id ="modelsummary">
<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
<caption>A Probit Model of Support for Joining the European Union in Norway</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Raw Scale (Probit) </th>
   <th style="text-align:center;">  Median-Centered Inputs (Probit) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Age </td>
   <td style="text-align:center;"> 0.002 </td>
   <td style="text-align:center;"> 0.002 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.002) </td>
   <td style="text-align:center;"> (0.002) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Education (in Years) </td>
   <td style="text-align:center;"> 0.022+ </td>
   <td style="text-align:center;"> 0.022+ </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.012) </td>
   <td style="text-align:center;"> (0.012) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Household Income (Deciles) </td>
   <td style="text-align:center;"> 0.027+ </td>
   <td style="text-align:center;"> 0.027+ </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.016) </td>
   <td style="text-align:center;"> (0.016) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ideology (L-R) </td>
   <td style="text-align:center;"> 0.088*** </td>
   <td style="text-align:center;"> 0.088*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.018) </td>
   <td style="text-align:center;"> (0.018) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Immigration Attitudes (Undermine-Enrich) </td>
   <td style="text-align:center;"> 0.084*** </td>
   <td style="text-align:center;"> 0.084*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.021) </td>
   <td style="text-align:center;"> (0.021) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Intercept </td>
   <td style="text-align:center;"> −2.221*** </td>
   <td style="text-align:center;"> −0.582*** </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1.5px">  </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.277) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.041) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 1093 </td>
   <td style="text-align:center;"> 1093 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>


</div>

Let's wave hands at the significance of the inputs a little bit. We see no discernible age effects or differences in this sample. We see observe tentative effects of education and household income. Higher levels of education coincide with a greater likelihood of support for joining the European Union, and the same can be said for higher levels of household income. The more precise (i.e. "more significant") effects are ideology and attitudes about immigration. It would seem that there is greater support for joining the European Union in Norway on the right than the left. It would likewise seem, partialing out ideology effects, that there is greater (lesser) support for joining the European Union the more a Norwegian thinks immigrants enrich (undermine) Norway's culture.

We got that out of the way, but that wasn't the task here. The task was to unpack what the probit model is trying to tell us on its own terms. and we'll do that by focusing on the ideology coefficient. The boilerplate/technical interpretation of this coefficient would be something like this: a one-unit increase in the ideology of the respondent, going from the political left to the political right, increases the "probit index" or *z*-score by .084. However, the confusion as to what exactly this means or what we should do with it is unaddressed by this interpretation. As we discussed above, a change in the *z*-score has different implications contingent on where exactly you're starting from and what *z*-score is getting changed. A change in the *z*-score of .084 from -2.221 is going to have a different substantive takeaway than if you are changing it from, say, 0.

With that in mind, this is why I now encourage students (or myself) to come armed with some baseline quantity of interest in order to get the most use of what the probit model is trying to tell you. Remember two things from the discussion to this point. The first comes from the stuff we knew about the normal distribution before starting this exercise. A *z*-score at the center of the distribution is 0, for which half of the curve is below. On this scale, and on its own terms, this would be equivalent to saying the "cumulative factors" (generally speaking) are saying it's even odds (i.e. *p* = .5) that *y* = 1. You always have that probit quantity in your back pocket: 0. Perhaps starting at 0 is a stretch. In our case, only about 28% of Norwegians would vote to join the European Union, though saying someone is "on the fence" of "50/50" isn't that dishonest.[^conflict]

[^conflict]: It would be a stretch to use this baseline of 50/50 in a probit model of conflict onset or escalation to war. Conflict is a rare event, and maybe you want to respect the fact that only about 1% of observations in a given dyad-year model with have a conflict and [*maybe* about 5% of confrontations escalate to war](https://internationalconflict.ua.edu/) (contingent on how you operationalize "war"). In that case, pick a more reasonable baseline.

The other quantity of interest that you could use as a baseline comes from the basic descriptive statistics we discerned from the data above. In our sample, about 28% of the respondents would vote to join the European Union and 72% of respondents would vote to stay outside the European Union. Let's plug that proportion (.28) into `qnorm()` to calculate what proportion of possible values in a standard normal distribution are below it.


```r
qnorm(.28) 
#> [1] -0.5828415
# ^ Hey, that looks familiar...

broom::tidy(M4) %>% pull(estimate) %>% .[1]
#> [1] -0.5818973
```

I hope that number looks familiar to you: it's just about the intercept of our median-centered model. Notice that the coefficients on the raw scale and when median-centered are identical and that the only parameter that's any different is the intercept. This intercept gives you a good place to start in communicating your probit model coefficients.

Let's further show what this looks like with this kind of starting point. You'd have no reason a priori to believe this is true about your data (it won't matter with respect to the model output you see), but, for illustration's sake, let's treat that *y*-intercept of -.582 (i.e. `qnorm(.28)`) as someone furthest to the ideological left. Incidentally, they're a 0 on the ideology variable. We have a  consistent coefficient change of about .088 in that quantity across the range of the scale [0:10]. We can use that information, hold everything else as fixed/constant, and show what the effects are for ideology across the range of the variable. More general usages will want to be faithful to the `predict()` function or to [model simulations](http://svmiller.com/simqi), but this works for interpreting the point estimates.


```r
x <- c(qnorm(.28), rep(NA, 10))

for (i in 2:11) {
  x[i] <- x[i-1] + as.vector(coef(M3)[5])
}

tibble(pred = x,
       prob = pnorm(pred),
       diff_pred = pred - lag(pred),
       diff_prob = prob - lag(prob),
       minmax_prob = max(prob) - min(prob))
#> # A tibble: 11 × 5
#>       pred  prob diff_pred diff_prob minmax_prob
#>      <dbl> <dbl>     <dbl>     <dbl>       <dbl>
#>  1 -0.583  0.28    NA        NA            0.337
#>  2 -0.495  0.310    0.0881    0.0304       0.337
#>  3 -0.407  0.342    0.0881    0.0317       0.337
#>  4 -0.319  0.375    0.0881    0.0329       0.337
#>  5 -0.231  0.409    0.0881    0.0338       0.337
#>  6 -0.143  0.443    0.0881    0.0345       0.337
#>  7 -0.0545 0.478    0.0881    0.0349       0.337
#>  8  0.0335 0.513    0.0881    0.0351       0.337
#>  9  0.122  0.548    0.0881    0.0350       0.337
#> 10  0.210  0.583    0.0881    0.0346       0.337
#> 11  0.298  0.617    0.0881    0.0340       0.337
```

Now, let's put everything together and show what is the "tired" way of interpreting probit coefficients, the "wired" way of interpreting probit coefficients, and the "inspired" way of interpreting probit coefficients. We'll keep it focused on the ideology coefficient

<div id="focusbox" markdown = "1">

## A Tired-Wired-Inspired Framework for Interpreting Probit Model Coefficients

### Tired

- The effect of higher levels of ideology on a left-right scale on support for joining the European Union in Norway is positive and statistically significant.
- Higher levels of ideology on a left-right scale increases the likelihood that a respondent in Norway would vote to join the European Union. The effect is statistically significant.

### Wired

- A one-unit increase in ideology (on a left-right scale) coincides with a change in the "probit index" by which *y* is expected to be 1 by .088. The effect is statistically significant.
- A one-unit increase in ideology (on a left-right scale) coincides with a change of .088 in the *z*-score of *y*. The effect is statistically significant.

### Inspired

- The coefficient for ideology is .088, which is statistically significant and discernible from a null hypothesis of zero relationship between ideology and support for joining the European Union in Norway. If the all-else-equal support for joining the European Union in our sample is about 28%, the effect of a unit increase in ideology changes the probability of support for joining the European Union from .28 to .31 (i.e. $$pnorm(qnorm(.28) + .088) = .310$$). If we grant that this baseline comparison is for someone furthest to the ideological left (i.e. the ideology variable is 0), the min-max effect of ideology is a change of about .337 in the probability of voting to join the EU (i.e. $$pnorm(qnorm(.28) + 10*.088) - pnorm(qnorm(.28)) = .337$$)
- The coefficient for ideology is .088, which is statistically significant and discernible from a null hypothesis of zero effect of ideology on support for joining the European Union in Norway. If a particular respondent was 50/50 on whether they would vote to join the European Union (i.e. *p* = .5), the unit effect changes their probability of voting to join the European Union by about .035 (i.e. $$pnorm(0+.088) = .535$$). If this hypothetical person were 50/50 and furthest to the left, the min-max effect of ideology going furthest to the right changes their probability of voting to join the EU from .5 to about .81 (i.e. $$pnorm(0 + 10*.088) = .810$$).
</div>

## Conclusion {#conclusion}

Now that I better appreciate what the probit model is trying to tell me, I'm inclined to use it a bit more in analyzing binary dependent variables. Certainly, the assumption of conditional normality is nice if you're [also willing to jointly make that assumption elsewhere](https://en.wikipedia.org/wiki/Heckman_correction). The probit model doesn't have the nice feature of a divide-by-four rule, nor does it have a logarithmic transformation that gives it an odds ratio or a more direct/intuitive path to a probability. However, what the probit model is doing is spiritually the same thing as what the logistic regression is doing: curve-fitting. It's also a bit more explicit, both in its origin and implementation, about changes with respect to the baseline even as the logistic regression is doing this as well. If you come armed with quantities that you want to treat as a baseline, and you have `pnorm()` handy, you too can make the most of the probit model.
