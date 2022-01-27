library(stevemisc)
library(tidyverse)
library(foreach)       # for some parallel magic
library(nortest)

half_cores  <- parallel::detectCores()/2
library(foreach)
my.cluster <- parallel::makeCluster(
  half_cores,
  type = "PSOCK"
)

doParallel::registerDoParallel(cl = half_cores)
foreach::getDoParRegistered()

set.seed(8675309)
Sims <- foreach(
  i = 1:1000,
  .combine = 'rbind'
) %:%
  foreach(nobs = c(10, 25, 50, 100, 400, 1000, 3000),
          .combine = 'rbind') %:%
  foreach(dfs = c(1:100, 1000),
          .combine = 'rbind') %dopar% {
    hold_this <- rst(nobs, dfs, 0, 1)
    ks <- broom::tidy(ks.test(hold_this, "pnorm", 0, 1)) %>% mutate(n = nobs, df = dfs, method = "K-S")
    sw <- broom::tidy(shapiro.test(hold_this)) %>% mutate(n = nobs, df = dfs, method = "S-W")
    ad <- broom::tidy(ad.test(hold_this)) %>% mutate(n = nobs, df = dfs, method = "A-D")
    binded <- bind_rows(ks, sw, ad) %>% select(-alternative) %>% mutate(iter = i)
  } 
parallel::stopCluster(cl = my.cluster) # close our clusters


saveRDS(Sims, "~/Dropbox/svmiller.github.io/R/t-normal/t-normal-sims.rds")
