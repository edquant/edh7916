################################################################################
##
## <PROJ> EDH7916: High performance R with Rcpp
## <FILE> rcpp.R 
## <INIT> 25 April 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------
library(tidyverse)
library(Rcpp)
library(microbenchmark)


## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")
rcpp_dir <- file.path(dat_dir, "rcpp")


## ---------------------------
## input data
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
df_col <- readRDS(file.path(rcpp_dir, "collegeloc.RDS"))
df_cbg <- readRDS(file.path(rcpp_dir, "cblocks.RDS"))


## college locations
df_col

## census block group locations
df_cbg


## ---------------------------------------------------------
## Function to compute great circle distance
## ---------------------------------------------------------


## convert degrees to radians
deg_to_rad <- function(degree) {
  m_pi <- 3.141592653589793238462643383280
  return(degree * m_pi / 180)
}

## compute Haversine distance between two points
dist_haversine <- function(xlon, xlat, ylon, ylat) {

  ## radius of Earth in meters
  e_r <- 6378137
  
  ## return 0 if same point
  if (xlon == ylon & xlat == xlon) { return(0) }
  
  ## convert degrees to radians
  xlon = deg_to_rad(xlon)
  xlat = deg_to_rad(xlat)
  ylon = deg_to_rad(ylon)
  ylat = deg_to_rad(ylat)
  
  ## haversine distance formula
  d1 <- sin((ylat - xlat) / 2)
  d2 <- sin((ylon - xlon) / 2)
  
  return(2 * e_r * asin(sqrt(d1^2 + cos(xlat) * cos(ylat) * d2^2)))
}


## -----------------------------------------------
## GC distance between two points
## -----------------------------------------------


## store first census block group point (x) and first college point (y)
xlon <- df_cbg[[1, "lon"]]
xlat <- df_cbg[[1, "lat"]]
ylon <- df_col[[1, "lon"]]
ylat <- df_col[[1, "lat"]]

## test single distance function
d <- dist_haversine(xlon, xlat, ylon, ylat)

## show
d


## -----------------------------------------------
## GC distance between many points
## -----------------------------------------------


## compute many to many distances and return matrix
dist_mtom <- function(xlon,         # vector of starting longitudes
                      xlat,         # vector of starting latitudes
                      ylon,         # vector of ending longitudes
                      ylat,         # vector of ending latitudes
                      x_names,      # vector of starting point names
                      y_names) {    # vector of ending point names

  ## init output matrix (n X k)
  n <- length(xlon)
  k <- length(ylon)
  mat <- matrix(NA, n, k)
  
  ## double loop through each set of points to get all combinations
  for(i in 1:n) {
    for(j in 1:k) {
      ## compute distance using core function
      mat[i,j] <- dist_haversine(xlon[i], xlat[i], ylon[j], ylat[j])
    }
  }
  
  ## add row and column names
  rownames(mat) <- x_names
  colnames(mat) <- y_names
  return(mat)
}


## test matrix (limit to only 10 starting points)
distmat <- dist_mtom(df_cbg$lon[1:10], df_cbg$lat[1:10],
                     df_col$lon, df_col$lat,
                     df_cbg$fips11[1:10], df_col$unitid)

## show
distmat[1:5,1:5]


## -----------------------------------------------
## minimum GC distance between many points
## -----------------------------------------------


## compute and return minimum distance along with name
dist_min <- function(xlon,         # vector of starting longitudes
                     xlat,         # vector of starting latitudes
                     ylon,         # vector of ending longitudes
                     ylat,         # vector of ending latitudes
                     x_names,      # vector of starting point names
                     y_names) {    # vector of ending point names
    
    ## NB: lengths: x coords == x names && y coords == y_names
    n <- length(xlon)
    k <- length(ylon)
    minvec_name <- vector('character', n)
    minvec_meter <- vector('numeric', n)

    ## init temporary vector for distances between one x and all ys
    tmp <- vector('numeric', k)

    ## give tmp names of y vector
    names(tmp) <- y_names

    ## loop through each set of starting points
    for(i in 1:n) {
        for(j in 1:k) {
            tmp[j] <- dist_haversine(xlon[i], xlat[i], ylon[j], ylat[j])
        }

        ## add to output matrix
        minvec_name[i] <- names(which.min(tmp))
        minvec_meter[i] <- min(tmp)
    }

    return(data.frame('fips11' = x_names,
                      'unitid' = minvec_name,
                      'meters' = minvec_meter,
                      stringsAsFactors = FALSE))
}


## test matrix (limit to only 10 starting points)
mindf <- dist_min(df_cbg$lon[1:10], df_cbg$lat[1:10],
                  df_col$lon, df_col$lat,
                  df_cbg$fips11[1:10], df_col$unitid)
## show
mindf


## ---------------------------------------------------------
## Source / compile Rcpp file: dist_func.cpp
## ---------------------------------------------------------


## source Rcpp code
sourceCpp('../scripts/dist_func.cpp', rebuild = TRUE)


## -----------------------------------------------
## Comparisons
## -----------------------------------------------
## ---------------------------
## single distance
## ---------------------------

d_Rcpp <- dist_haversine_rcpp(xlon, xlat, ylon, ylat)

## show
d_Rcpp

## compare
identical(d, d_Rcpp)


## ---------------------------
## many to many
## ---------------------------

distmat_Rcpp <- dist_mtom_rcpp(df_cbg$lon[1:10],
                               df_cbg$lat[1:10],
                               df_col$lon,
                               df_col$lat,
                               df_cbg$fips11[1:10],
                               df_col$unitid)

## show
distmat_Rcpp[1:5,1:5]

## compare
all.equal(distmat, distmat_Rcpp)


## ---------------------------
## minimum distance
## ---------------------------

mindf_Rcpp <- dist_min_rcpp(df_cbg$lon[1:10],
                            df_cbg$lat[1:10],
                            df_col$lon,
                            df_col$lat,
                            df_cbg$fips11[1:10],
                            df_col$unitid)

## show
mindf_Rcpp

## compare
all.equal(mindf, mindf_Rcpp)


## -----------------------------------------------
## Benchmarks!
## -----------------------------------------------
## ---------------------------
## single distance
## ---------------------------

## use microbenchmark to compare 
tm_single <- microbenchmark(base_R = dist_haversine(xlon, xlat, ylon, ylat),
                            Rcpp = dist_haversine_rcpp(xlon, xlat, ylon, ylat),
                            times = 1000L)
## results
tm_single

## plot
autoplot(tm_single)


## ---------------------------
## many to many
## ---------------------------

## time for base R to do many to many with 100 starting points
system.time(dist_mtom(df_cbg$lon[1:100],
                      df_cbg$lat[1:100],
                      df_col$lon,
                      df_col$lat,
                      df_cbg$fips11[1:100],
                      df_col$unitid))

## ...and now Rcpp version
system.time(dist_mtom_rcpp(df_cbg$lon[1:100],
                           df_cbg$lat[1:100],
                           df_col$lon,
                           df_col$lat,
                           df_cbg$fips11[1:100],
                           df_col$unitid))

## compare just 10 many to many
tm_mtom <- microbenchmark(base_R = dist_mtom(df_cbg$lon[1:10],
                                             df_cbg$lat[1:10],
                                             df_col$lon,
                                             df_col$lat,
                                             df_cbg$fips11[1:10],
                                             df_col$unitid),
                          Rcpp = dist_mtom_rcpp(df_cbg$lon[1:10],
                                                df_cbg$lat[1:10],
                                                df_col$lon,
                                                df_col$lat,
                                                df_cbg$fips11[1:10],
                                                df_col$unitid),
                          times = 100L)

## results
tm_mtom

## plot
autoplot(tm_mtom)


## ---------------------------
## minimum distance
## ---------------------------

## time for base R to do many to many with 100 starting points
system.time(dist_min(df_cbg$lon[1:100],
                     df_cbg$lat[1:100],
                     df_col$lon,
                     df_col$lat,
                     df_cbg$fips11[1:100],
                     df_col$unitid))

## ...and now Rcpp version
system.time(dist_min_rcpp(df_cbg$lon[1:100],
                          df_cbg$lat[1:100],
                          df_col$lon,
                          df_col$lat,
                          df_cbg$fips11[1:100],
                          df_col$unitid))

## compare just 10 min
tm_min <- microbenchmark(base_R = dist_min(df_cbg$lon[1:10],
                                           df_cbg$lat[1:10],
                                           df_col$lon,
                                           df_col$lat,
                                           df_cbg$fips11[1:10],
                                           df_col$unitid),
                         Rcpp = dist_min_rcpp(df_cbg$lon[1:10],
                                              df_cbg$lat[1:10],
                                              df_col$lon,
                                              df_col$lat,
                                              df_cbg$fips11[1:10],
                                              df_col$unitid),
                         times = 100)
## results
tm_min

## plot
autoplot(tm_min)


## ---------------------------
## full run for Rcpp
## ---------------------------

## find minimum
system.time(full_min <- dist_min_rcpp(df_cbg$lon,
                                      df_cbg$lat,
                                      df_col$lon,
                                      df_col$lat,
                                      df_cbg$fips11,
                                      df_col$unitid))

## show
full_min %>% tibble()




## =============================================================================
## END SCRIPT
################################################################################
