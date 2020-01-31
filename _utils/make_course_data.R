################################################################################
##
## <PROJ> EDH7916
## <FILE> make_course_data.R
## <INIT> 20 January 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## libraries
library(tidyverse)

## paths
dat_dir <- file.path("..", "data")
sch_dir <- file.path(dat_dir, "sch_test")
bys_dir <- file.path(sch_dir, "by_school")

## HSLS 2009: make smaller -----------------------------------------------------

## vars to keep
cols <- cols_only(STU_ID = col_integer(),
                  X1SEX = col_integer(),
                  X1RACE = col_integer(),
                  X1STDOB = col_integer(),
                  X1TXMTSCOR = col_double(),
                  X1PAREDU = col_integer(),
                  X1HHNUMBER = col_integer(),
                  X1FAMINCOME = col_integer(),
                  X1POVERTY185 = col_integer(),
                  X1SES = col_double(),
                  X1STUEDEXPCT = col_integer(),
                  X1PAREDEXPCT = col_integer(),
                  X1REGION = col_integer(),
                  X4HSCOMPSTAT = col_integer(),
                  X4EVRATNDCLG = col_integer(),
                  X4HS2PSMOS = col_integer())

## read / munge
df <- read_csv(file.path(dat_dir, "hsls_16_student_v1_0.csv"),
               col_types = cols) %>%
    rename_all(tolower)

## write
write_csv(df, file.path(dat_dir, "hsls_small.csv"))

## data sets for reshape -------------------------------------------------------

sch_names <- c("Bend Gate","East Heights","Niagara","Spottsville")

## create main long list
df <- data.frame(school = rep(sch_names, each = 3 * 6),
                 year = rep(rep(1980:1985, 4), each = 3),
                 test = rep(c("math","read","science"), 6 * 4),
                 score = as.integer(round(c(rbind(rnorm(6 * 4, 500, 10),
                                                  rnorm(6 * 4, 300, 20),
                                                  rnorm(6 * 4, 800, 15))))),

                 stringsAsFactors = FALSE) %>%
    tbl_df()

## make partial wide
df_wide <- df %>%
    pivot_wider(names_from = test,
                values_from = score)

## make full wide
df_full_wide <- df %>%
    pivot_wider(names_from = c(test, year),
                values_from = score)

## -----------------
## write
## -----------------

## write partial wide
write_csv(df_wide, file.path(sch_dir, "all_schools.csv"))

## write full wide
write_csv(df_full_wide, file.path(sch_dir, "all_schools_wide.csv"))

## split into school by year with test wide and write
walk(sch_names,
     ~ walk(1980:1985,
            ~ write_csv(df %>%
                        filter(school == .y, year == .x) %>%
                        pivot_wider(names_from = test,
                                    values_from = score),
                        file.path(bys_dir,
                                  paste0(gsub(" ",
                                              "_",
                                              tolower(.y)),
                                         "_",
                                         .x,
                                         ".csv"))),
            .y = .x))

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
