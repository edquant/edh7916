################################################################################
##
## <PROJ> EDH7916: Data Wrangling I: Enter the {tidyverse}
## <FILE> dw_one.R 
## <INIT> 20 January 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")

## -----------------------------------------------------------------------------
## Wrangle data
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

## data are CSV, so we use readr::read_csv()
df <- read_csv(file.path(dat_dir, "hsls_small.csv"))

## ---------------------------
## process
## ---------------------------

## select
df_tmp <- select(df, stu_id, x1stuedexpct, x1paredexpct, x1region)

## show
df_tmp

## mutate (notice that we use df_tmp now)
df_tmp <- mutate(df_tmp, high_expct = ifelse(x1stuedexpct > x1paredexpct, x1stuedexpct, x1paredexpct))

## show
df_tmp

## get summary of our new variable
table(df_tmp$high_expct)


## filter out missing values
df_tmp <- filter(df_tmp, high_expct != -8)

## notice the number of rows now:
## do they equal the first number minus the number of NAs from our table command?
df_tmp

## get average (without storing)
summarize(df_tmp, high_expct_mean = mean(high_expct))


## check our census regions
table(df_tmp$x1region)

## get expectations average within region
df_tmp <- group_by(df_tmp, x1region)

## show grouping
df_tmp

## get average (without storing)
df_tmp <- summarize(df_tmp, high_expct_mean = mean(high_expct))

## show
df_tmp

## arrange from highest expectations (first row) to lowest
df_tmp <- arrange(df_tmp, desc(high_expct_mean))

## show
df_tmp

## ---------------------------
## output
## ---------------------------

## write with useful name
write_csv(df_tmp, file.path(dat_dir, "high_expct_mean_region.csv"))

## pipe the original data frame into select
df_tmp_2 <- df %>%
    select(stu_id, x1stuedexpct, x1paredexpct, x1region)

## show
df_tmp_2

## same as before, but add mutate()
df_tmp_2 <- df %>%
    ## vars to select
    select(stu_id, x1stuedexpct, x1paredexpct, x1region) %>%
    ## vars to add
    mutate(high_expct = ifelse(x1stuedexpct > x1paredexpct, # test
                               x1stuedexpct,                # if TRUE
                               x1paredexpct))               # if FALSE

## show
df_tmp_2
