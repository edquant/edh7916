################################################################################
##
## <PROJ> EDH7916: Functional programming II
## <FILE> programming_two.R 
## <INIT> 25 April 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------
library(tidyverse)
library(plotly)


## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")


## ---------------------------------------------------------
## read in data
## ---------------------------------------------------------

df <- readRDS(file.path(dat_dir, "kmeans.RDS"))

## show
df

## plot first two dimensions
g <- ggplot(df, mapping = aes(x = x, y = y)) + geom_point()

## show
g


## ---------------------------------------------------------
## Spaghetti code or 'just get the job done'
## ---------------------------------------------------------


## convert data to matrix to make our lives easier (x and y, only, for now)
dat <- df %>% select(x, y) %>% as.matrix()


## get initial means to start
index <- sample(1:nrow(dat), 3)           # give k random indexes
means <- dat[index,]

## show
means


## init assignment vector
assign_vec <- numeric(nrow(dat))

## assign each point to one of the clusters
for (i in 1:nrow(dat)) {
  ## init a temporary distance object to hold k distance values
  distance <- numeric(3)
  ## compare to each mean
  for (j in 1:3) {
    distance[j] <- sum((dat[i,] - means[j,])^2)
  }
  ## assign the index of smallest value,
  ## which is effectively cluster ID
  assign_vec[i] <- which.min(distance)
}

## show first few
assign_vec[1:20]


## repeat above in loop until assignments don't change
identical <- FALSE
while (!identical) {
  ## update means by subsetting each column
  ## by assignment group, taking mean
  for (i in 1:3) {
    means[i,] <- colMeans(dat[assign_vec == i,])
  }
  ## store old assignments, b/c we need to compare
  old_assign_vec <- assign_vec
  ## assign each point to one of the clusters
  for (i in 1:nrow(dat)) {
    ## init a temporary distance object
    ## to hold k distance values
    distance <- numeric(3)
    ## compare to each mean
    for (j in 1:3) {
      distance[j] <- sum((dat[i,] - means[j,])^2)
    }
    ## assign the index of smallest value,
    ## which is effectively cluster ID
    assign_vec[i] <- which.min(distance)
  }
  ## check if assignments change
  identical <- identical(old_assign_vec, assign_vec)
}


## check assignment with scatter plot
plot_df <- bind_cols(df, as.data.frame(assign_vec))
g <- ggplot(plot_df, mapping = aes(x = x, y = y,
                                   color = factor(assign_vec))) +
  geom_point()

## show
g


## ---------------------------------------------------------
## Convert to functions
## ---------------------------------------------------------


## Euclidean distance^2
euclid_dist_sq <- function(x,y) return(sum((x - y)^2))


## compute new means for points in cluster
compute_mean <- function(data, k, assign_vec) {
  ## init means matrix: # means X # features (data columns)
  means <- matrix(NA, k, ncol(data))
  ## for each mean, k...
  for (i in 1:k) {
    ## ...get column means, restricting to cluster assigned points
    means[i,] <- colMeans(data[assign_vec == i,])
  }
  return(means)
}


## find nearest mean to each point and assign to cluster
assign_to_cluster <- function(data, k, means, assign_vec) {
  ## init within-cluster sum of squares for each cluster
  wcss <- numeric(k)
  ## for each data point (slow!)...
  for (i in 1:nrow(data)) {
    ## ...init distance vector, one for each cluster mean
    distance <- numeric(k)
    ## ...for each mean...
    for (j in 1:k) {
      ## ...compute distance to point
      distance[j] <- euclid_dist_sq(data[i,], means[j,])
    }
    ## ...assign to cluster with nearest mean
    assign_vec[i] <- which.min(distance)
    ## ...add distance to running sum of squares
    ## for assigned cluster
    wcss[assign_vec[i]] <- wcss[assign_vec[i]] + distance[assign_vec[i]]
  }
  return(list("assign_vec" = assign_vec, "wcss" = wcss))
}


## standardize function that also returns mu and sd
standardize_dat <- function(data) {
  ## column means
  mu <- colMeans(data)
  ## column standard deviations
  sd <- sqrt(diag(var(data)))
  ## scale data (z-score); faster to use pre-computed mu/sd
  sdata <- scale(data, center = mu, scale = sd)
  return(list("mu" = mu, "sd" = sd, "scaled_data" = sdata))
}


## ---------------------------------------------------------
## K-means function
## ---------------------------------------------------------


## k-means function
my_kmeans <- function(data,                  # data frame
                      k,                     # number of clusters
                      iterations = 100,      # max iterations
                      nstarts = 1,           # how many times to run
                      standardize = FALSE) { # standardize data?
  ## convert to matrix
  x <- as.matrix(data)
  ## standardize if TRUE
  if (standardize) {
    sdata <- standardize_dat(data)
    x <- sdata[["scaled_data"]]
  }
  ## for number of starts
  for (s in 1:nstarts) {
    ## init identical
    identical <- FALSE
    ## select k random points as starting means
    means <- x[sample(1:nrow(x),k),]
    ## init assignment vector
    init_assign_vec <- rep(NA, nrow(x))
    ## first assignment
    assign_wcss <- assign_to_cluster(x, k, means, init_assign_vec)
    ## iterate until iterations run out
    ## or no change in assignment
    while (iterations > 0 && !identical) {
      ## store old assignment / wcss object
      old_assign_wcss <- assign_wcss
      ## get new means
      means <- compute_mean(x, k, assign_wcss[["assign_vec"]])
      ## new assignments
      assign_wcss <- assign_to_cluster(x, k, means, assign_wcss[["assign_vec"]])
      ## check if identical (no change in assignment)
      identical <- identical(old_assign_wcss[["assign_vec"]],
                             assign_wcss[["assign_vec"]])
      ## reduce iteration counter
      iterations <- iterations - 1
    }
    ## store best values...
    if (s == 1) {
      best_wcss <- assign_wcss[["wcss"]]
      best_centers <- means
      best_assignvec <- assign_wcss[["assign_vec"]]
    } else {
      ## ...update accordingly if number of starts is > 1
      ## & wcss is lower
      if (sum(assign_wcss[["wcss"]]) < sum(best_wcss)) {
        best_wcss <- assign_wcss[["wcss"]]
        best_centers <- means
        best_assignvec <- assign_wcss[["assign_vec"]]
      }
    }
  }
  ## convert back to non-standard centers if necessary
  if (standardize) {
    sd <- sdata[["sd"]]
    mu <- sdata[["mu"]]
    for (j in 1:ncol(x)) {
      best_centers[,j] <- best_centers[,j] * sd[j] + mu[j]
    }
  }
  ## return assignment vector, cluster centers, & wcss
  return(list("assignments" = best_assignvec,
              "centers" = best_centers,
              "wcss" = best_wcss))
}


## ---------------------------------------------------------
## Run k-means function
## ---------------------------------------------------------


## 2 dimensions
km_2d <- my_kmeans(data = df[,c("x","y")], k = 3, nstarts = 20)

## check assignments, centers, and wcss
km_2d$assignments[1:20]
km_2d$centers
km_2d$wcss


## 3 dimensions
km_3d <- my_kmeans(data = df, k = 3, nstarts = 20)

## check centers and wcss
km_3d$assignments[1:20]
km_3d$centers
km_3d$wcss


## ---------------------------------------------------------
## Plot our results using plotly
## ---------------------------------------------------------


## using 2D: looks good 2D...
p <- plot_ly(df, x = ~x, y = ~y, color = factor(km_2d$assignments)) %>%
  add_markers()

## show
p


## ...but off in 3D
p <- plot_ly(df, x = ~x, y = ~y, z = ~z, color = factor(km_2d$assignments),
             marker = list(size = 3)) %>%
  add_markers()

## show
p


## using 3D: looks off in 2D...
p <- plot_ly(df, x = ~x, y = ~y, color = factor(km_3d$assignments)) %>%
  add_markers()

## show
p


## ...but clearly better fit in 3D
p <- plot_ly(df, x = ~x, y = ~y, z = ~z, color = factor(km_3d$assignments),
             marker = list(size = 3)) %>%
    add_markers()

## show
p



## =============================================================================
## END SCRIPT
################################################################################
