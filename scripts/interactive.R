################################################################################
##
## <PROJ> EDH7916: Interactive graphics
## <FILE> interactive.R 
## <INIT> 19 July 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(haven)
library(plotly)

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
## read_dta() ==> read in Stata (*.dta) files
## read_csv() ==> read in comma separated value (*.csv) files
df_hs <- read_dta(file.path(dat_dir, "hsls_small.dta"))
df_ts <- read_csv(file.path(tsc_dir, "all_schools.csv"))

## -----------------------------------------------------------------------------
## Graphics with plotly
## -----------------------------------------------------------------------------

## ---------------------------
## histogram
## ---------------------------

## create histogram plotly
p <- plot_ly(data = df_hs, x = ~x1txmtscor, type = "histogram")

## show
p


## create histogram plotly
p <- plot_ly(data = df_hs,
             x = ~x1txmtscor,
             histnorm = "probability",
             type = "histogram")

## show
p


## create histogram plotly w/
## 1. better labels
## 2. add title
## 3. change color of bars
## 4. add outline to bars
p <- plot_ly(data = df_hs,
             x = ~x1txmtscor,
             histnorm = "probability",
             type = "histogram",
             marker = list(color = "#E28F41",
                           line = list(color = "#6C9AC3",
                                       width = 2))) %>%
    layout(title = "Distribution of math test scores",
           xaxis = list(title = "Math test score"))

## show
p


## ---------------------------
## two way plot
## ---------------------------

## see the counts for each group
df_hs %>% count(x1paredu)

## need to set up data
plot_df <- df_hs %>%
    ## select the columns we need
    select(x1paredu, x1txmtscor) %>%
    ## can't plot NA so will drop
    drop_na() %>%
    ## create new variable that == 1 if parents have any college
    mutate(pared_coll = ifelse(x1paredu >= 3, 1, 0)) %>%
    ## drop (using negative sign) the original variable we don't need now
    select(-x1paredu) 

## show
head(plot_df)

## two way histogram
p <- plot_ly(alpha = 0.5) %>%
    add_histogram(data = plot_df %>% filter(pared_coll == 0),
                  x = ~x1txmtscor,
                  histnorm = "probability",
                  type = "histogram",
                  name = "No college") %>%
    add_histogram(data = plot_df %>% filter(pared_coll == 1),
                  x = ~x1txmtscor,
                  histnorm = "probability",
                  type = "histogram",
                  name = "Some college or more") %>%
    layout(barmode = "overlay",
           title = "Distribution of math test scores",
           xaxis = list(title = "Math test score"),
           legend = list(title = list(text = "Parent's education level")))

## show
p


## ---------------------------
## box plot
## ---------------------------

## box plot using both factor() and as_factor()
p <- plot_ly(data = df_hs,
             color = ~as_factor(x1paredu),
             y = ~x1txmtscor,
             type = "box") %>%
    layout(title = "Math score by parental expectations",
           yaxis = list(title ="Math score"),
           legend = list(title = list(text = "Parental expectations")))

## show
p


## ---------------------------
## scatter plot
## ---------------------------

## sample 10% to make figure clearer
df_hs_10 <- df_hs %>%
    ## drop observations with missing values for x1stuedexpct
    drop_na(x1stuedexpct) %>%
    ## sample
    sample_frac(0.1)

## scatter
p <- plot_ly(data = df_hs_10,
             x = ~x1ses,
             y = ~x1txmtscor,
             type = "scatter",
             mode = "markers")

## show
p


## scatter
p <- plot_ly(data = df_hs_10,
             x = ~x1ses,
             y = ~x1txmtscor,
             type = "scatter",
             mode = "markers",
             marker = list(size = 10,
                           color = "#E28F41",
                           line = list(color = "#6C9AC3",
                                       width = 2)),
             name = "",
             hovertemplate = paste("SES: %{x}",
                                   "<br>", # add <br> for line break
                                   "Math: %{y}")) %>%
    layout(title = "Math scores as function of SES",
           xaxis = list(title = "SES",
                        zeroline = FALSE),
           yaxis = list(title = "Math score"))

## show
p


## see student base year plans
df_hs %>%
    count(x1stuedexpct)

## create variable for students who plan to graduate from college
df_hs_10 <- df_hs_10 %>%
    mutate(plan_col_grad = ifelse(x1stuedexpct >= 6 & x1stuedexpct < 11,
                                  "Yes",        # if T: 1
                                  "No"))       # if F: 0

## set color palette with names
pal <- c("#E28F41","#6C9AC3")
pal <- setNames(pal, c("Yes", "No"))

## scatter
p <- plot_ly() %>%
    add_trace(data = df_hs_10,
              x = ~x1ses,
              y = ~x1txmtscor,
              color = ~plan_col_grad,
              colors = pal,             # using pal from above
              type = "scatter",
              mode = "markers",
              hovertemplate = paste("SES: %{x}",
                                    "<br>", # add <br> for line break
                                    "Math: %{y}")) %>%
    layout(title = "Math scores as function of SES",
           xaxis = list(title = "SES",
                        zeroline = FALSE),
           yaxis = list(title = "Math score"),
           legend = list(title = list(text = "Plans to graduate from college?")))

## show
p


## ---------------------------
## line graph
## ---------------------------

## show test score data
df_ts

## reshape data long
df_ts_long <- df_ts %>%
    pivot_longer(cols = c("math","read","science"), # cols to pivot long
                 names_to = "test",                 # where col names go
                 values_to = "score") %>%           # where col values go
    group_by(test) %>%
    mutate(score_std = (score - mean(score)) / sd(score)) %>%
    group_by(test, school) %>%
    arrange(year) %>% 
    mutate(score_year_one = first(score),
           ## note that we're using score_year_one instead of mean(score)
           score_std_sch = (score - score_year_one) / sd(score)) %>%
    ungroup

## show
df_ts_long

## scatter
p <- plot_ly() %>%
    add_trace(data = df_ts %>% filter(school == "Bend Gate"),
              x = ~year,
              y = ~math,
              name = "Math",
              type = "scatter",
              mode = "lines") %>%
    add_trace(x = ~year,
              y = ~read,
              name = "Reading",
              type = "scatter",
              mode = "lines") %>%
    add_trace(x = ~year,
              y = ~science,
              name = "Science",
              type = "scatter",
              mode = "lines") %>%
    layout(title = "Test scores at Bend Gate: 1980 - 1985",
           xaxis = list(title = "Year"),
           yaxis = list(title = "Score"),
           legend = list(title = list(text = "Test")),
           hovermode = "x unified")

## show
p


schools <- c("Bend Gate", "East Heights", "Niagara", "Spottsville")
plot_list <- list()
for (i in schools) {
    if_bg <- (i == schools[1])
    ## scatter
    plot_list[[i]] <- plot_ly() %>%
        add_trace(data = df_ts_long %>% filter(school == i),
                  x = ~year,
                  y = ~score_std_sch,
                  color = ~test,
                  legendgroup = ~test,
                  text = ~score,
                  showlegend = if_bg,
                  type = "scatter",
                  mode = "lines",
                  hovertemplate = paste("Year: %{x}",
                                        "<br>",
                                        "Score (scaled): %{y}",
                                        "<br>",
                                        "Score (actual): %{text}")) %>% 
        layout(xaxis = list(title = "Year"),
               yaxis = list(title = "Score"),
               legend = list(title = list(text = "Test"))) %>%
        add_annotations(text = i,
                        x = 0,
                        y = 1,
                        yref = "paper",
                        xref = "paper",
                        xanchor = "middle",
                        yanchor = "top",
                        showarrow = FALSE,
                        font = list(size = 15))
}

p <- subplot(plot_list[[1]], plot_list[[2]], plot_list[[3]], plot_list[[4]],
             nrows = 2)

## show
p


## =============================================================================
## END SCRIPT
################################################################################
