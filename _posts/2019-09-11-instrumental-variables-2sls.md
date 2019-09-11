---
title: "An Illustration of Instrumental Variables and a Two-Stage Least Squares (2SLS) Regression"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2019-09-11'
excerpt: "This is a simple illustration of correlated errors and addressing correlated errors with an instrumental variable and a two-stage least squares (2SLS) regression."
layout: post
categories:
  - R
image: "sans-bad-time.jpg"
---



{% include image.html url="/images/sans-bad-time.jpg" caption="Do you wanna have a bad time? 'Cause if your errors are correlated, you are REALLY not going to like what happens next. " width=400 align="right" %}

I'll be teaching a quantitative public policy analysis class for [Clemson University's Policy Studies program](https://www.clemson.edu/cbshs/departments/political-science/academics/policy-studies/index.html) and I'm finalizing a syllabus for that class. My intuition is such a class I've been asked to teach will have a different focus than a graduate-level quantitative methods class. The overlap is obviously substantial but a graduate-level quantitative methods class will care more about statistical inference from sample statistics to population parameters under known assumptions (e.g. random sampling, central limit theorem) whereas a quantitative public policy analysis class will be more interested in causal inference and the scope of treatment effects. Further, the class itself will be an introduction at the graduate-level to a quantitative approach to policy analysis, and likely the first exposure students in the program are getting to statistics for the social sciences. The class will have to be gentle, but communicate an important concern in the policy analysis world: does a policy treatment work, and by how much?

There will have to be some discussion of endogeneity. Yes, that "E-word" is one that is easy to use to dismiss someone's research. It's so easy that invoking it may come across as a signal of laziness or contempt. Still, it's an important topic the extent to which an endogenous treatment variable for a quantitative policy analysis can influence the kind of precision we want to communicate about treatment effects. After all, endogeneity emerges when a treatment is correlated with the error term and it's ideal to address that in a regression framework. This post will offer an illustration of how to do that with an instrumental variable and a two-stage least squares (2SLS) regression.

First, let's build a correlation matrix that communicates correlations among four types of variables. The first, `x` is a standard statistical control that is not terribly interesting to us as researchers but we'll include it anyway for a multiple regression. `treat` is the treatment of interest to us and `instr` is a possible instrument for `treat` that we have in the data. `e` is the error term.


```r
vars = c("x", "treat", "instr", "e")
Correlations <- matrix(cbind(1, 0.001, 0.001, 0.001,
                             0.001, 1, 0.85, -0.5,
                             0.001, 0.85, 1, 0.001,
                             0.001, -0.5, 0.001, 1),nrow=4)
rownames(Correlations) <- colnames(Correlations) <- vars
```

The specified correlation matrix suggests the following relationships. First, `x` is fundamentally uncorrelated with anything else. Its correlations with the treatment variable, the potential instrument, and the errors are only .001. As a result, we are not too interested in this variable for the sake of this exercise. Second, the correlation between the treatment variable (`treat`) and the errors is -.5. This implies there is a fairly large---however imprecise that language is---negative correlation between the treatment variable that most concerns us and the error term. This makes the treatment endogenous to the errors. Third, the correlation between the treatment variable and the potential instrument is strong; a correlation of .85 is a strong positive relationship. Finally, the correlation between the instrumental variable and the errors is only .001. That means that instrumental variable (`instr`) satisfies the [exclusion restriction](https://stats.stackexchange.com/questions/281323/instrumental-variable-exclusion-restriction); it will only affect the outcome through the treatment variable (`treat`).

We can generate some fake data to illustrate these correlations, though this exercise requires some Cholesky decomposition and more matrix-related stuff than I enjoy doing with data.


```r
# number of observations to simulate
nobs = 1000

# Cholesky decomposition
U = t(chol(Correlations))
nvars = dim(U)[1]

# Jenny, I got your number...
set.seed(8675309)

# Random variables that follow the correlation matrix
rdata = matrix(rnorm(nvars*nobs,0,1), nrow=nvars, ncol=nobs)
X = U %*% rdata
# Transpose, convert to data, then tbl_df()
# require(tidyverse)
Data = t(X) %>% as.data.frame() %>% tbl_df()
```

The actual correlation matrix of the simulated data corresponds well enough with the specified correlation matrix.

<center>

<table style="text-align:center"><caption><strong>A Correlation Matrix of the Data</strong></caption>
<tr><td colspan="5" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td>X</td><td>Treatment</td><td>Instrument</td><td>e</td></tr>
<tr><td colspan="5" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">X</td><td>1</td><td>0.020</td><td>0.016</td><td>0.003</td></tr>
<tr><td style="text-align:left">Treatment</td><td>0.020</td><td>1</td><td>0.854</td><td>-0.502</td></tr>
<tr><td style="text-align:left">Instrument</td><td>0.016</td><td>0.854</td><td>1</td><td>-0.011</td></tr>
<tr><td style="text-align:left">e</td><td>0.003</td><td>-0.502</td><td>-0.011</td><td>1</td></tr>
<tr><td colspan="5" style="border-bottom: 1px solid black"></td></tr></table>
<br /></center>

Let's further assume that there is some outcome `y` that is a linear function some slope-intercept (or "constant") + `x`, `treat`, and the error term `e`. Such that:


```r
Data$y <- with(Data, 5 + 1*x + 1*treat + e)
```

In other words, the true underlying effect of `x` and `treat` on the outcome `y` is 1 and the estimated value of `y` when all other parameters are at 0 is 5. A simple ordinary least squares model (i.e. `M1 <- lm(y ~ x + treat, data=Data)`) would produce the following results.

<center>

<table style="text-align:center"><caption><strong>A Simple OLS Model Where the Treatment is Correlated With the Errors</strong></caption>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="1" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td>Y (Outcome)</td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">X (Control)</td><td>1.012<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.027)</td></tr>
<tr><td style="text-align:left"></td><td></td></tr>
<tr><td style="text-align:left">Treatment</td><td>0.511<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.027)</td></tr>
<tr><td style="text-align:left"></td><td></td></tr>
<tr><td style="text-align:left">Constant</td><td>5.011<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.027)</td></tr>
<tr><td style="text-align:left"></td><td></td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>1,000</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.644</td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
<tr><td style="text-align:left"></td><td style="text-align:right"></td></tr>
</table>
<br /></center>

Notice the effect of the treatment variable is biased downward because of its negative correlation with the error term `e`. The true relationship is 1 but the coefficient is nowhere near it and 95% confidence intervals around the coefficient won't be anywhere close to 1 either.

One solution here is to use an instrumental variable estimator for the affected treatment variable and employ a 2SLS regression. There are a lot of econometrics texts on what this is doing along with ample statistical notation and theoretical discussion, but here is how someone more interested in the application should think about this.

First, take all of the endogenous variables and run regressions with these as the dependent variable and all other exogenous and all instrumental variables as explanatory variables. These regressions generate predicted/fitted values for all the endogenous variables from what an applied researcher can think of as a "first stage regression." This works when, in our case, all the explanatory variables in this first stage are uncorrelated with the error term and the ensuing fitted/predicted values for the endogoneous variable are also uncorrelated with the error term. The source of variation in the endogenous variable that was correlated with the error term got sucked into the error term of this first-stage regression. The "second stage" returns to the original OLS regression model but replaces the previously correlated variables with their fitted values from the first stage. The estimators that follow are unbiased and consistent.

In our case, this pertains to just one variable (`treat`) that we know is endogenous. While econometrics textbooks can bombard entry-level students with notation and theory to communicate this point, the application in R makes it seem much more accessible.


```r
# First-stage model...
FSM <- lm(treat ~ x + instr, data=Data)

# Generate treat_hat variable
Data$treat_hat <- fitted(FSM)

# Second-stage model...
SSM <- lm(y  ~ x + treat_hat, data=Data)
```

The following table will show the results of all three analyses. 

<center>

<table style="text-align:center"><caption><strong>A Comparison of OLS and Two-Stage Least Squares (2SLS) Regression</strong></caption>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="3"><em>Model</em></td></tr>
<tr><td></td><td colspan="3" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td>OLS (Endogenous Treatment)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>First-Stage Model&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Second-Stage Model</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td><td>(3)</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">X (Control)</td><td>1.012<sup>***</sup></td><td>0.006</td><td>1.003<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.027)</td><td>(0.017)</td><td>(0.016)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Treatment</td><td>0.511<sup>***</sup></td><td></td><td></td></tr>
<tr><td style="text-align:left"></td><td>(0.027)</td><td></td><td></td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Instrumental Variable</td><td></td><td>0.847<sup>***</sup></td><td></td></tr>
<tr><td style="text-align:left"></td><td></td><td>(0.016)</td><td></td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Treatment (fitted values)</td><td></td><td></td><td>0.987<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td>(0.019)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Constant</td><td>5.011<sup>***</sup></td><td>-0.010</td><td>5.018<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.027)</td><td>(0.017)</td><td>(0.016)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>1,000</td><td>1,000</td><td>1,000</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.644</td><td>0.729</td><td>0.870</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td colspan="3" style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
<tr><td style="text-align:left"></td><td colspan="3" style="text-align:right"></td></tr>
</table>
<br /></center>

The first model is the OLS model that showed a clear downward bias in the coefficient size for the treatment when the treatment is correlated with the error term. The true effect of the treatment on the response variable `y` is 1 but the OLS coefficient for the treatment is only .511. The first-stage model attempts to remove the variation in the treatment that is correlated with the error term by regressing the treatment variable on the control variable `x` and the instrumental variable that is correlated with the treatment but not the error term. This results in fitted values for the treatment (`treat_hat`) that are substituted for the endogenous treatment variable in the second-stage model. This second-stage model is identical in form to the OLS model, but only with a treatment variable where the sources of endogeneity have been stripped from the variable. The coefficient for this fitted treatment variable approaches 1, which is what the true effect is from the data-generating process.

The goal for this post is to offer something more accessible to my future students in quantitative public policy analysis on how to deal with endogeneity in important treatment variables. There are a number of approaches here but instrumental varables and 2SLS are particularly attractive. Econometrics textbooks can make this seem daunting but students who learn more by application than by notation will find these tools relatively straightforward.


