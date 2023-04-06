################################################################################
##
## <PROJ> EDH7916: Data wrangling with base R
## <FILE> dw_one_base_r.R 
## <INIT> 20 January 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

## NONE


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

## data are CSV, so we use read.csv(), which is base R function
df <- read.csv(file.path(dat_dir, "hsls_small.csv"))

## show first 10 rows
head(df, n = 10)

## show column types
sapply(df, class)

## ---------------------------
## process
## ---------------------------

## show value at row 1, col 4
df[1, 4]

## show value at row 1, x1stdob column
df[1, "x1stdob"]

## show values at row 1, stu_id & x1stdob column
df[1, c("stu_id", "x1stdob")]

## -----------------
## select
## -----------------

## select columns we need and assign to new object
df_tmp <- df[, c("stu_id", "x1stuedexpct", "x1paredexpct", "x1region")]

## show 10 rows
head(df_tmp, n = 10)

## -----------------
## mutate
## -----------------

## see unique values for student expectation
table(df_tmp$x1stuedexpct, useNA = "ifany")

## see unique values for parental expectation
table(df_tmp$x1paredexpct, useNA = "ifany")

## each version pulls the column of data for student expectations
## TRUE == 1, so if the mean of all values == 1, then all are TRUE
mean(df_tmp$x1stuedexpct == df_tmp[, "x1stuedexpct"]) == 1
mean(df_tmp$x1stuedexpct == df_tmp[["x1stuedexpct"]]) == 1

## replace student expectation values
df_tmp$x1stuedexpct[df_tmp$x1stuedexpct == -8] <- NA
df_tmp$x1stuedexpct[df_tmp$x1stuedexpct == 11] <- NA

## replace parent expectation values
df_tmp$x1paredexpct[df_tmp$x1paredexpct == -8] <- NA
df_tmp$x1paredexpct[df_tmp$x1paredexpct == -9] <- NA
df_tmp$x1paredexpct[df_tmp$x1paredexpct == 11] <- NA

## see unique values for student expectation (confirm changes)
table(df_tmp$x1stuedexpct, useNA = "ifany")

## see unique values for parental expectation (confirm changes)
table(df_tmp$x1paredexpct, useNA = "ifany")

## add new column
df_tmp$high_expct <- ifelse(df_tmp$x1stuedexpct > df_tmp$x1paredexpct, # test
                            df_tmp$x1stuedexpct,                       # if TRUE
                            df_tmp$x1paredexpct)                       # if FALSE

## show first 10 rows
head(df_tmp, n = 10)

## correct for NA values

## NB: We have to include [is.na(df_tmp$high_expct)] each time so that
## everything lines up

## step 1 student
df_tmp$high_expct[is.na(df_tmp$high_expct)] <- ifelse(
    ## test
    !is.na(df_tmp$x1stuedexpct[is.na(df_tmp$high_expct)]), 
    ## if TRUE do this...
    df_tmp$x1stuedexpct[is.na(df_tmp$high_expct)],
    ## ... else do that
    df_tmp$high_expct[is.na(df_tmp$high_expct)]
)

## step 2 parent
df_tmp$high_expct[is.na(df_tmp$high_expct)] <- ifelse(
    ## test
    !is.na(df_tmp$x1paredexpct[is.na(df_tmp$high_expct)]),
    ## if TRUE do this...
    df_tmp$x1paredexpct[is.na(df_tmp$high_expct)],
    ## ... else do that
    df_tmp$high_expct[is.na(df_tmp$high_expct)]
)

## show first 10 rows
head(df_tmp, n = 10)

## -----------------
## filter
## -----------------

## get summary of our new variable
table(df_tmp$high_expct, useNA = "ifany")

## filter in values that aren't missing
df_tmp <- df_tmp[!is.na(df_tmp$high_expct),]

## show first 10 rows
head(df_tmp, n = 10)

## is the original # of rows - current # or rows == NA in count?
nrow(df) - nrow(df_tmp)

## -----------------
## summarize
## -----------------

## get average (without storing)
mean(df_tmp$high_expct)

## check our census regions
table(df_tmp$x1region, useNA = "ifany")

## get average (assigning this time)
df_tmp <- aggregate(df_tmp["high_expct"],                # var of interest
                    by = list(region = df_tmp$x1region), # by group
                    FUN = mean)                          # function to run

## show
df_tmp

## -----------------
## arrange
## -----------------

## arrange from highest expectations (first row) to lowest
df_tmp <- df_tmp[order(df_tmp$high_expct, decreasing = TRUE),]

## show
df_tmp

## ---------------------------
## output
## ---------------------------

## write with useful name
write.csv(df_tmp, file.path(dat_dir, "high_expct_mean_region.csv"))

## -----------------------------------------------------------------------------
## end script
## -----------------------------------------------------------------------------
