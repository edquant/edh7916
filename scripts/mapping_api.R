################################################################################
##
## <PROJ> EDH7916: Introduction to Mapping in R
## <FILE> mapping_api.R 
## <INIT> 5 March 2023
## <AUTH> Matt Capaldi
##
################################################################################


## ---------------------------
## libraries
## ---------------------------
library(tidyverse)
library(sf)
library(tidycensus)
library(tigris)

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")

## ## ---------------------------
## ## example of shapefile read
## ## ---------------------------
## 
## ## pseudo code (won't run!)
## df <- read_sf(file.path("<Folder-You-Downloaded>", "<Shapefile-Name>.shp"))

## ## ---------------------------
## ## set API key
## ## ---------------------------
## 
## ## you only need to do this once: replace everything between the
## ## quotes with the key in the email you received
## ##
## ## eg. census_api_key("XXXXXXXXXXXXXXXXXX", install = T)
## census_api_key("<Your API Key Here>", install = T)

## ---------------------------
## first data pull
## ---------------------------

df_census <- get_acs(geography = "county",
                     state = "FL",
                     year = 2021,
                     variables = "DP02_0065PE", # Pop >=25 with Bachelors
                     output = "wide",
                     geometry = TRUE)

## show header of census data
head(df_census)

## view data frame without geometry data (not assigning, just viewing)
df_census %>%
  st_drop_geometry()

## ---------------------------------------------------------
## making a map
## ---------------------------------------------------------
## ---------------------------
## layer one: base map
## ---------------------------

## show CRS for dataframe
st_crs(df_census)

## transform the CRS to 4326
df_census <- df_census %>%
  st_transform(crs = 4326)

## show CRS again; notice how it changed from NAD93 to ESPG:4326
st_crs(df_census) 

## create base map
base_map <- ggplot() +
  geom_sf(data = df_census,
          aes(fill = DP02_0065PE),
          color = "black",
          size = 0.1) +
  labs(fill = str_wrap("Percent Population with Bachelor's", 20)) +
  scale_fill_gradient(low = "#a6b5c0", high = "#00254d")

## call base map by itself
base_map

## ---------------------------
## layer two: institutions
## ---------------------------

## read in IPEDS data
df_ipeds <- read_csv(file.path(dat_dir, "mapping_api_data.csv"))

## show IPEDS data
head(df_ipeds)

## convert coordinates columns into a true geometry column; this is
## much more reliable than simply plotting them as geom_points as it
## ensures the CRS matches etc.
df_ipeds <- df_ipeds %>% 
  st_as_sf(coords = c("LONGITUD", "LATITUDE"))

## show IPEDS data again
head(df_ipeds)

## check CRS for IPEDS data
st_crs(df_ipeds)

## add CRS to our IPEDS data
df_ipeds <- df_ipeds %>% 
  st_set_crs(4326) # When you first add coordinates to geometry, it doesn't know
                   # what CRS to use, so we set to 4326 to match our base map data

## check CRS of IPEDS data again
st_crs(df_ipeds)

## layer our points onto the base map
point_map <- base_map +
  geom_sf(data = df_ipeds %>% filter(FIPS == 12), # Only want to plot colleges in FL
          aes(size = LPBOOKS),
          alpha = 0.5) +
  labs(size = "Number of Books in Library")

## show new map
point_map

## ---------------------------------------------------------
## supplemental using tigris directly
## ---------------------------------------------------------
## ---------------------------
## get states geometries
## ---------------------------
df_st <- states() %>%
  filter(STATEFP <= 56) # keeping only the 50 states plus D.C.

## look at head of state data
head(df_st)

## quick plot of states
ggplot() +
  geom_sf(data = df_st,
          aes(),
          size = 0.1) # keep the lines thin, speeds up plotting processing

## shift position of Hawaii and Alaska
df_st <- df_st %>%
  shift_geometry(position = "below")

## replotting with shifted Hawaii and Alaska
ggplot() +
  geom_sf(data = df_st,
          aes(),
          size = 0.1) # keep the lines thin, speeds up plotting processing

## change CRS to what we used for earlier map
df_st <- df_st %>%
  st_transform(crs = 4326)

## make make
ggplot() +
  geom_sf(data = df_st,
          aes(),
          size = 0.1)
