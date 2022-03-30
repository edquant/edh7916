################################################################################
##
## <PROJ> EDH7916: Introduction to mapping in R
## <FILE> mapping.R 
## <INIT> 29 March 2022
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################


## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(sf)
library(usmap)

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")
geo_dir <- file.path(dat_dir, "geo")
usa_dir <- file.path(geo_dir, "cb_2018_us_state_20m")

## ---------------------------
## input data
## ---------------------------

## reading in the least detailed cartographic boundary (cb) file from 2018
df_us <- st_read(file.path(usa_dir, "cb_2018_us_state_20m.shp")) %>%
  ## renaming the data frame columns to all lowercase
  rename_all(tolower) %>%
  ## converting state fips codes (two digit) to numbers for later filtering
  mutate(statefp = as.integer(statefp))

## show
df_us

## ---------------------------
## initial plot
## ---------------------------

p <- ggplot(df_us) +
  geom_sf() +
  theme_void()

## show
p

## ---------------------------
## lower 48 only plot
## ---------------------------

## filter to keep only states (fips <= 56, Wyoming) and then drop AK/HI
df_l48 <- df_us %>%
  filter(statefp <= 56) %>%
  filter(statefp != 02 & statefp != 15)

## same plot with reduced data
p <- ggplot(df_l48) +
  geom_sf() +
  theme_void()

## show
p

## ---------------------------
## transform CRS (re-project)
## ---------------------------

## change CRS to something that looks better for US
df_l48 <- st_transform(df_l48, crs = 5070)

## same plot, but should look different b/c we changed projection
p <- ggplot(df_l48) +
  geom_sf() +
  theme_void()

## show
p

## ---------------------------
## use usmaps to get AK/HI
## ---------------------------

## load usmap data for states
df_usmap <- us_map(regions = "states")

## need to set up to work with sf
## start by setting up sf data frame with correct projection
df_usmap <- st_as_sf(df_usmap, coords = c("x", "y"), crs = 5070) %>%
  ## group by state / group (some states have non-contiguous parts like islands)
  group_by(fips, group) %>%
  ## combine these points into single geometry
  summarise(geometry = st_combine(geometry),
            .groups = "drop") %>%
  ## reset these points as polygons (think dots to lines that connect)
  st_cast("POLYGON")

## Alaska and Hawaii now included, but moved for tighter plot
p <- ggplot(df_usmap) +
  geom_sf() +
  theme_void()

## show
p

## ---------------------------
## BA attainment 2005-2019
## ---------------------------

## read in BA attainment (25-44yo) data
df_ba <- read_csv(file.path(geo_dir, "ba_25_44.csv"),
                  show_col_types = FALSE)

## show top of data
df_ba

## join data to mapping data
df_usmap <- df_usmap %>%
  ## create a join variable, stfips, that matches what's in df_ba
  mutate(stfips = as.integer(fips)) %>%
  ## left_join as usual
  left_join(df_ba, by = "stfips")

## plot with one year of BA attainment
p <- ggplot(df_usmap %>% filter(year == 2019)) +
  geom_sf(aes(fill = bapct)) +
  theme_void()

## show
p

## plot with 4 years of BA attainment
p <- ggplot(df_usmap %>% filter(year %in% c(2005, 2010, 2015, 2019))) +
  facet_wrap(~ year) +
  geom_sf(aes(fill = bapct)) +
  theme_void()

## show
p

## create new variable that's == 1 if BA attainment is >= 33%
df_usmap <- df_usmap %>%
  ## thinking ahead: use strings in yes/no options that will look good in legend
  mutate(bacut = ifelse(bapct >= 33, "33%+", "<33%"))

## plot with 4 years of BA attainment
p <- ggplot(df_usmap %>% filter(year %in% c(2005, 2010, 2015, 2019))) +
  facet_wrap(~year) +
  geom_sf(aes(fill = bacut)) +
  scale_fill_discrete(name = "BA attainment") +
  theme_void()

## show
p

## ---------------------------
## Alachua County: school/zip
## ---------------------------

## school attendance zones; school locations; zip codes
df_zon <- st_read(file.path(geo_dir, "ac_school_zones.geojson"))
df_sch <- st_read(file.path(geo_dir, "ac_school_locs.geojson"))
df_zip <- st_read(file.path(geo_dir, "ac_zipcodes.geojson"))

## plot school zones + schools
p <- ggplot(df_zon) +
  ## convert school level to a factor so we can order it
  facet_wrap(~ factor(level, levels = c("elementary",
                                        "middle",
                                        "high"))) +
  ## change the color of zones by their code (just for variety)
  geom_sf(aes(fill = code)) +
  ## remove legend since it doesn't really tell us much
  scale_fill_discrete(guide = "none") +
  theme_void()

## show
p

## plot zip codes zones + schools
p <- ggplot(df_zip) +
  geom_sf(aes(fill = zip)) +
  scale_fill_discrete(guide = "none") +
  theme_void()

## show
p

## join schools to zip codes
df_sch_zip <- st_join(df_sch, df_zip)

## show
df_sch_zip

## what zip code has the most schools?
df_sch_zip %>%
  ## drop geometry so that we are left with simple data frame
  st_drop_geometry() %>%
  ## group by zip code
  group_by(zip) %>%
  ## use n() to get number of rows (i.e., schools) in each zip group
  summarise(num_schools = n()) %>%
  ## arrange results in descending order so that max is first
  arrange(desc(num_schools))

## what zip code has the most schools?
p <- ggplot(df_zon %>% filter(facility == "Lake Forest Elementary")) +
  geom_sf() +
  theme_void()

## show
p

## join schools to zip codes
df_zon_zip <- st_intersection(df_zon, df_zip)

## what zip code has the most schools?
p <- ggplot(df_zon_zip %>% filter(facility == "Lake Forest Elementary")) +
  geom_sf(aes(fill = zip)) +
  scale_fill_discrete(name = "Zip Code") +
  theme_void()

## show
p


## =============================================================================
## END SCRIPT
################################################################################
