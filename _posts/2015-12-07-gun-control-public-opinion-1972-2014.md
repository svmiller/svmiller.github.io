---
title: "What Can Survey Data Tell Us About Public Opinion and the Gun Control Debate?"
author: steve
layout: post
permalink:
categories:
  - Political Science
excerpt:  "We commonly believe the gun control debate to be a polarizing issue, but data from the General Social Survey suggest that is not necessarily true."
image: "planned-parenthood-shooter-arrested.jpg"
---

<!--We commonly believe the gun control debate to be a polarizing issue, but data from the General Social Survey suggest that is not necessarily true. GOP partisanship does not robustly reduce support for gun control and most Republicans actually support gun control measures. However, the issue is quickly becoming a polarizing issue among the electorate, and it's likely not just the South that is responsible for that.
     -->

<dl id="" class="wp-caption aligncenter" style="max-width:100%; text-align: left; padding-top: 8px">

<dt><span style="font-weight:bold; font-size: 1em; padding-left: 8px">This blog post is now a peer-reviewed paper. ⤵️</span></dt>

<dd style = "padding-bottom: 8px">This was an end-of-the-semester diversion from grading and I was happy to get a publication out of it at <em>Social Science Quarterly</em>. A lot remains the same empirically, except for the addition of the 2016 wave of GSS data, the addition of another control variable for rural respondents, and a few auxiliary analyses on top of that.</dd> 

<dt><span style="font-weight:bold; font-size: 1em; padding-left: 8px">Suggested Citation:️</span></dt>
<dd style = "padding-bottom: 8px">
Miller, Steven V. 2019.  "<a href="http://svmiller.com/research/what-americans-really-think-about-gun-control/">What Americans Think About Gun Control: Evidence from the General Social Survey, 1972-2016</a>." <em>Social Science Quarterly</em> 100(1): 272--288.
</dd>
</dl>


{% include image.html url="/images/planned-parenthood-shooter-arrested.jpg" caption="Police take Robert Lewis Dear into custody after a mass shooting at a Colorado Springs Planned Parenthood." width=450 align="right" %}

The recent terrorist incidents in Colorado Springs and San Bernardino have renewed public interest in the gun control debate. The *New York Daily News* ran [a provocative front-page image](http://www.nydailynews.com/news/politics/gop-candidates-call-prayers-calf-massacre-article-1.2453261) that implored high-ranking politicians to abandon the proverbial "thoughts and prayers" as little more than cheap rhetoric from legislators who would rather not, well, "legislate" on this particular issue. [A follow-up front-page cover](https://twitter.com/NYDailyNews/status/672745824447787008?ref_src=twsrc^tfw) on the San Bernardino incident engaged in deliberate issue-linkage of the San Bernardino terrorist incident with semi-automatic rampages in Newtown and Aurora, among, sadly, several others.

The *New York Times* even dusted off a device it had not used in 95 years---the front-page editorial---to argue that our legislators' inability to push sensible gun control legislation into law is a ["moral outrage and national disgrace"](http://www.nytimes.com/2015/12/05/opinion/end-the-gun-epidemic-in-america.html).

The *New York Daily News* and *New York Times* are making these demonstrations because gun control legislation is a non-starter in Congress. [Senate Republicans voted down legislation](http://www.nydailynews.com/news/politics/senate-gop-votes-terrorist-gun-bill-article-1.2454448) that would have closed background check loopholes and banned subjects on the terror watch list from purchasing firearms. GOP opposition to the bill was almost unanimous, which conforms to the preferences of the National Rifle Association on this issue.

We tend to believe gun control legislation is a non-starter in Congress because the issue is heavily polarized. Democrats push the issue and Republicans are almost unanimous in their opposition to gun control. If, as we commonly believe, citizens are becoming increasingly polarized too (or at least better ["sorted"](http://www.amazon.com/Authoritarianism-Polarization-American-Politics-Hetherington/dp/052171124X)), then gun control pushes by partisan Democrats are unlikely to become law against strong opposition.[^1] For gun control advocates, a veto threat from Democrats may make further gun *de*regulation less likely. This, at least, constitutes a silver lining.

[^1]: The more accurate claim on polarization may be that the electorate is not more "polarized", just that the relationship between ideology and party affiliation is stronger now than it was before the great ["sorting"](http://www.amazon.com/Partisan-Sort-Democrats-Conservatives-Republicans-ebook/dp/B003C31OHK/ref=sr_1_1?s=books&ie=UTF8&qid=1449435004&sr=1-1&keywords=9780226473673) through the 1970s and 1980s, arguably culminating in the "Republican Revolution" of 1994. [Per Morris Fiorina's scholarship](http://www.the-american-interest.com/2013/02/12/americas-missing-moderates-hiding-in-plain-sight/), the greater polarization appears to be among America's ruling class and those non-politicians/bureaucrats still involved in the highest levels of politics.

What can public opinion data tell us about this debate? For those of who have poked around General Social Survey data before, the answers are somewhat surprising. They certainly surprise students in my quantitative methods class when gun control political attitude data appear in the assigned texts. In what follows, I use General Social Survey (GSS) data from 1972 to 2014 to illustrate some of the broader patterns on partisanship and support for gun control at the individual-level.

## GOP Partisanship Does Not Robustly Reduce Support for Gun Control...

Partisanship might be our go-to explanation for individual-level support for gun control. However, the partisanship-gun control relationship is not nearly as robust at the individual-level as we infer it to be at the elite-level.

I conducted a regression analysis of six questions on the topic of gun control. The first question concerns whether a police permit is required before a citizen could purchase a gun. This is the most ubiquitous gun control question in GSS and appears in every survey from 1972 to 2014, except for surveys in 1978, 1983, and 1986. The next five questions appear in just the 2006 wave of GSS. These concern whether background checks should be required for private gun sales, whether tougher penalties should be imposed on individuals for illegal gun sales than those imposed on selling drugs, whether semi-automatic weapons should be the exclusive domain of the police and military (i.e. no sales to the public), whether the respondent would support proposed state laws that would make it illegal to carry a gun while drunk, and whether the respondent believes gun control laws should be stricter after 9/11. All six responses are recoded as binary with recoded responses of 1 indicating support for a gun control measure.

I kept my independent variables rather minimal. I include the age of the respondent and [standardize it by two standard deviations](http://onlinelibrary.wiley.com/doi/10.1002/sim.3107/abstract), centered on the mean for the year (and not the global mean).[^2] I include dummies for the college educated and women. I break GSS' three-category race variable into two fixed effects for black respondents and "other" (i.e. not white) respondents. This leaves white respondents in the baseline. I include (and standardize, like the age variable) the six-point party identification variable. Increasing values indicate stronger affiliation with the Republican party.[^3] Finally, I code whether the respondents reports having a gun in his or her home. This variable serves as a crude proxy for the salience of guns to the respondent.

[^2]: GSS regrettably stops coding age in years for respondents older than 89. In other words, a value of 89 indicates respondents 89 and older. This coding decision makes the variable as technically ordinal, though I will treat it as interval for convenience.
[^3]: I recode the 7s in this variable to be missing. These are respondents who have another party affiliation and do not disclose it.

The models summarized in the following table are mixed effects logistic regressions. I include random effects for the year (in the first model) and [condensed Census regions](http://www2.census.gov/geo/pdfs/maps-data/maps/reference/us_regdiv.pdf) in all six models. I also allow the effect of party identification to vary by region and year.


<table style="text-align:center; padding-bottom: 20px"><caption><strong>Mixed Effects Models of Attitudes toward Gun Control</strong></caption>
<tr><td colspan="7" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td><strong>Require Police Permit?</strong></td><td><strong>Background Check for Private Sales?</strong></td><td><strong>Tougher Penalties than Selling Drugs?</strong></td><td><strong>Limit Semi-Automatics to Police/Military?</strong></td><td><strong>Illegal to Carry a Gun while Drunk?</strong></td><td><strong>Tougher Gun Control Laws after 9/11?</strong></td></tr>
<tr><td style="text-align:left"></td><td><strong>Model 1</strong></td><td><strong>Model 2</strong></td><td><strong>Model 3</strong></td><td><strong>Model 4</strong></td><td><strong>Model 5</strong></td><td><strong>Model 6</strong></td></tr>
<tr><td colspan="7" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Age</td><td>0.085<sup>***</sup></td><td>-0.049</td><td>0.343<sup>**</sup></td><td>1.234<sup>***</sup></td><td>0.164</td><td>0.071</td></tr>
<tr><td style="text-align:left"></td><td>(0.028)</td><td>(0.181)</td><td>(0.146)</td><td>(0.251)</td><td>(0.258)</td><td>(0.215)</td></tr>
<tr><td style="text-align:left">College Educated</td><td>0.338<sup>***</sup></td><td>0.598<sup>***</sup></td><td>-0.162</td><td>0.457</td><td>0.349</td><td>0.113</td></tr>
<tr><td style="text-align:left"></td><td>(0.036)</td><td>(0.231)</td><td>(0.168)</td><td>(0.283)</td><td>(0.317)</td><td>(0.252)</td></tr>
<tr><td style="text-align:left">Female</td><td>0.661<sup>***</sup></td><td>0.955<sup>***</sup></td><td>0.109</td><td>2.041<sup>***</sup></td><td>0.628<sup>**</sup></td><td>1.219<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.028)</td><td>(0.186)</td><td>(0.150)</td><td>(0.264)</td><td>(0.256)</td><td>(0.217)</td></tr>
<tr><td style="text-align:left">Black</td><td>0.122<sup>***</sup></td><td>-0.253</td><td>0.884<sup>***</sup></td><td>0.547</td><td>-0.515</td><td>-0.191</td></tr>
<tr><td style="text-align:left"></td><td>(0.046)</td><td>(0.291)</td><td>(0.242)</td><td>(0.438)</td><td>(0.389)</td><td>(0.378)</td></tr>
<tr><td style="text-align:left">Other Race (Not White)</td><td>0.361<sup>***</sup></td><td>-0.202</td><td>0.873<sup>***</sup></td><td>1.045<sup>**</sup></td><td>-0.396</td><td>0.342</td></tr>
<tr><td style="text-align:left"></td><td>(0.075)</td><td>(0.332)</td><td>(0.279)</td><td>(0.472)</td><td>(0.417)</td><td>(0.425)</td></tr>
<tr style=" background-color: #f3f3f3; font-weight: bold"><td style="text-align:left">Party ID (D to R)</td><td>-0.388<sup>***</sup></td><td>-0.283</td><td>0.082</td><td>-0.360</td><td>-0.287</td><td>-0.558<sup>**</sup></td></tr>
<tr style=" background-color: #f3f3f3; font-weight: bold"><td style="text-align:left"></td><td>(0.068)</td><td>(0.206)</td><td>(0.171)</td><td>(0.246)</td><td>(0.341)</td><td>(0.275)</td></tr>
<tr><td style="text-align:left">Gun in the Household</td><td>-0.983<sup>***</sup></td><td>-0.529<sup>***</sup></td><td>-0.603<sup>***</sup></td><td>-1.288<sup>***</sup></td><td>-0.063</td><td>-1.198<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.029)</td><td>(0.191)</td><td>(0.160)</td><td>(0.245)</td><td>(0.277)</td><td>(0.221)</td></tr>
<tr><td style="text-align:left">Constant</td><td>1.354<sup>***</sup></td><td>1.092<sup>***</sup></td><td>0.166</td><td>1.472<sup>***</sup></td><td>2.158<sup>***</sup></td><td>1.640<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.141)</td><td>(0.197)</td><td>(0.262)</td><td>(0.275)</td><td>(0.296)</td><td>(0.320)</td></tr>
<tr><td style="text-align:left">N</td><td>34234</td><td>838</td><td>835</td><td>832</td><td>842</td><td>790</td></tr>
<tr><td colspan="7" style="border-bottom: 1px solid black"></td></tr><tr><td colspan="7" style="text-align:left"><sup>***</sup>p < .01; <sup>**</sup>p < .05; <sup>*</sup>p < .1</td></tr>
</table>


The results here tell a mixed story about the effect of increasing partisanship with the GOP on support (rather: opposition) to gun control legislation. The most precise effect is observed in the first model that estimates whether a respondent believes a potential gun-owner should obtain a permit from the police before purchasing a weapon. A change across two standard deviations in the distribution of this variable (i.e. about 47.7% of the data) leads to a decrease of -.388 in the logged odds of support for this hypothetical gun control measure. There is a similar discernible effect of partisanship on opposition to tougher gun control measures after 9/11. An increase of two standard deviations across the partisanship variable leads to a decrease of -.558 in the logged odds of support for tougher gun control measures as a response to 9/11.

While this might be disconcerting for gun control advocates, I do wonder how informative this question is. It appears just once (in the 2006 wave of GSS). While it does frame the respondent to think of 9/11 in answering this question, it does *not* connect terrorists as potential firearm purchasers or owners. We know now this is an issue in the San Bernardino case. The attackers in that case were American citizens who purchased their weapons legally in advance of a terrorist attack.

## ...and Most Republicans Actually Support Gun Control

This is the most confusing thing for my students to learn. When I talk about [making comparisons](https://www.dropbox.com/s/0fsyb4w7qywlj83/posc3410-lecture-making-comparisons.pdf?dl=0) with basic cross-tabulation in my quantitative methods class, the first things students see in the relevant slide from that lecture is that 68.8% of *Republicans* support a law that would require a person to obtain a police permit before he or she could buy a gun. They miss that 87% of Democrats support it and that 79% of independents support it. They miss the observable effect of partisanship that I try to show them, even if that particular statistic about Republicans stands at odds with conventional wisdom.

That observation in GSS from 2006 is more than just an anomaly that defies conventional wisdom. It's a trend. There is not a year in GSS in which support for a law that would require a police permit among the **strong** Republicans is below 54%.

<table style="text-align:center"><caption><strong>Percentage of Respondents Supporting Police Permits, by Party ID and Year</strong></caption>
<tr><td colspan="18" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Party ID</td><td>1972</td><td>1973</td><td>1974</td><td>1975</td><td>1976</td><td>1977</td><td>1980</td><td>1982</td><td>1984</td><td>1985</td><td>1987</td><td>1988</td><td>1989</td><td>1990</td><td>1991</td><td>1993</td><td>1994</td></tr>
<tr><td colspan="18" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Strong Dem.</td><td>75.16</td><td>79.56</td><td>78.28</td><td>76.73</td><td>71.62</td><td>76.47</td><td>74.86</td><td>75.94</td><td>76.45</td><td>78.33</td><td>74.64</td><td>80.79</td><td>82.32</td><td>85.57</td><td>84.25</td><td>87.82</td><td>87.97</td></tr>
<tr><td style="text-align:left">Not Strong Dem.</td><td>73.57</td><td>76.34</td><td>78.2</td><td>80.88</td><td>76.19</td><td>72.45</td><td>75</td><td>77.45</td><td>77.09</td><td>72.38</td><td>73.64</td><td>80.9</td><td>87.05</td><td>84.1</td><td>83.16</td><td>86.05</td><td>84.32</td></tr>
<tr><td style="text-align:left">Indep., lean Dem.</td><td>69.43</td><td>74.87</td><td>76.81</td><td>70.67</td><td>73.3</td><td>74.75</td><td>69.79</td><td>74.48</td><td>75.24</td><td>79.87</td><td>75.85</td><td>73.6</td><td>77.91</td><td>82.35</td><td>83.75</td><td>83.85</td><td>82.06</td></tr>
<tr><td style="text-align:left">Independent</td><td>69.23</td><td>77.86</td><td>74.1</td><td>71.29</td><td>67.54</td><td>74.27</td><td>72.57</td><td>75.69</td><td>72.85</td><td>67.83</td><td>70.9</td><td>77.88</td><td>72.5</td><td>78.85</td><td>78.4</td><td>79.03</td><td>79.92</td></tr>
<tr><td style="text-align:left">Indep., lean GOP</td><td>68.69</td><td>68.57</td><td>70.19</td><td>71.9</td><td>70.48</td><td>63.28</td><td>65.29</td><td>72</td><td>65.16</td><td>70.51</td><td>68.71</td><td>73.33</td><td>68</td><td>70.48</td><td>80.91</td><td>86</td><td>72.19</td></tr>
<tr><td style="text-align:left">Not Strong GOP</td><td>70.22</td><td>69.77</td><td>75</td><td>77.09</td><td>71.63</td><td>73.06</td><td>66.36</td><td>70.95</td><td>69.58</td><td>71.76</td><td>76.34</td><td>69.19</td><td>79.17</td><td>79.37</td><td>79.06</td><td>74.19</td><td>74.77</td></tr>
<tr style=" background-color: #f3f3f3; font-weight: bold"><td style="text-align:left">Strong GOP</td><td>76.86</td><td>73.55</td><td>73.83</td><td>73.33</td><td>73.96</td><td>72.38</td><td>61.82</td><td>62.5</td><td>63.56</td><td>71.51</td><td>66.89</td><td>72.04</td><td>74.79</td><td>77.68</td><td>85.34</td><td>82.4</td><td>67.77</td></tr>
<tr><td colspan="18" style="border-bottom: 1px solid black"></td></tr></table>

<table style="text-align:center; padding-bottom: 20px"><tr><td colspan="11" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Party ID</td><td>1996</td><td>1998</td><td>2000</td><td>2002</td><td>2004</td><td>2006</td><td>2008</td><td>2010</td><td>2012</td><td>2014</td></tr>
<tr><td colspan="11" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Strong Dem.</td><td>88.05</td><td>86.75</td><td>90.11</td><td>90.77</td><td>86.47</td><td>87.37</td><td>87.3</td><td>84.13</td><td>85.9</td><td>87.37</td></tr>
<tr><td style="text-align:left">Not Strong Dem.</td><td>87.04</td><td>86.49</td><td>85.23</td><td>85.71</td><td>85.19</td><td>86.27</td><td>84.47</td><td>78.33</td><td>78.54</td><td>83.93</td></tr>
<tr><td style="text-align:left">Indep., lean Dem.</td><td>84.91</td><td>88.53</td><td>86.89</td><td>78.12</td><td>80.39</td><td>83.94</td><td>84.3</td><td>84.62</td><td>76.06</td><td>80.37</td></tr>
<tr><td style="text-align:left">Independent</td><td>80.27</td><td>84.28</td><td>84.14</td><td>84.76</td><td>81.21</td><td>79.18</td><td>81.19</td><td>73.59</td><td>73.88</td><td>68.15</td></tr>
<tr><td style="text-align:left">Indep., lean GOP</td><td>76.47</td><td>84.77</td><td>75.74</td><td>67.57</td><td>71.43</td><td>74.24</td><td>65.05</td><td>60.16</td><td>59.22</td><td>49.4</td></tr>
<tr><td style="text-align:left">Not Strong GOP</td><td>81.55</td><td>76.97</td><td>77.99</td><td>75.5</td><td>80</td><td>74.92</td><td>69.7</td><td>71.75</td><td>70.12</td><td>65.05</td></tr>
<tr style=" background-color: #f3f3f3; font-weight: bold"><td style="text-align:left">Strong GOP</td><td>71.05</td><td>76.67</td><td>65.19</td><td>69.39</td><td>65.52</td><td>71.17</td><td>68.28</td><td>58.97</td><td>54.62</td><td>59.54</td></tr>
<tr><td colspan="11" style="border-bottom: 1px solid black"></td></tr></table>

I use information like this to tell students to be mindful of what the regression actually communicates. The regression coefficient communicates a negative relationship of partisanship with the GOP on support for gun control that is statistically discernible from a zero relationship. This effect is discernible across the entire range of the independent variable. 

Do take care to internalize the difference between a wrong inferential statement and the correct inferential statement. That statistically significant negative coefficient *does not* tell us that the typical strong Republican is likely to oppose gun control. Instead, that typical strong Republican is just less likely to support gun control than someone with lesser affiliation to the GOP, all things equal.

We can further illustrate this with post-estimation simulation using the `Zelig` package.[^4] I re-estimated Model 1 in Zelig with just the raw score of party identification (i.e. from 0 to 6). Thereafter, I set explanatory variables at their typical values (which happens to be white respondents around age 51 without a college education). I set the party identification variable to be at its maximum (i.e. strong Republicans) and allow the gun ownership variable and gender variable to vary.

[^4]: See [King, Tomz, and Wittenberg's (2000) famous paper](http://gking.harvard.edu/files/making.pdf) on this topic.


<table style="float: right; padding-left:20px"><caption><strong>Expected Values of Support for Police Permits for Handgun Purchases</strong></caption>
	<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr>
	
  <tr>
    <th class="tg-031e">Category</th>
    <th style="text-align:center">Expected <br/> Value</th>
    <th class="tg-031e">95% <br /> Interval</th>
  </tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr>
  <tr>
    <td class="tg-031e">Female, Strong GOP, Doesn't Own Gun</td>
    <td style="text-align:center">.842</td>
    <td class="tg-031e">(.799, .880)</td>
  </tr>
  <tr>
    <td class="tg-031e">Men, Strong GOP, Doesn't Own Gun</td>
    <td style="text-align:center">.738</td>
    <td class="tg-031e">(.663, .792)</td>
  </tr>
  <tr>
    <td class="tg-031e">Female, Strong GOP, Gun Owners</td>
    <td style="text-align:center">.670</td>
    <td class="tg-031e">(.601, .739)</td>
  </tr>
  <tr>
    <td class="tg-031e">Men, Strong GOP, Gun Owners</td>
    <td style="text-align:center">.510</td>
    <td class="tg-031e">(.433, .595)</td>
  </tr>
  <tr>
    <td class="tg-031e">Men, Strong GOP, Gun Owners, College Educated</td>
    <td style="text-align:center">.590</td>
    <td class="tg-031e">(.511, .666)</td>
  </tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr>
</table>

The simulations show that the point estimates for expected value of support for police permits for handgun purchases, given the explanatory variables (e.g. women/men, strong GOP, owns gun/does not own a gun) are above .500 in every application. Further, the 95% interval for all expected values from the simulations are above .500 in all but one category---men with strong GOP affiliation, no college education, and with a gun in the home. Among those men who strongly identify as Republicans, who do own a gun, and *are* college educated in the analysis, the expected value of support for police permits rises to a mean of .590 and a 95% distribution of expected values that are above .500.

Among the respondents in the analysis with the strongest conceivable affiliation with the Republican party, most still prefer gun control measures. I withhold simulations for the other five models I estimate, but the descriptive statistics below support a similar interpretation. Obviously, Republican support for making penalties for illegal gun sales *tougher* than penalties for selling illicit drugs is somewhat lukewarm. However, this constitutes a particularly difficult support for gun control scenario given the support for the "War on Drugs" we typically afford to strong Republicans.

<table style="text-align:center; padding-bottom: 20px"><caption><strong>Percentage of Respondents Supporting Various Gun Control Measures, by Party ID (2006)</strong></caption>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Party ID</td><td>Background Check for Private Sales?</td><td>Tougher Penalties than Selling Drugs?</td><td>Limit Semi-Automatics to Police/Military?</td><td>Illegal to Carry a Gun while Drunk?</td><td>Tougher Gun Control Laws after 9/11?</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Strong Dem.</td><td>80.65</td><td>67.20</td><td>90.86</td><td>88.71</td><td>91.40</td></tr>
<tr><td style="text-align:left">Not Strong Dem.</td><td>84.46</td><td>56.48</td><td>88.60</td><td>90.16</td><td>83.94</td></tr>
<tr><td style="text-align:left">Indep., lean Dem.</td><td>82.24</td><td>57.24</td><td>90.79</td><td>92.11</td><td>86.84</td></tr>
<tr><td style="text-align:left">Independent</td><td>74.76</td><td>56.19</td><td>86.19</td><td>90</td><td>82.86</td></tr>
<tr><td style="text-align:left">Indep., lean GOP</td><td>78.72</td><td>56.38</td><td>85.11</td><td>92.55</td><td>81.91</td></tr>
<tr><td style="text-align:left">Not Strong GOP</td><td>80.81</td><td>46.97</td><td>83.33</td><td>93.43</td><td>77.78</td></tr>
<tr style=" background-color: #f3f3f3; font-weight: bold"><td style="text-align:left">Strong GOP</td><td>79.87</td><td>51.68</td><td>80.54</td><td>89.93</td><td>73.15</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr></table>


## Gun Control Isn't Necessarily a Partisan Issue, but It's Becoming One

Most Republicans are on board with gun control measures. However, we are observing a growing rift between left and right on this issue that seems to occur entirely during the Obama Administration.

The table above that shows percentage of respondents supporting police permits before handgun purchases, by party identification and year, suggests such a rift that begins in 2010. Recall, the mixed effects models from the regression table allow for different year and region random effects. In the first model, they also allow the effect of party identification to vary by region and, in Model 1, by year.

A caterpillar plot of the random effects associated with Model 1 also shows this same effect.

{% include image.html url="/images/gss-m1-ranef.png" caption="A caterpillar plot of the random effects in Model 1 (support for police permits) with random intercept for year and random slope for party ID." width=1000 align="center" %}

I will defer a more exhaustive, technical interpretation of mixed effects models to canonical texts like those provided by [Douglas Luke](http://www.amazon.com/Multilevel-Modeling-Quantitative-Applications-Sciences/dp/0761928790) or [Andrew Gelman and Jennifer Hill](http://www.amazon.com/gp/product/052168689X/ref=pd_lpo_sbs_dp_ss_1?pf_rd_p=1944687602&pf_rd_s=lpo-top-stripe-1&pf_rd_t=201&pf_rd_i=0761928790&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=0CTVXVJCBW0Z6SVCKZSZ) (which is how I taught myself mixed effects modeling).[^5] For the casual reader, think of the random intercepts (here: year and region in Model 1) as different "starting points". Some years may have higher than "average" support or opposition to requiring police permits for handgun purchases. In addition, think about the random slope of party identification as saying that the effect of increasing partisanship with the GOP may be stronger in some years and regions than they were in other years or regions. It may also be weaker than average in some other years.

[^5]: If either Gelman or Hill stumble across this post, I hope they know I would love to get an updated version of this book though I don't think a second edition is in the work. Gelman, in particular, has since done great work with [Stan](http://mc-stan.org/). [The ensuing book](https://www.crcpress.com/Bayesian-Data-Analysis-Third-Edition/Gelman-Carlin-Stern-Dunson-Vehtari-Rubin/9781439840955) has largely incorporated those examples into this new framework.

That's what this caterpillar plot shows. Notice the intercepts for the years in the 1970s were below zero (i.e. the global mean from the data or "the national average"). That is, respondents in the 1970s and mid-1980s were *less* likely to support a law that required police permits in order to obtain a handgun when compared to the global average. Some of these years also include "confidence intervals" (of sorts) that do not overlap zero. In other words, we can say that respondents in 1987 (for example) were discernibly more against this particular gun control measure than respondents on average. This changes in 1989 and into the 1990s and 2000s. Overall, respondents were more likely to support this gun control measure during this time than citizens overall, on average.

I could not offer a substantive explanation for this phenomenon since it rests outside my expertise. If I had to guess, the 1970s were a period of such notoriously high crime that citizens may have wanted a gun for their own protection without needing police permission. The change around 1988 and 1989 coincides with the first Bush Administration. Crime became a prominent national political issue (from my early recollections) and led to several national initiatives (or, at least, discussions) that carried into the Clinton Administration.

The change around the Obama Administration coincides with prominent events like the [spike in gun sales after Obama's election in 2008](http://www.cnn.com/2008/CRIME/11/11/obama.gun.sales/). Notice too the change of party identification. On average, Republicans are less likely to support this gun control measure than those whose political affinities gravitate more to the Democratic Party. However, this caterpillar plot shows that the effect of GOP partisanship is *stronger* in 2014 than it is overall. The effect of GOP partisanship decreases support for gun control even more in 2014 in addition to the overall decrease in support for GOP partisanship on average.

Most Republicans actually support gun control measures and the issue at stake is not necessarily as polarizing at the individual-level as it is at the elite-level. However, it is rather quickly becoming a partisan issue among the electorate.

## The South is Peculiar, but Not in the Way You'd Expect

The casual observer might think this is more a function of respondents in the South. After all, most electoral votes rest in the South than any other region. Southerners, we think, tend to love their guns (for whatever purpose) and will elect politicians who will fight hard for their interpretation of the Second Amendment to the U.S. Constitution.

The truth is there is more happening in the South than meets the eye. A caterpillar plot for the random effects in Model 1 (not shown here) suggests that respondents in the South are, on average, less likely to support police permits for handgun purchases. However, the estimated intercept for the South is actually *greater* (i.e. closer to zero) than the estimated intercept for the West region. The intercepts for both are discernible from zero, but we have preliminary evidence that opposition to gun control may be more pronounced in the West than in the South.[^6]

[^6]: Respondents in the Northeast are much more likely to support police permits while the intercept for the Midwest is almost zero (i.e. the Midwest is indistinguishable from the global average).

However, the effect of GOP partisanship is *positive* in the South from 1972 to 2014. The more Republican the respondent is in the South from 1972 to 2014, the more likely that respondent supports requiring a police permit for handgun purchases. However, this might be a function of politics in the South before the sorting of the electorate. Notice the random effects for region from a model that includes just years from 1972 to 1993 and contrast it with a model that includes the years from 1994 to 2014. 

{% include image.html url="/images/gss-m1a-ranef.png" caption="A caterpillar plot of the random effects in Model 1 (support for police permits) with random intercept for region and random slope for party ID (1972-1993)." width=1000 align="center" %}

In years after the Republican Revolution, there is no discernible effect of GOP partisanship on support for police permits for handgun purchases in the South, nor is the South distinguishable from the other regions.

{% include image.html url="/images/gss-m1b-ranef.png" caption="A caterpillar plot of the random effects in Model 1 (support for police permits) with random intercept for region and random slope for party ID (1994-2014)." width=1000 align="center" %}

## Conclusion

We commonly believe the gun control debate to be a polarizing issue. However, data from the General Social Survey suggest that is not necessarily true. GOP partisanship does not robustly reduce support for gun control across all forms of gun control policies that could be considered by the general public. Further, most Republicans actually support gun control measures notwithstanding the negative relationship between GOP partisanship and support for gun control. However, the issue is quickly becoming a polarizing issue among the electorate, and it's likely not just the South that is responsible for that.

Code for this analysis is available [on my Github](https://github.com/svmiller/gss-guns).
