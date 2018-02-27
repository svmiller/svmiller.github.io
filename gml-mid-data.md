---
layout: page
title: "Gibler-Miller-Little (GML) MID Data"
permalink: /gml-mid-data/
---

{% include image.html url="/images/agadir-crop.jpg" caption="The SMS Berlin arrives to fortify the Germans' position in Agadir in July 1911 (i.e. MID#0315)" width=350 align="right" %}

This page contains links to download non-directed/directed dyad-year militarized interstate dispute (MID) data derived from Gibler, Miller and Little's project published in *International Studies Quarterly*.

![Version 2.02](https://img.shields.io/badge/release-v2.02-blue.svg)

## Overview

Version 2 of the [Gibler](http://dmgibler.people.ua.edu/)-[Miller](http://svmiller.com)-[Little](https://www.erinklittle.com/) MID data forks version 4.01 of [the Correlates of War MID data](http://correlatesofwar.org/data-sets/MIDs) and provides changes to more than 72% of the original data to better conform to CoW's own coding rules. 

We suggest removing 373 MIDs (almost 15% of the dispute data) for not meeting CoW's criteria for inclusion in the MID data. These include disputes for which there were no codable militarized incidents, disputes that should be merged into other MIDs given overlap in the issue, time period, and actors involved, and 19 MIDs for which no available source documentation could corroborate the original coding. 

We also provide some substantively major changes to the data, including start and end years, dispute outcomes and settlements, fatalities, hostility levels, dispute-level reciprocation and to the identity and number of participants in a dispute. These major changes affect another 34% of the data. We also document more minor changes in a substantial portion of the data.

Our article in *International Studies Quarterly* shows that correcting these errors in the CoW-MID data have important implications for several influential studies in international conflict.

## Citation

We ask that those who use the data include the following citation in the bibliographies of these data:

> Gibler, Douglas M., Steven V. Miller, and Erin K. Little. 2016. "[An Analysis of the Militarized
Interstate Dispute (MID) Dataset, 1816–2001](https://academic.oup.com/isq/article-abstract/60/4/719/2918882/An-Analysis-of-the-Militarized-Interstate-Dispute?redirectedFrom=fulltext)." *International Studies Quarterly* 60(4): 719-730.

## Questions and Feedback

Please contact me (svmille@clemson.edu) with any inquiries about the script and the data it produces. Please contact Doug Gibler (dmgibler@ua.edu) with any inquiries about the overall re-evaluation and extension of the MID project.

## Data and Documentation

- [**Version 2.02**](http://bit.ly/gml_mid_202)

Contents of this zip file include:

- `gml-mida-[version].csv`: dispute-level GML MID data, forked from CoW's version 4.01.
- `gml-midb-[version].csv`: participant-level GML MID data, forked from CoW's version 4.01.
- `gml-ddy-disputes-[version].csv`: directed dispute-year GML MID data.
- `gml-ndy-disputes-[version].csv`: nondirected dispute-year GML data.
- `gml-ddy-[version].csv`:  Full directed dyad-year data for use in standard time-series cross-section models for MID onset. This data frame contains no duplicate observations for dyad-years.[^whittling] This data set includes all possible dyads no matter the dyad's [political relevance](http://journals.sagepub.com/doi/abs/10.1177/002200277602000302) or [activity](https://www.tandfonline.com/doi/abs/10.1080/07388940500503804). The user is free to employ case-exclusion rules of her/his choice.
- `gml-ndy-[version].csv`: Full *non*directed dyad-year data. See item above.

[^whittling]: Consider the case of France and Italy in 1860, which had three separate MID onsets that year (MID#0112, MID#0113, MID#0306), as illustrative of the problem. This data set employs the following rules to whittle down these duplicate dispute-year observations, first selecting on MID onsets, then selecting highest fatality level, highest hostility level, longest mindur, and finally, in the event of duplicates still outstanding, selecting the MID that came first. 

We refer the reader to CoW's own documentation about coding militarized incidents and aggregating militarized incidents to MIDs. Our project generated multiple supporting documents about these corrections to the data.

- [Bibliography Report](http://dmgibler.people.ua.edu/uploads/1/3/8/5/13858910/bibliography-report.pdf): A list of sources we used for each MID in the data.
- [Change Report](http://dmgibler.people.ua.edu/uploads/1/3/8/5/13858910/change-report.pdf): A report on recommendations to change MIDs.
- [Could-Not-Find Report](http://dmgibler.people.ua.edu/uploads/1/3/8/5/13858910/could-not-find-report.pdf): A report on MIDs in the CoW-MID data that could not be replicated.
- [Changes in the MID Data from MID 3.10 to MID 4 and to MID 4.01](http://dmgibler.people.ua.edu/uploads/1/3/8/5/13858910/mid310-4-401-changes.pdf): Our evaluation of changes in the MID data from MID 3.10 to MID 4, and from MID 4 to MID 4.01.
- [Drop Report](http://dmgibler.people.ua.edu/uploads/1/3/8/5/13858910/drop-report.pdf): A report on MIDs that we removed for not meeting CoW's own criteria for inclusion in the data set.
- [Merge Report](http://dmgibler.people.ua.edu/uploads/1/3/8/5/13858910/merge-report.pdf): A report on MIDs that overlapped other MIDs in the data in issue, location, and time.