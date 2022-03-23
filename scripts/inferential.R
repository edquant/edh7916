################################################################################
##
## <PROJ> EDH7916: Inferential I
## <FILE> inferential.R 
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
## correlation
## ---------------------------

## correlation between math and reading scores
cor(df$bynels2m, df$bynels2r, use = "complete.obs")

## correlation between various columns, using pipes
df %>%
    ## select a few variables
    select(byses1, bynels2m, bynels2r, par_ba) %>%
    ## use a . to be the placeholder for the piped in data.frame
    cor(., use = "complete.obs")

## ---------------------------
## t-test
## ---------------------------



## t-test of difference in math scores across parental education (BA/BA or not)
t.test(bynels2m ~ par_ba, data = df)

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

## compare unweighted and survey-weighted mean of math scores
df %>% summarise(bynels2m_m = mean(bynels2m, na.rm = TRUE))
svymean(~bynels2m, design = svy_df, na.rm = TRUE)

## get svymeans by group
svyby(~bynels2m, by = ~par_ba, design = svy_df, FUN = svymean, na.rm = TRUE)

## t-test using survey design / weights
svyttest(bynels2m ~ par_ba, design = svy_df)

## =============================================================================
## END SCRIPT
################################################################################
