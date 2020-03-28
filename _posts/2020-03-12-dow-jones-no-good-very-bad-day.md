---
title: "The Dow Jones' No Good, Very Bad Day in Context"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2020-03-12'
excerpt: "Here is some R code contextualizing the Dow Jones' recent slide, because gallows humor is the only thing that keeps me warm at night."
layout: post
categories:
  - R
image: "dow-jones-dude.jpg"
---



{% include image.html url="/images/dow-jones-dude.jpg" caption="That feeling when you realize you're not going to retire until your 70s. (Photo: Spencer Platt/Getty Images)" width=400 align="right" %}

*Last updated: March 28, 2020* 

[What he said](https://knowyourmeme.com/memes/shits-on-fire-yo).

Anyway, I'm of the mentality that reading too much into large nominal numbers in the Dow Jones Industrial Average is a fool's errand. The U.S. is absolutely wealthier on the balance now than it was at almost every other point in the Dow Jones' history. It means gains in nominal numbers will be larger. Losses in nominal numbers will be larger as well. Humility and scale are important in communicating information and trends from the Dow Jones.

That said, the Dow Jones' day was clearly no good, and very bad. Here's how you can contextualize that.

First, [my `stevemisc` package](https://github.com/svmiller/stevemisc) has Dow Jones Industrial Average data dating all the way to 1885 in the data frame `DJIA`. I updated it not long ago to include the end of 2019. I haven't added any 2020 observations to it yet, but that is easy to grab with the `quantmod` package. I also have presidential term data as part of the `Presidents` data set. Trump is not included in these data (because his term is still ongoing), but added him is simple in a tidyverse pipe.

```r
library(stevemisc)
library(tidyverse)
library(lubridate)
library(quantmod)
library(knitr)
library(kableExtra)

getSymbols("^DJI", src="yahoo", from= as.Date("2020-01-01"))

DJI %>% data.frame %>%
  rownames_to_column() %>% tbl_df() %>%
  rename(date = rowname,
         djia = DJI.Close) %>%
  mutate(date = as_date(date)) %>%
  select(date, djia) %>%
  bind_rows(DJIA, .) -> DJI

Presidents %>%
  # add Trump
  bind_rows(.,tibble(president="Donald J. Trump",
                     start = ymd("2017-01-20"),
                     end = ymd(today()))) %>%
  # Grover Cleveland had two non-consecutive terms.
  mutate(president = ifelse(president == "Grover Cleveland" & start == "1885-03-04", "Grover Cleveland 1", president),
         president = ifelse(president == "Grover Cleveland" & start == "1893-03-04", "Grover Cleveland 2", president)) %>%
  # rowwise, list-seq, and unnest...
  rowwise() %>%
  mutate(date = list(seq(start, end, by = '1 day'))) %>%
  unnest(date) %>%
  # get just the president and date to left_join into the Dow data.
  select(president, date) %>%
  # Note: this will create some duplicates because of how terms start/end
  # It won't be much a problem for what we're doing here.
  left_join(DJI, .) %>%
  mutate(president = fct_inorder(president)) -> Data
```

One way of faithfully communicating Dow data---or any economic data, for that matter---is to index the data to some point. It's why a lot of manufacturing data, for example, are indexed to 2010 or 2012 on FRED. Since the interest here is political (i.e. politicians like to take credit for good days on the Dow and deflect blame for bad days on the Dow), we can index the Dow trends within presidential administrations to the starting day of the presidency. Most indices start at 100, but we can have this start at 0 to more readily communicate growth and contraction in the Dow Jones Industrial Average within presidencies.


```r
Data %>%
  # Note: Arthur isn't going to have a lot to look at here.
  group_by(president) %>%
  mutate(index = (djia/first(djia))-1) %>% 
  ungroup() %>%
  mutate(cat = ifelse(index < 0, "Negative", "Positive")) %>%
  ggplot(.,aes(date, index,color=(index < 0))) + 
  theme_steve_web() + post_bg() +
  geom_line(aes(group=1)) +
  geom_hline(yintercept = 0, linetype="dashed", alpha=0.4) +
  # I think '%y is the best I can do because of FDR's tenure.
  scale_x_date(date_labels = "'%y", 
               date_breaks = "1 year") +
  facet_wrap(~president, scales = "free_x") +
  scale_color_manual(values=c("#009900", "#990000")) +
  theme(legend.position = "none") +
  labs(title = "The Dow Jones Industrial Average, Indexed to the Starting Point of Every Administration",
       subtitle = "The trends of the 'roaring '20s', the Great Depression, 1950s and 1990s growth, and post-collapse recoveries for FDR and Obama are apparent.",
       x = "Date",
       y = "Dow Jones Industrial Average, Indexed at Zero to the First Day of Trading for the Administration",
       caption = "Data: Dow Jones Industrial Average (Yahoo Finance, Pinnacle Systems, Measuring Worth), in the DJIA data (github.com/svmiller/stevemisc)")
```

![plot of chunk dow-jones-industrial-average-by-presidency](/images/dow-jones-industrial-average-by-presidency-1.png)

The data do well to show the scale of growth and contraction that defined these various presidencies. For example, we know the 1980s and 1990s were a period of high growth for the United States. This was made possible through a variety of factors, whether deregulation, technological change and innovation, and the Boomers entering their peak earning years. However, Ronald Reagan's last day close was 2,235 (up from 951) and Bill Clinton's last day close was 10,588 (up from 3,242). I'm old enough to remember the Dow crossing 10,000 for the first time being a big deal. However, those nominal numbers look paltry in modern times.

The other way of faithfully communicating good and bad trends in the Dow Jones Industrial Average is through a percentage change from some other benchmark's close. In most applications, this would be the previous day's close. Thus, what stands out from the blood-letting on the market on March 12, 2020 is less that it was the largest absolute drop from the previous day's close in the Dow's history. Again, it's a fool's errand to compare nominal numbers on the Dow. More importantly, it was the fourth-largest drop from the previous day's close in the Dow's history. That's a bigger deal.

Calculating percentage changes in a time series is simple. Here, would be the 10 worst days in the Dow Jones' history and the presidencies with which they concided.


```r
Data %>%
  # We have some duplicates because of start/end dates for presidencies.
  # This should fix that
  group_by(president) %>%
  mutate(l1_djia = lag(djia,1),
         percchange = ((djia - lag(djia,1))/lag(djia, 1))*100) %>%
  arrange(percchange) %>%
  select(date, president, everything()) %>%
  head(10) %>%
  ungroup() %>%
  mutate_if(is.numeric, ~round(., 2)) %>%
   kable(., format="html", table.attr='id="stevetable"',
        col.names=c("Date", "President", "DJIA (Close)", "DJIA (Close, Previous)", "% Change"),
        caption = "The Ten Worst Trading Days in Dow Jones History, Feb. 16, 1885 to the Present",
        align=c("l","l","c","c","c","c"))
```

<table id="stevetable">
<caption>The Ten Worst Trading Days in Dow Jones History, Feb. 16, 1885 to the Present</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Date </th>
   <th style="text-align:left;"> President </th>
   <th style="text-align:center;"> DJIA (Close) </th>
   <th style="text-align:center;"> DJIA (Close, Previous) </th>
   <th style="text-align:center;"> % Change </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1987-10-19 </td>
   <td style="text-align:left;"> Ronald Reagan </td>
   <td style="text-align:center;"> 1738.74 </td>
   <td style="text-align:center;"> 2246.73 </td>
   <td style="text-align:center;"> -22.61 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-16 </td>
   <td style="text-align:left;"> Donald J. Trump </td>
   <td style="text-align:center;"> 20188.52 </td>
   <td style="text-align:center;"> 23185.62 </td>
   <td style="text-align:center;"> -12.93 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-10-28 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 260.64 </td>
   <td style="text-align:center;"> 298.97 </td>
   <td style="text-align:center;"> -12.82 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-10-29 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 230.07 </td>
   <td style="text-align:center;"> 260.64 </td>
   <td style="text-align:center;"> -11.73 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-12 </td>
   <td style="text-align:left;"> Donald J. Trump </td>
   <td style="text-align:center;"> 21200.62 </td>
   <td style="text-align:center;"> 23553.22 </td>
   <td style="text-align:center;"> -9.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-11-06 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 232.13 </td>
   <td style="text-align:center;"> 257.68 </td>
   <td style="text-align:center;"> -9.92 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1899-12-18 </td>
   <td style="text-align:left;"> William McKinley </td>
   <td style="text-align:center;"> 42.69 </td>
   <td style="text-align:center;"> 46.77 </td>
   <td style="text-align:center;"> -8.72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1895-12-20 </td>
   <td style="text-align:left;"> Grover Cleveland 2 </td>
   <td style="text-align:center;"> 29.42 </td>
   <td style="text-align:center;"> 32.16 </td>
   <td style="text-align:center;"> -8.51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1932-08-12 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 63.11 </td>
   <td style="text-align:center;"> 68.90 </td>
   <td style="text-align:center;"> -8.40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1907-03-14 </td>
   <td style="text-align:left;"> Theodore Roosevelt </td>
   <td style="text-align:center;"> 55.84 </td>
   <td style="text-align:center;"> 60.89 </td>
   <td style="text-align:center;"> -8.29 </td>
  </tr>
</tbody>
</table>

There are not a whole lot of surprises. Ronald Reagan's no-good-very-bad "Black Monday" crash was an all-timer and may not ever be topped. I forget the exact trading curbs initiated for the Dow Jones, but it's likely trading would stop before that threshold is met in the future. Trump's no-good-very-bad Thursday ranks fourth all-time and is surrounded by three Herbert Hoover observations at the core of the Great Depression.

For additional context, here's every president's worst trading day in Dow Jones history. Here, the data are ranked worst to best and the first appearance for all presidents is provided in this table.


```r
Data %>%
  # We have some duplicates because of start/end dates for presidencies.
  # This should fix that
  group_by(president) %>%
  mutate(l1_djia = lag(djia,1),
         percchange = ((djia - lag(djia,1))/lag(djia, 1))*100) %>%
  arrange(percchange) %>%
  ungroup() %>%
  mutate(rank = seq(1:n())) %>%
  group_by(president) %>%
  filter(row_number() == 1) %>%
  mutate_if(is.numeric, ~round(., 2)) %>%
  select(date, president, everything()) %>%
    kable(., format="html", table.attr='id="stevetable"',
        col.names=c("Date", "President", "DJIA (Close)", "DJIA (Close, Previous)", "% Change", "Rank Among All-Time Worst Days"),
        caption = "The Worst Trading Days in Dow Jones History for Each President, Feb. 16, 1885 to the Present",
        align=c("l","l","c","c","c","c"))
```

<table id="stevetable">
<caption>The Worst Trading Days in Dow Jones History for Each President, Feb. 16, 1885 to the Present</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Date </th>
   <th style="text-align:left;"> President </th>
   <th style="text-align:center;"> DJIA (Close) </th>
   <th style="text-align:center;"> DJIA (Close, Previous) </th>
   <th style="text-align:center;"> % Change </th>
   <th style="text-align:center;"> Rank Among All-Time Worst Days </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1987-10-19 </td>
   <td style="text-align:left;"> Ronald Reagan </td>
   <td style="text-align:center;"> 1738.74 </td>
   <td style="text-align:center;"> 2246.73 </td>
   <td style="text-align:center;"> -22.61 </td>
   <td style="text-align:center;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-16 </td>
   <td style="text-align:left;"> Donald J. Trump </td>
   <td style="text-align:center;"> 20188.52 </td>
   <td style="text-align:center;"> 23185.62 </td>
   <td style="text-align:center;"> -12.93 </td>
   <td style="text-align:center;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-10-28 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 260.64 </td>
   <td style="text-align:center;"> 298.97 </td>
   <td style="text-align:center;"> -12.82 </td>
   <td style="text-align:center;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1899-12-18 </td>
   <td style="text-align:left;"> William McKinley </td>
   <td style="text-align:center;"> 42.69 </td>
   <td style="text-align:center;"> 46.77 </td>
   <td style="text-align:center;"> -8.72 </td>
   <td style="text-align:center;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1895-12-20 </td>
   <td style="text-align:left;"> Grover Cleveland 2 </td>
   <td style="text-align:center;"> 29.42 </td>
   <td style="text-align:center;"> 32.16 </td>
   <td style="text-align:center;"> -8.51 </td>
   <td style="text-align:center;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1907-03-14 </td>
   <td style="text-align:left;"> Theodore Roosevelt </td>
   <td style="text-align:center;"> 55.84 </td>
   <td style="text-align:center;"> 60.89 </td>
   <td style="text-align:center;"> -8.29 </td>
   <td style="text-align:center;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008-10-15 </td>
   <td style="text-align:left;"> George W. Bush </td>
   <td style="text-align:center;"> 8577.91 </td>
   <td style="text-align:center;"> 9310.99 </td>
   <td style="text-align:center;"> -7.87 </td>
   <td style="text-align:center;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1933-07-21 </td>
   <td style="text-align:left;"> Franklin D. Roosevelt </td>
   <td style="text-align:center;"> 88.71 </td>
   <td style="text-align:center;"> 96.26 </td>
   <td style="text-align:center;"> -7.84 </td>
   <td style="text-align:center;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1917-02-01 </td>
   <td style="text-align:left;"> Woodrow Wilson </td>
   <td style="text-align:center;"> 88.52 </td>
   <td style="text-align:center;"> 95.43 </td>
   <td style="text-align:center;"> -7.24 </td>
   <td style="text-align:center;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1997-10-27 </td>
   <td style="text-align:left;"> Bill Clinton </td>
   <td style="text-align:center;"> 7161.20 </td>
   <td style="text-align:center;"> 7715.40 </td>
   <td style="text-align:center;"> -7.18 </td>
   <td style="text-align:center;"> 20 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1989-10-13 </td>
   <td style="text-align:left;"> George Bush </td>
   <td style="text-align:center;"> 2569.26 </td>
   <td style="text-align:center;"> 2759.84 </td>
   <td style="text-align:center;"> -6.91 </td>
   <td style="text-align:center;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1955-09-26 </td>
   <td style="text-align:left;"> Dwight Eisenhower </td>
   <td style="text-align:center;"> 455.56 </td>
   <td style="text-align:center;"> 487.45 </td>
   <td style="text-align:center;"> -6.54 </td>
   <td style="text-align:center;"> 34 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1962-05-28 </td>
   <td style="text-align:left;"> John F. Kennedy </td>
   <td style="text-align:center;"> 576.93 </td>
   <td style="text-align:center;"> 611.88 </td>
   <td style="text-align:center;"> -5.71 </td>
   <td style="text-align:center;"> 48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1946-09-03 </td>
   <td style="text-align:left;"> Harry S. Truman </td>
   <td style="text-align:center;"> 178.68 </td>
   <td style="text-align:center;"> 189.19 </td>
   <td style="text-align:center;"> -5.56 </td>
   <td style="text-align:center;"> 53 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011-08-08 </td>
   <td style="text-align:left;"> Barack Obama </td>
   <td style="text-align:center;"> 10809.85 </td>
   <td style="text-align:center;"> 11444.61 </td>
   <td style="text-align:center;"> -5.55 </td>
   <td style="text-align:center;"> 54 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1928-12-08 </td>
   <td style="text-align:left;"> Calvin Coolidge </td>
   <td style="text-align:center;"> 257.33 </td>
   <td style="text-align:center;"> 271.05 </td>
   <td style="text-align:center;"> -5.06 </td>
   <td style="text-align:center;"> 77 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1913-01-20 </td>
   <td style="text-align:left;"> William Howard Taft </td>
   <td style="text-align:center;"> 59.74 </td>
   <td style="text-align:center;"> 62.82 </td>
   <td style="text-align:center;"> -4.90 </td>
   <td style="text-align:center;"> 89 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1890-11-10 </td>
   <td style="text-align:left;"> Benjamin Harrison </td>
   <td style="text-align:center;"> 35.89 </td>
   <td style="text-align:center;"> 37.44 </td>
   <td style="text-align:center;"> -4.15 </td>
   <td style="text-align:center;"> 154 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1886-05-17 </td>
   <td style="text-align:left;"> Grover Cleveland 1 </td>
   <td style="text-align:center;"> 35.11 </td>
   <td style="text-align:center;"> 36.59 </td>
   <td style="text-align:center;"> -4.05 </td>
   <td style="text-align:center;"> 172 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1921-06-20 </td>
   <td style="text-align:left;"> Warren G. Harding </td>
   <td style="text-align:center;"> 64.90 </td>
   <td style="text-align:center;"> 67.57 </td>
   <td style="text-align:center;"> -3.95 </td>
   <td style="text-align:center;"> 186 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1974-11-18 </td>
   <td style="text-align:left;"> Gerald Ford </td>
   <td style="text-align:center;"> 624.92 </td>
   <td style="text-align:center;"> 647.61 </td>
   <td style="text-align:center;"> -3.50 </td>
   <td style="text-align:center;"> 265 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1973-11-26 </td>
   <td style="text-align:left;"> Richard Nixon </td>
   <td style="text-align:center;"> 824.95 </td>
   <td style="text-align:center;"> 854.00 </td>
   <td style="text-align:center;"> -3.40 </td>
   <td style="text-align:center;"> 283 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1979-10-09 </td>
   <td style="text-align:left;"> Jimmy Carter </td>
   <td style="text-align:center;"> 857.59 </td>
   <td style="text-align:center;"> 884.04 </td>
   <td style="text-align:center;"> -2.99 </td>
   <td style="text-align:center;"> 389 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1966-10-03 </td>
   <td style="text-align:left;"> Lyndon B. Johnson </td>
   <td style="text-align:center;"> 757.96 </td>
   <td style="text-align:center;"> 774.22 </td>
   <td style="text-align:center;"> -2.10 </td>
   <td style="text-align:center;"> 971 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1885-02-27 </td>
   <td style="text-align:left;"> Chester Arthur </td>
   <td style="text-align:center;"> 31.77 </td>
   <td style="text-align:center;"> 32.33 </td>
   <td style="text-align:center;"> -1.75 </td>
   <td style="text-align:center;"> 1438 </td>
  </tr>
</tbody>
</table>

One mild surprise here is Lyndon Johnson. Among all presidents through the history of the Dow Jones Industrial Average, Johnson had---for lack of better term---the "second-best worst" trading day in history. The worst trading day of his presidency came on October 3, 1966, a contraction of just over 2% from the previous day's close. His presidency was turbulent in more than a few ways and it's any wonder he didn't have a worse day.

### Update for March 27, 2020

You could also extend this approach to look at the worst 30-day trading windows to further contextualize what's happening now. All it takes is change the lagged variable (`l1_djia`) from 1 to 30 (i.e. `l30_djia = lag(djia, 30)`. This would create a 30-day rolling window, within presidential administrations, to calculate the worst 30-day slides from time point *t* to time point *t+30*. Here, for example, are the 10 worst rolling windows over a 30-day period.

<table id="stevetable">
<caption>The Ten Worst 30-Day Rolling Windows in Dow Jones History, Feb. 16, 1885 to the Present</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Date </th>
   <th style="text-align:left;"> President </th>
   <th style="text-align:center;"> DJIA (Close) </th>
   <th style="text-align:center;"> DJIA (Close, Previous) </th>
   <th style="text-align:center;"> % Change </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1929-11-13 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 198.69 </td>
   <td style="text-align:center;"> 329.95 </td>
   <td style="text-align:center;"> -39.78 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-11-12 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 209.74 </td>
   <td style="text-align:center;"> 344.50 </td>
   <td style="text-align:center;"> -39.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1931-10-05 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 86.48 </td>
   <td style="text-align:center;"> 140.78 </td>
   <td style="text-align:center;"> -38.57 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-23 </td>
   <td style="text-align:left;"> Donald J. Trump </td>
   <td style="text-align:center;"> 18591.93 </td>
   <td style="text-align:center;"> 29102.51 </td>
   <td style="text-align:center;"> -36.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-10-29 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 230.07 </td>
   <td style="text-align:center;"> 359.00 </td>
   <td style="text-align:center;"> -35.91 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-11-11 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 220.39 </td>
   <td style="text-align:center;"> 342.57 </td>
   <td style="text-align:center;"> -35.67 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-20 </td>
   <td style="text-align:left;"> Donald J. Trump </td>
   <td style="text-align:center;"> 19173.98 </td>
   <td style="text-align:center;"> 29379.77 </td>
   <td style="text-align:center;"> -34.74 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-11-18 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 227.56 </td>
   <td style="text-align:center;"> 345.72 </td>
   <td style="text-align:center;"> -34.18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1931-12-17 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 73.79 </td>
   <td style="text-align:center;"> 112.01 </td>
   <td style="text-align:center;"> -34.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1931-12-14 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 77.22 </td>
   <td style="text-align:center;"> 115.60 </td>
   <td style="text-align:center;"> -33.20 </td>
  </tr>
</tbody>
</table>



You can also drive the point home about how precarious our current situation is by flipping one line of script in the above R code that calculates the worst individual trading days in Dow Jones history. See the above code that reads? `arrange(percchange)`? Replace it with `arrange(-percchange)` to get the best individual days in Dow history. Here, we'll select the top 20.

<table id="stevetable">
<caption>The 20 Best Trading Days in Dow Jones History, Feb. 16, 1885 to the Present</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Date </th>
   <th style="text-align:left;"> President </th>
   <th style="text-align:center;"> DJIA (Close) </th>
   <th style="text-align:center;"> DJIA (Close, Previous) </th>
   <th style="text-align:center;"> % Change </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1931-10-06 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 99.34 </td>
   <td style="text-align:center;"> 86.48 </td>
   <td style="text-align:center;"> 14.87 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-10-30 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 258.47 </td>
   <td style="text-align:center;"> 230.07 </td>
   <td style="text-align:center;"> 12.34 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-24 </td>
   <td style="text-align:left;"> Donald J. Trump </td>
   <td style="text-align:center;"> 20704.91 </td>
   <td style="text-align:center;"> 18591.93 </td>
   <td style="text-align:center;"> 11.37 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1932-09-21 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 75.16 </td>
   <td style="text-align:center;"> 67.49 </td>
   <td style="text-align:center;"> 11.36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008-10-13 </td>
   <td style="text-align:left;"> George W. Bush </td>
   <td style="text-align:center;"> 9387.61 </td>
   <td style="text-align:center;"> 8451.19 </td>
   <td style="text-align:center;"> 11.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008-10-28 </td>
   <td style="text-align:left;"> George W. Bush </td>
   <td style="text-align:center;"> 9065.12 </td>
   <td style="text-align:center;"> 8175.77 </td>
   <td style="text-align:center;"> 10.88 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1987-10-21 </td>
   <td style="text-align:left;"> Ronald Reagan </td>
   <td style="text-align:center;"> 2027.85 </td>
   <td style="text-align:center;"> 1841.01 </td>
   <td style="text-align:center;"> 10.15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1932-08-03 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 58.22 </td>
   <td style="text-align:center;"> 53.16 </td>
   <td style="text-align:center;"> 9.52 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1932-02-11 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 78.60 </td>
   <td style="text-align:center;"> 71.80 </td>
   <td style="text-align:center;"> 9.47 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020-03-13 </td>
   <td style="text-align:left;"> Donald J. Trump </td>
   <td style="text-align:center;"> 23185.62 </td>
   <td style="text-align:center;"> 21200.62 </td>
   <td style="text-align:center;"> 9.36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1929-11-14 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 217.28 </td>
   <td style="text-align:center;"> 198.69 </td>
   <td style="text-align:center;"> 9.36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1931-12-18 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 80.69 </td>
   <td style="text-align:center;"> 73.79 </td>
   <td style="text-align:center;"> 9.35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1932-02-13 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 85.82 </td>
   <td style="text-align:center;"> 78.60 </td>
   <td style="text-align:center;"> 9.19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1932-05-06 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 59.01 </td>
   <td style="text-align:center;"> 54.10 </td>
   <td style="text-align:center;"> 9.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1933-04-19 </td>
   <td style="text-align:left;"> Franklin D. Roosevelt </td>
   <td style="text-align:center;"> 68.31 </td>
   <td style="text-align:center;"> 62.65 </td>
   <td style="text-align:center;"> 9.03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1931-10-08 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 105.79 </td>
   <td style="text-align:center;"> 97.32 </td>
   <td style="text-align:center;"> 8.70 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1932-06-10 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 48.94 </td>
   <td style="text-align:center;"> 45.32 </td>
   <td style="text-align:center;"> 7.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1939-09-05 </td>
   <td style="text-align:left;"> Franklin D. Roosevelt </td>
   <td style="text-align:center;"> 148.12 </td>
   <td style="text-align:center;"> 138.09 </td>
   <td style="text-align:center;"> 7.26 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1931-06-03 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 130.37 </td>
   <td style="text-align:center;"> 121.70 </td>
   <td style="text-align:center;"> 7.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1932-01-06 </td>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:center;"> 76.31 </td>
   <td style="text-align:center;"> 71.24 </td>
   <td style="text-align:center;"> 7.12 </td>
  </tr>
</tbody>
</table>

It's worth saying growth in trading is ideally supposed to be incremental over the long-run. Huge volatility in trading runs both ways, never seeming to coincide with something good on the balance.

### Update for March 28, 2020

You can also use these data to assess just how confident we should be in magnitude gains from Monday to Friday. For example, [multiple](https://www.barrons.com/articles/dow-jones-industrial-average-has-best-week-since-1938-time-to-go-shopping-for-stocks-51585354856) [outlets](https://www.forbes.com/sites/sergeiklebnikov/2020/03/27/stocks-have-best-week-since-1938-after-trump-signs-2-trillion-coronavirus-stimulus-bill/#6e69b2be5ae4) are claiming that this week is the best week for trading since 1938, notwithstanding the loss on Friday. Consider this summary from Barrons:

> After the index’s eighth losing Friday in nine weeks, the Dow ended the week up 2,462.80 points, or 12.84%, to 21,636.78—its best week since 1938. The S&P 500 index gained 10.26%, to 2,541.47, and the Nasdaq Composite rose 9.05%, to 7502.38.

Here's how you can assess that claim with some context (check [the file in the `_source` directory](https://github.com/svmiller/svmiller.github.io/blob/master/_source/2020-03-12-dow-jones-no-good-very-bad-day.Rmd) for full code).

<table id="stevetable">
<caption>The 10 Best Trading Weeks in Dow Jones History, Feb. 16, 1885 to the Present</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> President </th>
   <th style="text-align:left;"> Week Starting </th>
   <th style="text-align:center;"> DJIA (Start of the Week) </th>
   <th style="text-align:center;"> DJIA (Close, Last Day of the Week) </th>
   <th style="text-align:center;"> % Change </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:left;"> 1932-08-01 </td>
   <td style="text-align:center;"> 54.26 </td>
   <td style="text-align:center;"> 62.60 </td>
   <td style="text-align:center;"> 15.37 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Franklin D. Roosevelt </td>
   <td style="text-align:left;"> 1938-06-20 </td>
   <td style="text-align:center;"> 113.23 </td>
   <td style="text-align:center;"> 129.06 </td>
   <td style="text-align:center;"> 13.98 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Donald J. Trump </td>
   <td style="text-align:left;"> 2020-03-23 </td>
   <td style="text-align:center;"> 19173.98 </td>
   <td style="text-align:center;"> 21636.78 </td>
   <td style="text-align:center;"> 12.84 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Franklin D. Roosevelt </td>
   <td style="text-align:left;"> 1933-03-13 </td>
   <td style="text-align:center;"> 53.84 </td>
   <td style="text-align:center;"> 60.73 </td>
   <td style="text-align:center;"> 12.80 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:left;"> 1932-07-25 </td>
   <td style="text-align:center;"> 47.84 </td>
   <td style="text-align:center;"> 53.89 </td>
   <td style="text-align:center;"> 12.65 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Herbert Hoover </td>
   <td style="text-align:left;"> 1931-10-05 </td>
   <td style="text-align:center;"> 92.77 </td>
   <td style="text-align:center;"> 104.46 </td>
   <td style="text-align:center;"> 12.60 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gerald Ford </td>
   <td style="text-align:left;"> 1974-10-07 </td>
   <td style="text-align:center;"> 584.56 </td>
   <td style="text-align:center;"> 658.17 </td>
   <td style="text-align:center;"> 12.59 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Franklin D. Roosevelt </td>
   <td style="text-align:left;"> 1933-10-23 </td>
   <td style="text-align:center;"> 83.64 </td>
   <td style="text-align:center;"> 93.22 </td>
   <td style="text-align:center;"> 11.45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Theodore Roosevelt </td>
   <td style="text-align:left;"> 1903-08-10 </td>
   <td style="text-align:center;"> 34.71 </td>
   <td style="text-align:center;"> 38.68 </td>
   <td style="text-align:center;"> 11.44 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> George W. Bush </td>
   <td style="text-align:left;"> 2008-10-27 </td>
   <td style="text-align:center;"> 8378.95 </td>
   <td style="text-align:center;"> 9325.01 </td>
   <td style="text-align:center;"> 11.29 </td>
  </tr>
</tbody>
</table>

A recurring trend in these posts is that I'm skeptical that many of the boastful claims about the performance of the Dow Jones industrial average of late amount to wishful thinking absent any type of context of the other times the Dow Jones had great days or great weeks. It's akin to [Homer Simpson chasing his roast pig](https://www.youtube.com/watch?v=MWvevkE0kAI). "It's still good! It's still good!" Buddy, it might be gone.


