---
title: "A Quick Tutorial on Various State (Country) Classification Systems"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2021-01-13'
excerpt: "This is a quick tutorial on various state (country) classification systems you'll encounter in political science/policy analysis research."
layout: post
categories:
  - R
image: "national-flags.jpg"
---





{% include image.html url="/images/national-flags.jpg" caption="A stock photo of assorted national flags (Getty Images)" width=425 align="right" %}

<style>
img[src*='#center'] { 
    display: block;
    margin: auto;
}
</style>

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

My graduate studies program director asked me to teach an independent study for a graduate student this semester. The goal is to better train the student for their research agenda beyond what I could plausibly teach them in a given semester.[^theythem] Toward that end, I'm going to offer most (if not all) of the independent study sessions as posts on my blog. This should help the student and possibly help others who stumble onto my website. Going forward, I'm probably just going to copy-paste this introduction for future posts for this independent study.

[^theythem]: I'll be using they/them pronouns here mostly for maximum anonymity.

The particular student is pursuing a research program in international political economy. Substantively, much of what they want to do is outside my wheelhouse. However, I can offer some things to help the student with their research. The first lesson will be about various state (country) classification systems. 

Here's a table of contents for what follows.

1. [The Issue: There Are So Many Different Classification Systems!](#theissue)
2. [Identify a Temporal Domain for a Cross-National Analysis (Because State Codes Change Over Time)](#temporaldomain)
3. [Make One Classification System a "Master", and Don't Use the Country Name](#makeamaster)
4. [Use R to Create a Panel of States (and States over Time)](#user)

## The Issue: There Are So Many Different Classification Systems! {#theissue}

It should not shock a graduate student in political science/policy analysis to learn that there is no universal standard for state classification. Indeed, various data sources and agencies will have varying definitions of what territorial unit counts as a state for classification purposes. Each data source/agency will also have a different coding scheme as well.

Take, for example, the following classification systems. The first, [Correlates of War (CoW)](https://correlatesofwar.org/data-sets/state-system-membership), leans on integers that range from 2 (the United States) to 990 (Samoa) to code states from 1816 to 2016. The second, the [Gleditsch-Ward system](http://ksgleditsch.com/data-4.html), is a slight derivation of the CoW system. The overlap is substantial and the numerical range is effectively the same, but important distinctions emerge as Gleditsch-Ward interpret independent states differently. The third is two-character and three-character codes provided by [the Organisation Internationale de Normalisation (ISO) 3166 Maintenance Agency](https://www.iso.org/iso-3166-country-codes.html), one that Americans will at least recognize as having tight integration with [the American National Standards Institute](https://en.wikipedia.org/wiki/American_National_Standards_Institute) as well as broad use elsewhere. The fourth is [the United Nations' M49 classification system](https://unstats.un.org/unsd/methodology/m49/). The fifth is [the Geopolitical Entities, Names, and Codes (GENC) Standard](https://nsgreg.nga.mil/genc/discovery) (in both two-character and three-character form), which provides names and codes for U.S. recognized entities and subdivisions. GENC supplanted the Federal Information Processing Standard (FIPS) about 10 years ago for this purpose. To round things out, we'll include [the Eurostat classification system](https://ec.europa.eu/eurostat/data/classifications) (which greatly resembles ISO's two-character code), the FIPS codes (which also looks a lot like ISO's two-character code), and the World Bank code (which is very similar to but slightly incompatible with ISO's three-character code).

Here is how a few territorial units are coded, selected on whether their English country name starts with "T" and as these codes appear in the `countrycode` package.

<table id="stevetable">
<caption>Select Territorial Units and Their Various Codes</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Country Name </th>
   <th style="text-align:center;"> CoW Code </th>
   <th style="text-align:center;"> Gleditsch-Ward Code </th>
   <th style="text-align:center;"> ISO (2) </th>
   <th style="text-align:center;"> ISO (3) </th>
   <th style="text-align:center;"> UN M49 </th>
   <th style="text-align:center;"> GENC (2) </th>
   <th style="text-align:center;"> GENC (3) </th>
   <th style="text-align:center;"> Eurostat </th>
   <th style="text-align:center;"> FIPS </th>
   <th style="text-align:center;"> World Bank </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Taiwan </td>
   <td style="text-align:center;"> 713 </td>
   <td style="text-align:center;"> 713 </td>
   <td style="text-align:center;"> TW </td>
   <td style="text-align:center;"> TWN </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> TW </td>
   <td style="text-align:center;"> TWN </td>
   <td style="text-align:center;"> TW </td>
   <td style="text-align:center;"> TW </td>
   <td style="text-align:center;"> TWN </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tajikistan </td>
   <td style="text-align:center;"> 702 </td>
   <td style="text-align:center;"> 702 </td>
   <td style="text-align:center;"> TJ </td>
   <td style="text-align:center;"> TJK </td>
   <td style="text-align:center;"> 762 </td>
   <td style="text-align:center;"> TJ </td>
   <td style="text-align:center;"> TJK </td>
   <td style="text-align:center;"> TJ </td>
   <td style="text-align:center;"> TI </td>
   <td style="text-align:center;"> TJK </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tanzania </td>
   <td style="text-align:center;"> 510 </td>
   <td style="text-align:center;"> 510 </td>
   <td style="text-align:center;"> TZ </td>
   <td style="text-align:center;"> TZA </td>
   <td style="text-align:center;"> 834 </td>
   <td style="text-align:center;"> TZ </td>
   <td style="text-align:center;"> TZA </td>
   <td style="text-align:center;"> TZ </td>
   <td style="text-align:center;"> TZ </td>
   <td style="text-align:center;"> TZA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Thailand </td>
   <td style="text-align:center;"> 800 </td>
   <td style="text-align:center;"> 800 </td>
   <td style="text-align:center;"> TH </td>
   <td style="text-align:center;"> THA </td>
   <td style="text-align:center;"> 764 </td>
   <td style="text-align:center;"> TH </td>
   <td style="text-align:center;"> THA </td>
   <td style="text-align:center;"> TH </td>
   <td style="text-align:center;"> TH </td>
   <td style="text-align:center;"> THA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Timor-Leste </td>
   <td style="text-align:center;"> 860 </td>
   <td style="text-align:center;"> 860 </td>
   <td style="text-align:center;"> TL </td>
   <td style="text-align:center;"> TLS </td>
   <td style="text-align:center;"> 626 </td>
   <td style="text-align:center;"> TL </td>
   <td style="text-align:center;"> TLS </td>
   <td style="text-align:center;"> TL </td>
   <td style="text-align:center;"> TT </td>
   <td style="text-align:center;"> TLS </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Togo </td>
   <td style="text-align:center;"> 461 </td>
   <td style="text-align:center;"> 461 </td>
   <td style="text-align:center;"> TG </td>
   <td style="text-align:center;"> TGO </td>
   <td style="text-align:center;"> 768 </td>
   <td style="text-align:center;"> TG </td>
   <td style="text-align:center;"> TGO </td>
   <td style="text-align:center;"> TG </td>
   <td style="text-align:center;"> TO </td>
   <td style="text-align:center;"> TGO </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tokelau </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> TK </td>
   <td style="text-align:center;"> TKL </td>
   <td style="text-align:center;"> 772 </td>
   <td style="text-align:center;"> TK </td>
   <td style="text-align:center;"> TKL </td>
   <td style="text-align:center;"> TK </td>
   <td style="text-align:center;"> TL </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tonga </td>
   <td style="text-align:center;"> 955 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> TO </td>
   <td style="text-align:center;"> TON </td>
   <td style="text-align:center;"> 776 </td>
   <td style="text-align:center;"> TO </td>
   <td style="text-align:center;"> TON </td>
   <td style="text-align:center;"> TO </td>
   <td style="text-align:center;"> TN </td>
   <td style="text-align:center;"> TON </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Trinidad &amp; Tobago </td>
   <td style="text-align:center;"> 52 </td>
   <td style="text-align:center;"> 52 </td>
   <td style="text-align:center;"> TT </td>
   <td style="text-align:center;"> TTO </td>
   <td style="text-align:center;"> 780 </td>
   <td style="text-align:center;"> TT </td>
   <td style="text-align:center;"> TTO </td>
   <td style="text-align:center;"> TT </td>
   <td style="text-align:center;"> TD </td>
   <td style="text-align:center;"> TTO </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:center;"> 616 </td>
   <td style="text-align:center;"> 616 </td>
   <td style="text-align:center;"> TN </td>
   <td style="text-align:center;"> TUN </td>
   <td style="text-align:center;"> 788 </td>
   <td style="text-align:center;"> TN </td>
   <td style="text-align:center;"> TUN </td>
   <td style="text-align:center;"> TN </td>
   <td style="text-align:center;"> TS </td>
   <td style="text-align:center;"> TUN </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Turkey </td>
   <td style="text-align:center;"> 640 </td>
   <td style="text-align:center;"> 640 </td>
   <td style="text-align:center;"> TR </td>
   <td style="text-align:center;"> TUR </td>
   <td style="text-align:center;"> 792 </td>
   <td style="text-align:center;"> TR </td>
   <td style="text-align:center;"> TUR </td>
   <td style="text-align:center;"> TR </td>
   <td style="text-align:center;"> TU </td>
   <td style="text-align:center;"> TUR </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Turkmenistan </td>
   <td style="text-align:center;"> 701 </td>
   <td style="text-align:center;"> 701 </td>
   <td style="text-align:center;"> TM </td>
   <td style="text-align:center;"> TKM </td>
   <td style="text-align:center;"> 795 </td>
   <td style="text-align:center;"> TM </td>
   <td style="text-align:center;"> TKM </td>
   <td style="text-align:center;"> TM </td>
   <td style="text-align:center;"> TX </td>
   <td style="text-align:center;"> TKM </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Turks &amp; Caicos Islands </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> TC </td>
   <td style="text-align:center;"> TCA </td>
   <td style="text-align:center;"> 796 </td>
   <td style="text-align:center;"> TC </td>
   <td style="text-align:center;"> TCA </td>
   <td style="text-align:center;"> TC </td>
   <td style="text-align:center;"> TK </td>
   <td style="text-align:center;"> TCA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tuscany </td>
   <td style="text-align:center;"> 337 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tuvalu </td>
   <td style="text-align:center;"> 947 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> TV </td>
   <td style="text-align:center;"> TUV </td>
   <td style="text-align:center;"> 798 </td>
   <td style="text-align:center;"> TV </td>
   <td style="text-align:center;"> TUV </td>
   <td style="text-align:center;"> TV </td>
   <td style="text-align:center;"> TV </td>
   <td style="text-align:center;"> TUV </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Two Sicilies </td>
   <td style="text-align:center;"> 329 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
</tbody>
</table>

It seems a bit daunting to see so many differences among these classification systems. With that in mind, I recommend a student (in particular, my student this semester) to do the following.

## Identify a Temporal Domain for a Cross-National Analysis (Because State Codes Change Over Time) {#temporaldomain}

My student is interested in a cross-national analysis of a group of states---regionally or globally, I can't yet tell---with respect to a host of financial indicators. The extent to which the analysis involves financial indicators means the temporal domain of the analysis is not going to be *that* long, all things considered. However, my student is going to want to make explicit the temporal domain *first* because that will have some implications for state classification.

Namely, a state may undergo a massive transformation at some point in the data. Consider an analysis that leans on the full domain of data made available by the World Bank. World Bank data (e.g. GDP) are generally available as early as 1960 and may, in some cases, go to a very recently concluded calendar year (e.g. 2019, since 2020 *just* ended). If that's the full domain, the student will want to be mindful of some major events that have important implications for state classification.

Consider the most obvious case here: the disintegration of the Soviet Union. Different classification systems code the disintegration of the Soviet Union differently. 

- **CoW, Gleditsch-Ward**: CoW and Gleditsch-Ward code the creation of new states that followed in effectively the same way. Both understand the Soviet Union as effectively dominated by Russia, which precedes and succeeds the Soviet Union with the same code the Soviet Union had (365). Moldova (359), Estonia (366), Latvia (367), Lithuania (368), Ukraine (369), Belarus (370), Armenia (371), Georgia (372), Azerbaijan (373), Turkmenistan (371), Tajikistan (702), Kyrgyzstan (703), Uzbekistan (704), and Kazakhstan (705) emerge as independent states in 1991.
- **UN M49**: [Per Wikipedia](https://en.wikipedia.org/wiki/UN_M49), the Soviet Union had a UN M49 code of 810. The disintegration of the Soviet Union creates new codes starting in 1991 for Armenia (051), Azerbaijan (031), Georgia (268), Kazakhstan (398), Kyrgyzstan (417), Tajikistan (762), Turkmenistan (795), Uzbekistan (860), Estonia (233), Latvia (428), Lithuania (440), Belarus (112), Moldova (498), Ukraine (804), and Russia (643). Importantly, the UN classification system sees the Russian Federation as a new entity entirely, and not just the dominant component of the Soviet Union.
- **ISO**: ISO does not readily advertise a temporal consideration to its classification scheme. Some digging identifies [an "exceptional reservation"](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3#Exceptional_reservations) for the Soviet Union as `SU` for the two-character code and `SUN` for the three-character code. The Russian Federation is `RU` and `RUS`, respectively. Whereas CoW, Gleditsch-Ward, and the UN M49 classifications end the Soviet Union in 1991, ISO appears to only note this code emerges in 2008 and is "transitionally reserved from September 1992."

This is just the biggest case. However, there are other major events that lead to divergences in classification systems. Among them: the unification of Vietnam, the unification of Yemen, the Ethiopian Civil War (and creation of Eritrea), the unification of Germany, and---another biggie---the disintegration of Yugoslavia.

I mention this only to note that if the temporal domain is something like 2000 to 2019, there won't be too many issues (other than some slight interpretations of the split between Serbia and Montenegro around 2006). If you want the full enchilada of a temporal domain---the Correlates of War domain from 1816 to the present---there will be *plenty* of peculiarities/oddities in the classification system you choose that are worth knowing (the extent to which you're going to be merging in data from multiple sources).

No matter, take inventory of the temporal domain you want *first*. State codes change over time. You'll want to take stock of what headaches you can expect in your travels.

## Make One Classification System a "Master", and Don't Use the Country Name {#makeamaster}

Vincent Arel-Bundock's `countrycode` package---which I'll discuss later---is going to be useful for getting different classification systems to integrate with each other. However, my student (and the reader) should be reticent to treat `countrycode` as magic or to use it uncritically. Namely, my student and the reader should treat one classification system as a "master" system for the particular project.

The system that the student/reader makes the "master" system is to their discretion. However, the master system should be the system that emerges as a center of gravity for the particular project. For example, I do *a lot* of research on inter-state conflict across time and space. The bulk of the data I use is in [the CoW ecosystem](https://correlatesofwar.org/data-sets). Naturally, CoW's state system membership is ultimately my "master" system. It integrates perfectly with other components of the CoW data ecosystem (e.g. trade, material capabilities). One data source I integrate into these projects---the Polity regime type data---has a different classification system. When that arises, I standardize---as well as I can---the Polity system codes to the CoW codes and integrate into my data based on the matching CoW codes. Again, `countrycode` is wonderful for this purpose (more on that later), but it is not magic. It's imperative on me, in my case, to treat the CoW system as a master system because it's the center of gravity for what I'm doing.

A student doing a lot of cross-national financial analyses will probably lean on the ISO system as the master system. Namely, ISO classification is everywhere and prominently used in International Monetary Fund and World Bank data.


One caution, though. The student/reader *should not* treat the English country name as master system. A person who does this will be flagging discrepancies between a lot of countries/states, like "Bahamas, The"/"Bahamas", "Brunei"/"Brunei Darussalam", "Burma"/"Myanmar", "Congo (Brazzaville)"/"Congo"/"Republic of Congo" and *many, many more*. 

Use a code, not a proper noun.

## Use R to Create a Panel of States (and States over Time) {#user}

The remainder of this post will advise the student on how to use a few lines in R and some R packages to generate a panel of states (and states over time). First, here are the R packages we'll be using.

```r
library(tidyverse) # for all things workflow
library(countrycode) # for integration among different classification systems
library(peacesciencer) # my R package for peace science stuff
library(ISOcodes) # for ISO and UN M 49 codes
```

I do want the student/reader to notice one thing I'm doing here. Namely, I have an underlying code and a country name alongside it as well. *Don't* use the country name for classification purposes, but *do* use it for debugging purposes. A reader may get fluent in CoW codes or ISO codes, but, in the event of a matching issue, sometimes it's good to see the full country name.

### Create a State-Year Panel of CoW States {#createcow}

This comes pre-processed in my `peacesciencer` package. `create_stateyears()` defaults to returning CoW state system members for all available years from 1816 to the most recently concluded calendar year.


```r
create_stateyears()
```

```
## # A tibble: 16,731 x 3
##    ccode statenme                  year
##    <dbl> <chr>                    <int>
##  1     2 United States of America  1816
##  2     2 United States of America  1817
##  3     2 United States of America  1818
##  4     2 United States of America  1819
##  5     2 United States of America  1820
##  6     2 United States of America  1821
##  7     2 United States of America  1822
##  8     2 United States of America  1823
##  9     2 United States of America  1824
## 10     2 United States of America  1825
## # … with 16,721 more rows
```

### Create a State-Year Panel of Gleditsch-Ward states {#creategw}

`create_stateyears()` can do the same for Gleditsch-Ward states, but requires the user to specify they want states from the Gleditsch-Ward system.


```r
create_stateyears(system="gw")
```

```
## # A tibble: 18,289 x 3
##    gwcode statename                 year
##     <dbl> <chr>                    <int>
##  1      2 United States of America  1816
##  2      2 United States of America  1817
##  3      2 United States of America  1818
##  4      2 United States of America  1819
##  5      2 United States of America  1820
##  6      2 United States of America  1821
##  7      2 United States of America  1822
##  8      2 United States of America  1823
##  9      2 United States of America  1824
## 10      2 United States of America  1825
## # … with 18,279 more rows
```

### Create a Panel of ISO Codes {#createiso}

ISO codes are ubiquitous in economic data. I do have some misgivings about using `countrycode` to create a panel of countries, even for the ISO codes. Recall my concern that ISO codes are not very transparent about when (or even if) a code changes at particular point in time. No matter, the `ISOcodes` package has this information

Recall my earlier plea, though: pick one system as a "master" system, even among ISO codes. I'm partial to the three-character ISO codes so I'll use that here.


```r
ISO_3166_1 %>% as_tibble() %>%
  # Alpha_2 = iso2c, if you wanted it.
  # I want the three-character one.
  select(Alpha_3, Name)
```

```
## # A tibble: 249 x 2
##    Alpha_3 Name                
##    <chr>   <chr>               
##  1 ABW     Aruba               
##  2 AFG     Afghanistan         
##  3 AGO     Angola              
##  4 AIA     Anguilla            
##  5 ALA     Åland Islands       
##  6 ALB     Albania             
##  7 AND     Andorra             
##  8 ARE     United Arab Emirates
##  9 ARG     Argentina           
## 10 ARM     Armenia             
## # … with 239 more rows
```

`ISOcodes` does have another data frame for "retired" codes. This is `ISO_3166_3` in the `ISOcodes` package. I encourage my student to take stock of how applicable some of these observations are for their particular analysis. My previous point about ISO codes---they don't neatly communicate a temporal dimension---still holds.


```r
ISO_3166_3 %>% as_tibble() %>%
  # Get rid of codes we don't want because we're focusing on three-character
  select(-Alpha_4, -Numeric)
```

<table id="stevetable">
<caption>A Table of Retired ISO Countries/Observations</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> ISO (3) </th>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:center;"> Date Withdrawn </th>
   <th style="text-align:left;"> Comment </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> AFI </td>
   <td style="text-align:left;"> French Afars and Issas </td>
   <td style="text-align:center;"> 1977 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ANT </td>
   <td style="text-align:left;"> Netherlands Antilles </td>
   <td style="text-align:center;"> 1993-07-12 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ATB </td>
   <td style="text-align:left;"> British Antarctic Territory </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> BUR </td>
   <td style="text-align:left;"> Burma, Socialist Republic of the Union of </td>
   <td style="text-align:center;"> 1989-12-05 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> BYS </td>
   <td style="text-align:left;"> Byelorussian SSR Soviet Socialist Republic </td>
   <td style="text-align:center;"> 1992-06-15 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> CSK </td>
   <td style="text-align:left;"> Czechoslovakia, Czechoslovak Socialist Republic </td>
   <td style="text-align:center;"> 1993-06-15 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> SCG </td>
   <td style="text-align:left;"> Serbia and Montenegro </td>
   <td style="text-align:center;"> 2006-06-05 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> CTE </td>
   <td style="text-align:left;"> Canton and Enderbury Islands </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> DDR </td>
   <td style="text-align:left;"> German Democratic Republic </td>
   <td style="text-align:center;"> 1990-10-30 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> DHY </td>
   <td style="text-align:left;"> Dahomey </td>
   <td style="text-align:center;"> 1977 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ATF </td>
   <td style="text-align:left;"> French Southern and Antarctic Territories </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:left;"> now split between AQ and TF </td>
  </tr>
  <tr>
   <td style="text-align:center;"> FXX </td>
   <td style="text-align:left;"> France, Metropolitan </td>
   <td style="text-align:center;"> 1997-07-14 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> GEL </td>
   <td style="text-align:left;"> Gilbert and Ellice Islands </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:left;"> now split into Kiribati and Tuvalu </td>
  </tr>
  <tr>
   <td style="text-align:center;"> HVO </td>
   <td style="text-align:left;"> Upper Volta, Republic of </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> JTN </td>
   <td style="text-align:left;"> Johnston Island </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> MID </td>
   <td style="text-align:left;"> Midway Islands </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> NHB </td>
   <td style="text-align:left;"> New Hebrides </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ATN </td>
   <td style="text-align:left;"> Dronning Maud Land </td>
   <td style="text-align:center;"> 1983 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> NTZ </td>
   <td style="text-align:left;"> Neutral Zone </td>
   <td style="text-align:center;"> 1993-07-12 </td>
   <td style="text-align:left;"> formerly between Saudi Arabia and Iraq </td>
  </tr>
  <tr>
   <td style="text-align:center;"> PCI </td>
   <td style="text-align:left;"> Pacific Islands (trust territory) </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:left;"> divided into FM, MH, MP, and PW </td>
  </tr>
  <tr>
   <td style="text-align:center;"> PUS </td>
   <td style="text-align:left;"> US Miscellaneous Pacific Islands </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> PCZ </td>
   <td style="text-align:left;"> Panama Canal Zone </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> RHO </td>
   <td style="text-align:left;"> Southern Rhodesia </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> SKM </td>
   <td style="text-align:left;"> Sikkim </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> SUN </td>
   <td style="text-align:left;"> USSR, Union of Soviet Socialist Republics </td>
   <td style="text-align:center;"> 1992-08-30 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> TMP </td>
   <td style="text-align:left;"> East Timor </td>
   <td style="text-align:center;"> 2002-05-20 </td>
   <td style="text-align:left;"> was Portuguese Timor </td>
  </tr>
  <tr>
   <td style="text-align:center;"> VDR </td>
   <td style="text-align:left;"> Viet-Nam, Democratic Republic of </td>
   <td style="text-align:center;"> 1977 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> WAK </td>
   <td style="text-align:left;"> Wake Island </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> YMD </td>
   <td style="text-align:left;"> Yemen, Democratic, People's Democratic Republic of </td>
   <td style="text-align:center;"> 1990-08-14 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> YUG </td>
   <td style="text-align:left;"> Yugoslavia, Socialist Federal Republic of </td>
   <td style="text-align:center;"> 1993-07-28 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ZAR </td>
   <td style="text-align:left;"> Zaire, Republic of </td>
   <td style="text-align:center;"> 1997-07-14 </td>
   <td style="text-align:left;">  </td>
  </tr>
</tbody>
</table>

### Create a State-Year Panel of ISO Codes {#createstateyeariso}

If I understand these data correctly, the last change to ISO classification (that could pose a problem for merging from a CoW perspective) concerns the separation between Serbia and Montenegro in 2006. Taking this information to heart, let's assume we wanted a state-year panel based off ISO codes for all ISO observations from 2010 to 2020. Toward that end, we'd do something like this.


```r
ISO_3166_1 %>% as_tibble() %>%
  # Alpha_2 = iso2c, if you wanted it.
  # I want the three-character one.
  select(Alpha_3, Name) %>%
  mutate(styear = 2010,
         endyear = 2020) %>%
  rowwise() %>%
  mutate(year = list(seq(styear, endyear))) %>%
  unnest(year) %>%
  select(-styear, -endyear)
```

```
## # A tibble: 2,739 x 3
##    Alpha_3 Name   year
##    <chr>   <chr> <int>
##  1 ABW     Aruba  2010
##  2 ABW     Aruba  2011
##  3 ABW     Aruba  2012
##  4 ABW     Aruba  2013
##  5 ABW     Aruba  2014
##  6 ABW     Aruba  2015
##  7 ABW     Aruba  2016
##  8 ABW     Aruba  2017
##  9 ABW     Aruba  2018
## 10 ABW     Aruba  2019
## # … with 2,729 more rows
```

### Create a Panel of UN M49 Codes {#createunm49}

`ISOcodes` also has UN M49 codes as well (`UN_M.49_Countries`) , though this requires some light cleaning.


```r
UN_M.49_Countries %>% as_tibble() %>% 
  select(-ISO_Alpha_3) %>%
  mutate(Name = str_trim(Name, side="left"))
```

```
## # A tibble: 249 x 2
##    Code  Name               
##    <chr> <chr>              
##  1 004   Afghanistan        
##  2 248   Åland Islands      
##  3 008   Albania            
##  4 012   Algeria            
##  5 016   American Samoa     
##  6 020   Andorra            
##  7 024   Angola             
##  8 660   Anguilla           
##  9 010   Antarctica         
## 10 028   Antigua and Barbuda
## # … with 239 more rows
```

### Use `countrycode` for Matching/Merging Across Classification Systems {#usecountrycode}

While I encourage the student/reader to treat one classification system as a "master", it's highly unlikely the classification system that is the "master" will be the only one encountered in a particular project. For example, let's assume our master system is the three-character ISO code. However, we're going to merge in data (say: [CoW's trade data](https://correlatesofwar.org/data-sets/bilateral-trade)) that uses the CoW state system classification. `countrycode` will be very useful in matching one classification to another.

`countrycode()` is the primary function in Arel-Bundock's for that purpose. Namely, the user should create a column using the `countrycode()` function that identifies the source column (here: `Alpha_3`), identifies what type of classification that is (here: `"iso3c"`), and returns the equivalent code we want (`"cown"`, for Correlates of War numeric code).


```r
ISO_3166_1 %>% as_tibble() %>%
  # Alpha_2 = iso2c, if you wanted it.
  # I want the three-character one.
  select(Alpha_3, Name) %>%
  mutate(ccode = countrycode(Alpha_3, "iso3c", "cown"))
```

```
## Warning: Problem with `mutate()` input `ccode`.
## ℹ Some values were not matched unambiguously: ABW, AIA, ALA, ASM, ATA, ATF, BES, BLM, BMU, BVT, CCK, COK, CUW, CXR, CYM, ESH, FLK, FRO, GGY, GIB, GLP, GRL, GUF, GUM, HKG, HMD, IMN, IOT, JEY, MAC, MAF, MNP, MSR, MTQ, MYT, NCL, NFK, NIU, PCN, PRI, PSE, PYF, REU, SGS, SHN, SJM, SPM, SRB, SXM, TCA, TKL, UMI, VGB, VIR, WLF
## 
## ℹ Input `ccode` is `countrycode(Alpha_3, "iso3c", "cown")`.
```

```
## Warning in countrycode(Alpha_3, "iso3c", "cown"): Some values were not matched unambiguously: ABW, AIA, ALA, ASM, ATA, ATF, BES, BLM, BMU, BVT, CCK, COK, CUW, CXR, CYM, ESH, FLK, FRO, GGY, GIB, GLP, GRL, GUF, GUM, HKG, HMD, IMN, IOT, JEY, MAC, MAF, MNP, MSR, MTQ, MYT, NCL, NFK, NIU, PCN, PRI, PSE, PYF, REU, SGS, SHN, SJM, SPM, SRB, SXM, TCA, TKL, UMI, VGB, VIR, WLF
```

```
## # A tibble: 249 x 3
##    Alpha_3 Name                 ccode
##    <chr>   <chr>                <dbl>
##  1 ABW     Aruba                   NA
##  2 AFG     Afghanistan            700
##  3 AGO     Angola                 540
##  4 AIA     Anguilla                NA
##  5 ALA     Åland Islands           NA
##  6 ALB     Albania                339
##  7 AND     Andorra                232
##  8 ARE     United Arab Emirates   696
##  9 ARG     Argentina              160
## 10 ARM     Armenia                371
## # … with 239 more rows
```

I do want the reader to observe something. `countrycode()` cannot perfectly match observations. In those circumstances, the ensuing output is an NA. Here are the NAs returned from this output.

<table id="stevetable">
<caption>ISO Codes Without CoW Codes</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> ISO (3) </th>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:center;"> CoW Code </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> ABW </td>
   <td style="text-align:left;"> Aruba </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> AIA </td>
   <td style="text-align:left;"> Anguilla </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ALA </td>
   <td style="text-align:left;"> Åland Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ASM </td>
   <td style="text-align:left;"> American Samoa </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ATA </td>
   <td style="text-align:left;"> Antarctica </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ATF </td>
   <td style="text-align:left;"> French Southern Territories </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> BES </td>
   <td style="text-align:left;"> Bonaire, Sint Eustatius and Saba </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> BLM </td>
   <td style="text-align:left;"> Saint Barthélemy </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> BMU </td>
   <td style="text-align:left;"> Bermuda </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> BVT </td>
   <td style="text-align:left;"> Bouvet Island </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> CCK </td>
   <td style="text-align:left;"> Cocos (Keeling) Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> COK </td>
   <td style="text-align:left;"> Cook Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> CUW </td>
   <td style="text-align:left;"> Curaçao </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> CXR </td>
   <td style="text-align:left;"> Christmas Island </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> CYM </td>
   <td style="text-align:left;"> Cayman Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ESH </td>
   <td style="text-align:left;"> Western Sahara </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> FLK </td>
   <td style="text-align:left;"> Falkland Islands (Malvinas) </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> FRO </td>
   <td style="text-align:left;"> Faroe Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> GGY </td>
   <td style="text-align:left;"> Guernsey </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> GIB </td>
   <td style="text-align:left;"> Gibraltar </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> GLP </td>
   <td style="text-align:left;"> Guadeloupe </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> GRL </td>
   <td style="text-align:left;"> Greenland </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> GUF </td>
   <td style="text-align:left;"> French Guiana </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> GUM </td>
   <td style="text-align:left;"> Guam </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> HKG </td>
   <td style="text-align:left;"> Hong Kong </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> HMD </td>
   <td style="text-align:left;"> Heard Island and McDonald Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> IMN </td>
   <td style="text-align:left;"> Isle of Man </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> IOT </td>
   <td style="text-align:left;"> British Indian Ocean Territory </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> JEY </td>
   <td style="text-align:left;"> Jersey </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> MAC </td>
   <td style="text-align:left;"> Macao </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> MAF </td>
   <td style="text-align:left;"> Saint Martin (French part) </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> MNP </td>
   <td style="text-align:left;"> Northern Mariana Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> MSR </td>
   <td style="text-align:left;"> Montserrat </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> MTQ </td>
   <td style="text-align:left;"> Martinique </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> MYT </td>
   <td style="text-align:left;"> Mayotte </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> NCL </td>
   <td style="text-align:left;"> New Caledonia </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> NFK </td>
   <td style="text-align:left;"> Norfolk Island </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> NIU </td>
   <td style="text-align:left;"> Niue </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> PCN </td>
   <td style="text-align:left;"> Pitcairn </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> PRI </td>
   <td style="text-align:left;"> Puerto Rico </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> PSE </td>
   <td style="text-align:left;"> Palestine, State of </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> PYF </td>
   <td style="text-align:left;"> French Polynesia </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> REU </td>
   <td style="text-align:left;"> Réunion </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> SGS </td>
   <td style="text-align:left;"> South Georgia and the South Sandwich Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> SHN </td>
   <td style="text-align:left;"> Saint Helena, Ascension and Tristan da Cunha </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> SJM </td>
   <td style="text-align:left;"> Svalbard and Jan Mayen </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> SPM </td>
   <td style="text-align:left;"> Saint Pierre and Miquelon </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> SRB </td>
   <td style="text-align:left;"> Serbia </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> SXM </td>
   <td style="text-align:left;"> Sint Maarten (Dutch part) </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> TCA </td>
   <td style="text-align:left;"> Turks and Caicos Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> TKL </td>
   <td style="text-align:left;"> Tokelau </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> UMI </td>
   <td style="text-align:left;"> United States Minor Outlying Islands </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> VGB </td>
   <td style="text-align:left;"> Virgin Islands, British </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> VIR </td>
   <td style="text-align:left;"> Virgin Islands, U.S. </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:center;"> WLF </td>
   <td style="text-align:left;"> Wallis and Futuna </td>
   <td style="text-align:center;">  </td>
  </tr>
</tbody>
</table>


Some of this is by design. For example, there's now CoW code for Aruba (`ABW`) because Aruba does not exist in the CoW system. That'll be the bulk of the warnings returned by `countrycode()` for a case like this and you can safely ignore those. Some of this is, well, a headache you'll need to fix yourself. For example, Serbia (`SRB`) always throws `countrycode()` for a loop, but Serbia has always been 345 in the CoW system. You can fix that yourself with addendum to the `mutate()` wrapper. Something like `ccode = ifelse(Alpha_3 == "SRB", 345, ccode)` will work. 

I use this to underscore that `countrycode` is one of the most useful R packages merging and matching across different state/country classification systems. However, it is not magic and should not be used uncritically. Always inspect the output.


