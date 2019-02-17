---
title: "An Empirical Analysis of RuPaul's Drag Race Contestants"
author: "steve"
date: '2019-02-17'
excerpt: "My wife got me into watching RuPaul's Drag Race, so here's an empirical analysis of the top performers of the show with the idea of starting a grease fire on the subreddit."
layout: post
permalink: null
categories:
  - R
  - RuPaul's Drag Race
---



{% include image.html url="/images/kameron-michaels.jpg" caption="Kameron Michaels isn't quite sure what's happening below, but she's certainly a little revolted at the sight." width=410 align="right" %}

My wife got me hooked into watching RuPaul's Drag Race with her. The long and short of it is I didn't need to have my arm twisted to watch or enjoy the show. Indeed, drag nights at Icon in Tuscaloosa---incidentally home to [the performer who gave Trinity her "Tuck" moniker](https://twitter.com/leland2genesis?lang=en)---are some of my fondest memories of graduate school. A performer who routinely served as opening act for her---[and sadly passed away](http://obits.al.com/obituaries/birmingham/obituary.aspx?n=kevin-thomas&pid=188344432&fhid=6039) last year---was among the sweetest/kindest people I knew in town.[^herdoc] I had a receptiveness to drag as concept and creative outlet, but oddly did not know about the show until my wife told me about it.

[^herdoc]: The University of Alabama's Center for Ethics and Social Responsibility [produced a video about her experience](http://documentingjustice.org/bambi-was-a-boy/) that's worth watching.

My wife also informed me of the debates that fans have about the show, some of which can be quite heated. Several of these---at least the ones that aren't completely subjective or involve questions that quickly devolve to total grease fires---involve concerns of measurement and ranking. Certainly, the show has evolved from Season 1 to Season 10, but how would a fan rank, say, Jinkx Monsoon's run to the crown in Season 5 versus Bianca Del Rio in Season 6? Or Bob the Drag Queen in Season 8?

This creates a lot of conversation on the subreddit for the show and spawns numerous videos where fans can upvote or downvote a particular performer or carry on these debates. I hear it as an opportunity to scrape [the wiki for the show](https://rupaulsdragrace.fandom.com) and create a few data sets to see if I can measure these things myself. Toward that end, I'm creating a package in R ([`dragracer`](https://github.com/svmiller/dragracer)) that will contain various data sets for this. Mostly, I just wanted to call dibs on having an R package for the show named `dragracer`.

## About the Data/Methods

The data package is a work in progress and leans heavily on scraping the wiki, especially [the contestant-level information that the wiki turns into pyramidal tables](https://rupaulsdragrace.fandom.com/wiki/RuPaul's_Drag_Race_(Season_10)#Contestants). I have, so far, a fairly informative episode-contestant-level data set and a somewhat informative episode-level data set. In the interest of full disclosure, I'll offer some caveats about what I have so far, and how I tweak some of the information the Wiki provides:

- I interpret "HIGH TEAM" codings as cases where the contestant was on a winning team for a main challenge, but the contestant herself is safe.
- "Eliminations" are broadly understood as cases where a participant was removed from the show. As a result, there is an `outcome` variable that codes whether a contestant was a winner, scored high, was safe, scored low, or was in the bottom two for the main challenge and runway and a corollary `eliminated` variable if the contestant was removed from the show. The overlap here is substantial, obviously. However, there are a few cases where a contestant was removed despite winning a challenge (Willam, Season 4) or scoring safe (Eureka O'Hara, Season 9) for some other reason.
- The `minichalw` column in the episode-contestant data is mostly uninformative. I think cases where the wiki lists a "team captain" outcome for a contestant is its way of saying the contestant won a mini-challenge and got to lead a team, but the queen herself did not win a challenge. I was unsure and effectively ignored those in favor of the more direct "mini-challenge winner" codings. However, those are incomplete.
- Finales are sui generis and users should not read too much into them. They also evolve substantially over the show's 10 seasons. For example, the first three seasons had finales where the finale itself effectively had a bottom and, practically, an elimination. Seasons 4-8 had top threes (later top fours) where there was no "bottom" or elimination, just a crowning. Season 9 started the newer trend of having a top four and semifinal competition that leads to a lip-sync for the crown. Users who want to compare performers should subset out finales.
- Related: Seasons 6 through 8 have a `penultimate` column. These were episodes in which RuPaul whittled the top four to a top 3. They're unique episodes in that no one was a bottom, but everyone lip-synced. This created three winners and one bottom/elimination. I code those episodes as such but encourage users to subset those out when comparing contestant performances.
- The episode-level data has a `numqueens` column that codes the number of participants who were active in the episode. There were several cases where RuPaul reintroduced a performer---or, in the case of Season 7, an entire damn cast---at the start of the episode. In more than a few cases, those reintroduced were eliminated the exact same episode.
- Related to that: I code that episode in Season 7 as a case where Pearl and Trixie Mattel were joint winners.
- The finales for Season 9 and Season 10 are cases where the runner-up(s) (e.g. Peppermint, Season 9) scored high and those who lost the semifinals (e.g. Trinity Taylor, Season 9) were bottoms for that episode. Again, these are finales so the user should subset them out when comparing queens across different seasons.

## An Empirical Analysis of RuPaul's Drag Race Performances

The data are far from perfect or complete, but they're workable for an empirical analysis of contestant performance for the 10 main seasons of RuPaul's Drag Race. Here, I'll explore some of the best performers in the history of the show with some rudimentary metrics. Namely, which contestants had the highest percentage of competitive (i.e. non-special, but non-finale) episodes in which they won, or scored high/won? Which queens scored the highest on the ["Dusted or Busted" scoring system](https://rupaulsdragrace.fandom.com/wiki/%22Dusted_or_Busted%22_Scoring_System)? The data aren't too hard to generate and require a few lines in `tidyverse`. Notice the case exclusion rules, which I think are justifiable in this context.[^nominic]


[^nominic]: For now, I'm omitting mini-challenge wins from consideration because I don't think the data I have are too reliable.

```r
rdr_contep %>% 
  filter(participant == 1 & finale == 0 & penultimate == 0) %>%
  mutate(high = ifelse(outcome == "HIGH", 1, 0),
         win = ifelse(outcome == "WIN", 1, 0),
         low = ifelse(outcome == "LOW", 1, 0),
         safe = ifelse(outcome == "SAFE", 1, 0),
         highsafe = ifelse(outcome %in% c("HIGH", "SAFE"), 1, 0),
         winhigh = ifelse(outcome %in% c("HIGH", "WIN"), 1, 0),
        btm = ifelse(outcome == "BTM", 1, 0),
         lowbtm = ifelse(outcome %in% c("BTM", "LOW"), 1, 0)) %>%
  group_by(season,Contestant,Rank) %>%
  mutate(numcontests = n()) %>%
  group_by(season,Contestant, numcontests, Rank) %>%
  summarize(perc_high = sum(high)/unique(numcontests),
            perc_win = sum(win)/unique(numcontests),
            perc_winhigh = sum(winhigh)/unique(numcontests),
            perc_low = sum(low)/unique(numcontests),
            perc_btm = sum(btm)/unique(numcontests),
            perc_lowbtm = sum(lowbtm)/unique(numcontests),
            num_high = sum(high),
            num_win = sum(win),
            num_winhigh = sum(winhigh),
            num_btm = sum(btm),
            num_low = sum(low),
            num_lowbtm = sum(lowbtm),
            bd_score = 2*sum(win, na.rm=T) +
              1*sum(high, na.rm=T) +
              (sum(safe, na.rm=T)*0) +
              (sum(low, na.rm=T)*-1) + (sum(btm, na.rm=T)*-2)) -> rdr_contestant_outcomes
```

### Comparing the Season Winners

This will facilitate some kind of comparison, say, among the season-winners by reference to thier performance in main challenges/runways through the course of a season. I choose to focus on the percentage of wins, bottoms, etc. because the number of competitive episodes varies considerably through the 10 seasons. For example, Bebe Zahara Benet had just six episodes before the finale in which she could've been eliminated. Raja, Season's 3 winner, had the most (12). Seasons since then have had 10 or 11 competitive episodes, excluding the eight competitive episodes in Season 8.

<table id="stevetable">
<caption>Ranking the RuPaul's Drag Race Winners from Season 1 to Season 10</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> season </th>
   <th style="text-align:left;"> Contestant </th>
   <th style="text-align:center;"> % Wins </th>
   <th style="text-align:center;"> % Wins/Highs </th>
   <th style="text-align:center;"> % Bottom </th>
   <th style="text-align:center;"> % Bottom/Low </th>
   <th style="text-align:center;"> DB Score </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> S01 </td>
   <td style="text-align:left;"> BeBe Zahara Benet </td>
   <td style="text-align:center;"> 33.33% </td>
   <td style="text-align:center;"> 50% </td>
   <td style="text-align:center;"> 16.67% </td>
   <td style="text-align:center;"> 16.67% </td>
   <td style="text-align:center;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S02 </td>
   <td style="text-align:left;"> Tyra Sanchez </td>
   <td style="text-align:center;"> 33.33% </td>
   <td style="text-align:center;"> 55.56% </td>
   <td style="text-align:center;"> 0% </td>
   <td style="text-align:center;"> 11.11% </td>
   <td style="text-align:center;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S03 </td>
   <td style="text-align:left;"> Raja </td>
   <td style="text-align:center;"> 25% </td>
   <td style="text-align:center;"> 58.33% </td>
   <td style="text-align:center;"> 8.33% </td>
   <td style="text-align:center;"> 16.67% </td>
   <td style="text-align:center;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S04 </td>
   <td style="text-align:left;"> Sharon Needles </td>
   <td style="text-align:center;"> 36.36% </td>
   <td style="text-align:center;"> 54.55% </td>
   <td style="text-align:center;"> 9.09% </td>
   <td style="text-align:center;"> 18.18% </td>
   <td style="text-align:center;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S05 </td>
   <td style="text-align:left;"> Jinkx Monsoon </td>
   <td style="text-align:center;"> 18.18% </td>
   <td style="text-align:center;"> 81.82% </td>
   <td style="text-align:center;"> 9.09% </td>
   <td style="text-align:center;"> 9.09% </td>
   <td style="text-align:center;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S06 </td>
   <td style="text-align:left;"> Bianca Del Rio </td>
   <td style="text-align:center;"> 30% </td>
   <td style="text-align:center;"> 70% </td>
   <td style="text-align:center;"> 0% </td>
   <td style="text-align:center;"> 0% </td>
   <td style="text-align:center;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S07 </td>
   <td style="text-align:left;"> Violet Chachki </td>
   <td style="text-align:center;"> 27.27% </td>
   <td style="text-align:center;"> 45.45% </td>
   <td style="text-align:center;"> 0% </td>
   <td style="text-align:center;"> 18.18% </td>
   <td style="text-align:center;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S08 </td>
   <td style="text-align:left;"> Bob the Drag Queen </td>
   <td style="text-align:center;"> 37.5% </td>
   <td style="text-align:center;"> 37.5% </td>
   <td style="text-align:center;"> 12.5% </td>
   <td style="text-align:center;"> 12.5% </td>
   <td style="text-align:center;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S09 </td>
   <td style="text-align:left;"> Sasha Velour </td>
   <td style="text-align:center;"> 18.18% </td>
   <td style="text-align:center;"> 63.64% </td>
   <td style="text-align:center;"> 0% </td>
   <td style="text-align:center;"> 9.09% </td>
   <td style="text-align:center;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S10 </td>
   <td style="text-align:left;"> Aquaria </td>
   <td style="text-align:center;"> 27.27% </td>
   <td style="text-align:center;"> 36.36% </td>
   <td style="text-align:center;"> 0% </td>
   <td style="text-align:center;"> 18.18% </td>
   <td style="text-align:center;"> 5 </td>
  </tr>
</tbody>
</table>

The table won't reveal too much that stands at odds with what long-running fans of the show already know. Sharon Needles had the most main challenge wins of any season-winner and, in my interpretation of the data, is tied with Shea Couleé (a Season 9 semifinalist) for most main challenge wins of any performer. Fans will qualify that Sharon won her challenges outright while Shea shared two of her wins with Sasha Velour. This may matter to the allocation of prize money but won't matter in the data as I have it.

Perhaps the strongest contestants are in the middle two seasons. Jinkx Monsoon and Bianca Del Rio effectively dominated their seasons. Jinkx stands out in particular for winning or placing high in nine of her 11 competitive episodes. A "safe" in the season-opener and bottom-two performance in the last competitive episode of the season before the finale sandwiched a run of excellence in which she won or scored high. This is particularly impressive because, if you want to treat the show as something other than reality TV in which winners are determined by RuPaul's discretion, her season might have been the most competitive. Roxxxy Andrews, Alaska, Detox, and Alyssa Edwards are legendary names as drag performers.

Likewise, Bianca Del Rio has the distinction of the first and, to date, only queen to never land in the bottom two or even get a "low" rating for a given episode. She is not alone as a winner to have never lip-synced for her life, but she is unique for not even ranking low. That effectively explains the one-point differential favoring Bianca Del Rio over Jinkx Monsoon in the "Dusted or Busted" scoring system.

Bob the Drag Queen and Aquaria stand out for scoring eye-openingly low in the "Dusted or Busted" scoring system. Both are, from what I've gathered, well-respected among fans of the show, and I think their low scores have some intuitive explanations. In Bob's case, she had just eight competitive episodes in what amounts to a conspicuously abbreviated season. That she has 12% of her appearances in the bottom means she was in the bottom just once. Fans will remember that episode well. She lip-synced against Derrick Barry to the tune of one of my all-time favorite jams: Sylvester's "You Make Me Feel (Mighty Real)." That contest was not close.

In Aquaria's case, her season might have been the most competitive top to bottom in the show's history. Blair St. Clair (9th place) and Mayhem Miller (10th place) could probably crack top five each in most other seasons. Vanessa Vanjie Mateo, 14th place in Season 10, may even make a long run in Season 11.

### Who Were the Lowest-Ranked Performers to Land in the Top Four?

The data can also be used to identify the lowest-scoring performers to get a top four finish in the show's 10 seasons. There are several metrics available for ranking these performers, but I'll go in descending order, by "Dusted or Busted" score.

<table id="stevetable">
<caption>The Lowest-Ranked Top Four Performers from Season 1 to Season 10</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> season </th>
   <th style="text-align:center;"> Rank </th>
   <th style="text-align:left;"> Contestant </th>
   <th style="text-align:center;"> % Wins </th>
   <th style="text-align:center;"> % Wins/Highs </th>
   <th style="text-align:center;"> % Bottom </th>
   <th style="text-align:center;"> % Bottom/Low </th>
   <th style="text-align:center;"> DB Score </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> S06 </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> Darienne Lake </td>
   <td style="text-align:center;"> 10% </td>
   <td style="text-align:center;"> 20% </td>
   <td style="text-align:center;"> 30% </td>
   <td style="text-align:center;"> 60% </td>
   <td style="text-align:center;"> -6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S02 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Jujubee </td>
   <td style="text-align:center;"> 0% </td>
   <td style="text-align:center;"> 22.22% </td>
   <td style="text-align:center;"> 33.33% </td>
   <td style="text-align:center;"> 44.44% </td>
   <td style="text-align:center;"> -5 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S01 </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> Shannel </td>
   <td style="text-align:center;"> 0% </td>
   <td style="text-align:center;"> 16.67% </td>
   <td style="text-align:center;"> 33.33% </td>
   <td style="text-align:center;"> 50% </td>
   <td style="text-align:center;"> -4 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S05 </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> Detox </td>
   <td style="text-align:center;"> 9.09% </td>
   <td style="text-align:center;"> 18.18% </td>
   <td style="text-align:center;"> 27.27% </td>
   <td style="text-align:center;"> 36.36% </td>
   <td style="text-align:center;"> -4 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S10 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:left;"> Kameron Michaels </td>
   <td style="text-align:center;"> 9.09% </td>
   <td style="text-align:center;"> 27.27% </td>
   <td style="text-align:center;"> 27.27% </td>
   <td style="text-align:center;"> 36.36% </td>
   <td style="text-align:center;"> -3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S01 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Rebecca Glasscock </td>
   <td style="text-align:center;"> 16.67% </td>
   <td style="text-align:center;"> 33.33% </td>
   <td style="text-align:center;"> 33.33% </td>
   <td style="text-align:center;"> 50% </td>
   <td style="text-align:center;"> -2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S02 </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> Tatianna </td>
   <td style="text-align:center;"> 11.11% </td>
   <td style="text-align:center;"> 22.22% </td>
   <td style="text-align:center;"> 22.22% </td>
   <td style="text-align:center;"> 33.33% </td>
   <td style="text-align:center;"> -2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S08 </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> Chi Chi DeVayne </td>
   <td style="text-align:center;"> 12.5% </td>
   <td style="text-align:center;"> 25% </td>
   <td style="text-align:center;"> 25% </td>
   <td style="text-align:center;"> 37.5% </td>
   <td style="text-align:center;"> -2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S04 </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:left;"> Latrice Royale </td>
   <td style="text-align:center;"> 18.18% </td>
   <td style="text-align:center;"> 36.36% </td>
   <td style="text-align:center;"> 27.27% </td>
   <td style="text-align:center;"> 36.36% </td>
   <td style="text-align:center;"> -1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> S03 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:left;"> Alexis Mateo </td>
   <td style="text-align:center;"> 25% </td>
   <td style="text-align:center;"> 41.67% </td>
   <td style="text-align:center;"> 25% </td>
   <td style="text-align:center;"> 41.67% </td>
   <td style="text-align:center;"> 0 </td>
  </tr>
</tbody>
</table>

A couple of names stand out. Darienne Lake has the lowest "Dusted or Busted" score of any contestant with a top four finish. In fact, she finished bottom or low in six of her 10 competitive episodes. The distance between her and the next lowest scoring top four performer by "Dusted or Busted" score (Courtney Act) is seven points.

Several names will be familiar and unsurprising entries on this list, thinking especially of Shannel, Jujubee, and Tatianna. Jujubee emerged as the queen of the read and the lip-sync assassin of Season 2. She was in the bottom two three times and sent home Sahara Davenport, Pandora Boxx, and Tatianna. No matter, bottom two performances are still penalized heavily in this scoring system. Tatianna, likewise, is in the bottom 10 in this metric. From my outside reading of how fans interpret the show, Tatianna was perhaps raw in Season 2---apparently only 20 years old at the time of filming. She was excellent in Season 2 of All-Stars, though. It is interesting to see two of Season 2's top four in this list, though.

Kameron Michaels is the only No. 2 finisher to appear in this top ten. Fans of the show will note she mostly played it safe but, as the competition whittled down, otherwise "safe" performances put her in the bottom two. The interesting anecdote to emerge from that, however, is she appears to have the most consecutive "shantays" in lip-sync battles. In four-straight episodes, she shantayed in lip-syncs against Eureka O'Hara (a double shantay), Monét X Change, Miz Cracker, and Asia O'Hara. Do note that lip-syncs are selection effects. Kameron's final lip-sync in that run was also a semifinal. Further, RuPaul is generally unforgiving of multiple, consecutive appearances in the bottom two (see: Alyssa Edwards [Season 5], Akashia [Season 1]). However, that four-episode run for Kameron Michaels is an all-time best and likely won't be matched, given the nature of the show and the peculiar string of those lip-syncs.

Detox's entry into this list is one of those head-scratchers that makes sense upon further review. Detox can match high-concept looks with great comedy, but that and her top three performance in All-Stars 2 belie that her performance in Season 5 included only one win and four appearances in the "low" or "bottom" categories.

### A Simple Item Response Model for Ranking All Contestants

Finally, I decided to run a simple graded response model on the data for all contestants. The graded response model includes the number of performances in which the contestant won, won or scored high, or was in the bottom.[^lowbtmcomment] I also include the contestant's final rank for the season and the "Dusted or Busted" score. Conceptually, these polytomous measures of a contestant's performances are judges of a contestant's ability based on discrete scale. This is obviously rudimentary, and someone more versed in IRT modeling will balk at treating the "Dusted or Busted" score in this way, but the model ran and I'm not submitting it for peer review and I don't have time to invest in a more comprehensive model. Your critiques can sashay away.

[^lowbtmcomment]: I had also included the number of performances in the bottom or with a low mark. This factor didn't load well and the model improved for its absence.

The top 25 participants on this metric are listed below, with accompanying standard errors around the latent estimate.

![plot of chunk top-rupauls-drag-race-performers](/figure/source/2019-02-17-dragracer-rupauls-drag-race-analysis/top-rupauls-drag-race-performers-1.png)

Fans of the show are free to read into this what they want. I'm not too invested in what this demonstrates, but a few things are worth mentioning as quick hitters.

{% include image.html url="/images/bendela-going-home.gif" caption="She went home." width=250 align="right" %}

The model wants to downweight Bob the Drag Queen for being on an abbreviated season. She's not the lowest-ranked winner on this list; in fact: Bebe Zahara Benet is not even on it. I don't think fans of the show hold Bob in low regard. Her snatch game, always an important metric, is among the best. However, metrics for evaluating contestants focus on raw counts (e.g. wins, highs, etc). Toward that end, being on an abbreviated season hurts Bob's rankings.

BenDeLaCreme and Katya are the only contestants without top four finishes on this list. This is a case where a model might tell you something that's intuitively true, but probably not implied by what you thought from the inputs. In other words: these two are great. Katya could've won All-Stars 2 and the only reason BenDeLaCreme didn't win All-Stars 3 is because she chose not to win it.


### Conclusion: As 🔥 #Takes

I don't have much to conclude, but I do have a few #takes that I'll offer as heaters here.

- The scorecard is pretty clear Tyra Sanchez deserved to win Season 2, but I bet RuPaul wishes she could back and do that one again.
- Kameron Michaels should've won Season 10. Hey, I didn't say these takes were good, just that they were 🔥.
- Sasha Velour needs a street named after her in Urbana. Hell, next-door [Champaign had a street named after REO Speedwagon](https://www.chicagotribune.com/news/ct-xpm-2001-01-16-0101160268-story.html) when I was living in that city. Why not Sasha Velour for Urbana?
- Acid Betty needed more episodes on Season 8. Her three high performances in the first three episodes push her up a lot of rankings for someone who otherwise landed No. 8 in a season.
- I would've put Aquaria as a bottom instead of Monét in episode 10 of Season 10. That would've put Aquaria, the future winner of the season, in front of the grim reaper of lip-syncs (Kameron Michaels). And, yeah, there's no way RuPaul would've sent Aquaria home instead of Kameron Michaels, but the thought experiment is fun.
- I feel most scoring metrics for RuPaul's Drag Race should include a category that awards 10 points to a contestant if she is able to check the box of "is Alyssa Edwards." I think that's appropriate.
- I am compelled to support Nina West in Season 11 because she is from Columbus. I will disregard any critiques of her as wrong as a result.
