---
title: "Find Something to Do with the Quality of Government (Cross-Section) Data"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2025-10-25'
excerpt: "The Quality of Government cross-sectional data offer some opportunities for students to learn quantitative methods with real-world applications."
layout: post
categories:
  - Teaching
  - R
image: "protectors-of-our-industries.jpg"
active: blog
---




{% include image.html url="/images/protectors-of-our-industries.jpg" caption="Bernhard Gilliam's 'Protector of our Industries' (1883) is one of many political cartoons of this time decrying the Gilded Age in the United States." width=400 align="right" %}

<!-- *Last updated: 25 October 2025.*  -->

This is yet another tutorial for students in my quantitative methods courses, this time at the BA-level. I sense a kind of panic from students as they approach a final paper in which I ask them to ask their own question and answer it with quantitative methods. They don't know where to look. I've made a few guides available to them. I have an example paper I provide to them where I do a simple analysis of Swedish respondents in the World Values Survey on attitudes toward democracy. I've given them some inspiration for [the kinds of analysis they can do](https://svmiller.com/blog/2024/10/inequality-insurgency-south-vietnam-1968-statistical-analysis/), and how you can [use `{WDI}` to do these types of papers as well](https://svmiller.com/blog/2024/10/make-simple-cross-sectional-world-bank-data-wdi/). I also make a copy of the Quality of Government (QoG) data from [the Quality of Government Institute](https://www.gu.se/en/quality-government) available to them. However, I don't offer them a particular example with these data. I thought I would do that here to hopefully dissuade them from further panic about this assignment and from biting off more they can chew on conflict data. I laud the initiative to do spatial analyses or TSCS models of conflict fatalities, but doing those well requires *a lot* of guidance about [joins](https://svmiller.com/blog/2021/01/a-tutorial-on-the-join-family-in-r/), [state systems](https://svmiller.com/blog/2021/01/a-tutorial-on-state-classification-systems/), and [the myriad things you can do in `{peacesciencer}`](https://svmiller.com/peacesciencer/). [This class has just three lectures and seven labs](https://ir3-2.svmiller.com/) and students have to [draw an owl](https://www.reddit.com/r/pics/comments/d3zhx/how_to_draw_an_owl/) under those constraints. I can only do so much and ask for so much. I don't want students trying to do too much, and doing it poorly. I'd rather a very simple exercise be done confidently at this stage than see students try to slay a dragon with a fork and dinner plate.

Here are the R packages I'll be using.

```r
library(tidyverse)
library(stevemisc)
library(stevethemes)
library(modelsummary)
```

Here's a table of contents.

1. [(Download) Load the Data, (Download) Read the Codebook](#data)
2. [Find Something That Interests You](#dv)
3. [Look for Some "Causes"](#ivs)
    - [Getting Some Other Stuff](#controls)
4. [Some Descriptive Statistics](#descriptive)
5. [A Basic Analysis](#lm)
6. [Very Basic Diagnostics](#diagnostics)
7. [Conclusion](#conclusion)

On with the show...

## (Download) Load the Data, (Download) Read the Codebook {#data}

Students should [download the "standard" data set](https://www.gu.se/en/quality-government/qog-data/data-downloads/standard-dataset) made available by the Quality of Government Institute. This is an intro-level, one-month-long quantitative methods course and I cannot expect students to get into the weeds of cross-section time-series (panel) data. Download the "Cross-Section" version of the data in any format and save it to your hard drive.

Load it into R as follows. The file path obviously suggests that I make these available to my students (in Stata's `.dta` format). Students should adjust their file path to wherever the data are on their hard drive.


``` r
QoG <- haven::read_dta("~/Koofr/teaching/eh1903-ir3/2/data/qog/qog_std_cs_jan24_stata14.dta")
QoG
#> # A tibble: 194 × 1,652
#>    ccode cname     ccode_qog cname_qog ccodealp ccodecow version aii_acc aii_aio
#>    <dbl> <chr>         <dbl> <chr>     <chr>       <dbl> <chr>     <dbl>   <dbl>
#>  1     4 Afghanis…         4 Afghanis… AFG           700 QoGStd…   NA         NA
#>  2     8 Albania           8 Albania   ALB           339 QoGStd…   NA         NA
#>  3    12 Algeria          12 Algeria   DZA           615 QoGStd…    6.25       5
#>  4    20 Andorra          20 Andorra   AND           232 QoGStd…   NA         NA
#>  5    24 Angola           24 Angola    AGO           540 QoGStd…   18.8       10
#>  6    28 Antigua …        28 Antigua … ATG            58 QoGStd…   NA         NA
#>  7    31 Azerbaij…        31 Azerbaij… AZE           373 QoGStd…   NA         NA
#>  8    32 Argentina        32 Argentina ARG           160 QoGStd…   NA         NA
#>  9    36 Australia        36 Australia AUS           900 QoGStd…   NA         NA
#> 10    40 Austria          40 Austria   AUT           305 QoGStd…   NA         NA
#> # ℹ 184 more rows
#> # ℹ 1,643 more variables: aii_cilser <dbl>, aii_elec <dbl>, aii_pubm <dbl>,
#> #   aii_q01 <dbl>, aii_q02 <dbl>, aii_q03 <dbl>, aii_q04 <dbl>, aii_q05 <dbl>,
#> #   aii_q06 <dbl>, aii_q07 <dbl>, aii_q08 <dbl>, aii_q09 <dbl>, aii_q10 <dbl>,
#> #   aii_q11 <dbl>, aii_q12 <dbl>, aii_q13 <dbl>, aii_q14 <dbl>, aii_q17 <dbl>,
#> #   aii_q18 <dbl>, aii_q19 <dbl>, aii_q20 <dbl>, aii_q21 <dbl>, aii_q22 <dbl>,
#> #   aii_q23 <dbl>, aii_q24 <dbl>, aii_q25 <dbl>, aii_q26 <dbl>, …
```

The data I have are from 2024 and have 194 rows with 1,652 columns. The number of rows (and the information displayed in the first few columns) are clear signals this is a cross-section of sovereign states/territorial entities in the world. The staggering number of columns communicates some information about them that might interest us. There really is not a way of proceeding through this exercise without also downloading the codebook. Have it open and be prepared to search it (`Ctrl-F`) for information you might find interesting. However, that would require having an idea of something you may want to locate, because it interests you.

## Find Something That Interests You {#dv}

This might be the biggest challenge I've encountered so far in teaching students about quantitative methods. I impress the importance of finding something that interests the student that they may want to better explain. Contingent on the thing in question, you could find a reasonable quantitative measurement of it and fit a statistical model to explain variation in it. Often, the student has no idea what they want to do and thus cannot proceed from there. This is obviously a problem, because I can't (and won't) gives topics of interest to students.

I don't have much recourse other than to plead with the student to read, read widely, and embrace a hobby horse that they care about on some level. It's quite likely that a measurement is available in the Quality of Government data related to this interest. In this case, I elected to do an analysis that's focused on the current discussion of extreme wealth concentration and its implications for democracy and the current international order. In particular, I'm interested in the language we use about wealth concentration in the "top 1%". Lo, the Quality of Government has an indicator (`top_top1_income_share`) measuring the pre-tax income share of the top 1% of the population. I found it searching for "top 1%" in the codebook having a hunch that QoG would have these data from Piketty, Saez and company available from [the World Inequality Database](https://wid.world/). They do. See:

{% include image.html url="/images/top1-qog.png" caption="Information about the 'top 1%' variable in Quality of Government's cross-sectional data set." width=1200 align="center" %}

Observe the codebook helpfully communicates temporal reach and, importantly, cross-sectional coverage. For cross-sectional data with a global aim, we want as many observations as possible (knowing we have just 194 as a maximum). In this case, the codebook is advertising that 88.6% of countries have a measure of the "top 1%"'s share of pre-tax national income.

The measure itself [correlates highly](https://www.jstor.org/stable/4625575?seq=1) with other standard measures of "inequality" even if it [may not be an optimum measure of the thing in question](https://ciaotest.cc.columbia.edu/wps/cato/0026818/f_0026818_21908.pdf) when better alternatives are available.[^cato] No matter, the language of the "top 1%" still resonates in how we link issues of wealth concentration with the current trajectory of democracy in the international system. Modeling its variation and what we know about where extreme wealth concentrates is not a bad exercise for a student at this stage. I would obviously expect more of a literature review than this than I'm doing here even if I'm not asking for much on the assignment.

[^cato]: Of course this would be a Cato working paper but it's a fair point to make.

For now, though, let's see the variation in this measure. First, a summary by way of R's `summary()` function.


``` r
summary(QoG$top_top1_income_share)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#>  0.0706  0.1195  0.1530  0.1570  0.1937  0.3111      22
```

Then, a histogram. Behind the scenes, the students should also ask for a density plot that better smooths out the histogram's basic limitation (i.e. the arbitrary number of bins and how that might deceive about issues of bimodality). 


``` r
QoG %>%
  ggplot(., aes(top_top1_income_share)) +
  theme_steve() +
  geom_histogram(color = 'black', fill = g_c("su_water"), alpha = .8) +
  scale_x_continuous(labels = scales::percent_format()) +
  labs(title = "A Histogram of Wealth Concentration in the Top 1%",
       x = "Percent Income Share in Top 1%", y = "Count",
       subtitle = "The distribution does have the smallest right skew for those states with extreme wealth concentration.",
       caption = "Data: Quality of Government Standard Dataset, 2024 (Cross-Section)")
```

![plot of chunk unnamed-chunk-3](/images/quality-of-government-example/unnamed-chunk-3-1.png)

Having seen both, presenting the histogram, and consulting the basic measures of the range and central tendency of the measure, the rough takeaway is the typical country's wealth concentration in the top 1% is about 15%. The mean and median don't disagree with each other much at all though it looks like there is a small tail for a select few countries where as much as 31% of the pre-tax national income is held in the top 1% of the population. `filter()` and some hackery with `row_number()` can identify the top five and bottom five in this measure.


``` r
QoG %>%
  select(cname, top_top1_income_share) %>%
  arrange(-top_top1_income_share) %>%
  na.omit %>% # cheesing this because of missing data
  filter(row_number() %in% c(1:5, 168:172)) %>%
  mutate(rank = c(1:5, 168:172))
#> # A tibble: 10 × 3
#>    cname                          top_top1_income_share  rank
#>    <chr>                                          <dbl> <int>
#>  1 Mozambique                                    0.311      1
#>  2 Central African Republic (the)                0.310      2
#>  3 Peru                                          0.280      3
#>  4 Mexico                                        0.268      4
#>  5 Angola                                        0.260      5
#>  6 Slovenia                                      0.0793   168
#>  7 Montenegro                                    0.0769   169
#>  8 Netherlands (the)                             0.0767   170
#>  9 Slovakia                                      0.0764   171
#> 10 North Macedonia                               0.0706   172
```

## Look for Some "Causes" {#ivs}

Social science likes to tug on pretty little causal levers when it can, though this isn't available to us in a cross-sectional data set like this for a class that lasts a month and has three lectures. Thus, we'll do our best to conceptualize some "causes" of the variation in the "top 1%" income share measure and just hope we don't get hounded by someone asking for an instrumental variable or difference-in-difference estimator or whatever. The best I can encourage students to do at this stage after identifying a dependent variable of interest is to search for analyses that have used this exact measure as a dependent variable. See what they did. Get some inspiration from that.

This led me to [this 2019 article from Huber et al. in *Socio-Economic Review*](https://doi.org/10.1093/ser/mwx027) where this measure features as a dependent variable. Their main argument is the causes of variation in this measure are largely political and less economic. In particular, they argue we can understand variation in this measure as largely a function of tax rates, the power/prevalence of unions, and the control of government by the political right. This finding emerges even controlling for various economic indicators.

I want to echo their argument about the prevalence of the bargaining power of the labor force as important correlate of this measure. I could spin a ball of yarn that the general flattening of income distributions is a triumph of organized labor in the early-to-mid 20th century and we should expect to see the legacy of that today.[^more] One thinks/hopes this argument would resonate with a Swedish audience that I teach. Let's see if we can find something related to this by searching for things like "union", "bargain[ing]", "worker", or "labo[u]r".

[^more]: Students of mine, I'm asking for a bit more than this. You can see my examples on the course module.

Great, I found something.

{% include image.html url="/images/worker-qog.png" caption="Information about worker's rights in Quality of Government's cross-sectional data set." width=1200 align="center" %}

We can work with this. I wish it had a greater cross-sectional reach (beyond the 63% coverage we have), but it has enough global coverage to proceed. We're further not limiting ourselves arbitrarily to an analysis of OECD countries.

A basic scatterplot will illustrate what bivariate relationship emerges before further consideration of partial effects in a linear model. We'll also get an informal warning about the distribution of the worker's rights measure.


``` r
QoG %>%
  select(top_top1_income_share, wef_wr) %>%
  ggplot(., aes(wef_wr, top_top1_income_share)) +
  theme_steve() +
  geom_point() +
  geom_smooth(method = 'lm') +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "The Bivariate Relationship Between Worker's Rights and Wealth Concentration in the Top 1%",
       subtitle = "An intuitively negative relationship emerges in the data, along with a caution about the distribution of the worker's rights index.",
       x = "Worker's RIghts Index [1 = worst, 100 = best]", y = "Percent Income Share in Top 1%",
       caption = "Data: Quality of Government Standard Dataset, 2024 (Cross-Section)")
```

![plot of chunk unnamed-chunk-5](/images/quality-of-government-example/unnamed-chunk-5-1.png)

### Getting Some Other Stuff {#controls}

I will say up front we cannot possibly do everything that the authors did with this data set because some measures will just not be available or will be super limited in its cross-sectional reach. I permit some flexibility in doing an analysis like this for the sake of the final assignment. No matter, we'll try our best to approximate what Huber et al. did with the following information that's also available in the QoG data. We have to "control" for the relationship we're arguing exists between worker's rights and the wealth concentration measure.

- `[bmr_dem]`: We really need a measure of democracy of some kind but don't have the more granular measurements the authors use. We'll use a dummy indicator by way of [Boix et al. (2013)](https://journals.sagepub.com/doi/10.1177/0010414012463905). Boix, incidentally, has one of my favorite analyses of [the nexus between democracy and redistribution](https://www.cambridge.org/core/books/democracy-and-redistribution/ACB818ADD9174249D028E64634627626) that I have ever read.
- `[wdi_expedu]`: government expenditure on education (as a percentage of GDP). We need some kind of human capital/education measure, and this is the one I chose. Word to the wise (students): prefices of `wdi_` generally signal greater cross-sectional coverage as it comes from the World Bank's DataBank.
- `[fi_sog]`: the QoG data do not appear to have the kind of marginal tax rate variable that I would want, but a search for "tax rate" found this measure. It's an index from the "Economic Freedom Dataset" on the size of government by way of the Fraser Institute. Higher values signal, among other things, "low marginal tax rates and high income thresholds". I'll say this now to get it out of the way; [the Fraser Institute is not serious](https://www.huffpost.com/archive/ca/entry/koch-brothers-tea-party-billionaires-donated-to-right-wing-fra_n_1456223) and [anything they do should not be taken seriously](https://www.healthcoalition.ca/past-time-to-stop-platforming-the-fraser-institute-canada-can-afford-public-health-care/) [as a scientific initiative](https://link.springer.com/article/10.1007/s12134-013-0305-5). Even acknowledging that the sources of their financial support are not sufficient to be making these claims, the institute [does not seem that interested in beating the allegations](https://pressprogress.ca/professional-educators-dont-take-the-fraser-institutes-school-rankings-seriously-neither-should-you/). Alas, it's here and there's not (I think?) a better one at the moment in the data I have. Perhaps the charitable interpretation from this forfeits a causal effect and asserts it's just going to find a (positive) partial association between its measure and what these people hope to achieve (i.e. the upward redistribution of wealth). So, there's that, I guess.
- `[wdi_gdpcapcon2015]`: Gotta have GDP per capita. Will log-transform this.
- `[wdi_fdiout]`: Foreign direct investment, net outflows (as percentage of GDP). This is a case where I needed to search for "foreign direct" and not "FDI" to better find what I wanted.
- `[wdi_gdpgr]`: GDP growth (as an annual percentage). Huber et al. have it included in their paper, or at least a working paper that was easier to obtain.

Let's get everything we want. Importantly, let's also get the country name and three-character ISO code for potential diagnostic purposes. It would also be useful in case we wanted to [add some World Bank group indicators](https://svmiller.com/blog/2025/01/create-your-panel-or-state-year-data/) to these data.


``` r
QoG %>%
  select(cname, ccodealp,
         top_top1_income_share, wef_wr,
         wdi_expedu, fi_sog, bmr_dem,
         wdi_gdpcapcon2015, wdi_fdiout, wdi_gdpgr) %>%
  # go ahead an do this now...
  mutate(ln_gdppc = log(wdi_gdpcapcon2015)) %>%
  # A nuclear option to get complete cases. Use with caution.
  # Do so only if your data are fully inclusive of everything you want and
  # doesn't have anything you don't want.
  na.omit -> Data 

Data
#> # A tibble: 105 × 11
#>    cname         ccodealp top_top1_income_share wef_wr wdi_expedu fi_sog bmr_dem
#>    <chr>         <chr>                    <dbl>  <dbl>      <dbl>  <dbl>   <dbl>
#>  1 Albania       ALB                     0.0800     79       3.34   7.83       1
#>  2 Algeria       DZA                     0.0991     57       7.04   4.36       0
#>  3 Angola        AGO                     0.260      71       2.74   7.58       0
#>  4 Argentina     ARG                     0.138      73       5.28   6.09       1
#>  5 Australia     AUS                     0.0991     82       5.61   6.03       1
#>  6 Bahrain       BHR                     0.243      63       2.55   7.05       0
#>  7 Bangladesh    BGD                     0.162      61       1.77   8.33       0
#>  8 Belgium       BEL                     0.0831     89       6.81   4.32       1
#>  9 Bolivia (Plu… BOL                     0.198      72       8.44   5.95       1
#> 10 Botswana      BWA                     0.227      71       8.06   6.54       1
#> # ℹ 95 more rows
#> # ℹ 4 more variables: wdi_gdpcapcon2015 <dbl>, wdi_fdiout <dbl>,
#> #   wdi_gdpgr <dbl>, ln_gdppc <dbl>
```

Cool? Cool.

## Some Descriptive Statistics {#descriptive}

From here, you can do some basic descriptive statistics like the kind I introduce to students in my class. This will lean on `{modelsummary}` and, in particular, the `datasummary_skim()` function it has. This is my go-to for teaching students how to effortlessly create a descriptive statistics table that they can copy-paste into their Word document. I wish I had time to teach them R Markdown, but that's a different conversation. Doing this in R Markdown would also make the title appear as a caption. Students can manually insert that themselves. However, it won't show for my purposes given [my relatively archaic setup](https://svmiller.com/categories/#Jekyll).


``` r
Data %>%
  select(-cname, -ccodealp, -wdi_gdpcapcon2015) %>%
  # omit country name/info and the un-logged GDP per capita
  datasummary_skim(., output = "kableExtra",
                   title = "Descriptive Statistics for Our Analysis",
                   align = c("c")
```

<div id ="modelsummary">

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:left;"> Unique </th>
   <th style="text-align:left;"> Missing Pct. </th>
   <th style="text-align:left;"> Mean </th>
   <th style="text-align:left;"> SD </th>
   <th style="text-align:left;"> Min </th>
   <th style="text-align:left;"> Median </th>
   <th style="text-align:left;"> Max </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Top 1% income share </td>
   <td style="text-align:left;"> 96 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 0.2 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 0.1 </td>
   <td style="text-align:left;"> 0.2 </td>
   <td style="text-align:left;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Workers' rights. 1-100 (best) </td>
   <td style="text-align:left;"> 39 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 73.1 </td>
   <td style="text-align:left;"> 18.8 </td>
   <td style="text-align:left;"> 3.0 </td>
   <td style="text-align:left;"> 73.0 </td>
   <td style="text-align:left;"> 100.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Government expenditure on education, total (% of GDP) </td>
   <td style="text-align:left;"> 105 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 4.6 </td>
   <td style="text-align:left;"> 1.6 </td>
   <td style="text-align:left;"> 1.6 </td>
   <td style="text-align:left;"> 4.4 </td>
   <td style="text-align:left;"> 9.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Size of Government: Expenditures, Taxes and Enterprises (current) </td>
   <td style="text-align:left;"> 105 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 6.7 </td>
   <td style="text-align:left;"> 1.1 </td>
   <td style="text-align:left;"> 4.3 </td>
   <td style="text-align:left;"> 6.7 </td>
   <td style="text-align:left;"> 9.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dichotomous democracy measure </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 0.7 </td>
   <td style="text-align:left;"> 0.5 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 1.0 </td>
   <td style="text-align:left;"> 1.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Foreign direct investment, net outflows (% of GDP) </td>
   <td style="text-align:left;"> 102 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 1.0 </td>
   <td style="text-align:left;"> 11.2 </td>
   <td style="text-align:left;"> −31.8 </td>
   <td style="text-align:left;"> 0.3 </td>
   <td style="text-align:left;"> 104.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GDP growth (annual %) </td>
   <td style="text-align:left;"> 105 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> −4.1 </td>
   <td style="text-align:left;"> 4.5 </td>
   <td style="text-align:left;"> −21.4 </td>
   <td style="text-align:left;"> −3.7 </td>
   <td style="text-align:left;"> 6.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GDP per capita (constant 2015 US$) </td>
   <td style="text-align:left;"> 105 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 8.9 </td>
   <td style="text-align:left;"> 1.4 </td>
   <td style="text-align:left;"> 5.6 </td>
   <td style="text-align:left;"> 8.8 </td>
   <td style="text-align:left;"> 11.3 </td>
  </tr>
</tbody>
</table>


</div>

One thing I've discovered that I think(?) is a relatively new feature of `datasummary_skim()` in `{modelsummary}` is its ability to process variable labels. It really isn't worth belaboring these things in the limited time I have with students. Students can also just as well fix these things in their Word document. For now, it might be nice to know you can find where these things are stored in the data frame. You might also find an Easter egg from the Quality of Government Institute in the data referencing a Spiderman movie.


``` r
str(Data)
#> tibble [105 × 11] (S3: tbl_df/tbl/data.frame)
#>  $ cname                : chr [1:105] "Albania" "Algeria" "Angola" "Argentina" ...
#>   ..- attr(*, "label")= chr "Country name ISO"
#>   ..- attr(*, "format.stata")= chr "%58s"
#>  $ ccodealp             : chr [1:105] "ALB" "DZA" "AGO" "ARG" ...
#>   ..- attr(*, "label")= chr "3-letter Country Code"
#>   ..- attr(*, "format.stata")= chr "%3s"
#>  $ top_top1_income_share: num [1:105] 0.08 0.0991 0.2598 0.1382 0.0991 ...
#>   ..- attr(*, "label")= chr "Top 1% income share"
#>   ..- attr(*, "format.stata")= chr "%9.0g"
#>  $ wef_wr               : num [1:105] 79 57 71 73 82 63 61 89 72 71 ...
#>   ..- attr(*, "label")= chr "Workers' rights. 1-100 (best)"
#>   ..- attr(*, "format.stata")= chr "%10.0g"
#>  $ wdi_expedu           : num [1:105] 3.34 7.04 2.74 5.28 5.61 ...
#>   ..- attr(*, "label")= chr "Government expenditure on education, total (% of GDP)"
#>   ..- attr(*, "format.stata")= chr "%10.0g"
#>  $ fi_sog               : num [1:105] 7.83 4.36 7.58 6.09 6.03 ...
#>   ..- attr(*, "label")= chr "Size of Government: Expenditures, Taxes and Enterprises (current)"
#>   ..- attr(*, "format.stata")= chr "%10.0g"
#>  $ bmr_dem              : num [1:105] 1 0 0 1 1 0 0 1 1 1 ...
#>   ..- attr(*, "label")= chr "Dichotomous democracy measure"
#>   ..- attr(*, "format.stata")= chr "%9.0g"
#>  $ wdi_gdpcapcon2015    : num [1:105] 4419 3874 2347 11341 58116 ...
#>   ..- attr(*, "label")= chr "GDP per capita (constant 2015 US$)"
#>   ..- attr(*, "format.stata")= chr "%10.0g"
#>  $ wdi_fdiout           : num [1:105] 0.33 0.01 0.18 0.305 0.625 ...
#>   ..- attr(*, "label")= chr "Foreign direct investment, net outflows (% of GDP)"
#>   ..- attr(*, "format.stata")= chr "%10.0g"
#>  $ wdi_gdpgr            : num [1:105] -3.3021 -5.1 -5.6382 -9.9432 -0.0509 ...
#>   ..- attr(*, "label")= chr "GDP growth (annual %)"
#>   ..- attr(*, "format.stata")= chr "%10.0g"
#>  $ ln_gdppc             : num [1:105] 8.39 8.26 7.76 9.34 10.97 ...
#>   ..- attr(*, "label")= chr "GDP per capita (constant 2015 US$)"
#>   ..- attr(*, "format.stata")= chr "%10.0g"
#>  - attr(*, "label")= chr "Quality of Government Standard dataset 2024 - Cross-Section"
#>  - attr(*, "notes")= chr [1:2] "\"Everyone keeps telling me how my story is supposed to go. Nah, Imma do my own thing.\"" "1"
#>  - attr(*, "na.action")= 'omit' Named int [1:89] 1 4 6 7 10 11 14 15 17 19 ...
#>   ..- attr(*, "names")= chr [1:89] "1" "4" "6" "7" ...

attr(Data$ln_gdppc, "label")
#> [1] "GDP per capita (constant 2015 US$)"
```

Let's overwrite a few things to show how this works. You'll obviously want to tailor this to your particular data set.


``` r
attr(Data$ln_gdppc, "label") <- "Logged GDP per Capita (2015 USD)"
attr(Data$fi_sog, "label") <- "Size of Government (Fraser Institute, which, yeah...)"
attr(Data$wdi_fdiout, "label") <- "FDI, net outflows (% of GDP)"
```

Now, let's do it again. Again, I'm aware the title won't come through formatting to Markdown as I do it but it will in other outputs. Students can also insert it into their Word document manually.


``` r
Data %>%
  select(-cname, -ccodealp, -wdi_gdpcapcon2015) %>%
  # omit country name/info and the un-logged GDP per capita
  datasummary_skim(., output = "kableExtra",
                   title = "Descriptive Statistics for Our Analysis",
                   align = c("c")
```


<div id ="modelsummary">

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:left;"> Unique </th>
   <th style="text-align:left;"> Missing Pct. </th>
   <th style="text-align:left;"> Mean </th>
   <th style="text-align:left;"> SD </th>
   <th style="text-align:left;"> Min </th>
   <th style="text-align:left;"> Median </th>
   <th style="text-align:left;"> Max </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Top 1% income share </td>
   <td style="text-align:left;"> 96 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 0.2 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 0.1 </td>
   <td style="text-align:left;"> 0.2 </td>
   <td style="text-align:left;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Workers' rights. 1-100 (best) </td>
   <td style="text-align:left;"> 39 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 73.1 </td>
   <td style="text-align:left;"> 18.8 </td>
   <td style="text-align:left;"> 3.0 </td>
   <td style="text-align:left;"> 73.0 </td>
   <td style="text-align:left;"> 100.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Government expenditure on education, total (% of GDP) </td>
   <td style="text-align:left;"> 105 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 4.6 </td>
   <td style="text-align:left;"> 1.6 </td>
   <td style="text-align:left;"> 1.6 </td>
   <td style="text-align:left;"> 4.4 </td>
   <td style="text-align:left;"> 9.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Size of Government (Fraser Institute, which, yeah...) </td>
   <td style="text-align:left;"> 105 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 6.7 </td>
   <td style="text-align:left;"> 1.1 </td>
   <td style="text-align:left;"> 4.3 </td>
   <td style="text-align:left;"> 6.7 </td>
   <td style="text-align:left;"> 9.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dichotomous democracy measure </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 0.7 </td>
   <td style="text-align:left;"> 0.5 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 1.0 </td>
   <td style="text-align:left;"> 1.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FDI, net outflows (% of GDP) </td>
   <td style="text-align:left;"> 102 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 1.0 </td>
   <td style="text-align:left;"> 11.2 </td>
   <td style="text-align:left;"> −31.8 </td>
   <td style="text-align:left;"> 0.3 </td>
   <td style="text-align:left;"> 104.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GDP growth (annual %) </td>
   <td style="text-align:left;"> 105 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> −4.1 </td>
   <td style="text-align:left;"> 4.5 </td>
   <td style="text-align:left;"> −21.4 </td>
   <td style="text-align:left;"> −3.7 </td>
   <td style="text-align:left;"> 6.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Logged GDP per Capita (2015 USD) </td>
   <td style="text-align:left;"> 105 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 8.9 </td>
   <td style="text-align:left;"> 1.4 </td>
   <td style="text-align:left;"> 5.6 </td>
   <td style="text-align:left;"> 8.8 </td>
   <td style="text-align:left;"> 11.3 </td>
  </tr>
</tbody>
</table>



</div>

The descriptive statistics imply, if not necessarily demonstrate, that the FDI net outflows variable is going to have a gaudy distribution. These distributions typically do, [from experience](https://svmiller.com/blog/2024/01/linear-model-diagnostics-by-ir-example/).

## A Basic Analysis {#lm}

You can do a basic linear model and summarize the results. For readability, I'm going to multiply the dependent variable by 100 (i.e. it's a proportion and students may find percentages easier to understand).


``` r
Data %>%
  mutate(dv = top_top1_income_share*100) -> Data

M1 <- lm(dv ~ bmr_dem + wdi_expedu + wef_wr + fi_sog + 
           ln_gdppc + wdi_fdiout + wdi_gdpgr, Data)

modelsummary(list("Model 1" = M1),
             stars = TRUE,
             output = 'kableExtra',
             title = "The Correlates of Wealth Concentration (QoG, 2024)",
             coef_map = c("bmr_dem" = "Democracy Dummy (BMR)",
                          "wdi_expedu" = "Education Expenditures",
                          "wef_wr" = "Worker's Rights Index",
                          "fi_sog" = "Size of Government (Fraser Institute, I know...)",
                          "ln_gdppc" = "Logged (GDP per Capita)",
                          "wdi_fdiout" = "Net FDI Outflows",
                          "wdi_gdpgr" = "GDP Growth (Annual %)",
                          "(Intercept)" = "Intercept"),
             gof_map = c("adj.r.squared", "nobs"))
```


<div id ="modelsummary">

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
<caption>The Correlates of Wealth Concentration (QoG, 2024)</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Model 1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Democracy Dummy (BMR) </td>
   <td style="text-align:center;"> −1.981+ </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (1.122) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Education Expenditures </td>
   <td style="text-align:center;"> 0.381 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.327) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Worker's Rights Index </td>
   <td style="text-align:center;"> −0.044+ </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.025) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Size of Government (Fraser Institute, I know...) </td>
   <td style="text-align:center;"> 1.503** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.474) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Logged (GDP per Capita) </td>
   <td style="text-align:center;"> −0.498 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.376) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Net FDI Outflows </td>
   <td style="text-align:center;"> −0.012 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.038) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GDP Growth (Annual %) </td>
   <td style="text-align:center;"> −0.173+ </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.100) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Intercept </td>
   <td style="text-align:center;"> 12.500* </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1.5px">  </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (5.860) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.237 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 105 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>




</div>

The results identify statistically significant effects for the democracy measure, the worker's rights measure, the size of government variable, and GDP growth. The size of government variable from the Fraser Institute is easily the most precisely estimated effect. The others, by comparison, are significant at only the .10 level. The statistically significant effects we identify are not log-transformed, so we don't have to [sweat that detail](https://svmiller.com/blog/2023/01/what-log-variables-do-for-your-ols-model/). We can note, in the case of our hypothesis, that a one-unit change in the Worker's Rights Index decreases the percentage of wealth concentration in the top 1% by .04 percentage points. It's significant at the .10 level (p = .082). The model itself accounts for about 23% of the variation in the wealth concentration measure.

## Very Basic Diagnostics {#diagnostics}

Do some basic diagnostics too. There's more I'd like students to consider, but there just isn't time to wring hands about them all. Do the fitted-residual plot, for one.


``` r
broom::augment(M1) %>%
  ggplot(.,aes(.fitted, .resid)) +
  geom_point(pch = 21) +
  theme_steve() +
  geom_hline(yintercept = 0, linetype="dashed", color="red") +
  geom_smooth(method = "loess") +
  labs(title = "A Fitted-Residual Plot of Our Model",
       subtitle = "There are a few tail observations and some movement in the smoother, but it's tough to say much from this regarding linearity.",
       x = "Fitted Values", y = "Residuals",
       caption = "I am pleasantly surprised this passed the Breusch-Pagan test.")
```

![plot of chunk unnamed-chunk-15](/images/quality-of-government-example/unnamed-chunk-15-1.png)

My `linloess_plot()` function might say more about these relationships. Perhaps the size of government variable merits a square term, should we conceptualize about wealth concentration peculiarities at the tails of the spectrum vis-a-vis the middle. That FDI outflow variable is, well, what it is. I knew what to expect and was not surprised.


``` r
linloess_plot(M1, se = FALSE, no_dummies = TRUE) +
  theme_steve() +
  labs(title = "A Component-Residual (Lin-LOESS) Plot of Our Model",
       subtitle = "I suspected there'd be weirdness in that FDI variable. The weirdness in the main IV doesn't seem to matter too much for linearity assumptions.",
       x = "Value", y = "Residual")
```

![plot of chunk unnamed-chunk-16](/images/quality-of-government-example/unnamed-chunk-16-1.png)

You can humor the normality assumption (of the residuals) in a few ways. For example, here's Shapiro-Wilk.


``` r
shapiro.test(resid(M1))
#> 
#> 	Shapiro-Wilk normality test
#> 
#> data:  resid(M1)
#> W = 0.98291, p-value = 0.196
```

Here's my residual density plot function (`rd_plot()`). Before practitioners I know pounce on me for teaching students this, I do emphasize this assumption is the least important of OLS' assumptions. In real world applications, normality is reasonably approximated if never truly achieved for a model with a large number of observations and any peculiarities whatsoever. However, students can easily get the intuition behind this even as I belabor that it's a conditional assumption that wants to imply something about the dependent variable in question.


``` r
rd_plot(M1) +
  theme_steve() +
  labs(title = "A Density Plot of our Model's Residuals",
       subtitle = "We already passed Shapiro-Wilk. In a lot of real world applications, the normality assumption is reasonably approximated",
       x = "Residuals", y = "Density")
```

![plot of chunk unnamed-chunk-18](/images/quality-of-government-example/unnamed-chunk-18-1.png)

## Conclusion {#conclusion}

Students: find something to do in the QoG data if you want to make your life easier for your final papers. It will involve finding a topic of interest, finding relevant variables included in the data, and being mindful about cross-sectional coverage. This resource is nice for students to learn quantitative methods around a relatively simple (but still information-rich) data set.
