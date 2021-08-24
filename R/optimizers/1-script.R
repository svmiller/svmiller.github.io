# Load libraries -----

library(tidyverse) # for most things
library(stevemisc) # helper functions/formatting
library(stevedata) # the data
library(lme4) # for mixed models

# Get some background info -----
my_cpu <- benchmarkme::get_cpu()
my_ram <- benchmarkme::get_ram()
my_sinfo <- devtools::session_info()

# Recode data -----
wvs_usa_abortion %>%
  mutate(ajd = carr(aj, "1=0; 2:10=1")) %>%
  # r2sd_at() is in {stevemisc}
  r2sd_at(c("age", "ideology", "satisfinancial", "cai", "godimportant")) -> Data


# Get boilerplate models -----
M1 <- lmer(aj ~ z_age + female + 
             z_ideology + z_satisfinancial + z_cai + z_godimportant + 
             (1 | year), data = Data,
           control=lmerControl(optimizer="bobyqa",
                               optCtrl=list(maxfun=2e5)))
M2 <- glmer(ajd ~ z_age + female + 
              z_ideology + z_satisfinancial + z_cai + z_godimportant + 
              (1 | year), data = Data, family=binomial(link="logit"),
            control=glmerControl(optimizer="bobyqa",
                                 optCtrl=list(maxfun=2e5)))

# Linear times ----
linear_times <- tibble()

for (i in 1:100) {
  AF1 <- allFit(M1, verbose=F)
  hold_this <- cbind(as.data.frame(summary(AF1)$times), rownames(summary(AF1)$times)) %>% as_tibble() %>% mutate(iter = i)
  linear_times <- bind_rows(linear_times, hold_this)
  
}

linear_times %>%
  select(iter, everything()) %>%
  rename(optimizer = ncol(.)) -> linear_times

# Logit times -----
logit_times <- tibble()

for (i in 1:100) {
  AF2 <- allFit(M2, verbose=F)
  hold_this <- cbind(as.data.frame(summary(AF2)$times), rownames(summary(AF2)$times)) %>% as_tibble() %>% mutate(iter = i)
  logit_times <- bind_rows(logit_times, hold_this)
  
}

logit_times %>%
  select(iter, everything()) %>%
  rename(optimizer = ncol(.)) -> logit_times

list("my_cpu" = my_cpu,
     "my_ram" = my_ram,
     "my_sinfo" = my_sinfo,
     "linear_times" = linear_times,
     "logit_times" = logit_times) -> optimizer_data

saveRDS(optimizer_data, "~/Dropbox/svmiller.github.io/R/optimizers/optimizer_data.rds")
