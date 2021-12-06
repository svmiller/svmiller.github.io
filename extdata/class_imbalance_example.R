library(tidyverse)
library(stevemisc) # for gvi()

ESS9 <- haven::read_sav("~/Dropbox/data/ess/ESS9e01_2.sav")

# ESS9 %>%
#   filter(cntry == "GB") %>% labelled::var_label() -> Labels
# 
# 
# Labels %>% bind_rows() %>%
#   gather(var, val) %>%
#   write_csv(., "data-raw/ess9gb-labels.csv")

ESS9 %>%
  filter(cntry == "GB" &  brncntr == 1 & blgetmg == 2) %>%
  select(cntry, idno, region, essround, edition, brncntr, blgetmg,
         # select the outcome we want to explain
         dscrrce,
         # Basic demographic stuff: age, gender, eduyrs, household income, marital status
         agea, gndr, eduyrs, hinctnta, marsts,
         # trust indicators: most people can be trusted, take advantage of you, or mostly helpful
         ppltrst, pplfair, pplhlp,
         # political interest, voted last national election, would vote to remain member of EU or leave,
         # party voted for last election, party closest to, ideology scale
         polintr, vote, vteumbgb, prtvtcgb, prtclcgb, lrscale,
         # how emotionally attached to country, how emotionally attached to Europe
         atchctr, atcherp,
         # immigration bad/good for economy, cultural life enriched, immigrants make country worse
         imbgeco, imueclt, imwbcnt, 
         # ashamed if close family was gay/lesbian, gay and lesbian couples free to live life, gay couples right to adopt
         hmsfmlsh, freehms, hmsacld,
         # how religious are you
         rlgdgr) %>%
  mutate(region = as_factor(region),
         prtvtcgb = as_factor(prtvtcgb),
         prtclcgb = as_factor(prtclcgb)) -> class_imbalance_example

class_imbalance_example %>% 
  mutate(female = gndr - 1,
         marital_status = case_when(
           marsts == 1 ~ "Married",
           marsts == 2 ~ "Civil union",
           marsts == 3 ~ "Separated",
           marsts == 4 ~ "Divorced",
           marsts == 5 ~ "Widowed",
           marsts == 6 ~ "None of these"
         ),
         last_voted = case_when(
           vote == 1 ~ "Yes",
           vote == 2 ~ "No",
           vote == 3 ~ "Not eligible",
         ),
         hypothetical_eu_vote = ifelse(vteumbgb > 2, NA, vteumbgb),
         would_vote_remain = ifelse(vteumbgb == 1, 1, 0),
         would_vote_leave = ifelse(vteumbgb == 2, 1, 0),
         voted_tory = ifelse(prtvtcgb == "Conservative", 1, 0),
         voted_labour = ifelse(prtvtcgb == "Labour", 1, 0),
         voted_libdem = ifelse(prtvtcgb == "Liberal Democrat", 1, 0),
         voted_snp = ifelse(prtvtcgb == "Scottish National Party", 1, 0),
         voted_ukip = ifelse(prtvtcgb == "UK Independence Party", 1, 0)) %>%
  haven::zap_labels() -> class_imbalance_example

saveRDS(class_imbalance_example, "extdata/class_imbalance_example.rds")
