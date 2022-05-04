---
title: "The Political Ideology of Terrorism in the United States: The 1970s"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
author: "steve"
date: '2019-08-09'
excerpt: "This is the first of what may be a series of exploratory analyses of the political ideology of terrorism in the U.S. Here, I start with the 1970s."
layout: post
categories:
  - Political Science
image: "weather-underground-day-of-rage.jpg"
---






{% include image.html url="/images/weather-underground-day-of-rage.jpg" caption="John Jacobs (l) and Terry Robbins (r) at the Days of Rage, Chicago, October 1969. Their group, the Weathermen, were a conspicuous domestic terrorism problem in the early 1970s. (Photo: David Fenton, ITV)" width=400 align="right" %}

The past few years have emphasized a growing domestic terrorism problem in the United States, especially on the political right. Cesar Sayoc [sent upwards of 18 pipe bombs](https://en.wikipedia.org/wiki/October_2018_United_States_mail_bombing_attempts) to prominent Democrats (e.g. Barack Obama, Joe Biden, Hillary Clinton), purported "enemies of the state" or "deep state" public officials who have drawn Trump's ire (e.g. James Clapper and John O. Brennan) and left-of-center elites who were fodder for right-wing talking points (George Soros, naturally). Robert Dear [shot up a Planned Parenthood clinic](https://en.wikipedia.org/wiki/Colorado_Springs_Planned_Parenthood_shooting) in Colorado Springs as a form of anti-abortion protest. Dylann Roof [murdered nine church-goers](https://en.wikipedia.org/wiki/Charleston_church_shooting) in Charleston, South Carolina in what was clearly a white supremacist attack on a black church. There have been prominent anti-Jewish terror attacks I can recall from the top of my head, one [in 2014 in Kansas](https://en.wikipedia.org/wiki/Overland_Park_Jewish_Community_Center_shooting) and another [at a synagogue in Pittsburgh last year](https://en.wikipedia.org/wiki/Pittsburgh_synagogue_shooting). Most recently, a white supremacist [traveled from Allen, Texas to El Paso](https://en.wikipedia.org/wiki/2019_El_Paso_shooting) to massacre as many Hispanics as he could at a local Walmart, articulating a manifesto/hoax that Hispanics were "replacing" non-Hispanic whites in the United States. I could articulate more terror attacks recently if I chose.

It's important for a variety of reasons to uncover the ideological motivations of domestic terrorism, certainly in the United States. For one, it's [seemingly uncomfortable for Americans to define "terrorism"](https://onlinelibrary.wiley.com/doi/full/10.1111/ajps.12329), perhaps unless an act were committed by a jihadist. This is one-part post-9/11 trauma and one-part "Othering" and inflating minority threats; Muslims are [only 1% of the U.S. population](https://www.pewresearch.org/fact-tank/2018/01/03/new-estimates-show-u-s-muslim-population-continues-to-grow/) but people have [a bad habit of exaggerating the extent of a perceived threat](https://www.nbcnews.com/news/us-news/most-americans-overestimate-muslim-population-17x-poll-shows-n696071). Further, Islamic extremists have no monopoly on terrorism here or anywhere. There's an added difficulty, seemingly for the media and certainly for a certain set of lawmakers, to identify and condemn acts of terrorism coming from one side of the spectrum. Let the current moment show, and let the case of "The Troubles" further underscore, that one man's domestic terrorist is another political party's [loyal partisan](https://twitter.com/MatthewKeysLive/status/1159586743793811456) and [paramilitary](https://www.splcenter.org/hatewatch/2019/07/31/militias-capitalizing-gop-rhetoric-heading-election-season).

I thought it might illustrate the heterogeneity of domestic terrorism in the United States over time to explore the [Global Terrorism Database (GTD)](https://www.start.umd.edu/gtd/) on terror incidents and combine it with [an auxiliary data set](https://www.start.umd.edu/news/proportion-terrorist-attacks-religious-and-right-wing-extremists-rise-united-states) on the political motivations of these attacks. The GTD data go from 1970 to 2017 though the auxiliary data set on ideological motivations includes coverage only through 2016. Briefly, the ideological motivations data has categories for whether the terrorist incident was perpretrated by 1) environmentalists, 2) left-wing extremists, 3) right-wing extremists (subcategories: [sovereign citizen motivations](https://en.wikipedia.org/wiki/Sovereign_citizen_movement), anti-government motivations), 4) nationalist/separatist groups, 5) religious groups (subcategories: Christian, Jewish, Islamic [Sunni/Shia]), and 6) single-issue groups (e.g. anti-abortion extremists). Categories are not mutually exclusive either. Groups like the Black Panthers have both left-wing and nationalist components whereas the Ku Klux Klan articulates both a right-wing manifesto and has religious themes as well. 

My analysis will be structured by decade and paint with a broad brush in the process. Code for replication is available [on my Github](https://github.com/svmiller/svmiller.github.io/tree/master/_source). I'll start chronologically with the peak terrorism decade on record: the 1970s. I hope to make it a series of blog posts by decade after this one.

## The 1970s: The Peak of Post-WWII Domestic Terrorism in the United States

The 1970s were a lost decade for the United States. Without trivializing what "lost decade" means for other countries, the decade for the United States is best characterized by the ["Nixon shock"](https://en.wikipedia.org/wiki/Nixon_shock) that effectively ended the Bretton Woods system that underpinned the U.S. post-war growth, subsequent [oil crises](https://en.wikipedia.org/wiki/1973_oil_crisis) and [stagflation](https://www.investopedia.com/articles/economics/08/1970-stagflation.asp) episodes that further hindered growth and wealth for an entire generation, the mounting costs of the Vietnam War that siphoned important government resources, and [the peak of crime rates](https://flashbak.com/alarmed-and-dangerous-a-look-at-crime-in-1970s-80s-america-25282/) emerging at the same time. Domestic terrorism soared concurrent to these, and certainly alongside the crime problem. The available data do not pick up observations from the 1960s, but the political themes of that decade---civil rights, anti-war protests---carried into the 1970s as well.

<!-- It was that  One thing worth reiterating out loud, and up front, is that the worst period for domestic terrorism in the United States was the first one in the data. The 1970s had a slew of terrorist incidents that had not been seen in decades since, which also clusters on the notoriety of [the 1970s as a high-crime decade](https://flashbak.com/alarmed-and-dangerous-a-look-at-crime-in-1970s-80s-america-25282/). -->

Motivation-wise, left-wing extremists were clearly the focal point of the problem. There were almost 800 terror attacks in the decade perpetrated by people or groups with left-wing motivations. The overlap between left-wing terrorism and nationalist-separatist terrorism---the second biggest category---was non-trivial as well, which further accentuates the nature of terrorism that decade.

<table id="stevetable">
<caption>The Number of Terror Attacks by Motivation in the 1970s</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Motivation </th>
   <th style="text-align:center;"> Number of Terror Attacks </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Left-Wing </td>
   <td style="text-align:center;"> 781 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nationalist-Separatist </td>
   <td style="text-align:center;"> 451 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Right-Wing </td>
   <td style="text-align:center;"> 163 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Single Issue </td>
   <td style="text-align:center;"> 158 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Religious </td>
   <td style="text-align:center;"> 118 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Environmental </td>
   <td style="text-align:center;"> 2 </td>
  </tr>
</tbody>
</table>



The motivations behind these terror attacks focus on salient topics for the political left at the time. A simple `grep` search of the summaries of these incidents in the 1970s reveals **42** incidents with 1) left-wing motivations involving 2) summaries including "vietnam" or "war." There were **147** incidents with 1) left-wing motivations perpetrated by people that GTD categorized as "black (nationalists OR panthers OR afro militant movement OR liberation army OR revolutionary assault team)". This is just illustrative for now of the exact motivations behind these terror attacks during the decade, absent some other more advanced topic modeling of the `summary` column in the GTD data. However, any summary assessment of domestic terrorism in the United States during this decade will note that most of it is left-wing the extent to which it was trying to advance causes that the political left was struggling to accomplish through other means (e.g. withdrawal from the Vietnam War). Indeed, the 147 terror incidents by left-wing actors committed by "black (nationalists OR panthers OR afro militant movement OR liberation army OR revolutionary assault team)" are just 16 incidents fewer than the total number of incidents committed by right-wing actors that decade. Again, this is illustrative, and not exhaustive, but it accentuates the nature of terrorism in the 1970s.


The following table will provide some estimates of the societal costs---the number killed, wounded, the total number of caualties (i.e. killed + wounded), and the extent of property damage---of terror attacks carried out by extremists of these different motivations. For what it's worth, I mimic some of my coding in [my *Political Research Quarterly* article](http://svmiller.com/research/effect-terrorism-judicial-confidence/) that also uses this data, which also coincides with some of the coding decisions employed by the [Global Terrorism Index](http://visionofhumanity.org/indexes/terrorism-index/). Namely, if the number of people killed or wounded in a terror incident is missing, I impute a 1. In other words, the GTD coders had reason to believe there were casualties in a terror incident but do not have an estimate of the full number. Thus, I impute a conservative value of 1. Importantly, the property damage extimate should be treated with caution. I reverse-code an ordinal measure (`propextent` in the GTD data) that is, here, 0 if the terror attack had no property damage, 1 if the terror attack likely had minor damage (i.e. under $1 million USD in damage), 2 if the terror attack likely had major damage (i.e. between $1 million and $1 billion), and 3 if the terror attack had catastrophic property damange (i.e. likely over $1 billion). I'm pretty sure the dollar amount estimates are nominal as well. In other words, don't treat this measure as communicating precise information. It's a simple sum of a crude ordinal measure.

<table id="stevetable">
<caption>The Number of Terror Attacks by Motivation in the 1970s</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Motivation </th>
   <th style="text-align:center;"> Total Incidents </th>
   <th style="text-align:center;"> Total Killed </th>
   <th style="text-align:center;"> Total Wounded </th>
   <th style="text-align:center;"> Total Casualties </th>
   <th style="text-align:center;"> Total Property Damage Estimate </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Environmental </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Left-Wing </td>
   <td style="text-align:center;"> 781 </td>
   <td style="text-align:center;"> 112 </td>
   <td style="text-align:center;"> 309 </td>
   <td style="text-align:center;"> 421 </td>
   <td style="text-align:center;"> 477 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nationalist-Separatist </td>
   <td style="text-align:center;"> 451 </td>
   <td style="text-align:center;"> 81 </td>
   <td style="text-align:center;"> 298 </td>
   <td style="text-align:center;"> 379 </td>
   <td style="text-align:center;"> 263 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Religious </td>
   <td style="text-align:center;"> 118 </td>
   <td style="text-align:center;"> 43 </td>
   <td style="text-align:center;"> 57 </td>
   <td style="text-align:center;"> 100 </td>
   <td style="text-align:center;"> 42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Right-Wing </td>
   <td style="text-align:center;"> 163 </td>
   <td style="text-align:center;"> 26 </td>
   <td style="text-align:center;"> 87 </td>
   <td style="text-align:center;"> 113 </td>
   <td style="text-align:center;"> 83 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Single Issue </td>
   <td style="text-align:center;"> 158 </td>
   <td style="text-align:center;"> 14 </td>
   <td style="text-align:center;"> 84 </td>
   <td style="text-align:center;"> 98 </td>
   <td style="text-align:center;"> 80 </td>
  </tr>
</tbody>
</table>

It should be unsurprising that estimates of societal costs track closely with the number of incidents. Left-wing extremists carried out the most incidents and imposed the most costs on society in the process. There is some minor intrigue that religious extremists carried out 118 incidents, resulting in 100 casualties, but the estimate of property damage seems lower than what one would expect looking at similar casualty counts for terror attacks carried out by right-wing extremists or single-issue extremists. 

For what it's worth, environmentalists were reportedly responsible for just two terrorist incidents in the 1970s, resulting in no casualties or property damage, and are excluded from subsequent analyses for the decade. Both terror incidents were apparently committed by the [Environmental Life Force](https://en.wikipedia.org/wiki/Environmental_Life_Force), which are also included in the left-wing category.

There wasn't a whole lot of variation of attack types by ideological motivations. Namely, bombing/explosions were the method du jour for most of these groups. Certainly, bombings are the first things that come to my mind thinking of left-wing terror attacks in the 1970s (e.g. [Sterling Hall bombing (1970)](https://en.wikipedia.org/wiki/Sterling_Hall_bombing), [Pentagon bombing (1972)](https://en.wikipedia.org/wiki/Weather_Underground#Pentagon_bombing)). There is some variation by motivation, but it looks minor. It should perhaps be unsurprising that the distribution of nationalist-separatist attack types looks similar to the distribution of left-wing attack types because the overlap in those groups is quite large (more on that later). Right-wing extremists favored armed assaults and facility attacks more than their left-wing counterparts. Single-issue extremists were disproportionately inclined toward bombings/explosions. Recall that single-issue extremism can assume any form for any issue and any issue position. Thus, while anti-abortion extremists of the decade were more drawn to facility/infrastructure attacks, [Omega-7](https://en.wikipedia.org/wiki/Omega_7), a single-issue group dedicated to overthrowing Castro in Cuba, was almost exclusively a bombing/explosion outfit (26 of 29 attacks, with three other assassination incidents). In addition, religious extremists in the 1970s showed a greater affinity toward armed assaults than did other kinds of extremists, a finding partially influenced by Muslim terrorism of that decade (more on that later).

![plot of chunk attack-type-terrorism-1970s](/images/us-terrorism-ideology-analysis-1970s/attack-type-terrorism-1970s-1.png)

A look at the perpetrators for these incidents will offer some insight to who these actors were and what were the political causes motivating terrorism in the 1970s. The following table lists the top 10 perpetrators of terrorist incidents by one of the five motivations (omitting the two environmentalist incidents, which are already subsumed in the left-wing category). Do note that the motivations are not necessarily mutually exclusive and so some groups appear in multiple columns.

<table id="stevetable" class="table" style="font-size: 12px; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">The Number of Terror Attacks by Motivation and Group Name in the 1970s</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Left-Wing Group </th>
   <th style="text-align:center;"> N </th>
   <th style="text-align:left;"> Nationalist-Separatist Group </th>
   <th style="text-align:center;"> N </th>
   <th style="text-align:left;"> Religious Group </th>
   <th style="text-align:center;"> N </th>
   <th style="text-align:left;"> Right-Wing Group </th>
   <th style="text-align:center;"> N </th>
   <th style="text-align:left;"> Single-Issue Group </th>
   <th style="text-align:center;"> N </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Left-Wing Militants </td>
   <td style="text-align:center;"> 169 </td>
   <td style="text-align:left;"> Fuerzas Armadas de Liberacion Nacional (FALN) </td>
   <td style="text-align:center;"> 107 </td>
   <td style="text-align:left;"> Jewish Defense League (JDL) </td>
   <td style="text-align:center;"> 44 </td>
   <td style="text-align:left;"> White extremists </td>
   <td style="text-align:center;"> 52 </td>
   <td style="text-align:left;"> Omega-7 </td>
   <td style="text-align:center;"> 29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fuerzas Armadas de Liberacion Nacional (FALN) </td>
   <td style="text-align:center;"> 106 </td>
   <td style="text-align:left;"> Black Nationalists </td>
   <td style="text-align:center;"> 82 </td>
   <td style="text-align:left;"> Zebra killers </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:left;"> Jewish Defense League (JDL) </td>
   <td style="text-align:center;"> 44 </td>
   <td style="text-align:left;"> Strikers </td>
   <td style="text-align:center;"> 23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New World Liberation Front (NWLF) </td>
   <td style="text-align:center;"> 86 </td>
   <td style="text-align:left;"> Jewish Defense League (JDL) </td>
   <td style="text-align:center;"> 44 </td>
   <td style="text-align:left;"> Jewish Armed Resistance </td>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:left;"> Jewish Armed Resistance </td>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:left;"> Cuban Action </td>
   <td style="text-align:center;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Black Nationalists </td>
   <td style="text-align:center;"> 82 </td>
   <td style="text-align:left;"> Chicano Liberation Front </td>
   <td style="text-align:center;"> 31 </td>
   <td style="text-align:left;"> Ku Klux Klan </td>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:left;"> Cuban Action </td>
   <td style="text-align:center;"> 12 </td>
   <td style="text-align:left;"> National Front for the Liberation of Cuba (FLNC) </td>
   <td style="text-align:center;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Weather Underground, Weathermen </td>
   <td style="text-align:center;"> 45 </td>
   <td style="text-align:left;"> Armed Revolutionary Independence Movement (MIRA) </td>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:left;"> Black Muslims </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:left;"> Ku Klux Klan </td>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:left;"> Anti-Abortion extremists </td>
   <td style="text-align:center;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Black Liberation Army </td>
   <td style="text-align:center;"> 34 </td>
   <td style="text-align:left;"> Puerto Rican Nationalists </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:left;"> International Committee Against Nazism </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:left;"> International Committee Against Nazism </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:left;"> Cuban Exiles </td>
   <td style="text-align:center;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chicano Liberation Front </td>
   <td style="text-align:center;"> 31 </td>
   <td style="text-align:left;"> Independent Armed Revolutionary Commandos (CRIA) </td>
   <td style="text-align:center;"> 19 </td>
   <td style="text-align:left;"> New Jewish Defense League </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> New Jewish Defense League </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> Luis Boitel Commandos </td>
   <td style="text-align:center;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Armed Revolutionary Independence Movement (MIRA) </td>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:left;"> Jewish Armed Resistance </td>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:left;"> Hanafi Muslims </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Jewish Committee of Concern </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Secret Cuban Government </td>
   <td style="text-align:center;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Black Panthers </td>
   <td style="text-align:center;"> 24 </td>
   <td style="text-align:left;"> Armed Commandos of Liberation </td>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:left;"> Jewish Committee of Concern </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Neo-Nazi extremists </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Fred Hampton Unit of the People's Forces </td>
   <td style="text-align:center;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> George Jackson Brigade </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:left;"> Revolutionary Commandos of the People (CRP) </td>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:left;"> Jewish Extremists </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Otpor </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Latin America Anti-Communist Army (LAACA) </td>
   <td style="text-align:center;"> 4 </td>
  </tr>
</tbody>
</table>

Recall that not every perpetrator is necessarily part of a group even as individual perpetrators and groups may share near identical motivations. For example, Christopher Brian Cowsar went to an Air Force recruiting station in Berkeley and stabbed an Air Force sergeant to death [on April 29, 1971](https://cdnc.ucr.edu/?a=d&d=DS19710501.2.14&e=-------en--20--1--txt-txIN--------1). During the incident, Cowsar screamed "he's sending people to Vietnam. He's got to die." Likewise, another incident perpetrated by the Weathermen---the Pentagon bombing on May 19, 1972---was [explicit retaliation for a bombing campaign in Hanoi](https://timeline.com/weather-underground-smash-monogamy-b109c96597ff?gi=d8efb171ba94) during the Vietnam War. The former was an attack perpetrated by a lone individual, categorized by the GTD as a "left-wing militant." The other was done by the Weathermen (aka Weather Underground), which was responsible for 45 total incidents in the decade.


{% include image.html url="/images/1975-fraunces-tavern-bombing.jpg" caption="Four people were killed and dozens were injured in the deadliest incident perpetrated by FALN. (Anonymous/ASSOCIATED PRESS)" width=400 align="right" %}

Elsewhere, [Fuerzas Armadas de Liberación Nacional](https://en.wikipedia.org/wiki/Fuerzas_Armadas_de_Liberaci%C3%B3n_Nacional_Puertorrique%C3%B1a) (FALN) immediately stands out as the No. 1 *group* for both left-wing terrorism (i.e. omitting individual extremists) and nationalist-separatist terrorism in the decade. Any casual reader of my website who is not versed in the academic study of terrorism might be surprised to learn that Puerto Rican separatism was a major problem in the 1960s and the 1970s. FALN, in particular, sought independence for Puerto Rico and to transform the island's government into a Marxist-Leninist state. It perpetrated 107 incidents in the 1970s---one of the incidents did not appear to communicate left-wing motivations, hence the small discrepancy. FALN particularly favored bombing campaigns---only six of its 107 terror attacks were anything other than bombing campaigns---and is perhaps best known for its January 24, 1975 bombing of the [Fraunces Tavern](https://en.wikipedia.org/wiki/Fraunces_Tavern) in New York City. That incident killed four people and wounded 53 others.

Six of the 10 groups in the religious extremist category are Jewish groups. The [Jewish Defense League](https://www.splcenter.org/fighting-hate/extremist-files/group/jewish-defense-league) (JDL) led all religious groups with 44 incidents in the 1970s. The Jewish extremist groups listed in this top ten---JDL, Jewish Armed Resistance, International Committee Against Nazism (ICAN), New JDL,  Jewish Committee of Concern, and the catch-all "Jewish Extremists"---all carried some unique motivations. For example, the JDL preached a violent form of Jewish and anti-Arab nationalism and carried out terror attacks that largely targeted foreign diplomats (in addition to Muslims) to coerce more support for Israel. ICAN, by contrast, was more interested in [targeting neo-Nazis](https://www.jta.org/1979/06/07/archive/anti-nazi-group-denies-it-is-sending-parcel-bombs-to-nazis).

Some digging through the characteristics of religious motivation, by faith, will show that Jewish extremists are responsible for almost 67% of all religiously-motivated terrorism in the decade, and are easily responsible for most of the property damage done by those attacks. However, Islamic terrorism, which conspicuously relied more on armed assaults than other attack types, claimed more lives despite accounting for just under 24% of all incidents. Two things stand out from the Islamic terrorism of the decade. First, the deadliest individual incident was [the 1973 Hanafi Muslim massacre](https://en.wikipedia.org/wiki/1973_Hanafi_Muslim_massacre) in which suspected Black Muslims murdered seven people, targeting [Hamaas Abdul Khaalis](https://en.wikipedia.org/wiki/Hamaas_Abdul_Khaalis) in particular for his criticism of [Elijah Muhammad](https://en.wikipedia.org/wiki/Elijah_Muhammad). Second, the most incidents of Islamic terrorism were committed as part of [the "Zebra murders" in San Francisco](https://en.wikipedia.org/wiki/Zebra_murders). Those incidents make for an interesting read by themselves.

<table id="stevetable">
<caption>The Characteristics of Religious Terrorism by Faith in the 1970s</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Motivation </th>
   <th style="text-align:center;"> Total Incidents </th>
   <th style="text-align:center;"> Total Killed </th>
   <th style="text-align:center;"> Total Wounded </th>
   <th style="text-align:center;"> Total Casualties </th>
   <th style="text-align:center;"> Total Property Damage Estimate </th>
   <th style="text-align:left;"> Preferred Method </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Christian </td>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 22 </td>
   <td style="text-align:center;"> 28 </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:left;"> Bombing/Explosion (36%) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Islamic </td>
   <td style="text-align:center;"> 28 </td>
   <td style="text-align:center;"> 34 </td>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:center;"> 47 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:left;"> Armed Assault (67%) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Jewish </td>
   <td style="text-align:center;"> 79 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 22 </td>
   <td style="text-align:center;"> 25 </td>
   <td style="text-align:center;"> 37 </td>
   <td style="text-align:left;"> Bombing/Explosion (50%) </td>
  </tr>
</tbody>
</table>

### Wrapping Up

The 1970s were the most notorious decade for terrorism after the 1970s, but it's important to note the worst stretches of terrorism were early in the decade. The 468 incidents in 1970s is easily the most in any given year. The combined 715 incidents in 1970 and 1971 are over 25% of the entire data set from 1970 to 2017. Drops in terrorism were discernible after those first two years. In 1979, the U.S. had just 69 total terror incidents, an 85% drop from the first year of the decade.

![plot of chunk terrorism-incidents-by-year-motivation-1970s](/images/us-terrorism-ideology-analysis-1970s/terrorism-incidents-by-year-motivation-1970s-1.png)

The middle part of the decade sees some increase in terrorism from 1972 and 1973. There were 58 total incidents in 1973 (the nadir for the decade), but 94 incidents in 1974 (a 62% increase from 1973) and 149 incidents in 1975 (a 156% increase from 1973 and 58% increase from 1974). These do coincide with small surges in left-wing terrorism in the middle of the decade. 

Further, as an aside, they also coincide with some of the deadlier incidents that decade. The two deadliest terrorist incidents were in 1975 and effectively bookended the year. The first of those two incidents is the aforementioned Fraunces Tavern bombing that killed four and injured 53 others while the second was the LaGuardia Airport bombing that December. In that incidents, unknown perpetrators---purportedly Croatian nationalists, but this is mostly unverified---planted a bomb that exploded at the TWA baggage claim area. The blast killed 11 people and wounded 74 others. Left-wing groups are well represented in the list below, as well as nationalist-separatist groups with left-leaning political motivations.


<table id="stevetable" class="table" style="font-size: 12px; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">The Number of Terror Attacks by Motivation and Group Name in the 1970s</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> Date </th>
   <th style="text-align:left;"> Perpetrator/Group </th>
   <th style="text-align:left;"> State </th>
   <th style="text-align:left;"> City </th>
   <th style="text-align:center;"> Number Killed </th>
   <th style="text-align:center;"> Total Casualties </th>
   <th style="text-align:left;"> Incident Description/URL </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1975-12-29 </td>
   <td style="text-align:left;"> Croatian Nationalists </td>
   <td style="text-align:left;"> New York </td>
   <td style="text-align:left;"> New York City </td>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> 85 </td>
   <td style="text-align:left;"> <a href="https://en.wikipedia.org/wiki/1975_LaGuardia_Airport_bombing" style="     ">LaGuardia Airport bombing (1975)</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1975-01-24 </td>
   <td style="text-align:left;"> Fuerzas Armadas de Liberacion Nacional (FALN) </td>
   <td style="text-align:left;"> New York </td>
   <td style="text-align:left;"> New York City </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 57 </td>
   <td style="text-align:left;"> <a href="https://www.nydailynews.com/new-york/manhattan/puerto-rican-terrorists-plant-bomb-tavern-1975-article-1.2484977" style="     ">Fraunces Tavern bombing (1975)</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1974-08-06 </td>
   <td style="text-align:left;"> Anti-Government extremists </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:left;"> Los Angeles </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 39 </td>
   <td style="text-align:left;"> <a href="https://en.wikipedia.org/wiki/1974_Los_Angeles_International_Airport_Bombing" style="     ">LAX bombing (1974)</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1973-01-07 </td>
   <td style="text-align:left;"> Republic of New Afrika </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:left;"> New Orleans </td>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> 28 </td>
   <td style="text-align:left;"> <a href="https://murderpedia.org/male.E/e/essex-mark.htm" style="     ">Mark Essex Shooting Spree (1973)</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1971-11-17 </td>
   <td style="text-align:left;"> White extremists </td>
   <td style="text-align:left;"> Oklahoma </td>
   <td style="text-align:left;"> Norman </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 27 </td>
   <td style="text-align:left;"> <a href="https://www.start.umd.edu/gtd/search/IncidentSummary.aspx?gtdid=197111170003" style="     ">Oklahoma University Arson Spree (1971)</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1976-04-22 </td>
   <td style="text-align:left;"> United Freedom Front (UFF) </td>
   <td style="text-align:left;"> Massachusetts </td>
   <td style="text-align:left;"> Boston </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 22 </td>
   <td style="text-align:left;"> <a href="https://www.start.umd.edu/gtd/search/IncidentSummary.aspx?gtdid=197604220004" style="     ">Suffolk County Courthouse Bombing (1976)</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1970-06-13 </td>
   <td style="text-align:left;"> Black Panthers </td>
   <td style="text-align:left;"> Iowa </td>
   <td style="text-align:left;"> Des Moines </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:left;"> <a href="https://www.start.umd.edu/gtd/search/IncidentSummary.aspx?gtdid=197006130001" style="     ">Des Moines Chamber of Commerce Bombing (1970)</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1970-03-22 </td>
   <td style="text-align:left;"> Black Panthers </td>
   <td style="text-align:left;"> New York </td>
   <td style="text-align:left;"> New York City </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:left;"> <a href="https://www.nytimes.com/1970/03/23/archives/15-at-the-electric-circus-injured-in-bomb-explosion-15-at-the.html" style="     ">Electric Circus Discotheque Bombing (1970)</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1979-11-03 </td>
   <td style="text-align:left;"> Ku Klux Klan </td>
   <td style="text-align:left;"> North Carolina </td>
   <td style="text-align:left;"> Greensboro </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 15 </td>
   <td style="text-align:left;"> <a href="https://en.wikipedia.org/wiki/Greensboro_massacre" style="     ">Greensboro Massacre (1979)</a> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1972-01-26 </td>
   <td style="text-align:left;"> Jewish Defense League (JDL) </td>
   <td style="text-align:left;"> New York </td>
   <td style="text-align:left;"> New York City </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 14 </td>
   <td style="text-align:left;"> <a href="https://www.nytimes.com/1972/01/27/archives/fire-bomb-kills-woman-hurts-13-in-hurok-office-firebombing-in-hurok.html" style="     ">Sol Hurok Office Bombing (1972)</a> </td>
  </tr>
</tbody>
</table>

There are some right-wing terror incidents in this top ten as well. The University of Oklahoma had an arson spree in Nov. 1971 that targeted black students on campus. No one was killed, but the fires injured 27. The Greensboro massacre stands out in this list as well. Students of right-wing terrorism know it as a sad case where the Ku Klux Klan---the U.S.' longest-running and most conspicuous terror organization---killed five people and injured 10 others. Few were charged with crimes and *none* were convicted. The state jury formally cited "self-defense" but the more likely explanation for the acquittal by an all-white jury was because the victims in this North Carolina shooting were protesters from the Communist Worker's Party and were demonstrating at a "Death to the Klan" march. A follow-up federal investigation failed to convict any perpetrators with hate crimes because the defense successfully argued the shootings were "politically motivated" and thus outside the scope of federal civil rights legislation.

However, we characterize the 1970s as the peak decade for domestic terrorism in the 1970s with the worst of it being early in the decade and coinciding with left-wing terorrism and related nationalist-separatist causes. As these declined, so did terrorism in the decade overall. The causes here are multiple. [COINTELPRO](https://en.wikipedia.org/wiki/COINTELPRO) will likely get some credit here, certainly as its operations (started in 1956) concluded in 1971. The effect there may have been to start cracking the organizational structure of a lot of these organizations. However, there's an important epilogue to COINTELPRO worth highlighting. FBI officials working on COINTELPRO knowing ordered warantless searches of these left-leaning organizations, which resulted in indictments for prominent officials like [Patrick Gray](https://en.wikipedia.org/wiki/L._Patrick_Gray) and [Mark "Deep Throat" Felt](https://en.wikipedia.org/wiki/Mark_Felt). Gray was convicted, but Reagan pardoned him. Felt was ordered to pay fines as part of his punishment, but Reagan pardoned him as well before he did.

Charges against these groups were quietly dropped because of the warantless searches, but organizational difficulties for some of these left-wing groups emerged as well. The Weather Underground/Weathermen had a major schism surrounding the *Prairie Fire* manifesto. Several prominent members---like [Mark Rudd](https://en.wikipedia.org/wiki/Mark_Rudd) and [Cathy Wilkerson](https://en.wikipedia.org/wiki/Cathlyn_Platt_Wilkerson) in 1977 and [Bernardine Dohrn](https://en.wikipedia.org/wiki/Bernardine_Dohrn) and [Bill Ayers](https://en.wikipedia.org/wiki/Bill_Ayers) in 1980---emerged from hiding just to surrender themselves to the police. The group was no longer active by the end of the decade. The Black Panthers had massive organizational problems as well, also partly a function of COINTELPRO. The long-run effect of counterterror operations of variable legality targeting the Black Panthers hollowed out the organization, which [had as few as 27 members by 1980](https://archive.org/details/upagainstwallvio00aust). It was defunct by 1982. Effective policing and counterterrorism also took down FALN, which [fell silent between July 1978 and April 1979](https://www.dhs.gov/sites/default/files/publications/OPSR_TP_START_Countermeasures-Case-Study-of-LE-Countermeasures-Against-FALN-Report_1208-508.pdf). A 1980 arrest of 11 FALN members in Evanston, Illinois was the beginning of the end for FALN, which had ceased operations by 1984. 

Amid successful counterterrorism/policing (again, of varying legality), as well the absence of some of the original motivations for these groups/militants (e.g. the end of the Vietnam war), left-wing terrorism was about 57% of all terrorism and only just over 24% of all terrorism by 1979. Nationalist-separatist terrorism surpassed left-wing terrorism as the modal form of terrorism by the end of the decade even as all forms of terrorism combined was just over 14% of what it was in 1970. Indeed, the 69 incidents in 1979 would be just four more than what the U.S. experienced in 2017 and five more than what it experienced in 2016.

In other words, domestic terrorism regressed to the typical mean by the end of the decade even as the first two years are over a quarter of the entire data set.
