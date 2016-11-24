---
title: "What's the Matter with Wisconsin? Probably Not Vote Hacking"
author: steve
layout: post
permalink:
categories:
  - Political Science
excerpt: "John Bonifaz and J. Alex Halderman think they have evidence of vote hacking in Wisconsin. I don't think they do."
---

{% include image.html url="/images/votinglines600.jpg" caption="Voters line up at the Kenosha Public Museum to cast their votes in Wisconsin's recall election. (Zbigniew Bzdak, Chicago Tribune)" width=450 align="right" %}

Remember when Clinton supporters derided Trump supporters, whose chosen candidate was already making pre-emptive claims of ["rigged elections"](http://www.politico.com/story/2016/10/donald-trump-rigged-election-guide-230302) and ["voter fraud"](http://www.factcheck.org/2016/10/trumps-bogus-voter-fraud-claims/) when it looked like Clinton was en route to an easy victory? Then Nov. 8 threw a major curveball. Trump swept almost every swing state and broke the Democrats' "blue wall" in Michigan, Pennsylvania, and Wisconsin. Trump is now the president-elect of the United States despite a pre-election predicted probability of about .15 that would happen.

This has invited some reservations among Democrats about vote-rigging. After all, the Russian government targeted the Democratic National Committee to hack for party documents and communiques, using Wikileaks as its own "disinformation" service to selectively leak documents that were more scintillating (i.e. gossip) than criminal. I'm honest-to-god amazed this was not a major deal during the campaign season. Republicans controlled both chambers of Congress (and, thus, investigatory and oversight capabilities) and seemed all too eager to benefit from this assault on American democratic processes if it would help them in November. News media in the United States, supposedly democracy's fourth estate, were all too eager to compound the problem by promoting things like John Podesta's risotto recipe as news. Clicks and ratings uber alles for American media. It's a business first and foremost, driven by profit more than political or social responsibility.

While Russian security services effectively "hacked" American political processes in support of their [useful](http://www.politico.com/story/2016/10/trump-russia-useful-idiot-madeleine-albright-230238) [idiot](https://newrepublic.com/article/137333/donald-trump-useful-idiot-dangerous-people)---seriously, [the National Security Adviser even said so!](http://www.motherjones.com/politics/2016/11/will-congress-investigate-russian-interference-2016-campaign)---it seemed untenable to think Russian security services could hack the actual votes themselves. Make no mistake; [Kremlin actors are artisans](http://www.politico.com/magazine/story/2016/10/seven-reasons-the-new-russian-hack-announcement-is-a-big-deal-214330) at vote-rigging. However, the U.S. process is so decentralized with a myriad of safeguards to make vote-hacking an impossibility.

[Enter John Bonifaz and J. Alex Halderman](http://nymag.com/daily/intelligencer/2016/11/activists-urge-hillary-clinton-to-challenge-election-results.html), respectively a voting rights attorney and director of the University of Michigan Center for Computer Security and Society, who are asking the Clinton campaign to demand a vote audit in the three "blue wall" states she lost. Here's the money passage, with a particular emphasis on the shocking result in Wisconsin.

> The academics presented findings showing that in Wisconsin, Clinton received 7 percent fewer votes in counties that relied on electronic-voting machines compared with counties that used optical scanners and paper ballots. Based on this statistical analysis, Clinton may have been denied as many as 30,000 votes; she lost Wisconsin by 27,000. While it’s important to note the group has not found proof of hacking or manipulation, they are arguing to the campaign that the suspicious pattern merits an independent review — especially in light of the fact that the Obama White House has accused the Russian government of hacking the Democratic National Committee.

Color me as suspicious and opportunistic. One, I'm unconvinced by the claim that Bonifaz and Halderman advance, even if I have a lot of respect for Halderman as an established voice in the field of computer science. Two, I'm opportunistic because I think this will probably be a cool exercise for my [quantitative methods in political science](http://svmiller.com/teaching/posc-3410-quantitative-methods-in-political-science/) kids.

So, here's what I did. I gathered county-level information for all Wisconsin's 72 counties. I consulted Census data to get estimates on the percentage of the county that's black, the percentage of the county that's white, the size of the county (i.e. population), and the percentage of the county that has a college education. I used [Verified Voting](https://www.verifiedvoting.org/verifier/#year/2016/state/55) to determine which of these counties had paper ballots. Thereafter, I found official vote tallies in 2012 for Obama and Romney at the county-level and added (admittedly unofficial) 2016 results at the county-level (using POLITICO). 

Thereafter, I test the hypothesis that Bonifaz and Halderman make implicit. Paper ballots *reduce* the difference between Obama's vote share in 2012 and Clinton's vote share in 2016 among Wisconsin's counties. In essence, an observable negative association between paper ballots and this vote share that is discernible from zero is consistent with the vote hacking argument that Bonifaz and Halderman advance. The results follow.[^scale]

[^scale]: I regrettably did not scale these variables, which I always tell my students to do. Some of the regression parameters are not as directly interpretable as a result.

<table align="center" style="padding-bottom: 20px; margin: 0px auto;text-align:center" ><caption><strong>Simple Regression of Wisconsin County Presidential Election Results</strong></caption>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="3"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="3" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="2">Vote Share: Obama - Clinton&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Turnout: 2016 - 2012</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td><td>(3)</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Paper Ballots</td><td>-0.050<sup>***</sup></td><td>-0.003</td><td>-579.949</td></tr>
<tr><td style="text-align:left"></td><td>(0.010)</td><td>(0.007)</td><td>(1,060.756)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">% White</td><td></td><td>0.001<sup>**</sup></td><td>-2.179</td></tr>
<tr><td style="text-align:left"></td><td></td><td>(0.0003)</td><td>(40.098)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">% Black</td><td></td><td>-0.001</td><td>-2,467.117<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td></td><td>(0.001)</td><td>(161.225)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">% College Educated</td><td></td><td>-0.005<sup>***</sup></td><td>15.607</td></tr>
<tr><td style="text-align:left"></td><td></td><td>(0.001)</td><td>(94.576)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">County Population (logged)</td><td></td><td>-0.008<sup>**</sup></td><td>177.968</td></tr>
<tr><td style="text-align:left"></td><td></td><td>(0.004)</td><td>(602.739)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Constant</td><td>0.118<sup>***</sup></td><td>0.206<sup>***</sup></td><td>-907.052</td></tr>
<tr><td style="text-align:left"></td><td>(0.005)</td><td>(0.038)</td><td>(5,634.320)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>72</td><td>72</td><td>72</td></tr>
<tr><td style="text-align:left">R<sup>2</sup></td><td>0.276</td><td>0.754</td><td>0.854</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.265</td><td>0.736</td><td>0.843</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td colspan="3" style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
</table>

Notice the first model, a simple bivariate model that regresses the difference in vote share from Obama to Clinton on the presence of paper balloting in the county. The results suggest a negative statistical association that is distinguishable from zero. In other words, the presence of paper ballots in the county *reduces* the difference in vote share from Obama to Clinton by an estimated .05 percent. In an election as close as Wisconsin, that would be grounds for a vote audit.

However, look what happens when we add just some basic controls: percentage of the county that's white, black, college educated, and logged population size. The effect of paper ballots goes to zero with a standard error that dwarves the coefficient. Meanwhile, whiter counties have bigger vote shares between Obama and Clinton (i.e. Obama did better in the county as a share of the overall vote than Clinton) while more educated counties have a smaller vote share between Obama and Clinton. Larger counties saw a smaller discrepancy in the vote share difference between Obama and Clinton. Intuitively, Trump seems to have done his damage in smaller, ostensibly more rural counties. These counties are whiter and have fewer college graduates. I don't think anyone would challenge Trump's message played well to these voters. The data suggest it and give a more plausible alternative explanation to the paper ballots arguments offered by Bonifaz and Halderman.

Put another way, this paints the story we've been telling generally about the election results in the Rust Belt: Trump did well among whiter counties and those without a lot of college graduates. They are not the "typical" Trump voter (i.e. a garden variety Republican partisan), but they were the "pivotal" voter in this election.

For morbid curiosity, I decided to test what at the county level among these covariates explains depressed turnout. This analysis is a bit problematic since vote tallies are not final, but we nevertheless observed a decline in turnout country-wide relative to 2008 (and even 2012). 

The only significant predictor in this model is the percentage of the county that's black. The findings here are rather stark. Each unit (i.e. percentage point) increase in the percent of the county that's black coincides with an estimated decrease of turnout by 2,467 votes relative to 2012. That's... that's something.

I'm a political scientist that teaches quantitative methods every semester so it would be professional malfeasance to not caution about the [ecological fallacy](https://en.wikipedia.org/wiki/Ecological_fallacy) in these results. We don't know *who* didn't vote among these blacker counties; we can just discern that turnout was lower relative to 2012 in counties with a greater percentage of black citizens. The reader is free to arrive at any conclusion s/he wants for this absent solid individual-level information. Possible culprits include Obama's absence from the ballot, [Clinton's "superpredators" comment](http://www.politifact.com/truth-o-meter/statements/2016/aug/28/reince-priebus/did-hillary-clinton-call-african-american-youth-su/), the Trump campaign's ["negative turnout" strategy](http://www.wsj.com/articles/donald-trumps-new-attack-strategy-keep-clinton-voters-home-1476221895), or [the voter suppression efforts in Wisconsin](http://isthmus.com/opinion/opinion/voter-suppression-in-wisconsin-in-2016-election/). The last is a serious normative concern but is just one of several possible culprits to explain this finding.

So, did the Russian government hack voting machines in Wisconsin? Unlikely. The evidence Bonifaz and Halderman provide is weak. A simple investigation of the county-level results suggest an interpretation consistent with more plausible alternative explanations. Absent more convincing evidence, disappointed Democrats should be reticent to engage in the behavior for which they spent the better part of September and October lambasting Trump supporters.

[Code/data are available on my Github](https://github.com/svmiller/2016-trump-shift).