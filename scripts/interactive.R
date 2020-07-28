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

## create basic histogram with plotly
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
## 5. improve the tooltip
p <- plot_ly(data = df_hs,
             x = ~x1txmtscor,
             histnorm = "probability",
             type = "histogram",
             marker = list(color = "#E28F41",
                           line = list(color = "#6C9AC3",
                                       width = 2)),
             name = "",
             hovertemplate = paste("Bin width: %{x}",
                                   "<br>", # add HTML <br> for line break
                                   "Probability: %{y}")) %>%
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
plot_df

## two way histogram: add one at a time
p <- plot_ly(alpha = 0.5) %>%
    ## first: when parents don't have college degree
    add_histogram(data = plot_df %>% filter(pared_coll == 0),
                  x = ~x1txmtscor,
                  histnorm = "probability",
                  type = "histogram",
                  name = "No college",
                  text = "No college",
                  hovertemplate = paste("%{text}",
                                        "<br>",
                                        "Bin width: %{x}",
                                        "<br>",
                                        "Probability: %{y}",
                                        "<extra></extra>")) %>%
    ## second: when parents have college degree
    add_histogram(data = plot_df %>% filter(pared_coll == 1),
                  x = ~x1txmtscor,
                  histnorm = "probability",
                  type = "histogram",
                  name = "Some college or more",
                  text = "Some college or more",
                  hovertemplate = paste("%{text}",
                                        "<br>",
                                        "Bin width: %{x}",
                                        "<br>",
                                        "Probability: %{y}",
                                        "<extra></extra>")) %>%
    ## tell plotly to overlay the histograms
    layout(barmode = "overlay",
           title = "Distribution of math test scores",
           xaxis = list(title = "Math test score"),
           legend = list(title = list(text = "Parent's education level")))

## show
p


## ---------------------------
## box plot
## ---------------------------

## box plot using as_factor()
p <- plot_ly(data = df_hs,
             color = ~as_factor(x1paredu),
             y = ~x1txmtscor,
             type = "box") %>%
    layout(title = "Math score by parental expectations",
           xaxis = list(title = "Parental expectations"),
           yaxis = list(title = "Math score"),
           showlegend = FALSE)

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
             ## set point options
             ## size: radius
             ## color: fill color
             ## line: circumference line width and color
             marker = list(size = 10,
                           color = "#E28F41",
                           line = list(color = "#6C9AC3",
                                       width = 2)),
             ## turn off side name on hover
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
                                  "Yes",        # if T: "Yes"
                                  "No"))        # if F: "No"

## set color palette with names
pal <- c("#E28F41","#6C9AC3")
pal <- setNames(pal, c("Yes", "No"))

## scatter plot
p <- plot_ly() %>%
    add_trace(data = df_hs_10,
              x = ~x1ses,
              y = ~x1txmtscor,
              color = ~plan_col_grad,   # color changes by college plans
              colors = pal,             # using pal from above
              type = "scatter",
              mode = "markers",
              hovertemplate = paste("SES: %{x}",
                                    "<br>",
                                    "Math: %{y}",
                                    "<extra></extra>")) %>%
    layout(title = "Math scores as function of SES",
           xaxis = list(title = "SES",
                        zeroline = FALSE), # turn off bold zero line
           yaxis = list(title = "Math score"),
           legend = list(title = list(text = "Plans to graduate from college?")))

## show
p


## set color palette with names
pal <- c("#E28F41","#6C9AC3")
pal <- setNames(pal, c("Yes", "No"))

## scatter along three dimensions; most settings inside plot_ly() function now
p <- plot_ly(data = df_hs_10,
             x = ~x1ses,
             y = ~x1txmtscor,
             z = ~x4hs2psmos,
             color = ~plan_col_grad,
             colors = pal,
             ## add extra row to tool tip
             hovertemplate = paste("SES: %{x}",
                                   "<br>", 
                                   "Math: %{y}",
                                   "<br>",
                                   "HS to College: %{z} months",
                                   "<extra></extra>"),
             ## make marker a little smaller
             marker = list(size = 3)) %>%
    ## now tell plot_ly to add points as markers
    add_markers() %>%
    ## in 3D, set axis titles inside scene() argument
    layout(title = "Math scores as function of SES",
           scene = list(xaxis = list(title = "SES"),
                        yaxis = list(title = "Math score"),
                        zaxis = list(title = "Months between HS and college")),
           legend = list(title = list(text = "Plans to graduate from college?")))

## show
p


## ---------------------------
## line graph
## ---------------------------

## show test score data
df_ts

## reshape data long (as we've done in a prior lesson)
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

## scatter plot
p <- plot_ly() %>%
    ## add data for Bend Gate only; y == math
    add_trace(data = df_ts %>% filter(school == "Bend Gate"),
              x = ~year,
              y = ~math,
              name = "Math",
              type = "scatter",
              mode = "lines") %>%
    ## repeated, but this time y == reading
    add_trace(x = ~year,
              y = ~read,
              name = "Reading",
              type = "scatter",
              mode = "lines") %>%
    ## repeated, but this time y == science
    add_trace(x = ~year,
              y = ~science,
              name = "Science",
              type = "scatter",
              mode = "lines") %>%
    ## add unified hovermode so that tooltip for all test scores pops ups
    layout(title = "Test scores at Bend Gate: 1980 - 1985",
           xaxis = list(title = "Year"),
           yaxis = list(title = "Score"),
           legend = list(title = list(text = "Test")),
           hovermode = "x unified")

## show
p


## set up vector of school names
schools <- c("Bend Gate", "East Heights", "Niagara", "Spottsville")

## init list to hold plots
plot_list <- list()

## loop through schools to make each plot at a time
for (i in schools) {

    ## TRUE if first school, otherwise FALSE;
    ## use so we only end up with one legend
    if_first <- (i == 1)
    
    ## store scatter plot in list using index i
    plot_list[[i]] <- plot_ly() %>%
        ## filter to school i (one school at a time)
        add_trace(data = df_ts_long %>% filter(school == i),
                  x = ~year,
                  y = ~score_std_sch,
                  color = ~test,
                  legendgroup = ~test,
                  text = ~score,
                  showlegend = if_first,   # only TRUE the first time
                  type = "scatter",
                  mode = "lines",
                  ## notice that we include scaled and actual score in hover
                  hovertemplate = paste("Year: %{x}",
                                        "<br>",
                                        "Score (scaled): %{y}",
                                        "<br>",
                                        "Score (actual): %{text}")) %>% 
        layout(xaxis = list(title = "Year"),
               yaxis = list(title = "Score"),
               legend = list(title = list(text = "Test"))) %>%
        ## settings to add school name to title of each subplot
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

## combine subplots into on main plot like ggplot() facet_wrap()
p <- subplot(plot_list[[1]], plot_list[[2]], plot_list[[3]], plot_list[[4]],
             nrows = 2)

## show
p


## make interactive table
tab <- plot_ly(
    type = "table",
    ## adjust how header row looks
    header = list(
        ## use str_to_title() with tibble column names: math --> Math
        values = c(str_to_title(names(df_ts))),
        ## left align school names, and center all other columns (hence -1)
        align = c("left", rep("center", ncol(df_ts) - 1)),
        ## make vertical lines thicker
        line = list(width = 1, color = "black"),
        ## fill color with blue
        fill = list(color = "rgba(108, 154, 195, 0.8)"),
        ## set font to sans serif with bigger size and white color
        font = list(family = "Arial", size = 14, color = "white")),
    ## adjust how cells look
    cells = list(
        ## use df_ts, but...
        ## 1. convert to matrix,
        ## 2. transpose using t(),
        ## 3. drop names (already in header row)
        values = t(as.matrix(unname(df_ts))),
        ## same alignment as header
        align = c("left", rep("center", ncol(df_ts) - 1)),
        ## same vertical line setup as header
        line = list(color = "black", width = 1),
        ## fill first column different color to stand out
        fill = list(color = c("rgba(108, 154, 195, 0.5)",
                              "rgba(226, 143, 65, 0.5)")),
        ## same font as header, but smaller and different color
        font = list(family = "Arial", size = 12, color = c("black"))
    ))

## show
tab



## =============================================================================
## END SCRIPT
################################################################################
