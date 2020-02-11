################################################################################
##
## <PROJ> EDH7916: Data Wrangling III: Working with strings and dates
## <FILE> dw_three.R 
## <INIT> 10 February 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################


## ---------------------------
## libraries
## ---------------------------

## NB: The {stringr} library is loaded with {tidyverse}, but
## {lubridate} is not, so we need to load it separately

library(tidyverse)
library(lubridate)

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")

## ---------------------------
## input
## ---------------------------

## read in data and lower all names using rename_all(tolower)
df <- read_csv(file.path(dat_dir, "hd2007.csv")) %>%
    rename_all(tolower)

## -----------------------------------------------------------------------------
## Working with strings
## -----------------------------------------------------------------------------

## filter using state abbreviation (not saving, just viewing)
df %>%
    filter(stabbr == "FL")

## see first few rows of distinct chief titles
df %>%
    distinct(chftitle)


## return the most common titles
df %>%
    ## get counts of each type
    count(chftitle) %>%
    ## arrange in descending order so we see most popular at top
    arrange(desc(n))

## how many use some form of the title president?
df %>%
    ## still starting with our count
    count(chftitle) %>%
    ## ...but keeping only those titles that contain "President"
    filter(str_detect(chftitle, "President")) %>%
    ## arranging as before
    arrange(desc(n))


## solution 1: look for either P or p
df %>%
    count(chftitle) %>%
    filter(str_detect(chftitle, "[Pp]resident")) %>%
    arrange(desc(n))


## solution 2: make everything lowercase so that case doesn't matter
df %>%
    count(chftitle) %>%
    filter(str_detect(str_to_lower(chftitle), "president")) %>%
    arrange(desc(n))


## show first few zip code values
df %>%
    select(unitid, zip)

## pull out first 5 digits of zip code
df <- df %>%
    mutate(zip5 = str_sub(zip, start = 1, end = 5))

## show (use select() to subset so we can set new columns)
df %>%
    select(unitid, zip, zip5)

## drop last four digits of extended zip code if they exist
df <- df %>%
    mutate(zip5_v2 = str_replace(zip, "([0-9]+)(-[0-9]+)?", "\\1"))

## show (use select() to subset so we can set new columns)
df %>%
    select(unitid, zip, zip5, zip5_v2)

## check if both versions of new zip column are equal
identical(df %>% select(zip5), df %>% select(zip5_v2))

## filter to rows where zip5 != zip5_v2 (not storing...just looking)
df %>%
    filter(zip5 != zip5_v2) %>%
    select(unitid, zip, zip5, zip5_v2)


## -----------------------------------------------------------------------------
## Working with dates
## -----------------------------------------------------------------------------


## subset to schools who closed during this period
df <- df %>%
    filter(closedat != -2)

## show first few rows
df %>% select(unitid, instnm, closedat)


## create a new close date column 
df <- df %>%
    mutate(closedat_dt = mdy(closedat))

## show
df %>% select(starts_with("close"))

## convert MON-YYYY to MON-01-YYYY
df <- df %>%
    mutate(closedat_fix = str_replace(closedat, "-", "-01-"),
           closedat_fix_dt = mdy(closedat_fix))

## show
df %>% select(starts_with("close"))                                

## add columns for
## - year
## - month
## - day
## - day of week (dow)
df <- df %>%
    mutate(close_year = year(closedat_fix_dt),
           close_month = month(closedat_fix_dt),
           close_day = day(closedat_fix_dt),
           close_dow = wday(closedat_fix_dt, label = TRUE))
## show
df %>%
    select(closedat_fix_dt, close_year, close_month, close_day, close_dow)

## how long since the institution closed
## - as of 1 January 2020
## - as of today
df <- df %>%
    mutate(time_since_close_jan = ymd("2020-01-01") - closedat_fix_dt,
           time_since_close_now = today() - closedat_fix_dt)

## show
df %>% select(starts_with("time_since_close"))

## -----------------------------------------------------------------------------
## end script
################################################################################
