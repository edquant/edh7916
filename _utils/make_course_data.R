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
