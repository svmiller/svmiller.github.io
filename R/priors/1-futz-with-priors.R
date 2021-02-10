library(tidyverse)
library(brms)
library(stevedata)
library(tidybayes)
library(stevemisc)

fct_reorg <- function(fac, ...) {
  fct_recode(fct_relevel(fac, ...), ...)
}

# https://discourse.mc-stan.org/t/default-student-t-priors-in-brms/17197/8

# the cocksure prior stuff first ----

B0 <- brm(immigsent ~ agea + female + eduyrs + uempla + hinctnta + lrscale,
          data = ESS9GB,
          seed = 8675309,
          family = gaussian())


cocksure_prior <- c(set_prior("normal(-2.12,1.26)", class="b", coef="uempla"))

B1 <- brm(immigsent ~ agea + female + eduyrs + uempla + hinctnta + lrscale,
          data = ESS9GB,
          seed = 8675309,
          prior = cocksure_prior,
          family = gaussian())

B0 %>%
  tidy_draws() %>%
  select(.chain:b_lrscale) %>%
  group_by(.chain, .iteration, .draw) %>%
  gather(var, val, b_Intercept:ncol(.)) %>%
  ungroup() %>%
  mutate(cat = "Default/Flat Prior") -> tidyB0


B1 %>%
  tidy_draws() %>%
  select(.chain:b_lrscale) %>%
  group_by(.chain, .iteration, .draw) %>%
  gather(var, val, b_Intercept:ncol(.)) %>%
  ungroup() %>%
  mutate(cat = "Cocksure Prior (for Unemployment Coefficient)")  -> tidyB1


bind_rows(tidyB0, tidyB1) -> tidyB01

saveRDS(tidyB01, "R/priors/tidyB01.rds")

  group_by(cat, var) %>%
  summarize(mean = mean(val),
            sd = sd(val),
            lwr = quantile(val, .05),
            upr = quantile(val, .95)) %>%
  filter(var != "b_Intercept") %>%
  mutate(var = fct_reorg(var,
                         "Age"="b_agea",
                         "Education (in Years)" = "b_eduyrs")) %>%
  ggplot(.,aes(var, mean, ymin=lwr, ymax=upr)) +
  theme_steve_web() + post_bg() +
  facet_wrap(~cat) +
  coord_flip() +
  geom_pointrange() +
  geom_hline(yintercept = 0, linetype="dashed")

  
# forms and priors -----
  
lazy_priors_normal <- c(set_prior("normal(0,1)", class = "b", coef= "left"),
                        set_prior("normal(0,1)", class = "b", coef="size"),
                        set_prior("normal(0,1)", class="b", coef="concen"),
                        set_prior("normal(0,1)", class="Intercept"),
                        set_prior("normal(0,1)", class="sigma"))


lazy_priors_vague <- c(set_prior("normal(0,10^6)", class = "b", coef= "left"),
                         set_prior("normal(0,10^6)", class = "b", coef="size"),
                         set_prior("normal(0,10^6)", class="b", coef="concen"),
                         set_prior("normal(0,10^6)", class="Intercept"),
                         set_prior("normal(0, 10^6)", class="sigma"))

# go-go-gadget rstan priors...
# per p. 124 of Gelman et al. (2020), you're doing a lot of 2.5*sd_y/sd_x here on normal with mean 0.
# exception: the default prior on sigma is from an exponential distribution where rate = (1/sd_y)
# also: y-intercept = mean(y), 2.5(sd_y)
# Let's make sure we know what we're doing here...

uniondensity %>%
  summarize(sd_y = sd(union),
            mean_y = mean(union),
            sd_y25 = sd_y*2.5,
            sd_left = 2.5*sd_y/sd(left),
            sd_size = 2.5*sd_y/sd(size),
            sd_concen = 2.5*sd_y/sd(concen),
            rate_sigma = 1/sd_y) %>% data.frame

rstan_priors <- c(set_prior("normal(0,1.39)", class = "b", coef= "left"),
                  set_prior("normal(0,28.85)", class = "b", coef="size"),
                  set_prior("normal(0,145.09)", class="b", coef="concen"),
                  set_prior("normal(54.06, 46.88)", class="Intercept"),
                  set_prior("exponential(0.05)", class="sigma"))




reasonable_priors <- c(set_prior("normal(0,.32)", class = "b", coef= "left"),
                       set_prior("normal(0,4.84)", class = "b", coef="size"),
                       set_prior("normal(0,15.5)", class="b", coef="concen"),
                       set_prior("normal(50, 25)", class="Intercept"),
                       set_prior("exponential(.05)", class="sigma"))


# Models -----

m_lazynormal <- brm(brmform,
                    prior=lazy_priors_normal,
                    data = uniondensity,
                    seed = 8675309,
                    family="gaussian")


m_lazyvague <- brm(brmform,
                    prior=lazy_priors_vague,
                    data = uniondensity,
                   seed = 8675309,
                    family="gaussian")


m_brms <- brm(brmform,
              data = uniondensity,
              seed = 8675309,
              family="gaussian")

m_rstan <- brm(brmform,
               prior=rstan_priors,
               data = uniondensity,
               seed = 8675309,
               family="gaussian")

m_reasonable <- brm(brmform,
                    prior=reasonable_priors,
                    data = uniondensity,
                    seed = 8675309,
                    family="gaussian")


# Get summaries ----

m_lazynormal %>%
  spread_draws(b_Intercept, b_left, b_size, b_concen) %>%
  gather(variable, value, b_Intercept:b_concen) %>%
  group_by(variable) %>%
  summarize(mean = mean(value),
            sd = sd(value),
            lwr = quantile(value, .05),
            upr = quantile(value, .95)) %>%
  mutate(prior = "Lazy Normal(0,1) Priors") -> sum_m_lazynormal

m_lazyvague %>%
  spread_draws(b_Intercept, b_left, b_size, b_concen) %>%
  gather(variable, value, b_Intercept:b_concen) %>%
  group_by(variable) %>%
  summarize(mean = mean(value),
            sd = sd(value),
            lwr = quantile(value, .05),
            upr = quantile(value, .95)) %>%
  mutate(prior = "Lazy (Vague) Normal(0,10^6) Priors") -> sum_m_lazyvague


m_rstan  %>%
  spread_draws(b_Intercept, b_left, b_size, b_concen) %>%
  gather(variable, value, b_Intercept:b_concen) %>%
  group_by(variable) %>%
  summarize(mean = mean(value),
            sd = sd(value),
            lwr = quantile(value, .05),
            upr = quantile(value, .95)) %>%
  mutate(prior = "{rstanarm} Priors") -> sum_m_rstan

m_brms %>%
  spread_draws(b_Intercept, b_left, b_size, b_concen) %>%
  gather(variable, value, b_Intercept:b_concen) %>%
  group_by(variable) %>%
  summarize(mean = mean(value),
            sd = sd(value),
            lwr = quantile(value, .05),
            upr = quantile(value, .95)) %>%
  mutate(prior = "{brms} Priors") -> sum_m_brms


m_reasonable  %>%
  spread_draws(b_Intercept, b_left, b_size, b_concen) %>%
  gather(variable, value, b_Intercept:b_concen) %>%
  group_by(variable) %>%
  summarize(mean = mean(value),
            sd = sd(value),
            lwr = quantile(value, .05),
            upr = quantile(value, .95)) %>%
  mutate(prior = "Reasonable Ignorance Priors") -> sum_m_reasonable

m_sums <- bind_rows(sum_m_lazynormal, sum_m_lazyvague,
                    sum_m_rstan, sum_m_brms,
                    sum_m_reasonable)


saveRDS(m_sums, "R/priors/m_sums.rds")
