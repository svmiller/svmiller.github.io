---
title: "How Bad America's Gun Violence/Mass Shooting Problem Is, Automated with R Code"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
    pandoc_args: [ 
      "--ascii"
    ]
# knit: (function(inputFile, encoding) {
#   rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "steve"
date: '2019-08-03'
excerpt: "America's gun violence/mass shooting problem is bad. Conspicuously bad and it's getting worse despite obvious soluations for which there's no political will."
layout: post
categories:
  - R
  - Political Science
image: "gilroy-strong.jpg"
---

{% include image.html url=“/images/gilroy-strong.jpg” caption=“Artist
Ignacio ‘Nacho’ Moya carries a sign he made during a vigil for the
victims of the Gilroy Garlic Festival Shooting (Nhat V. Meyer/Bay Area
News Group)” width=400 align=“right” %}

*Last updated: August 03, 2019*

[Another day, another mass
shooting](https://www.cnn.com/2019/08/03/us/el-paso-shooting/index.html)
for literally the only country of its size and development where this
happens on a routine basis. This one in El Paso may (reportedly) have
some domestic terrorist overtones to it, but barring confirmation of the
shooter and the shooter’s motives for the moment, this post will focus
on just the mass shooting angle here.

Gun control emerged as a political and academic hobby horse of mine
largely because the problem strikes me as a massive and obvious public
health problem that has a fairly simple solution on paper. Cheap gun
supply—especially of weapons like AR-15s and AK-47s that have no
practical use for hobbyists, hunters, ranchers, or those with an earnest
interest in self-defense—decreases the transaction costs associated with
carrying out violent rampages (see:
[Wintemute, 2005](https://ucdavis.pure.elsevier.com/en/publications/guns-and-gun-violence)
and [Bartley and
Williams, 2018](https://events.iadb.org/events/handler/geteventdocument.ashx?AFCF784DCD0CBF43BE2C6862BF3344018A6A5CB902FA5578FDC3D0A580A830F93EB421FAAECD73D52562D8C42E362FA5853AE10D3E97D4160C156BD8B16088D305C031362E48EDD5)).
The quality of those assault rifles in particular also increase the
costs for first-responders, putting them at risk and delaying much
needed aid. This raises the societal costs for these “transactions”
carried out by perpetrators. Restricting gun supply should raise the
transaction costs associated with executing a violent rampage. Again,
it’s not hard. If you don’t believe that, then you don’t believe
people respond to economic incentives.

Obviously, there’s no political will here. [The public opinion is
there](http://svmiller.com/research/what-americans-really-think-about-gun-control/)
in support of most forms of gun control, even subtly aggressive forms of
gun control, but GOP voters are gradually adopting cues from GOP elites
on this topic. At the elite-level, the GOP relies on the National Rifle
Association—which wants cheap guns for purchase to the benefit of gun
manufacturers—to help [message “conservatism” to the voting
bloc](https://www.amazon.com/Guns-Democracy-Insurrectionist-Joshua-Horwitz/dp/0472033700)
and massage over other issues for GOP partisans (on fiscal policies, for
example). The National Rifle Association is well-funded and partisan
sorting has made them credible threats to primary GOP legislators who
don’t cooperate with them.

Alas, here we are: massive public health problem—*needless* public
health problem—fairly simple and straightforward policy proposals, and
no real (collective) will to do them. 🤷

Anywho, a few lines of R code will emphasize the scope of the problem.

First, United Nations Office on Drugs and Crime data (see:
[here](https://www.unodc.org/documents/data-and-analysis/statistics/Homicide/Homicides_by_firearms.xls))
will emphasize how the U.S. stands out among peer countries. I link to
the spreadsheet in this post. It’s an *ugly* spreadsheet that requires
some tidying and eye-balling things in LibreOffice for slicing, but it
can be done all the same. Do note: the data are mostly limited to
2009/2010 observations, not that it should meaningfully change the
takeaway here. The U.S. will conspicuously be an island among peer
countries (i.e. Canada, Australia, New Zealand, and Western/Northern
Europe) for its homicide by firearm rate.

``` r
readxl::read_xls("~/Dropbox/data/unodc/Homicides_by_firearms.xls",
                 skip = 5) %>%
  select(1:3, Variable, `1995`:`2010`) %>% slice(1:348) %>%
  rename(Country = `Country/Territory`) %>%
  fill(Region, Subregion, Country) %>%
  group_by(Region, Subregion, Country, Variable) %>%
  gather(year, value, `1995`:`2010`) %>%
  mutate(ccode = countrycode::countrycode(Country,"country.name","cown")) -> UNODC

UNODC %>% ungroup() %>%
  filter(ccode %in% c(2, 20, 200, 205, 210, 211, 212, 220, 230,
                      235, 255, 260, 305, 310, 316, 317, 325,
                      366, 367, 368, 900, 920)) %>%
  filter(Variable == "Homicide by firearm rate per 100,000 population") %>%
  arrange(Country, year) %>% 
  group_by(Country) %>%
  # These are advanced countries so most fills are coming from 2009 or so.
  fill(value) %>% 
  filter(year >= 2010) %>%
  # Meh, didn't want to have to do this.
  ungroup() %>%
  mutate(Country = ifelse(Country == "United States of America", "USA", Country),
         Country = ifelse(Country == "United Kingdom (Northern Ireland)", "Northern Ireland", Country),
         Country = ifelse(Country == "United Kingdom (England and Wales)", "England/Wales", Country),) %>%
  ggplot(.,aes(reorder(Country, -value), value)) +
  theme_steve_web() +
  geom_bar(stat="identity", alpha=0.6, color="black") +
  geom_text(aes(label=round(value, 2)), vjust=-.5, colour="black",
            position=position_dodge(.9), size=4, family="Open Sans") +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(x = "Country/Territory",
       y = "Homicide by Firearm Rate (per 100,000 population)",
       subtitle = "That's more than four times the next nearest peer country (Italy), which had a firearm mortality rate of .71 per 100,000 people.",
       caption = "Data: United Nations Office on Drugs and Crime. Note: data are limited to 2010 at the latest for convenience. Includes some fills from previous years.",
       title = "The U.S. (in 2010) Had a Homicide by Firearm Rate of 3.21 per 100,000 People")
```

![](/images/firearm-homicide-rate-data-usa-peer-countries-1.png)<!-- -->

Finally, you can start thinking about automating a script to scan [the
Mother Jones database on mass
shootings](https://www.motherjones.com/politics/2012/12/mass-shootings-mother-jones-full-data/)
to note how this problem is only getting worse. In subsequent updates, I
might try to fully automate this with built-in assessments of how much
worse the problem is getting.

Because it’s only getting worse.

``` r
library(gsheet)

mass_shootings = gsheet2tbl('https://docs.google.com/spreadsheets/d/1b9o6uDO18sLxBqPwl_Gh9bnhW-ev_dABH83M5Vb5L8o/htmlview?sle=true#gid=0')

mass_shootings %>%
  separate(date, c("month","day","year"), sep="/") %>%
  mutate(date = lubridate::as_date(paste0(year,"-",month,"-", day))) %>%
  select(case, date, everything()) %>%
  mutate(year = lubridate::year(date)) %>%
  group_by(year) %>%
  summarize(n = n()) %>% 
  ggplot(.,aes(year, n)) +
  theme_steve_web() +
  geom_bar(stat="identity", alpha=0.4, fill="#619cff",color="black") +
  scale_x_continuous(breaks = seq(1980, 2020, by = 4)) +
  geom_text(aes(label=n), vjust=-.5, colour="black",
            position=position_dodge(.9), size=4, family="Open Sans") +
  labs(y = "Number of Mass Shootings in a Calendar Year",
       x = "Year",
       title = paste0("The Number of Mass Shootings by Year, 1982-Present (", format(Sys.time(), '%B %d, %Y'), ")"),
       subtitle = "There were 31 mass shootings from 1982-1999. There've been 28---29, including El Paso---in the past 2.5 years.",
       caption = "Data: Mother Jones. Methodology: pretty sure these are shooting incidents in which at least three people died. Earlier classifications of mass shootings counted four or more casualties, if I recall correctly.")
```

![](/images/us-mass-shootings-by-year-1982-present-mother-jones-1.png)<!-- -->
