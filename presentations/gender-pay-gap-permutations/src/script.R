library(tidyverse)
library(stevedata) # development for now (on Github) because of adding wrkstat to gss_wages
library(MatchIt)
library(modelr)
library(kableExtra)

gss_wages %>%
  mutate(married = ifelse(maritalcat == "Married", 1, 0),
         collegeed = ifelse(educcat %in% c("Bachelor", "Graduate"), 1, 0),
         female = ifelse(gender == "Female", 1, 0),
         prestgf = floor((prestg10)/10)) %>%
  filter(year >= 2010 & married == 0 & childs == 0 & wrkstat == "Full-Time") %>% na.omit -> wages10

# https://www.inflationtool.com/us-dollar/1986-to-present-value#:~:text=The%20inflation%20rate%20in%20the,in%201986%20equals%20$235.53%20today.
wages10 %>%
  mutate(realrinc20 = floor(realrinc*(108.42/46.11))) -> wages10



wages10_matched <- matchit(female ~ age + prestgf + collegeed,
        data = wages10,
        method = "nearest",
        distance = "mahalanobis",
        replace = F)


wages10_matched <- match.data(wages10_matched)

saveRDS(wages10_matched, "~/Dropbox/svmiller.github.io/presentations/gender-pay-gap-permutations/data/wages10_matched.rds")

set.seed(8675309)
wages10_matched %>%
  permute(10000, realrinc20) -> Perms

# saveRDS(Perms, "~/Dropbox/svmiller.github.io/presentations/gender-pay-gap-permutations/data/Perms.rds")


Perms %>% 
  mutate(ttests = map(perm, ~broom::tidy(t.test(realrinc20 ~ gender, data = .)))) %>% 
  pull(ttests) %>% map2_df(., seq(1, 10000), ~mutate(.x, perm = .y)) %>%
  select(perm, everything()) -> perm_ttests

saveRDS(perm_ttests, "~/Dropbox/svmiller.github.io/presentations/gender-pay-gap-permutations/data/perm_ttests.rds")

