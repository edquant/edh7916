################################################################################
##
## <PROJ> EDH7916: Exploratory data analysis: Data visualization with {ggplot2}
## <FILE> eda_dv.R 
## <INIT> 9 March 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(haven)
library(labelled)

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")
tsc_dir <- file.path(dat_dir, "sch_test")

## ---------------------------
## input data
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
df_hs <- read_dta(file.path(dat_dir, "hsls_small.dta"))
df_ts <- read_csv(file.path(tsc_dir, "all_schools.csv"))

## -----------------------------------------------------------------------------
## Base R graphics
## -----------------------------------------------------------------------------

## ---------------------------
## histogram
## ---------------------------

## histogram of math scores
hist(df_hs$x1txmtscor)

## ---------------------------
## density
## ---------------------------

## density plot of math scores with hist() function
hist(df_hs$x1txmtscor, freq = FALSE)

## density plot of math scores
plot(density(df_hs$x1txmtscor, na.rm = TRUE))

## ---------------------------
## box plot
## ---------------------------

## box plot of math scores against student expectations
boxplot(x1txmtscor ~ x1stuedexpct, data = df_hs)

## ---------------------------
## scatter
## ---------------------------

## scatter plot of math against SES
plot(df_hs$x1txmtscor, df_hs$x1ses)

## -----------------------------------------------------------------------------
## Graphics with ggplot2
## -----------------------------------------------------------------------------

## ---------------------------
## histogram
## ---------------------------

## init ggplot 
p <- ggplot(data = df_hs, mapping = aes(x = x1txmtscor))
p

## add histogram instruction
p <- p + geom_histogram()
p

## init ggplot 
p <- ggplot(data = df_hs, mapping = aes(x = x1txmtscor)) +
    geom_histogram()
p

## ---------------------------
## density
## ---------------------------

## density
p <- ggplot(data = df_hs, mapping = aes(x = x1txmtscor)) +
    geom_density()
p

## histogram with density plot overlapping
p <- ggplot(data = df_hs, mapping = aes(x = x1txmtscor)) +
    geom_histogram(mapping = aes(y = ..density..)) +
    geom_density()
p

## histogram with density plot overlapping (add color to see better)
p <- ggplot(data = df_hs, mapping = aes(x = x1txmtscor)) +
    geom_histogram(mapping = aes(y = ..density..),
                   color = "black",
                   fill = "white") +
    geom_density(fill = "red", alpha = 0.2)
p

## ---------------------------
## two way plot
## ---------------------------

## see the counts for each group
df_hs %>% count(x1paredu)

## need to set up data
plot_df <- df_hs %>%
    select(x1paredu, x1txmtscor) %>%
    drop_na() %>%                       # can't plot NA so will drop
    mutate(pared_coll = ifelse(x1paredu >= 3, 1, 0)) %>%
    select(-x1paredu) 

## show
head(plot_df)

## two way histogram
p <- ggplot(data = plot_df,
            aes(x = x1txmtscor, fill = factor(pared_coll))) +
    geom_histogram(alpha = 0.5, stat = "density", position = "identity")
p

## ---------------------------
## box plot
## ---------------------------

## box plot using both factor() and as_factor()
p <- ggplot(data = df_hs,
            mapping = aes(x = factor(x1paredu),
                          y = x1txmtscor,
                          fill = as_factor(x1paredu))) +
    geom_boxplot()
p

## ---------------------------
## scatter plot
## ---------------------------

## sample 10% to make figure clearer
df_hs_10 <- df_hs %>% sample_frac(0.1)

## scatter
p <- ggplot(data = df_hs_10, mapping = aes(x = x1ses, y = x1txmtscor)) +
    geom_point()
p


## see student base year plans
df_hs %>%
    count(x1stuedexpct)

## create variable for students who plan to graduate from college
df_hs_10 <- df_hs_10 %>%
    mutate(plan_col_grad = ifelse(x1stuedexpct >= 6, 1, 0))

## scatter
p <- ggplot(data = df_hs_10,
            mapping = aes(x = x1ses, y = x1txmtscor)) +
    geom_point(mapping = aes(color = factor(plan_col_grad)), alpha = 0.5)
p

## ---------------------------
## fitted lines
## ---------------------------

## add fitted line with linear fit
p <- ggplot(data = df_hs_10, mapping = aes(x = x1ses, y = x1txmtscor)) +
    geom_point(mapping = aes(color = factor(plan_col_grad)), alpha = 0.5) +
    geom_smooth(method = lm)
p

## add fitted line with polynomial linear fit
p <- ggplot(data = df_hs_10, mapping = aes(x = x1ses, y = x1txmtscor)) +
    geom_point(mapping = aes(color = factor(plan_col_grad)), alpha = 0.5) +
    geom_smooth(method = lm, formula = y ~ poly(x,2))
p

## add fitted line with loess
p <- ggplot(data = df_hs_10, mapping = aes(x = x1ses, y = x1txmtscor)) +
    geom_point(mapping = aes(color = factor(plan_col_grad)), alpha = 0.5) +
    geom_smooth(method = loess)
p

## ---------------------------
## line graph
## ---------------------------

## show test score data
df_ts

## line graph
p <- ggplot(data = df_ts %>% filter(school == "Spottsville"),
            mapping = aes(x = year, y = math)) +
    geom_line()
p

## line graph for math scores at every school over time
p <- ggplot(data = df_ts,
            mapping = aes(x = year, y = math, colour = school)) +
    geom_line()
p

## facet line graph
p <- ggplot(data = df_ts,
            mapping = aes(x = year, y = math)) +
    facet_wrap(~ school) +
    geom_line()
p

## reshape data long
df_ts_long <- df_ts %>%
    pivot_longer(cols = c("math","read","science"), # cols to pivot long
                 names_to = "test",                 # where col names go
                 values_to = "score")               # where col values go

## show
df_ts_long

## facet line graph, with colour = test and ~school
p <- ggplot(data = df_ts_long,
            mapping = aes(x = year, y = score, colour = test)) +
    facet_wrap(~ school) +
    geom_line()
p

## facet line graph, now with colour = school and ~test
p <- ggplot(data = df_ts_long,
            mapping = aes(x = year, y = score, colour = school)) +
    facet_wrap(~ test) +
    geom_line()
p

## facet line graph, with one column so they stack
p <- ggplot(data = df_ts_long,
            mapping = aes(x = year, y = score, colour = school)) +
    facet_wrap(~ test, ncol = 1, scales = "free_y") +
    geom_line()
p

## rescale test scores
df_ts_long <- df_ts_long %>%
    group_by(test) %>%
    mutate(score_std = (score - mean(score)) / sd(score)) %>%
    ungroup

## facet line graph with standardized test scores
p <- ggplot(data = df_ts_long,
            mapping = aes(x = year, y = score_std, colour = school)) +
    facet_wrap(~ test, ncol = 1) +
    geom_line()
p

## facet line graph
p <- ggplot(data = df_ts_long,
            mapping = aes(x = year, y = score_std, colour = test)) +
    facet_wrap(~ school) +
    geom_line()
p

## standardize test scores within school to first year
df_ts_long <- df_ts_long %>%
    group_by(test, school) %>%
    arrange(year) %>% 
    mutate(score_year_one = first(score),
           ## note that we're using score_year_one instead of mean(score)
           score_std_sch = (score - score_year_one) / sd(score)) %>%
    ungroup

## facet line graph
p <- ggplot(data = df_ts_long,
            mapping = aes(x = year, y = score_std_sch, colour = test)) +
    facet_wrap(~ school) +
    geom_line()
p


## =============================================================================
## END SCRIPT
################################################################################
