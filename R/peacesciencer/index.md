---
layout: page
title: "{peacesciencer} Remote Data"
permalink: /R/peacesciencer/
---

This serves as a simple index page for some information about remote data available for download in [`{peacesciencer}`](http://svmiller.com/peacesciencer/). CRAN has a size requirement---5 MB for the whole package---that can be restrictive for a package that aims to do as many things as `{peacesciencer}`. This will concern some data sets of interest for users. These are always the largest files in an R package.

## How {peacesciencer} Informs You About These Data for Download

First, open R and load `{peacesciencer}` into the session. If you are greeted with a message about extra data for download, it's because you just downloaded/updated the package and don't have these data right now. A simple call of `download_extdata()` will accomplish this.

```r
library(peacesciencer)
# ^ if you just downloaded/updated the package, you'll be 
#   greeted with a message about remote data for download.
?download_extdata() 
# ^ for more information about what's available to download
download_extdata() 
# ^ downloaded the data, also gives a message about where
#   these data were downloaded.
```

## Data for Remote Download

`download_extdata()` will download the following data sets into the `extdata` subdirectory for the package.

### Correlates of War Dyadic Trade Data Set (v. 4.0) [[`cow_trade_ddy.rds`](http://svmiller.com/R/peacesciencer/cow_trade_ddy.rds)]

These are directed dyad-year-level data for national trade from the Correlates of War project. The trade values presented here have been rounded to three decimal points to conserve space. The data downloaded by this function are about 4.1 megabytes in size.

### Directed Leader Dyad-Year Data, 1870-2015 (CoW States) [[`cow_dir_leader_dyad_years.rds`](http://svmiller.com/R/peacesciencer/cow_dir_leader_dyad_years.rds)]

These are all directed leader dyad-year data from 1870-2015. Data come from the Archigos data (version 4.1). The data are standardized to just those observations where both leaders and states appear in the CoW state system data. The data downloaded by this function are about 2 megabytes in size.

### Directed Leader Dyad-Year Data, 1870-2015 (Gleditsch-Ward States) [[`gw_dir_leader_dyad_years.rds`](http://svmiller.com/R/peacesciencer/gw_dir_leader_dyad_years.rds)]

These are all directed leader dyad-year data from 1870-2015. Data come from the Archigos data (version 4.1). The data represent every possible dyadic leader-pairing in the Archigos data (which is denominated in the Gleditsch-Ward system), but standardizes leader dyad-years to Gleditsch-Ward state system dates. The data downloaded by this function are about 2.2 megabytes in size.

### Chance-Corrected Measures of Foreign Policy Similarity (FPSIM, v. 2) [[`dyadic_fp_similarity.rds`](http://svmiller.com/R/peacesciencer/dyadic_fp_similarity.rds)]

The FPSIM data set provides measures of foreign policy similarity of dyads based on alliance ties (Correlates of War, version 4.1) and UN General Assembly voting (Voeten, version 17) for all members of the Correlates of War state system. The alliance data cover the time period from 1816 to 2012, and the UN voting data from 1946 to 2015. The similarity measures include various versions of Ritter and Signorino's "S" (weighted/non-weighted by material capabilities; squared/absolute distance metrics) as well as the chance-corrected measures Cohen's (1960) kappa and Scott's (1955) pi. The measures based on alliance data come in two versions: one is based on valued alliance ties and the other is based on binary alliance ties. Data were last updated on December 7, 2017, and this description was [effectively plagiarized (with his blessing) from Frank Häge's Dataverse](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ALVXLM&widget=dataverse@haege).

These data are directed dyad-years with 17 columns and 1,872,198 observations. They will almost certainly be the largest data set
I nudge/ask you to download remotely. The file containing this information is 18.6 MB in size. To reduce size further, these
decimal points have also been rounded to three spots.

### (Non-Directed) Dyadic Minimum Distance Data *Plus* (CoW States) [[`cow_mindist_plus.rds`](http://svmiller.com/R/peacesciencer/cow_mindist_plus.rds)]

These are *non-directed* dyadic minimum distance data from Schvitz et al.
(2022) for all Correlates of War states from the start of 1886 to the
end of 2019. Note that I call these "data *plus*", with the idea of
informally branding these as a kind of augmentation of what you might
otherwise do with the [`{cshapes}`](https://icr.ethz.ch/data/cshapes/) package. This data set has over
4.4 million rows for each dyadic minimum distance for all available
years. Within each year, there is a recorded minimum distance for Jan. 1,
June 30, Dec. 31 and, in addition, any day within the year where the
composition of the international system (or shape of a state) changed, as
recorded in [`{cshapes}`](https://icr.ethz.ch/data/cshapes/). Sometimes these changes concern the dyadic
minimum distance; sometimes they don't. For example, the League of Nations
is responsible for a lot shape changes (i.e. system entry) in the CoW state
system data in the year 1920. That obviously won't change the dyadic minimum
distance between the U.S. and Canada, which will always be zero. Sometimes the
start of the year (Jan. 1), the midpoint of the year (June 30), or the end of
the year (Dec. 31) coincides with a system change. Often it doesn't. Note that
a referent day (Jan. 1, June 30, Dec. 31) may not appear in a given year for
a given dyad if that date exists outside CoW state system membership. For
example, Canada doesn't appear as a state system member until Jan. 10, 1920.
The goal of this data set is allow you to more quickly generate dyadic
minimum distances within [`{peacesciencer}`](http://svmiller.com/peacesciencer/)'s functionality if you are
proficient in [`{tidyverse}`](https://www.tidyverse.org/) verbs. You could also use it to highlight
how often the dyadic minimum distance may vary within a year for a given
dyad.

Despite the dimensions of the data set, it's not too big of a download. The
data are about 1.7 MB in size.


### (Non-Directed) Dyadic Minimum Distance Data *Plus* (G-W States) [[`gw_mindist_plus.rds`](http://svmiller.com/R/peacesciencer/gw_mindist_plus.rds)]

These are *non-directed* dyadic minimum distance data from Schvitz et al.
(2022) for all Gleditsch-Ward states from the start of 1886 to the
end of 2019. Note that I call these "data *plus*", with the idea of
informally branding these as a kind of augmentation of what you might
otherwise do with the [`{cshapes}`](https://icr.ethz.ch/data/cshapes/) package. This data set has over
3.7 million rows for each dyadic minimum distance for all available
years. Within each year, there is a recorded minimum distance for Jan. 1,
June 30, Dec. 31 and, in addition, any day within the year where the
composition of the international system (or shape of a state) changed, as
recorded in [`{cshapes}`](https://icr.ethz.ch/data/cshapes/). Sometimes these changes concern the dyadic
minimum distance; sometimes they don't. For example, the dissolution of
the Soviet Union is responsible for a lot shape changes (i.e. system entry) in
1991. That obviously won't change the dyadic minimum
distance between the U.S. and Canada, which will always be zero. Sometimes the
start of the year (Jan. 1), the midpoint of the year (June 30), or the end of
the year (Dec. 31) coincides with a system change. Often it doesn't. Note that
a referent day (Jan. 1, June 30, Dec. 31) may not appear in a given year for
a given dyad if that date exists outside G-W state system membership. For
example, Haiti disappears from the state system on July 4, 1915 and
reappears on Aug. 15, 1934. That means there won't be any dyadic minimum
distance observations with the U.S., for example, on Dec. 31, 1915 or June
30, 1934. The goal of this data set is allow you to more quickly generate dyadic
minimum distances within [`{peacesciencer}`](http://svmiller.com/peacesciencer/)'s functionality if you are
proficient in [`{tidyverse}`](https://www.tidyverse.org/) verbs. You could also use it to highlight
how often the dyadic minimum distance may vary within a year for a given
dyad.

Despite the dimensions of the data set, it's not too big of a download. The
data are about 1.4 MB in size.
