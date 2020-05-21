---
title: "A Better Way to Include Random Effects for Mixed Effects Models in a Stargazer Table"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2020-05-15'
excerpt: "There's a better way to include effects about random parameters from a mixed effects model in a table made by R's stargazer package."
layout: post
categories:
  - R
image: "alma-observatory.jpg"
---



{% include image.html url="/images/alma-observatory.jpg" caption="Stargazing on Scale (ALMA Observatory, Chile)" width=400 align="right" %}

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

I think we've all had things that we've written that we kind of cringe seeing now. That's me and [this guide I wrote over five years ago](http://svmiller.com/blog/2015/02/quasi-automating-the-inclusion-of-random-effects-in-rs-stargazer-package/) on how to include information about the random effects from a mixed effects (multilevel) model in a table made by the `stargazer` package. I mean, ew, Steve from five years ago. For a guide that purports to "quasi-automate" something, it involves a lot of manual steps and is convoluted as hell. Even the illustrative data set is unintuitive. Yet, it's one of the most frequently visited pages on my website despite not being very helpful. Good work, Steve from five years ago.

There is a better way, though. There are multiple benefits to the approach that follows. It involves fewer steps. It's generalizable to cases where `stargazer` can't process the kind of statistical model. It also has a more intuitive example data set.

Here are the R packages we'll be using in this guide.

```r
library(tidyverse) # for all-things workflow
library(stevemisc) # for the r2sd() function and the data set
library(lme4) # the workhorse mixed effects models package in R
library(blme) # some Bayesian add-ons in an lme4 framework
library(stargazer) # the star of the show
```

## The Data and the Models

I discussed these data in a post from late March this year. [In that post](http://svmiller.com/blog/2020/03/what-explains-british-attitudes-toward-immigration-a-pedagogical-example/), which I was supposed to give to some students in the United Kingdom before the COVID-19 outbreak, I proposed a rudimentary statistical model of immigration sentiment in the United Kingdom to better teach students in the UK about quantitative methods. I make that data available in my `stevemisc` package as the `ESS9GB` data. 

Briefly, the `immigsent` is a 31-point scale of attitudes about immigration created as an additive index of three 10-point prompts about whether a respondent believes immigration is good for the UK's economy, whether cultural life is enriched by immigrants, and whether the UK is made a better place to live because of immigrants. Higher values mean more pro-immigration sentiment. We're going to propose an explanation of variation in the `immigsent` variable as a function of the respondent's age (`agea`), whether the respondent is a woman (`female`) or unemployed (`uempla`), the respondent's household income in deciles (`hinctnta`), and hte respondent's ideology on an 11-point left-right scale (`lrscale`). Data come from the 9th round of ESS data for the United Kingdom and were already subset to just those respondents who were born in the United Kingdom.

We'll propose three models. The first is a simple linear model, much like I did in the post in March. The second is a mixed effects model with a random effect for one of 12 UK regions in the data. These regions are East Midlands, East of England, London, North East, North West, Northern Ireland, Scotland, South East, South West, Wales, West Midlands, and Yorkshire and the Humber. The third model will include a random slope for ideology on the random effect of region. This model will also be estimated with the `blme` package. Of note: `stargazer` doesn't support the `blme` package.

Before estimating the models, let's scale everything that's not binary by two standard deviations. Centering, at the least, is just good modeling practice. Mixed effects models, in particular, get very whiny in the absence of naturally occurring zeroes.[^didntdothisbefore]

[^didntdothisbefore]: The analyses from the blog post in March were done on unstandardized inputs. So, the coefficients and standard errors will look different but the underlying *t*-statistics will be the same for all but the constant, which incidentally becomes more precise and meaningful.

```r
ESS9GB %>%
  mutate_at(vars("agea", "eduyrs", "hinctnta", "lrscale"), list(z = ~r2sd(.))) %>%
  rename_at(vars(contains("_z")),
            ~paste("z", gsub("_z", "", .), sep = "_") ) -> Data
```

Now, let's estimate the three models.

```r
# Simple linear model
M1 <- lm(immigsent ~ z_agea + female + z_eduyrs + uempla + z_hinctnta  + 
           z_lrscale, data=Data)

# Simple Linear Mixed Effects Model
M2 <- lmer(immigsent ~ z_agea + female + z_eduyrs + uempla + z_hinctnta  + 
             z_lrscale + (1 | region), data=Data)
             
# Simple Bayesian Linear Mixed Effects Model (not supported by stargazer)
M3 <- blmer(immigsent ~ z_agea + female + z_eduyrs + uempla + z_hinctnta  + 
              z_lrscale + (1 + z_lrscale | region), data=Data)
```

## Creating a Stargazer Table

The approach I recommend starts with creating "tidied" data frames of the regression model. These will contain the fixed effects and their standard errors. Importantly, that's all we want from these objects even as the `broom` package will also store information about the random effects. It's useful information in a lot of applications, just not this particular one.

```r
tidyM1 <- broom::tidy(M1)
tidyM2 <- broom::tidy(M2) %>% filter(effect == "fixed")
tidyM3 <- broom::tidy(M3) %>% filter(effect == "fixed")
```

Next, grab some information about the random effects  and store them as vectors. Some reviewers will care more about certain aspects of a mixed effects model than others, but I think, at a minimum, a researcher estimating and presenting a mixed effects model must present 1) the number of unique group-level "clusters" in the random effect(s) (in our case: the 12 regions of the UK in the data) and 2) the standard deviation (or variance) of the random parameters (i.e. the random slopes and/or the random intercepts). This simple example has just one random intercept and, for M3, a random slope on top of that. However, this approach I recommend is generalizable to more random effects for more complicated models.

```r
 # Number of unique regions for that one random effect
num_region <- as.numeric(sapply(ranef(M2),nrow)[1])

# SD for region in M2
sd_regionM2 <- round(as.numeric(attributes(VarCorr(M2)$"region")$stddev), 3)

# SD for region in M3. Note: we have a random slope on top of that too.
sd_regionM3 <- round(as.numeric(attributes(VarCorr(M3)$"region")$stddev)[1], 3)

# sd for the random slope in region for M3.
sd_regionM3lrscale <- round(as.numeric(attributes(VarCorr(M3)$"region")$stddev)[2], 3)
```

Now, let's manually create a tibble that has all this information presented in the order we want. We're also going to add the number of observations from the model as well. Do note you can choose to eschew the vectors and have the tibble do the calculations for you, but that would clutter up the workflow (I think). I'm sure there's a way of getting escaping LaTeX characters in this if you're thinking ahead to a LaTeX table, but this will do for now.

```r

tribble(~stat, ~M1, ~M2, ~M3,
        "Number of Regions", NA, num_region, num_region,
        "sd(Region)", NA, sd_regionM2, sd_regionM3,
        "sd(Region, Ideology)", NA, NA, sd_regionM3lrscale,
        "", NA, NA, NA,
        "N", nobs(M1), nobs(M2), nobs(M3)) -> mod_stats
          
```

Now, let's create a regression table using the `stargazer` package. This will format to HTML (for this blog post), but changing the type to "latex" (for example) won't materially change anything. I'll walk through the important pieces after the table.

```r
stargazer(M1, M2, M2, type="html", 
          # ^  Notice M2 is called twice. I'm going somewhere with this.
          # Below: manually supply tidied coefficients and standard errors
          coef = list(tidyM1$estimate, tidyM2$estimate, tidyM3$estimate),
          se = list(tidyM1$std.error, tidyM2$std.error, tidyM3$std.error),
          # Omit model statistics by default...
          omit.table.layout = "s",
          # ...but supply your own that you created (with random effects)
          add.lines = lapply(1:nrow(mod_stats), function(i) unlist(mod_stats[i, ])),
          covariate.labels = c("Age","Female","Years of Education", "Unemployed", "Household Income (Deciles)", "Ideology (L to R)"),
          notes="<small>Data: ESS, Round 9 (United Kingdom)</small>",
          dep.var.labels="Pro-Immigration Sentiment",
          model.names = FALSE,
          column.labels = c("OLS", "Linear Mixed Effects", "Linear Mixed Effects (Bayesian)")
          )

```

<div id="stargazer">

<table style="text-align:center"><tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="3"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="3" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="3">Pro-Immigration Sentiment</td></tr>
<tr><td style="text-align:left"></td><td>OLS</td><td>Linear Mixed Effects</td><td>Linear Mixed Effects<br />(Bayesian)</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td><td>(3)</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Age</td><td>-0.068</td><td>-0.103</td><td>-0.021</td></tr>
<tr><td style="text-align:left"></td><td>(0.372)</td><td>(0.372)</td><td>(0.373)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Female</td><td>-0.248</td><td>-0.212</td><td>-0.225</td></tr>
<tr><td style="text-align:left"></td><td>(0.338)</td><td>(0.335)</td><td>(0.335)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Years of Education</td><td>3.544<sup>***</sup></td><td>3.491<sup>***</sup></td><td>3.427<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.354)</td><td>(0.354)</td><td>(0.354)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Unemployed</td><td>-1.102</td><td>-1.005</td><td>-0.744</td></tr>
<tr><td style="text-align:left"></td><td>(1.204)</td><td>(1.194)</td><td>(1.203)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Household Income (Deciles)</td><td>2.007<sup>***</sup></td><td>1.908<sup>***</sup></td><td>1.885<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.365)</td><td>(0.366)</td><td>(0.366)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Ideology (L to R)</td><td>-2.267<sup>***</sup></td><td>-2.273<sup>***</sup></td><td>-2.109</td></tr>
<tr><td style="text-align:left"></td><td>(0.343)</td><td>(0.341)</td><td>(1.764)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Constant</td><td>17.269<sup>***</sup></td><td>17.133<sup>***</sup></td><td>17.150<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.243)</td><td>(0.368)</td><td>(0.369)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Number of Regions</td><td></td><td>12</td><td>12</td></tr>
<tr><td style="text-align:left">sd(Region)</td><td></td><td>0.941</td><td>0.946</td></tr>
<tr><td style="text-align:left">sd(Region, Ideology)</td><td></td><td></td><td>5.971</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">N</td><td>1454</td><td>1454</td><td>1454</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td colspan="3" style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
<tr><td style="text-align:left"></td><td colspan="3" style="text-align:right"><small>Data: ESS, Round 9 (United Kingdom)</small></td></tr>
</table>
<br /></div>

This approach is flexible to your own needs and particular set of models, but I want to highlight these important components. First, notice that Model 3 in the presentation was actually called as Model 2. Minimally, the function is `stargazer(M1, M2, M2)` because Model 3 (`M3`) is of class `blmerMod`. The overlap between `blmerMod` for Model 3 and `lmerMod` for Model 2 is obviously substantial, but `stargazer` will only process the latter and not the former. Thus, technically, Model 3 in the table was actually called as Model 2 again.

Second, and importantly, I manually supplied the coefficients and the standard errors as a list drawn from the tidied objects I created with the `broom` package. This allowed me to overwrite Model 2 (as Model 3) with the actual coefficients and standard errors from Model 3. Thus, you can see in Model 3 that the results of the Bayesian mixed effects model suggest that allowing a random of slope for ideology for the 12 regions in the UK implies there's no overall effect of ideology in the United Kingdom after considering the region-by-region variation in the data. I note this humbly because, as I mentioned in [the blog post from March](http://svmiller.com/blog/2020/03/what-explains-british-attitudes-toward-immigration-a-pedagogical-example/), this is just a simple exercise aimed for instruction about quantitative methods.

More importantly than the inferential takeaway (for the sake of this guide), I think this offers a workaround for those of you working with statistical models that `stargazer` can't process. If `stargazer` can't process/summarize the particular statistical model, but the `tidy()` function in the `broom` package can, 1) estimate a simple linear model or generalized linear model that contains all the same variables (with the exact variable names), 2) have `stargazer` process that model and 3) overwrite the coefficients and standard errors with the information summarized by the `tidy()` function in `broom`.

Third, omit the default model statistics that `stargazer` wants to supply and add your own with the `add.lines` option. This will be the information that includes the number of groups/"clusters" in the random effect, the standard deviation of the random parameters, and the total number of observations in the data. The rest of the `stargazer` call is just for formatting.

My [previous stab at this](http://svmiller.com/blog/2015/02/quasi-automating-the-inclusion-of-random-effects-in-rs-stargazer-package/) purported a means to "automate" the inclusion of information about random effects in a `stargazer` table summarizing mixed effects regressions. This is a better way of doing it. 



