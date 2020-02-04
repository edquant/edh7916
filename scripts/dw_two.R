################################################################################
##
## <PROJ> EDH7916: Data wrangling II: Appending, joining, and reshaping data
## <FILE> dw_two.R 
## <INIT> 31 January 2020
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
sch_dir <- file.path(dat_dir, "sch_test")
bys_dir <- file.path(sch_dir, "by_school")

## -----------------------------------------------------------------------------
## Append data
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

## read in data
df_1 <- read_csv(file.path(bys_dir, "bend_gate_1980.csv"))
df_2 <- read_csv(file.path(bys_dir, "bend_gate_1981.csv"))
df_3 <- read_csv(file.path(bys_dir, "bend_gate_1982.csv"))

## ---------------------------
## process
## ---------------------------

## show
df_1
df_2
df_3

## append files
df <- bind_rows(df_1, df_2, df_3)

## show
df

## -----------------------------------------------------------------------------
## Join data
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

## read in data
df <- read_csv(file.path(sch_dir, "all_schools.csv"))

## show
df

## ---------------------------
## process
## ---------------------------

## get test score summary within year
df_sum <- df %>%
    group_by(year) %>%
    summarize(math_m = mean(math),
              read_m = mean(read),
              science_m = mean(science))

## show
df_sum


df_joined <- df %>%
    left_join(df_sum, by = "year")

## show
df_joined

## -----------------------------------------------------------------------------
## Reshape data
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

## reading again just to be sure we have the original data
df <- read_csv(file.path(sch_dir, "all_schools.csv"))

## ---------------------------
## process
## ---------------------------

## wide to long
df_long <- df %>%
    pivot_longer(cols = c("math","read","science"),
                 names_to = "test",
                 values_to = "score")

## show
df_long

## ---------------------------
## process
## ---------------------------

## long to wide
df_wide <- df_long %>%
    pivot_wider(names_from = "test",
                values_from = "score")

## show
df_wide

## ---------------------------
## input
## ---------------------------

## read in very wide test score data
df <- read_csv(file.path(sch_dir, "all_schools_wide.csv"))

## show
df

## ---------------------------
## process
## ---------------------------

## wide to long
df_long <- df %>%
    pivot_longer(cols = contains("19"),
                 names_to = "test_year",
                 values_to = "score")

## show
df_long

## separate test_year into two columns, filling appropriately
df_long_fix <- df_long %>%
    separate(col = "test_year",
             into = c("test", "year"),
             sep = "_")

## show
df_long_fix

## -----------------------------------------------------------------------------
## end script
## -----------------------------------------------------------------------------
