---
layout: page
title: "Clean USAID Greenbook Data"
permalink: /miscellany/clean-usaid-greenbook-data/
---

{% include image.html url="/images/usaid-logo.jpeg" caption="USAID: From the American People." width=900 align="center" %}

This R code processes [Greenbook data provided by the United States Agency for International Development][1] (USAID), correcting for various errors and omissions along the way. You can download this code here: [1-clean-greenbook.R][2].

Here is a summary of what this code will do:

  * Summarizes all economic aid programs from 1946 to 2011, collapsing the summary into one output for each recipient country in a given year.
  * Adds the 1976 transitional quarter to the 1976 fiscal year commitment. The United States government changed its fiscal calendar in 1976, creating this transitional quarter.
  * Converts the data from wide to long, creating time series cross-sectional data amenable to analysis in programs like Stata.
  * Eliminates financial aid commitments to regions and other non-states.
  * Syncs USAID commitments with [COW state system membership][3]. 
      * As a judgment call, West Germany and Germany are coded as 260 for the entirety of this temporal domain. This allows the resulting data to speak better with [Gleditsch-Ward country numbers][4]. Though a judgment call, it follows because the data are left-bound at 1946. This treatment assumes (reasonably) that West Germany absorbed East Germany in 1990, rather than West Germany and East Germany unifying in 1990 to recreate the German state that existed prior to the conclusion of World War II.
      * The data also account for Yemeni unification and the short-lived United Arab Republic. During the United Arab Republic period (1958-1961), Syria's aid commitments are added to Egypt's and Syria drops from the sample for 1959 and 1960.
  * Accounts for problems of strategic selection of recipients by accounting for states like Czechoslovakia and East Germany, that were eligible for aid but never received it.
  * Corrects misleading figures from USAID data about what state is actually receiving aid. For example, Vietnam's aid commitments from 1954 to 1975 were afforded to South Vietnam. A similar treatment is considered and applied to China and Taiwan before the creation of Taiwan as state system member.

This script creates the following files:

  * **useconaidtotal.csv**: This is a wide-form data frame with just the summary of total economic aid commitments to a country in a given year. This does *not* account for issues of COW state system membership.
  * **useconaid.csv:** This is a long-form data frame of country-year economic aid data for recipients of U.S. foreign aid.
  * **usmilitaid.csv:** This is a long-form data frame of country-year military aid data for recipients of U.S. foreign aid.
  * **ustotalaid.csv:** This is a long-form data frame of country-year economic and military aid data for recipients of U.S. foreign aid. It also includes natural logs of these commitments. 
      * The natural logs account for negative values (i.e. repayments) in Greenbook data in multiple ways. Following [Baccini and Urpelainen (2012)][5], the log of negative values are coded as the natural log of the absolute value, which is multiplied by -1 thereafter. In addition, two other columns are created which treats negative values as missing.

**Assumptions:**

  * Since Greenbook's latest versions have been in \*.xls files, I encourage separating the actual data from the Excel spreadsheets and dumping it into its own \*.csv file. There are ways to read Excel data into R, but they're not user-friendly.
  * The user is responsible for setting the working directory and accounting for the exact name of the *.csv files read into R.

 [1]: http://gbk.eads.usaidallnet.gov/
 [2]: https://github.com/svmiller/clean-greenbook
 [3]: http://www.correlatesofwar.org/COW2%20Data/SystemMembership/2011/System2011.html
 [4]: http://privatewww.essex.ac.uk/~ksg/statelist.html
 [5]: http://journals.cambridge.org/action/displayAbstract?fromPage=online&aid=8711929

