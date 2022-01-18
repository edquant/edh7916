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

## data are CSV, so we use read_csv() from the readr library
df <- read_csv(file.path(dat_dir, "hsls_small.csv"))

## ---------------------------
## process
## ---------------------------

## -----------------
## select
## -----------------

## select columns we need and assign to new object
df_tmp <- select(df, stu_id, x1stuedexpct, x1paredexpct, x1region)

## show
df_tmp

## -----------------
## mutate
## -----------------

## see unique values for student expectation
count(df_tmp, x1stuedexpct)

## see unique values for parental expectation
count(df_tmp, x1paredexpct)

## use case_when to overwrite -8 and 11 with NA in our two expectation variables
df_tmp <- mutate(df_tmp,
                 ## correct student expectations 
                 x1stuedexpct = ifelse(x1stuedexpct < 0,   # is value < 0?
                                       NA,                 # T: replace with NA
                                       x1stuedexpct),      # F: replace with self
                 x1stuedexpct = ifelse(x1stuedexpct == 11, # is value == 11?
                                       NA,                 # T: replace with NA
                                       x1stuedexpct),      # F: replace with self
                 ## correct parental expectations
                 x1paredexpct = ifelse(x1paredexpct < 0,   # (same as above...)
                                       NA,                 
                                       x1paredexpct),       
                 x1paredexpct = ifelse(x1paredexpct == 11,
                                       NA,
                                       x1paredexpct))

## again see unique values for student expectation
count(df_tmp, x1stuedexpct)

## again see unique values for parental expectation
count(df_tmp, x1paredexpct)

## mutate (notice that we use df_tmp now)
df_tmp <- mutate(df_tmp,
                 high_expct = ifelse(x1stuedexpct > x1paredexpct, # test
                                     x1stuedexpct,                # if TRUE
                                     x1paredexpct))               # if FALSE

## show
df_tmp

## correct for NA values
df_tmp <- mutate(df_tmp,
                 ## step 1: compare with student's expectations
                 high_expct = ifelse(is.na(high_expct) & !is.na(x1stuedexpct), 
                                     x1stuedexpct,                
                                     high_expct),
                 ## step 2: compare with parent's expectations
                 high_expct = ifelse(is.na(high_expct) & !is.na(x1paredexpct), 
                                     x1paredexpct,                
                                     high_expct))               

## show
df_tmp

## -----------------
## filter
## -----------------

## get summary of our new variable
count(df_tmp, high_expct)

## filter out missing values
df_tmp <- filter(df_tmp, !is.na(high_expct))

## show
df_tmp

## is the original # of rows - current # or rows == NA in count?
nrow(df) - nrow(df_tmp)

## -----------------
## summarize
## -----------------

## get average (without storing)
summarize(df_tmp, high_expct_mean = mean(high_expct))

## check our census regions
count(df_tmp, x1region)

## get expectations average within region
df_tmp <- group_by(df_tmp, x1region)

## show grouping
df_tmp

## get average (assigning this time)
df_tmp <- summarize(df_tmp, high_expct_mean = mean(high_expct))

## show
df_tmp

## -----------------
## arrange
## -----------------

## arrange from highest expectations (first row) to lowest
df_tmp <- arrange(df_tmp, desc(high_expct_mean))

## show
df_tmp

## ---------------------------
## output
## ---------------------------

## write with useful name
write_csv(df_tmp, file.path(dat_dir, "high_expct_mean_region.csv"))

## ---------------------------
## appendix
## ---------------------------

## Let's redo the analysis above, but with a fully chained set of
## functions.


## start with the original data frame...
df_tmp_chained <- df %>%
    ## (df is piped in): select the columns we want
    select(stu_id, x1stuedexpct, x1paredexpct, x1region) %>%
    ## (selected df is piped in): mutate our data, starting with missing
    mutate(x1stuedexpct = ifelse(x1stuedexpct < 0,   
                                 NA,                 
                                 x1stuedexpct),      
           x1stuedexpct = ifelse(x1stuedexpct == 11, 
                                 NA,                 
                                 x1stuedexpct),      
           x1paredexpct = ifelse(x1paredexpct < 0,   
                                 NA,                 
                                 x1paredexpct),       
           x1paredexpct = ifelse(x1paredexpct == 11,
                                 NA,
                                 x1paredexpct),
           ## create new column
           high_expct = ifelse(x1stuedexpct > x1paredexpct, 
                               x1stuedexpct,                
                               x1paredexpct),
           ## fix new column NAs
           high_expct = ifelse(is.na(high_expct) & !is.na(x1stuedexpct), 
                               x1stuedexpct,                
                               high_expct),
           high_expct = ifelse(is.na(high_expct) & !is.na(x1paredexpct), 
                               x1paredexpct,                
                               high_expct)) %>%
    ## (mutated df is piped in): filter in non-missing rows
    filter(!is.na(high_expct)) %>%
    ## (filtered df is piped in): group by region
    group_by(x1region) %>%
    ## (grouped df is piped in): summarize mean expectations
    summarize(high_expct_mean = mean(high_expct)) %>%
    ## (summarized df is piped in): arrange average expectations hi --> lo
    arrange(desc(high_expct_mean))         

## show
df_tmp_chained

## test using identical()
identical(df_tmp, df_tmp_chained)

## -----------------------------------------------------------------------------
## end script
## -----------------------------------------------------------------------------
