################################################################################
##
## [ PROJ ] EDH 7916: Organization
## [ FILE ] organizing.R
## [ AUTH ] Benjamin Skinner (@btskinner)
## [ INIT ] 13 January 2020
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)

## ---------------------------
## directory paths
## ---------------------------

dat_dir <- file.path("..", "data")
fig_dir <- file.path("..", "figures")

## ---------------------------
## settings/macros
## ---------------------------

old_to_new_score_ratio <- 1.1

## ---------------------------
## functions
## ---------------------------

old_to_new_score <- function(test_score) {
    return(test_score * old_to_new_score_ratio)
}

## -----------------------------------------------------------------------------
## BODY
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

df <- readRDS(file.path(dat_dir, "test_scores.RDS"))

## ---------------------------
## process
## ---------------------------

## add a column for new test score
## format: <data.frame>$<new_scores_column> <- function(<old_scores_column>)
df$test_scores_new <- old_to_new_score(df$test_score)

## ---------------------------
## output
## ---------------------------

saveRDS(df, file.path(dat_dir, "test_scores_updated.RDS"))

## -----------------------------------------------------------------------------
## END SCRIPT
## -----------------------------------------------------------------------------
