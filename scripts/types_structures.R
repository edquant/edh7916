################################################################################
##
## <PROJ> EDH7916: Data types and structures <supplemental>
## <FILE> types_structures.R 
## <INIT> 6 January 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################


## ---------------------------------------------------------
## Data types and structures
## ---------------------------------------------------------

## ---------------------------
## types
## ---------------------------

## ------------
## logical
## ------------

## assignment
x <- TRUE
x

## ! == NOT
!x

## check: is it a logical type?
is.logical(x)

## evaluate (notice the double `==`)
1 + 1 == 2


## ------------
## numeric
## ------------

## use 'L' after digit to store as integer
x <- 1L
is.integer(x)

## R stores as double by default
y <- 1
is.double(y)

## both are numeric
is.numeric(x)
is.numeric(y)


## ------------
## character
## ------------

## store a string using quotation marks
x <- "The quick brown fox jumps over the lazy dog."
x

## store a number with leading zeros
x <- "00001"
x


## ---------------------------
## structures
## ---------------------------


## ------------
## vector
## ------------

## create vector
x <- 1

## check
is.vector(x)

## add to vector
## NB: can do so recursively meaning old x can help make new x
x <- c(x, 5, 8)
x

## no dim...
dim(x)

## ...but length
length(x)


## get the second element
x[2]


## check class of x
class(x)

## add character
x <- c(x, "a")
x

## check class
class(x)


## ------------
## matrix/array
## ------------


## create 3 x 3 matrix that is the sequence of numbers between 1 and 9
x <- matrix(1:9, nrow = 3, ncol = 3)
x

## ...fill by row this time
y <- matrix(1:9, nrow = 3, ncol = 3, byrow = TRUE)
y

## a matrix has two dimensions
dim(x)


## # of rows
nrow(x)

## # of columns
ncol(x)


## show the values in the first row
x[1, ]

## show the values in the third column
x[ ,3]

## this is the same as just calling x by itself
x[ , ]


## ------------
## list
## ------------


## create single-level list
x <- list(1, "a", TRUE)

## show
x

## check
is.list(x)

## create blank list
y <- list()

## add to first list, creating nested list
z <- list(x, y)

## show
z

## the first item in list z is list x
z[[1]]

## to get to "a" in list x, need to add more brackets
z[[1]][[2]]


## ------------
## data frame
## ------------


## create data frame where col_* are the column (variable) names
df <- data.frame(col_a = c(1,2,3),
                 col_b = c(4,5,6),
                 col_c = c(7,8,9))

## show
df

## check
is.data.frame(df)
    

## get column names
names(df)


## get col_a
df$col_a


## get col_a (note the quotation marks this time)
df[["col_a"]]

