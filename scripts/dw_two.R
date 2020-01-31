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

## data are CSV, so we use read_csv()
df_1 <- read_csv(file.path(bys_dir, "bend_gate_1980.csv"))
df_2 <- read_csv(file.path(bys_dir, "bend_gate_1981.csv"))
df_3 <- read_csv(file.path(bys_dir, "bend_gate_1982.csv"))

## -----------------------------------------------------------------------------
## Join data
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Reshape data
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

## data are CSV, so we use read_csv()
df <- read_csv(file.path(sch_dir, "all_schools.csv"))



## ---------------------------
## input
## ---------------------------

## data are CSV, so we use read_csv()
df <- read_csv(file.path(sch_dir, "all_schools_wide.csv"))



## -----------------------------------------------------------------------------
## end script
## -----------------------------------------------------------------------------
