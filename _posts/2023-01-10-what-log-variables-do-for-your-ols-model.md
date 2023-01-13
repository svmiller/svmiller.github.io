---
title: "Log, Log, Log (i.e. What Logarithmic Transformations Do to Your OLS Model Summary)"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2023-01-10'
excerpt: "This is a somewhat convoluted (and hopefully not too sloppily done) way of thinking about what logarithmic transformations mean for how you should summarize your OLS model."
layout: post
categories:
  - R
image: "ren-stimpy-log.png"
active: blog
---



{% include image.html url="/images/ren-stimpy-log.png" caption="It's better than bad; it's good." width=400 align="right" %}

I'm writing this out of necessity so that it may go into a future grad-level course about what logarithmic transformations do to your OLS model. When we are first introduced to logarithmic transformations, we learn they have a nice effect of coercing normality into positive real variables that have some kind of unwelcome skew. They become a quick fix for cases where the OLS model is sensitive to skew on either the left- or right-hand side of the equation. However, we often lose sight of the fact that the introduction of logarithmic transformations on one or both sides of the regression equation result in a different interpretation of what the OLS model is telling you for the stuff you want to know. So, I'm writing this as a simple primer for future students so that we can avoid some uncomfortable interpretations of OLS model parameters in the presence of logarithmic transformations. The goal of this post isn't to litigate whether logarithmic transformations make sense as a matter of principle. [Sometimes they do](https://statmodeling.stat.columbia.edu/2019/08/21/you-should-usually-log-transform-your-positive-data/); [sometimes they don't](https://www.jonathandroth.com/assets/files/LogUniqueHOD0_Draft.pdf). The goal here is just to make sure my students understand how interpretation of the model output changes in the presence of logarithmic transformations of the underlying phenomenon being estimated.

First, here are the R packages I'll be using in this post.

```r
library(tidyverse)     # for most things
library(stevedata)     # for the data
library(modelsummary)  # for modelsummary()
library(kableExtra)    # for extra table formatting
library(modelr)        # for data grids
```

Here's a table of contents.

1. [An Aside on Logarithms (and Exponents), and Some Basic Rules](#aside)
2. [The Data and the Models](#datamodels)
    - [Neither the IV or DV is Log-Transformed](#linlin)
    - [The DV is Log-Transformed, but the IV Isn't](#loglin)
    - [The DV isn't Log-Transformed, but the IV is](#linlog)
    - [Both the DV and the IV are Log-Transformed](#loglog)
3. [Conclusion](#conclusion)

## An Aside on Logarithms (and Exponents), and Some Basic Rules {#aside}

I want to start with a discussion of basic rules of (natural) logarithms and their exponents. The logarithm of a number $$x$$ to base $$b$$ is the exponent to which $$b$$ must be raised to make $$x$$. This is a bit easier to see when the base is 10, which is common in a lot of scientific and engineering examples (like the Richter scale). $$10^2$$ (or 10 raised to the power of 2) is 100. That means the logarithm of base 10 of 100 is 2, which effectively inverts or "undoes" the exponent.

Statisticians instead prefer a logarithm of base $$e$$ (i.e. [Leonhard Euler](https://en.wikipedia.org/wiki/Leonhard_Euler)'s constant, or about 2.718) because the derivative of this so-called "natural" log of $$x$$ is a simple $$1/x$$. Much of the same rules apply, even if the derivative of the log of base 10 is different. However, it's why statisticians mean "log of base $$e$$" when they say "log" or "natural log."

I'll admit that it's been a very long time since I've had to think about "proving" these so-called logarithmic laws or identities, but here are the operative ones you'll need to remember. In the following notation, "log" is shorthand for the log of base $$e$$ and exponentiation (often represented as something like $$e^{x}$$) is spelled out a little more as $$exp$$ in juxtaposition to Leonhard Euler's constant ($$e$$).

$$
log(e) = 1 \\
log(1) = 0 \\
exp(1) = e \\
log(a) = b \\
exp(b) = a \\
log(exp(a)) = a \\
exp(log(a)) = a \\
log(a^b) = b*(log(a)) \\
log(a*b) = log(a) + log(b) \\
log(a/b) = log(a) - log(b) \\
exp(a*b) = (exp(a))^b
$$

Here's a basic proof of concept in R for some of these important identities. Let [$$a$$ be 45](https://en.wikipedia.org/wiki/Archie_Griffin) and let [$$b$$ be 48](https://eu.buckeyextra.com/story/football/2020/11/26/ohio-state-football-great-brian-baschnagel-positive-amid-mystery-illness/6383487002/). Pay careful attention to the quotient and product identities.


```r
log(45^48); 48*(log(45))
#> [1] 182.7198
#> [1] 182.7198
log(exp(45))
#> [1] 45
exp(log(48))
#> [1] 48
log(45*48); log(45) + log(48)
#> [1] 7.677864
#> [1] 7.677864
log(45/48); log(45) - log(48)
#> [1] -0.06453852
#> [1] -0.06453852
```

I do want to talk about one derivation of the quotient rule (i.e. $$log(a/b) = log(a) - log(b)$$). This is the *percentage change approximation rule* (of thumb) in which log differences are understood as percent changes. Here's a quick formulation of this that is worth proving because it's going to matter a great deal to how we deal with log-transformed dependent variables. Let there be two values, $$y'$$ and $$y$$, where $$y$$ is observed at $$x$$ and $$y'$$ is observed at $$(x + 1)$$ (i.e. a one-unit change). This quotient rule in logarithms devolves accordingly.

$$
log(y') - log(y) = log(y'/y) = \beta(x + 1) - \beta x = \beta
$$

In other words, our regression coefficient is our estimated of the difference between $$log(y')$$ and $$log(y)$$ (alternatively: $$log(y'/y$$). Let's start with the quotient, which we know has a logarithmic identity. We can exponentiate that logarithmic identity and the following equivalencies come out.

$$
exp(log(y'/y)) = exp(\beta) = y'/y = 1 + (\frac{y'-y}{y})
$$

We'd say from this that $$\frac{y'-y}{y}$$ is the *relative* change and that $$\frac{y'-y}{y}*100 = 100*(exp(\beta) -1)$$ is the *percentage* change. Part of that ($$100*(exp(\beta - 1)$$) comes by way of something that I admittedly have very little appetite to discuss: Taylor series and the [Maclaurin series](https://brilliant.org/wiki/maclaurin-series/). I won't pretend to have the most sophisticated treatment here, but the operative language we use is for "very small values close to 0", the Maclaurin series shows $$exp(x) - 1 \approx x$$, and, alternatively, $$exp(x) - x \approx 1$$. Calculus was never my strong suit, but you'll just have to commit some of that to memory.

## The Data and the Models {#datamodels}

The data I'll be using for this post are a classic data set in pedagogical instruction. These are the Chatterjee and Price (1977) education expenditure data. In this classic case, Chatterjee and Price (1977) are trying to model projected per capita public school expenditures (`edexppc`) as a function of the the number of residents (per thousand) living in urban areas (`urbanpop`), the state-level income per capita (`incpc`), and the number of residents (per thousand) under 18 years of age.[^dates] These data are relatively well-known for statistical instruction because they are a well-known case of heteroskedasticity and you can teach the jackknife and the bootstrap around them with minimal effort. We will not bother with those issues here, though it's worth reiterating that the interpretation of log-transformed regression parameters should come with a caveat about other aspects of model fit and OLS' assumptions. 

The data look like this.

[^dates]: The urban population data are benchmarked to 1970. The income per capita variable is supposedly from 1973. The under-18 variable is supposedly from 1974. The per capita public school expenditures data are forecasts for the year 1975. The data are admittedly ancient, but they are useful for this purpose.

<table id="stevetable">
<caption>The Chatterjee and Price (1977) Education Expenditure Data Set</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> State </th>
   <th style="text-align:center;"> Urban Population </th>
   <th style="text-align:center;"> Income per Capita </th>
   <th style="text-align:center;"> Under-18 Population </th>
   <th style="text-align:center;"> Education Expenditure per Capita Forecasts </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> AK </td>
   <td style="text-align:center;"> 831 </td>
   <td style="text-align:center;"> 5309 </td>
   <td style="text-align:center;"> 333 </td>
   <td style="text-align:center;"> 311 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AL </td>
   <td style="text-align:center;"> 584 </td>
   <td style="text-align:center;"> 3724 </td>
   <td style="text-align:center;"> 332 </td>
   <td style="text-align:center;"> 208 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AR </td>
   <td style="text-align:center;"> 500 </td>
   <td style="text-align:center;"> 3680 </td>
   <td style="text-align:center;"> 320 </td>
   <td style="text-align:center;"> 221 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AZ </td>
   <td style="text-align:center;"> 796 </td>
   <td style="text-align:center;"> 4504 </td>
   <td style="text-align:center;"> 340 </td>
   <td style="text-align:center;"> 332 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:center;"> 909 </td>
   <td style="text-align:center;"> 5438 </td>
   <td style="text-align:center;"> 307 </td>
   <td style="text-align:center;"> 332 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO </td>
   <td style="text-align:center;"> 785 </td>
   <td style="text-align:center;"> 5046 </td>
   <td style="text-align:center;"> 324 </td>
   <td style="text-align:center;"> 304 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CT </td>
   <td style="text-align:center;"> 774 </td>
   <td style="text-align:center;"> 5889 </td>
   <td style="text-align:center;"> 307 </td>
   <td style="text-align:center;"> 317 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:center;"> 722 </td>
   <td style="text-align:center;"> 5540 </td>
   <td style="text-align:center;"> 328 </td>
   <td style="text-align:center;"> 344 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FL </td>
   <td style="text-align:center;"> 805 </td>
   <td style="text-align:center;"> 4647 </td>
   <td style="text-align:center;"> 287 </td>
   <td style="text-align:center;"> 243 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GA </td>
   <td style="text-align:center;"> 603 </td>
   <td style="text-align:center;"> 4243 </td>
   <td style="text-align:center;"> 339 </td>
   <td style="text-align:center;"> 250 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HI </td>
   <td style="text-align:center;"> 484 </td>
   <td style="text-align:center;"> 5613 </td>
   <td style="text-align:center;"> 386 </td>
   <td style="text-align:center;"> 546 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IA </td>
   <td style="text-align:center;"> 572 </td>
   <td style="text-align:center;"> 4869 </td>
   <td style="text-align:center;"> 318 </td>
   <td style="text-align:center;"> 232 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ID </td>
   <td style="text-align:center;"> 541 </td>
   <td style="text-align:center;"> 4323 </td>
   <td style="text-align:center;"> 344 </td>
   <td style="text-align:center;"> 268 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IL </td>
   <td style="text-align:center;"> 830 </td>
   <td style="text-align:center;"> 5753 </td>
   <td style="text-align:center;"> 320 </td>
   <td style="text-align:center;"> 308 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IN </td>
   <td style="text-align:center;"> 649 </td>
   <td style="text-align:center;"> 4908 </td>
   <td style="text-align:center;"> 329 </td>
   <td style="text-align:center;"> 264 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KS </td>
   <td style="text-align:center;"> 661 </td>
   <td style="text-align:center;"> 5057 </td>
   <td style="text-align:center;"> 304 </td>
   <td style="text-align:center;"> 337 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KY </td>
   <td style="text-align:center;"> 523 </td>
   <td style="text-align:center;"> 3967 </td>
   <td style="text-align:center;"> 325 </td>
   <td style="text-align:center;"> 216 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LA </td>
   <td style="text-align:center;"> 661 </td>
   <td style="text-align:center;"> 3825 </td>
   <td style="text-align:center;"> 355 </td>
   <td style="text-align:center;"> 244 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:center;"> 846 </td>
   <td style="text-align:center;"> 5233 </td>
   <td style="text-align:center;"> 305 </td>
   <td style="text-align:center;"> 261 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MD </td>
   <td style="text-align:center;"> 766 </td>
   <td style="text-align:center;"> 5331 </td>
   <td style="text-align:center;"> 323 </td>
   <td style="text-align:center;"> 330 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ME </td>
   <td style="text-align:center;"> 508 </td>
   <td style="text-align:center;"> 3944 </td>
   <td style="text-align:center;"> 325 </td>
   <td style="text-align:center;"> 235 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MI </td>
   <td style="text-align:center;"> 738 </td>
   <td style="text-align:center;"> 5439 </td>
   <td style="text-align:center;"> 337 </td>
   <td style="text-align:center;"> 379 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MN </td>
   <td style="text-align:center;"> 664 </td>
   <td style="text-align:center;"> 4921 </td>
   <td style="text-align:center;"> 330 </td>
   <td style="text-align:center;"> 378 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MO </td>
   <td style="text-align:center;"> 701 </td>
   <td style="text-align:center;"> 4672 </td>
   <td style="text-align:center;"> 309 </td>
   <td style="text-align:center;"> 231 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MS </td>
   <td style="text-align:center;"> 445 </td>
   <td style="text-align:center;"> 3448 </td>
   <td style="text-align:center;"> 358 </td>
   <td style="text-align:center;"> 215 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MT </td>
   <td style="text-align:center;"> 534 </td>
   <td style="text-align:center;"> 4418 </td>
   <td style="text-align:center;"> 335 </td>
   <td style="text-align:center;"> 302 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NC </td>
   <td style="text-align:center;"> 450 </td>
   <td style="text-align:center;"> 4120 </td>
   <td style="text-align:center;"> 321 </td>
   <td style="text-align:center;"> 245 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ND </td>
   <td style="text-align:center;"> 443 </td>
   <td style="text-align:center;"> 4782 </td>
   <td style="text-align:center;"> 333 </td>
   <td style="text-align:center;"> 246 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NE </td>
   <td style="text-align:center;"> 615 </td>
   <td style="text-align:center;"> 4827 </td>
   <td style="text-align:center;"> 318 </td>
   <td style="text-align:center;"> 268 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NH </td>
   <td style="text-align:center;"> 564 </td>
   <td style="text-align:center;"> 4578 </td>
   <td style="text-align:center;"> 323 </td>
   <td style="text-align:center;"> 231 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NJ </td>
   <td style="text-align:center;"> 889 </td>
   <td style="text-align:center;"> 5759 </td>
   <td style="text-align:center;"> 310 </td>
   <td style="text-align:center;"> 285 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NM </td>
   <td style="text-align:center;"> 698 </td>
   <td style="text-align:center;"> 3764 </td>
   <td style="text-align:center;"> 366 </td>
   <td style="text-align:center;"> 317 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NV </td>
   <td style="text-align:center;"> 809 </td>
   <td style="text-align:center;"> 5560 </td>
   <td style="text-align:center;"> 330 </td>
   <td style="text-align:center;"> 291 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NY </td>
   <td style="text-align:center;"> 856 </td>
   <td style="text-align:center;"> 5663 </td>
   <td style="text-align:center;"> 301 </td>
   <td style="text-align:center;"> 387 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OH </td>
   <td style="text-align:center;"> 753 </td>
   <td style="text-align:center;"> 5012 </td>
   <td style="text-align:center;"> 324 </td>
   <td style="text-align:center;"> 221 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OK </td>
   <td style="text-align:center;"> 680 </td>
   <td style="text-align:center;"> 4189 </td>
   <td style="text-align:center;"> 306 </td>
   <td style="text-align:center;"> 234 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OR </td>
   <td style="text-align:center;"> 671 </td>
   <td style="text-align:center;"> 4697 </td>
   <td style="text-align:center;"> 305 </td>
   <td style="text-align:center;"> 316 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PA </td>
   <td style="text-align:center;"> 715 </td>
   <td style="text-align:center;"> 4894 </td>
   <td style="text-align:center;"> 300 </td>
   <td style="text-align:center;"> 300 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RI </td>
   <td style="text-align:center;"> 871 </td>
   <td style="text-align:center;"> 4780 </td>
   <td style="text-align:center;"> 303 </td>
   <td style="text-align:center;"> 300 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SC </td>
   <td style="text-align:center;"> 476 </td>
   <td style="text-align:center;"> 3817 </td>
   <td style="text-align:center;"> 342 </td>
   <td style="text-align:center;"> 233 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SD </td>
   <td style="text-align:center;"> 446 </td>
   <td style="text-align:center;"> 4296 </td>
   <td style="text-align:center;"> 330 </td>
   <td style="text-align:center;"> 230 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TN </td>
   <td style="text-align:center;"> 588 </td>
   <td style="text-align:center;"> 3946 </td>
   <td style="text-align:center;"> 315 </td>
   <td style="text-align:center;"> 212 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TX </td>
   <td style="text-align:center;"> 797 </td>
   <td style="text-align:center;"> 4336 </td>
   <td style="text-align:center;"> 335 </td>
   <td style="text-align:center;"> 269 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> UT </td>
   <td style="text-align:center;"> 804 </td>
   <td style="text-align:center;"> 4005 </td>
   <td style="text-align:center;"> 378 </td>
   <td style="text-align:center;"> 315 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VA </td>
   <td style="text-align:center;"> 631 </td>
   <td style="text-align:center;"> 4715 </td>
   <td style="text-align:center;"> 317 </td>
   <td style="text-align:center;"> 261 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VT </td>
   <td style="text-align:center;"> 322 </td>
   <td style="text-align:center;"> 4011 </td>
   <td style="text-align:center;"> 328 </td>
   <td style="text-align:center;"> 270 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:center;"> 726 </td>
   <td style="text-align:center;"> 4989 </td>
   <td style="text-align:center;"> 313 </td>
   <td style="text-align:center;"> 312 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WI </td>
   <td style="text-align:center;"> 659 </td>
   <td style="text-align:center;"> 4634 </td>
   <td style="text-align:center;"> 328 </td>
   <td style="text-align:center;"> 342 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WV </td>
   <td style="text-align:center;"> 390 </td>
   <td style="text-align:center;"> 3828 </td>
   <td style="text-align:center;"> 310 </td>
   <td style="text-align:center;"> 214 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WY </td>
   <td style="text-align:center;"> 605 </td>
   <td style="text-align:center;"> 4813 </td>
   <td style="text-align:center;"> 331 </td>
   <td style="text-align:center;"> 323 </td>
  </tr>
</tbody>
</table>

We are going to run four different regressions on these data, with an eye toward understanding forecasts of educated expenditure per capita as a function of all three of these other variables. In the first case, we're going to use the raw, untransformed scale of all the variables (i.e. nothing is log-transformed). In the second model, we're going to log-transform just the dependent variable. In the third model, we're going to pick one of the independent variables to transform (the under-18 population variable) and we're going to leave the dependent variable on its original scale. In the fourth model and final model, we're going to log-transform the dependent variable in addition to this under-18 population variable.

Let's perform the analyses with the code below. [Vincent Arel-Bundock's `{modelsummary}`](https://vincentarelbundock.github.io/modelsummary/articles/modelsummary.html) magic is happening underneath the hood to format the regression table.


```r
CP77 %>% mutate(ln_edexppc = log(edexppc),
                ln_pop = log(pop)) -> CP77

M1 <- lm(edexppc ~ urbanpop + incpc + pop, CP77)
M2 <- lm(ln_edexppc ~ urbanpop + incpc + pop, CP77)
M3 <- lm(edexppc ~ urbanpop + incpc + ln_pop, CP77)
M4 <- lm(ln_edexppc ~ urbanpop + incpc + ln_pop, CP77)
```

<div id="modelsummary">

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
<caption>Multiple Regressions of Education Expenditure per Capita from Chatterjee and Price (1977)</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> No Transformations </th>
   <th style="text-align:center;">  DV is Log-Transformed </th>
   <th style="text-align:center;">  Under-18 Population is Log-Transformed </th>
   <th style="text-align:center;">  DV and Under-18 Population are Both Log-Transformed </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;background-color: #e3f4f7 !important;"> Under-18 Population </td>
   <td style="text-align:center;font-weight: bold;background-color: #e3f4f7 !important;"> 1.552*** </td>
   <td style="text-align:center;font-weight: bold;background-color: #e3f4f7 !important;"> 0.005*** </td>
   <td style="text-align:center;font-weight: bold;background-color: #e3f4f7 !important;"> 503.206*** </td>
   <td style="text-align:center;font-weight: bold;background-color: #e3f4f7 !important;"> 1.495*** </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;background-color: #e3f4f7 !important;">  </td>
   <td style="text-align:center;font-weight: bold;background-color: #e3f4f7 !important;"> (0.315) </td>
   <td style="text-align:center;font-weight: bold;background-color: #e3f4f7 !important;"> (0.001) </td>
   <td style="text-align:center;font-weight: bold;background-color: #e3f4f7 !important;"> (106.804) </td>
   <td style="text-align:center;font-weight: bold;background-color: #e3f4f7 !important;"> (0.341) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Urban Population </td>
   <td style="text-align:center;"> −0.004 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> −0.003 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.051) </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.052) </td>
   <td style="text-align:center;"> (0.000) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Income per Capita </td>
   <td style="text-align:center;"> 0.072*** </td>
   <td style="text-align:center;"> 0.000*** </td>
   <td style="text-align:center;"> 0.072*** </td>
   <td style="text-align:center;"> 0.000*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.012) </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;"> (0.012) </td>
   <td style="text-align:center;"> (0.000) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Intercept </td>
   <td style="text-align:center;"> −556.568*** </td>
   <td style="text-align:center;"> 3.026*** </td>
   <td style="text-align:center;"> −2961.222*** </td>
   <td style="text-align:center;"> −4.128* </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (123.195) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.395) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (632.959) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (2.019) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 50 </td>
   <td style="text-align:center;"> 50 </td>
   <td style="text-align:center;"> 50 </td>
   <td style="text-align:center;"> 50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.565 </td>
   <td style="text-align:center;"> 0.568 </td>
   <td style="text-align:center;"> 0.551 </td>
   <td style="text-align:center;"> 0.559 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>

</div>


Normally, this type of regression strategy would just minimally note that both scales (raw and log-transformed) of the under-18 population variable (and the DV) would result in a statistically significant coefficient that is positive. Or: "the (hypothesized, positive) effect of the under-18 population variable is robust to different variable specifications/transformations." However, what they communicate as a coefficient is actually kind of different. Let's start with the first case, and the simplest case.

### Neither the IV or DV is Log-Transformed {#linlin}

This is the simplest case and I don't want to belabor it too much because I'm assuming a rudimentary understanding of OLS regression. In this instance, the regression coefficient is communicating a basic takeaway: **a one-unit change in the number of residents (per thousand) under 18 years of age coincides with an estimated change of about 1.552 in the projected per capita public school expenditures for 1975.** This isn't too difficult to understand; it's the most ideal case. We can use basic model predictions to show just that.


```r
CP77 %>%
  data_grid(.model = M1,
            pop = seq(min(pop), max(pop), by=1)) %>%
  mutate(pred = predict(M1, .),
         diff = pred - lag(pred, 1)) -> predM1

predM1
#> # A tibble: 100 × 5
#>      pop urbanpop incpc  pred  diff
#>    <dbl>    <int> <int> <dbl> <dbl>
#>  1   287      661  4697  226. NA   
#>  2   288      661  4697  228.  1.55
#>  3   289      661  4697  229.  1.55
#>  4   290      661  4697  231.  1.55
#>  5   291      661  4697  232.  1.55
#>  6   292      661  4697  234.  1.55
#>  7   293      661  4697  235.  1.55
#>  8   294      661  4697  237.  1.55
#>  9   295      661  4697  238.  1.55
#> 10   296      661  4697  240.  1.55
#> # … with 90 more rows
```

We can summarize those model predictions we just gathered as well and compare them to the regression coefficient.


```r
predM1 %>% 
  # this is basically a mean in name only, given R distinct-value weirdness
  summarize(mean = mean(diff, na.rm=T)) %>% pull()
#> [1] 1.552054

coef(M1)[4]
#>      pop 
#> 1.552054
```

So yeah, this wasn't too hard. When nothing in the OLS model is log-transformed, a one-unit change in the value of the independent variable coincides with an estimated change of the regression coefficient in the value of the dependent variable. That's easy.

### The DV is Log-Transformed, but the IV Isn't {#loglin}

This changes a little bit when the dependent variable is log-transformed as practitioners sometimes like to do to impose normality on positive, (typically?) right-skewed variables. After all, skewed dependent variables are typically the culprit of some OLS model diagnostic problems (e.g. heteroskedasticity, non-normal residuals). It's tempting---and I suppose, not completely dishonest---to say that a one-unit change in the under-18 population variable coincides with an estimated change of about .005 in the log-transformed value of the dependent variable. After all, R may or may not know that this dependent variable is a logarithmic transformation of something else. At least, if it knows, it doesn't care. The practitioner has to know something else is happening in this so-called "log-lin" model.

Let's illustrate what's happening here in a stylized form. First, let's create a simple prediction grid from this model where the income per capita and urban population variables are both fixed at their central tendency. I think `data_grid()` does the median by default. We're going to set the under-18 population variable to be two values. The first is the median and the second is the median, + 1. Our simple data look like this.


```r
CP77 %>%
  data_grid(.model = M2,
            pop = c(median(pop), median(pop) + 1)) -> newdat

newdat %>% data.frame
#>     pop urbanpop incpc
#> 1 324.5      661  4697
#> 2 325.5      661  4697
```

Now, we're going to get our estimated values of education expenditure per capita estimates, given the model. We're going to compare that to the regression coefficient and find something not too dissimilar to what we found before: the regression coefficient.


```r
newdat %>%
  mutate(pred = predict(M2, newdata =.)) -> newdat

newdat %>% mutate(diff = pred - lag(pred, 1)) %>%
  data.frame
#>     pop urbanpop incpc     pred        diff
#> 1 324.5      661  4697 5.630567          NA
#> 2 325.5      661  4697 5.635155 0.004587787

coef(M2)[4]
#>         pop 
#> 0.004587787
```

Hold on, though! The dependent variable is a logarithm and logarithms have special rules, some of which we introduced above. In particular, the quotient rule is going to apply here. $$log(a) - log(b) = log(a/b)$$
In our context here, we have two different values of the dependent variable. One, when the under-18 population variable is at the median, is about 5.630567. The other, when the under-18 population variable increases by one unit, is about 5.635155. The difference between them is the regression coefficient, yes, but those two values are logarithms. Thus, this quotient rule applies and we can understand the OLS model as communicating the following things, rounded for clarity, and omitting the other regressors (which are themselves fixed). Let $$y$$ be the value of estimated education expenditures per capita when the under-18 population variable is at the median and let $$y'$$ communicate the value of estimated education expenditures per capita when the under-18 population variable changes in its level by 1.

$$
log(y) = 5.63057 \\
log(y') = 5.635155 \\
log(y') - log(y) = \beta_{pop} \\
log(y'/y) = \beta_{pop}
$$

A few interesting things are happening here. For one, recall that the dependent variable is log-transformed, meaning it has a special identity: [the geometric mean](https://en.wikipedia.org/wiki/Geometric_mean). So yes, there is an arithmetic mean of the log-transformed variable but contained in this logarithmic transformation is another attribute, the geometric mean, from its exponential form. Second, the regression coefficient is something akin to a ratio because of this quotient rule and logarithmic transformations. Third, there's another property lurking around here of interest to us: the percentage change approximation rule. With those in mind, here are the following ways you could unpack this quantity in relation to its *un*transformed (raw) scale, given some of the logarithmic identities introduced above. Our focus here is just on the under-18 population variable in order to maintain consistency throughout the post.


<div id="focusbox" markdown = "1">

### Summarizing Our log(DV)~IV Model

1. $$exp(.004587787) = 1.004598$$, or: "a one-unit change in the residents (per thousand) under the age of 18 multiplies the expected per capita public school expenditures by about 1.004598.
2. $$exp(.004587787*20) = 1.096097$$, or: a 20-unit change in the residents (per thousand)  under the age of 18---which is incidentally about a standard deviation change across the range of this variable---multiplies the expected per capita public school expenditures by about 1.096.
3. The percentage change rule of logarithmic difference says a one-unit change in the residents (per thousand) under the age of 18 coincides with an estimated $$100*(.004587787) \approx .45$$ *percent* increase in expected per capita public school estimates. This one is typically everyone's go-to for cases where the DV is logged but the IV is not. Just understand the percentage change rule is always approximate, though it's fair to use it because your treatment of the regression coefficients is always approximate too.
</div>

We can use a prediction grid to illustrate this. Here, let's create a prediction grid with a sequence from the minimum to the maximum of the under-18 population variable, fixing the other regressors at a typical value. Then, we'll create model predictions, based on the model with the logged dependent variable. We can exponentiate those model predictions and create a relative change variable communicating the relative change from its previous value (i.e. $$\frac{y'-y}{y}$$), and then multiplying that by 100 to get its percentage change. What emerges is consistent with what we did above, though we are relating the discussion back to our raw (untransformed) variable that we log-transformed for the regression.


```r
CP77 %>%
  data_grid(.model = M2,
            pop = seq(min(pop), max(pop), by=1)) -> newdat

newdat %>% 
  mutate(pred = predict(M2, newdata=.),
         exppred = exp(pred)) %>% 
  mutate(relchange = (exppred - lag(exppred))/lag(exppred, 1),
         perchange = relchange*100) %>%
  summarize_at(c("relchange", "perchange"), ~mean(.,na.rm=T)) %>%
  data.frame
#>     relchange perchange
#> 1 0.004598327 0.4598327
```


### The DV isn't Log-Transformed, but the IV is {#linlog}

This is the so-called "lin-log" model and I see this less often than I see the so-called "log-lin" model. In our case, a rudimentary explanation of the under-18 population coefficient would say "a one-unit change in the logged value of the under-18 population variable coincides with an estimated change of about 503 in the estimated per capita education expenditures." Or, words to that effect. This is already an odd thing to say because the transformation of the independent variable will juice up the absolute value of the coefficient (i.e. it reduces the scale of the variable in the model), which might artificially make the effect look "big." In our particular case, there is no possible increase of 1 on the log scale for this variable. The logged minimum is about 5.66 and the logged maximum is about 5.96. A one-unit change doesn't exist on the log scale here. Perhaps that is reason to not have log-transformed this variable in the first place, though the point of this exercises ignores that question altogether (i.e. I'm more interested in explaining how to interpret the OLS model in the presence of log transformations).

That said, something else is happening here. It's a comparison of what the dependent variable is estimated to be under two hypotheticals. The first $$log(pop)$$ and the second is $$log(pop) + 1$$. Whatever that change comes out to is our regression coefficient (of about 503 in this case). However, we need to break this down into little pieces. To start, 1 in the context of a logarithmic variable can be understood as the log of Leonhard Eueler's constant ($$e$$). Thus, $$log(x) + 1$$ can also be restated as $$log(x) + log(e)$$, which we have available to us because this variable was log-transformed before plugging it into the model.·That could further be restated as $$e*log(x)$$ given the logarithmic identities introduced above. Fundamentally, the regression coefficient is communicating a proportional change, saying what the dependent variable would look like if you were to multiply a value of the independent variable by Leonhard Euler's constant.

There's another way of looking at this, much like we did above with the percentage change of rule approximation. Comparing two values of the per capita education expenditures ($$y', y$$) for a one-unit change in the logged under-18 population value ($$x', x$$) can be written as $$y' - y = 503.206*(log(x') - log(x)) = 503.206*(\log(x'/x))$$. Our percentage rule of thumb will reappear in how we can summarize this relationship, though this time it's on the right-hand side of the formula. Here are the many ways you could summarize the "lin-log" model we estimated.


<div id="focusbox" markdown = "1">

### Summarizing Our DV~log(IV) Model

1. The estimated change in per capita expenditures when the under-18 population variable is multiplied by Leonhard Euler's constant is 503.206.
2. The estimated change in per capita expenditures is 503.206 when the under-18 population variable changes by $$100*(e - 1) \approx 171.82\%$$
3. A 1% change in the under-18 population variable changes the estimated per capita education expenditures by $$503.206*log(1.01) = 5.007$$. A 10% change in the under-18 population variable changes the estimated per capita expenditures by $$503.206*log(1.10) \approx 47.96$$. A 20% change in the under-18 population variable changes the estimated per capita expenditures by $$503.206*log(1.20) = 91.74$$.
4. Alternatively, and this is the one I see most often used given the percentage change approximation rule of thumb: a 1% change in the under-18 population variable changes the estimated per capita expenditures by $$503.206/100 \approx 5.03206$$
</div>

I see the fourth approach taught to students more often than the third. While I would not object to a student doing this, I think the third is more honest. Consider the code below as proof of concept. In this case, I'm starting a vector of 20 with the minimum of the under-18 population variable, leaving the next 19 spots blank. Then, I'm going to loop through the vector and create a new observation in the vector that is just the previous one, increased by 1%. This will encompass the effective range of the variable. Then, I'm going to create a prediction grid of its logarithm and get model predictions, summarizing the first differences of those predictions. While the $$\beta/100$$ interpretation isn't necessarily wrong for communicating the regression coefficient for a change of 1% (it's an admitted approximation!), $$\beta*log(1.01)$$ is the more accurate summary.


```r
x <- c(322, rep(NA, 19))

for (i in 2:20) {
  x[i] <- x[i-1]*1.01
}

CP77 %>%
    data_grid(.model = M3,
              ln_pop = log(x)) -> newdat

newdat %>%
  mutate(pred = predict(M3, newdata =.),
         diff = pred - lag(pred, 1)) %>%
  summarize(mean = mean(diff, na.rm=T)) %>% data.frame
#>       mean
#> 1 5.007064
```

### Both the DV and the IV are Log-Transformed {#loglog}

Beyond the simple OLS case, I think this so-called "log-log" model is the most straightforward to understand. We may have struggled to internalize that the log-transformed dependent variable is now functionally a ratio because of the quotient rule, but learned that a one-unit change in the (not log-transformed) independent variable communicated some estimated *percent* change in the underlying dependent variable that was log-transformed. $$\beta*100$$ is a useful way of summarizing/approximating it. We may have found it odd to think about a log-transformed independent variable also having this property, but also learned that a one percentage change in the independent variable (underneath the logarithmic transformation) has a $$\beta*log(1.01) \approx \beta/100$$ change in the value of the dependent variable. Because the quotient rule applies to both the dependent variable and the independent variable in this case, we have both. There is an estimate percentage change in the dependent variable for some percentage change in the independent variable.

<div id="focusbox" markdown = "1">

### Summarizing Our log(DV)~log(IV) Model

1. The estimated change in per capita expenditures when the under-18 population variable is multiplied by Leonhard Euler's constant is about $$exp(1.495) \approx 4.459$$.
2. The estimated percentage change in per capita education expenditures for a 1% change in the under-18 population is $$1.01^1.495 \approx 1.014$$. We expect about a 1.4% increase in per capita education expenditures for this 1% change in the under-18 population.
</div>

We can use an amalgam of the same code above (having already generated our 1% changes in the under-18 population variable) to illustrate what this looks like.


```r
CP77 %>%
    data_grid(.model = M4,
              ln_pop = log(x)) -> newdat

newdat %>%
  mutate(pred = predict(M4, newdata=.),
         exppred = exp(pred)) %>% 
  mutate(relchange = (exppred - lag(exppred))/lag(exppred, 1),
         perchange = relchange*100) %>%
  summarize_at(c("relchange", "perchange"), ~mean(.,na.rm=T)) %>%
  data.frame
#>    relchange perchange
#> 1 0.01498897  1.498897
```

## Conclusion {#conclusion}

It's not completely dishonest to summarize an OLS model with logarithmic transformations in very general language. A researcher could summarize an OLS model in which only the dependent variable is log-transformed by saying "a one-unit change in the independent variable coincides with an estimated change of $$\beta$$ in the log-transformed dependent variable." Perhaps the goal is just to identify statistical significance and direction, in which case the language can be even more general. However, it's not too much effort to relay the log transformations back to their untransformed values. Different procedures apply for different conditions of log transformation (i.e. whether the DV or IV is log-transformed, or if both are), but think of it this way. The standard OLS model in which nothing is log-transformed communicates unit changes and the presence of log transformations communicates proportional changes on the untransformed scale. How you communicate those depends on what exactly is log-transformed, but be mindful that the presence of logarithmic transformations mean there are multiplicative/proportional effects being communicated in the model.

