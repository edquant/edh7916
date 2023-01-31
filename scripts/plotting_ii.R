################################################################################
##
## <PROJ> EDH7916: Data visualization with ggplot2 II
## <FILE> plotting_ii.R 
## <INIT> 5 April 2022
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################


## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(patchwork)

## ---------------------------
## functions
## ---------------------------

## utility function to convert values to NA
fix_missing <- function(x, miss_val) {
  x <- ifelse(x %in% miss_val, NA, x)
  return(x)
}

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")

## ---------------------------
## input data
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
df <- read_csv(file.path(dat_dir, "hsls_small.csv"), show_col_types = FALSE)

## -----------------------------------------------------------------------------
## initial plain plot
## -----------------------------------------------------------------------------

## fix missing values for text score and then drop missing
df <- df %>%
  mutate(math_test = fix_missing(x1txmtscor, -8)) %>%
  drop_na(math_test)

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  geom_histogram()

## show
p

## -----------------------------------------------------------------------------
## titles and captions
## -----------------------------------------------------------------------------

## create histogram using ggplot, showing placeholder titles/labels/captions
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  geom_histogram(bins = 30) +
  labs(title = "Title",
       subtitle = "Subtitle",
       caption = "Caption",
       x = "X axis label",
       y = "Y axis label")

## show 
p

## ---------------------------
## titles and captions: ver 2
## ---------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  geom_histogram(bins = 30) +
  labs(title = "Math test scores",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count")

## show 
p

## -----------------------------------------------------------------------------
## axis formatting
## -----------------------------------------------------------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  geom_histogram(bins = 30) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 2500, by = 100),
                     minor_breaks = seq(from = 0, to = 2500, by = 50)) +
  labs(title = "Math test scores",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count")

## show 
p

## ---------------------------
## axis formatting: ver 2
## ---------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  geom_histogram(bins = 30) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 2500, by = 500),
                     minor_breaks = seq(from = 0, to = 2500, by = 100)) +
  labs(title = "Math test scores",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count")

## show 
p

## -----------------------------------------------------------------------------
## legend labels
## -----------------------------------------------------------------------------

## add indicator that == 1 if either parent has any college
df <- df %>%
  mutate(pared_coll = ifelse(x1paredu >= 3, 1, 0))

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test, fill = as_factor(pared_coll))) +
  geom_histogram(bins = 50, alpha = 0.5, position = "identity") +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 2500, by = 500),
                     minor_breaks = seq(from = 0, to = 2500, by = 100)) +
  labs(title = "Math test scores by parental education",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count")

## show 
p

## ---------------------------
## legend labels: ver 2
## ---------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test,
                          fill = factor(pared_coll,
                                        levels = c(0,1),
                                        labels = c("No college",
                                                   "College")))) +
  geom_histogram(bins = 50, alpha = 0.5, position = "identity") +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 2500, by = 500),
                     minor_breaks = seq(from = 0, to = 2500, by = 100)) +
  labs(title = "Math test scores by parental education",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count")

## show 
p

## ---------------------------
## legend labels: ver 3
## ---------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test,
                          fill = factor(pared_coll,
                                        levels = c(0,1),
                                        labels = c("No college",
                                                   "College")))) +
  geom_histogram(bins = 50, alpha = 0.5, position = "identity") +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  scale_fill_discrete(name = "Parental education") +
  labs(title = "Math test scores by parental education",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count")

## show 
p

## -----------------------------------------------------------------------------
## facet labels
## -----------------------------------------------------------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  facet_wrap(~ factor(pared_coll,
                      levels = c(0,1),
                      labels = c("No college","College"))) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  labs(title = "Math test scores by parental education",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count")

## show 
p

## -----------------------------------------------------------------------------
## themes
## -----------------------------------------------------------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  facet_wrap(~ factor(pared_coll,
                      levels = c(0,1),
                      labels = c("No college","College"))) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  labs(title = "Math test scores by parental education",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count") +
  theme(panel.background = element_blank())

## show 
p

## ---------------------------
## themes: ver 2
## ---------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  facet_wrap(~ factor(pared_coll,
                      levels = c(0,1),
                      labels = c("No college","College"))) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  labs(title = "Math test scores by parental education",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count") +
  theme(panel.background = element_blank(),
        panel.grid.major = element_line(colour = "gray"),
        panel.grid.minor = element_line(colour = "gray"))

## show 
p

## ---------------------------
## themes: ver 3
## ---------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  facet_wrap(~ factor(pared_coll,
                      levels = c(0,1),
                      labels = c("No college","College"))) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  labs(title = "Math test scores by parental education",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count") +
  theme(panel.background = element_blank(),
        panel.grid.major.x = element_line(colour = "grey"),
        panel.grid.minor.x = element_line(colour = "grey"),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank())

## show 
p

## ---------------------------
## themes: ver 4
## ---------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  facet_wrap(~ factor(pared_coll,
                      levels = c(0,1),
                      labels = c("No college","College"))) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  labs(title = "Math test scores by parental education",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count") +
  theme(panel.background = element_blank(),
        panel.grid.major.x = element_line(colour = "grey"),
        panel.grid.minor.x = element_line(colour = "grey"),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

## show 
p

## ---------------------------
## themes: ver 5
## ---------------------------

## create histogram using ggplot
p <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  facet_wrap(~ factor(pared_coll,
                      levels = c(0,1),
                      labels = c("No college","College"))) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  labs(title = "Math test scores by parental education",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count") +
  theme_bw()

## show 
p

## -----------------------------------------------------------------------------
## multiple plots with patchwork
## -----------------------------------------------------------------------------

## remove missing values
df <- df %>%
  mutate(pov185 = fix_missing(x1poverty185, c(-8,-9))) %>%
  drop_na(pov185)

## make histogram
p2 <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  facet_wrap(~ factor(pov185,
                      levels = c(0,1),
                      labels = c("Below 185% poverty line",
                                 "Above 185% poverty line"))) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  labs(title = "Math test scores by poverty level",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "Math score",
       y = "Count") +
  theme_bw()

## show
p2

## ---------------------------
## patchwork: side by side
## ---------------------------

## use plus sign for side by side
pp <- p + p2

## show
pp

## ---------------------------
## patchwork: stack
## ---------------------------

## use forward slash to stack
pp <- p / p2

## show
pp

## ---------------------------
## patchwork: 2 over 1
## ---------------------------

## drop missing SES values
df <- df %>%
  mutate(ses = fix_missing(x1ses, -8)) %>%
  drop_na(ses)

## create third histogram of just SES
p3 <- ggplot(data = df,
             mapping = aes(x = x1ses)) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = -5, to = 5, by = 1),
                     minor_breaks = seq(from = -5, to = 5, by = 0.5)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1000, by = 100),
                     minor_breaks = seq(from = 0, to = 1000, by = 25)) +
  labs(title = "Socioeconomic score",
       caption = "Data: High School Longitudinal Study, 2009",
       x = "SES",
       y = "Count") +
  theme_bw()

## show
p3

## use parentheses to put figures together (like in algebra)
pp <- (p + p2) / p3

## show
pp

## ---------------------------
## patchwork: clean up
## ---------------------------

## Redo the above plots so that:
## - remove some redundant captions
## - change base_size so font is smaller

## test score by parental education
p1 <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  facet_wrap(~ factor(pared_coll,
                      levels = c(0,1),
                      labels = c("No college","College"))) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  labs(title = "Math test scores by parental education",
       x = "Math score",
       y = "Count") +
  theme_bw(base_size = 8)

## test score by poverty level
p2 <- ggplot(data = df,
            mapping = aes(x = math_test)) +
  facet_wrap(~ factor(pov185,
                      levels = c(0,1),
                      labels = c("Below 185% poverty line",
                                 "Above 185% poverty line"))) + 
  geom_histogram(bins = 50) +
  scale_x_continuous(breaks = seq(from = 0, to = 100, by = 5),
                     minor_breaks = seq(from = 0, to = 100, by = 1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 1500, by = 100),
                     minor_breaks = seq(from = 0, to = 1500, by = 25)) +
  labs(title = "Math test scores by poverty level",
       x = "Math score",
       y = "Count") +
  theme_bw(base_size = 8)

## create third histogram of just SES
p3 <- ggplot(data = df,
             mapping = aes(x = x1ses, y = math_test)) + 
  geom_point() +
  scale_x_continuous(breaks = seq(from = -5, to = 5, by = 1),
                     minor_breaks = seq(from = -5, to = 5, by = 0.5)) +
  scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
                     minor_breaks = seq(from = 0, to = 100, by = 5)) +
  labs(title = "Math test scores by socioeconomic status",
       x = "SES",
       y = "Math score") +
  theme_bw(base_size = 8)

## use parentheses to put figures together (like in algebra)
pp <- (p1 + p2) / p3

## add annotations
pp <- pp + plot_annotation(
  title = "Math scores across various factors",
  caption = "Data: High School Longitudinal Study, 2009",
  tag_levels = "A"
)

## show
pp


## =============================================================================
## END SCRIPT
################################################################################
