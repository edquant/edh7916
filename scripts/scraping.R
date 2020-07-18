################################################################################
##
## <PROJ> EDH7916: Web scraping
## <FILE> scraping.R 
## <INIT> 18 July 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(rvest)
library(lubridate)

## ---------------------------------------------------------
## Read underlying web page code
## ---------------------------------------------------------

## set site
url <- "https://nces.ed.gov/programs/digest/d17/tables/dt17_302.10.asp"

## get site
site <- read_html(url)

## show
site

## ---------------------------------------------------------
## Get data for recent graduate totals
## ---------------------------------------------------------

## subset to just first column
tot <- site %>%
    html_nodes(".tableBracketRow td:nth-child(2)") %>%
    html_text()

## show
tot

## ...this time trim blank spaces
tot <- site %>%
    html_nodes(".tableBracketRow td:nth-child(2)") %>%
    html_text(trim = TRUE)

## show
tot

## remove blank values; tot where tot does not equal ""
tot <- tot[tot != ""]

## show
tot

## remove commas, replacing with empty string
tot <- str_replace(tot, ",", "")

## show
tot

## convert to numeric
tot <- as.integer(tot)

## show
tot

## ---------------------------------------------------------
## Add years
## ---------------------------------------------------------

## get years column
years <- site %>%
    html_nodes("tbody th") %>%
    html_text(trim = TRUE)

## remove blank spaces like before
years <- years[years != ""]

## show
years

## trim footnote that's become extra digit
years <- str_sub(years, 1, 4)

## show
years

## put in data frame
df <- bind_cols(years = years, total = tot) %>%
    mutate(years = ymd(years, truncated = 2L))
df

## plot
g <- ggplot(df, mapping = aes(x = years, y = total)) +
    ## line for the main estimate
    geom_line() +
    ## make x-axis look nice
    ## major breaks: every 5 years, from min year to max year
    ## minor breaks: every 1 year, from min year to max year
    ## labels: formate to only show year ("%Y")
    scale_x_date(breaks = seq(min(df$years),
                              max(df$years),
                              "5 years"),
                 minor_breaks = seq(min(df$years),
                                    max(df$years),
                                    "1 years"),
                 date_labels = "%Y") +
    ## nice labels and titles
    labs(x = "Year",
         y = "High school completers (1000s)",
         title = "Total number of high school completers: 1960 to 2016",
         caption = "Source: NCES Digest of Education Statistics, 2017, Table 302.10")
g

## ---------------------------------------------------------
## Scrape entire table
## ---------------------------------------------------------


## save node
node <- paste0(".TblCls002 , td.TblCls005 , tbody .TblCls008 , ",
               ".TblCls009 , .TblCls011 , .TblCls010")

## save more dataframe-friendly column names that we
## get from looking at the table online
nms <- c("year","hs_comp_tot", "hs_comp_tot_se",
         "hs_comp_m", "hs_comp_m_se",
         "hs_comp_f", "hs_comp_f_se",
         "enr_pct", "enr_pct_se",
         "enr_pct_2", "enr_pct_2_se",
         "enr_pct_4", "enr_pct_4_se",
         "enr_pct_m", "enr_pct_m_se",
         "enr_pct_2_m", "enr_pct_2_m_se",
         "enr_pct_4_m", "enr_pct_4_m_se",
         "enr_pct_f", "enr_pct_f_se",
         "enr_pct_2_f", "enr_pct_2_f_se",
         "enr_pct_4_f", "enr_pct_4_f_se")

## whole table
tab <- site %>%
    ## use nodes
    html_nodes(node) %>%
    ## to text with trim
    html_text(trim = TRUE)

## show first few elements
tab[1:30]

## convert to matrix
tab <- tab %>%
    ## we know the size by looking at the table online
    matrix(., ncol = 25, byrow = TRUE)

## dimensions
dim(tab)

## show first few columns
tab[1:10,1:5]

## clean up table
tab <- tab %>%
    ## convert to tibble, leaving name repair as minimal for now
    as_tibble(.name_repair = "minimal") %>%
    ## rename using names above
    setNames(nms) %>%
    ## remove commas
    mutate_all(~ str_replace(., ",", "")) %>%
    ## remove dagger and parentheses
    mutate_all(~ str_replace_na(., "\\(\U2020\\)")) %>%
    ## remove hyphens
    mutate_all(~ str_replace_na(., "\U2014")) %>%
    ## remove parentheses, but keep any content that was inside
    mutate_all(~ str_replace(., "\\((.*)\\)", "\\1")) %>%
    ## remove blank strings (^ = start, $ = end, so ^$ = start to end w/ nothing)
    mutate_all(~ str_replace_na(., "^$")) %>%
    ## drop rows with missing year (blank online)
    drop_na(year) %>%
    ## fix years like above
    mutate(year = str_sub(year, 1, 4)) %>%
    ## convert to numbers, suppressing warnings about NAs b/c we know
    mutate_all(~ suppressWarnings(as.numeric(.)))

## show
tab

## ---------------------------------------------------------
## Reshape data
## ---------------------------------------------------------


## gather for long data
df <- tab %>%
    ## pivot_longer estimates, leaving standard errors wide for the moment
    pivot_longer(cols = -c(year, ends_with("se")),
                 names_to = "group",
                 values_to = "estimate") %>%
    ## pivot_longer standard errors
    pivot_longer(cols = -c(year, group, estimate),
                 names_to = "group_se",
                 values_to = "se") %>% 
    ## drop "_se" from standard error estimates
    mutate(group_se = str_replace(group_se, "_se", "")) %>%
    ## filter where group == group_se
    filter(group == group_se) %>%
    ## drop extra column
    select(-group_se) %>%
    ## arrange
    arrange(year) %>%
    ## drop if missing year after reshaping
    drop_na(year)

## show
df

## ---------------------------------------------------------
## Plot trends
## ---------------------------------------------------------


## adjust data for specific plot
plot_df <- df %>%
    filter(group %in% c("enr_pct", "enr_pct_m", "enr_pct_f")) %>%
    mutate(hi = estimate + se * qnorm(.975),
           lo = estimate - se * qnorm(.975),
           year = ymd(as.character(year), truncated = 2L),
           group = ifelse(group == "enr_pct_f", "Women",
                   ifelse(group == "enr_pct_m", "Men", "All")))

## show
plot_df

## plot overall average
g <- ggplot(plot_df %>% filter(group == "All"),
            mapping = aes(x = year, y = estimate)) +
    ## create shaded ribbon for 95% CI
    geom_ribbon(aes(ymin = lo, ymax = hi), fill = "grey70") +
    ## line for main estimate
    geom_line() +
    ## make x-axis look nice
    ## major breaks: every 5 years, from min year to max year
    ## minor breaks: every 1 year, from min year to max year
    ## labels: formate to only show year ("%Y")
    scale_x_date(breaks = seq(min(plot_df$year),
                              max(plot_df$year),
                              "5 years"),
                 minor_breaks = seq(min(plot_df$year),
                                    max(plot_df$year),
                                    "1 years"),
                 date_labels = "%Y") +
    ## good labels and titles
    labs(x = "Year",
         y = "Percent",
         title = "Percent of recent high school completers in college: 1960 to 2016",
         caption = "Source: NCES Digest of Education Statistics, 2017, Table 302.10")    
g

## plot comparison between men and women
g <- ggplot(plot_df %>% filter(group %in% c("Men","Women")),
            ## add colour == group to separate between men and women
            mapping = aes(x = year, y = estimate, colour = group)) +
    ## ribbon for 95% CI, but lower alpha so more transparent
    geom_ribbon(aes(ymin = lo, ymax = hi, fill = group), alpha = 0.2) +
    ## primary estimate line
    geom_line() +
    ## neat x-axis breaks as before
    scale_x_date(breaks = seq(min(plot_df$year),
                              max(plot_df$year),
                              "5 years"),
                 minor_breaks = seq(min(plot_df$year),
                                    max(plot_df$year),
                                    "1 years"),
                 date_labels = "%Y") +
    ## good labels and titles
    labs(x = "Year",
         y = "Percent",
         title = "Percent of recent high school completers in college: 1960 to 2016",
         caption = "Source: NCES Digest of Education Statistics, 2017, Table 302.10") +
    ## set legend title, drop legend for colour since it's redundant with fill
    guides(fill = guide_legend(title = "Group"),
           colour = FALSE) +
    ## position legend so that it sits on plot face, in lower right-hand corner
    theme(legend.position = c(1,0), legend.justification = c(1,0))
g


## =============================================================================
## END SCRIPT
################################################################################
