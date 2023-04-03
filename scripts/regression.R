################################################################################
##
## <PROJ> EDH7916: Inferential II: Regression and prediction
## <FILE> regression.R 
## <INIT> 24 March 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(haven)
library(survey)

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")

## -----------------------------------------------------------------------------
## Model data
## -----------------------------------------------------------------------------

## ---------------------------
## input data
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
df <- read_dta(file.path(dat_dir, "els_plans.dta"))

## ---------------------------
## linear model
## ---------------------------




## t-test of difference in math scores across parental education (BA/BA or not)
t.test(bynels2m ~ par_ba, data = df, var.equal = TRUE)

## compute same test as above, but in a linear model
fit <- lm(bynels2m ~ par_ba, data = df)
fit

## use summary to see more information about regression
summary(fit)

## add intercept and par_ba coefficient
fit$coefficients[["(Intercept)"]] + fit$coefficients[["par_ba"]]

## ------------
## lm w/terms
## ------------

## linear model with more than one covariate on the RHS
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
          data = df)
summary(fit)

## check number of observations
nobs(fit)

## see what fit object holds
names(fit)

## see first few fitted values and residuals
head(fit$fitted.values)
head(fit$residuals)

## see the design matrix
head(model.matrix(fit))

## ------------
## factors
## ------------

## check values of student expectations
df %>%
    count(bystexp)

## add factors
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba
          + lowinc + factor(bystexp),
          data = df)
summary(fit)

## same model, but use as_factor() instead of factor() to use labels
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba
          + lowinc + as_factor(bystexp),
          data = df)
summary(fit)

## see what R did under the hood to convert categorical to dummies
head(model.matrix(fit))

## ------------
## interactions
## ------------

## add interactions
fit <- lm(bynels2m ~ byses1 + factor(bypared)*lowinc, data = df)
summary(fit)

## ------------
## polynomials
## ------------

## add polynomials
fit <- lm(bynels2m ~ bynels2r + I(bynels2r^2), data = df)
summary(fit)

## ---------------------------
## generalized linear model
## ---------------------------

## logit
fit <- glm(plan_col_grad ~ bynels2m + as_factor(bypared),
           data = df,
           family = binomial())
summary(fit)

## probit
fit <- glm(plan_col_grad ~ bynels2m + as_factor(bypared),
           data = df,
           family = binomial(link = "probit"))
summary(fit)

## ---------------------------
## survey weights
## ---------------------------

## subset data
svy_df <- df %>%
    select(psu,                         # primary sampling unit
           strat_id,                    # stratum ID
           bystuwt,                     # weight we want to use
           bynels2m,                    # variables we want...
           moth_ba,
           fath_ba,
           par_ba,
           byses1,
           lowinc,
           female) %>%
    ## go ahead and drop observations with missing values
    drop_na()

## set svy design data
svy_df <- svydesign(ids = ~psu,
                    strata = ~strat_id,
                    weight = ~bystuwt,
                    data = svy_df,
                    nest = TRUE)

## fit the svyglm regression and show output
svyfit <- svyglm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
                 design = svy_df)
summary(svyfit)

## ------------
## predictions
## ------------

## predict from first model
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
          data = df)

## old data
fit_pred <- predict(fit, se.fit = TRUE)

## show options
names(fit_pred)
head(fit_pred$fit)
head(fit_pred$se.fit)

## create new data that has two rows, with averages and one marginal change

## (1) save model matrix
mm <- model.matrix(fit)
head(mm)

## (2) drop intercept column of ones (predict() doesn't need them)
mm <- mm[,-1]
head(mm)

## (3) convert to data frame so we can use $ notation in next step
mm <- as_tibble(mm)

## (4) new data frame of means where only lowinc changes
new_df <- tibble(byses1 = mean(mm$byses1),
                 female = mean(mm$female),
                 moth_ba = mean(mm$moth_ba),
                 fath_ba = mean(mm$fath_ba),
                 lowinc = c(0,1))

## see new data
new_df

## predict margins
predict(fit, newdata = new_df, se.fit = TRUE)

## =============================================================================
## END SCRIPT
################################################################################
