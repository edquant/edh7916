################################################################################
##
## <PROJ> EDH7916: Functional programming
## <FILE> programming.R 
## <INIT> 14 February 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")
sch_dir <- file.path(dat_dir, "sch_test")
bys_dir <- file.path(sch_dir, "by_school")

## -----------------------------------------------------------------------------
## Part I: Control flow
## -----------------------------------------------------------------------------

## ---------------------------
## for
## ---------------------------

## make vector of numbers between 1 and 10
num_sequence <- 1:10

## loop through, printing each num_sequence value, one at a time
for (i in num_sequence) {
    print(i)
}

## character vector using letters object from R base
chr_sequence <- letters[1:10]

## loop through, printing each chr_sequence value, one at a time
for (i in chr_sequence) {
    print(i)
}

## for loop by indices
for (i in 1:length(chr_sequence)) {
    print(chr_sequence[i])
}

## for loop by indices (just show indices)
for (i in 1:length(chr_sequence)) {
    print(i)
}

## confirm that we can use variables as indices
i <- 1                     # set i == 1
chr_sequence[i]      
i <- 2                     # now set i == 2
chr_sequence[i]            # notice that code is exactly the same here

## for loop by indices (once again)
for (i in 1:length(chr_sequence)) {
    print(chr_sequence[i])
}

## ---------------------------
## while
## ---------------------------

## set up a counter
i <- 1
## with each loop, add one to i
while(i < 11) {
    print(i)
    i <- i + 1
}

## ---------------------------
## if
## ---------------------------

## only print if number is not 5
for (i in num_sequence) {
    if (i != 5) {
        print(i)
    }
}

## if/else loop
for (i in num_sequence) {
    if (i != 3 & i != 5) {
        print(i)
    } else if (i == 3) {
        print('three')
    } else {
        print('five')
    }
}

## -----------------------------------------------------------------------------
## Part II: Writing functions
## -----------------------------------------------------------------------------

## ---------------------------
## hello function
## ---------------------------

## function to say hi!
say_hi <- function() {
    print("Hi!")
}

## call it
say_hi()

## function to say hi!
say_hi <- function(name) {
    ## combine (notice we add space after comma)
    out_string <- paste0("Hi, ", name, "!")
    ## print output string
    print(out_string)
}

## call it
say_hi("Leo")

## ---------------------------
## print sequence of numbers
## ---------------------------

## new function to print sequence of numbers
print_nums <- function(num_vector) {
    ## this code looks familiar...
    for (i in num_vector) {
        print(i)
    }
}

## try it out!
print_nums(1:10)

## v1
print_nums(1)

## v2
print_nums(1:5)

## v3
print_nums(seq(1, 20, by = 2))

## -----------------------------------------------------------------------------
## Part III: Practical examples
## -----------------------------------------------------------------------------

## ---------------------------
## missing values to NA
## ---------------------------

## create a data frame with around 10% missing values (-97,-98,-99) in
## three columns
df <- tibble("id" = 1:100,
             "age" = sample(c(seq(11,20,1), -97),
                            size = 100,
                            replace = TRUE,
                            prob = c(rep(.09, 10), .1)),
             "sibage" = sample(c(seq(5,12,1), -98),
                               size = 100,
                               replace = TRUE,
                               prob = c(rep(.115, 8), .08)),
             "parage" = sample(c(seq(45,55,1), c(-98,-99)),
                               size = 100,
                               replace = TRUE,
                               prob = c(rep(.085, 11), c(.12, .12)))
             ) 
## show
df

## function to fix missing values
fix_missing <- function(x, miss_val) {
    ## use ifelse(< test >, < do this if TRUE >, < do that if FALSE >)
    x <- ifelse(x %in% miss_val,        # is x == any value in miss_val?
                NA,                     # TRUE: replace with NA
                x)                      # FALSE: return original value as is
    ## return corrected x
    return(x)
}

## check
df %>%
    count(age)

## missing values in age are coded as -97
df <- df %>%
    mutate(age = fix_missing(age, -97))

## recheck
df %>%
    count(age)

## ---------------------------
## batch read files: all
## ---------------------------

## read in all Bend Gate test score files
df_1 <- read_csv(file.path(bys_dir, "bend_gate_1980.csv"))
df_2 <- read_csv(file.path(bys_dir, "bend_gate_1981.csv"))
df_3 <- read_csv(file.path(bys_dir, "bend_gate_1982.csv"))
df_4 <- read_csv(file.path(bys_dir, "bend_gate_1983.csv"))
df_5 <- read_csv(file.path(bys_dir, "bend_gate_1984.csv"))
df_6 <- read_csv(file.path(bys_dir, "bend_gate_1985.csv"))

## append
df <- bind_rows(df_1, df_2, df_3, df_4, df_5, df_6)

## show
df

## get names (with full path) of all school test score files
files <- list.files(bys_dir, full.names = TRUE)

## show
files

## init list
df_list <- list()

## use loop to read in files
for (i in 1:length(files)) {
    ## read in file (f) and store in list (note double brackets for list)
    df_list[[i]] <- read_csv(files[i])    
}

## show first 3 items
df_list[1:3]

## bind our list to single data frame
df <- df_list %>%
    bind_rows()

## show
df

## ---------------------------
## batch read files: some
## ---------------------------

## filter files to be read in using pattern
files_sp <- list.files(bys_dir, pattern = "spottsville", full.names = TRUE)

## check
files_sp

## init list
df_sp_list <- list()

## use loop to read in files
for (i in 1:length(files_sp)) {
    ## read in file (f) and store in list
    df_sp_list[[i]] <- read_csv(files_sp[i])    
}

## bind our list to single data frame
df_sp <- df_sp_list %>%
    bind_rows()

## show
df_sp

## ---------------------------
## batch read files: map()
## ---------------------------

## use purrr::map() to read in all files; then pipe into bind rows
df <- map(files,
          ~ read_csv(.x)) %>%
    bind_rows()

## show
df

## -----------------------------------------------------------------------------
## end script
################################################################################
