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

### Correlates of War Dyadic Trade Data Set (v. 4.0) ([`cow_trade_ddy.rds`](http://svmiller.com/R/peacesciencer/cow_trade_ddy.rds))

These are directed dyad-year-level data for national trade from the Correlates of War project.

### Directed Leader Dyad-Year Data, 1870-2015 ([`dir_leader_dyad_years.rds`](http://svmiller.com/R/peacesciencer/dir_leader_dyad_years.rds))

These are all directed leader dyad-year data from 1870-2015. Data come from the Archigos data (version 4.1).

