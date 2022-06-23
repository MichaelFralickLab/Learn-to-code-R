##################################################
## Project: R syntax and datatypes. My first R script!
##################################################
#'
#' In this segment, I'll introduce you to R code and data types...
#'
#' Think of this as watching the opening credits for a movie:
#' it's a brief intro to the things we'll be exposed to later.
#'
#' The examples are trivial to focus the basics of code and data.
#' Don't type along here, just try to capture what is happening.
#'
#'
#'
#' https://raw.githubusercontent.com/jmoggridge/Learn-to-code-R/main/R/syntax_datatypes.R
#################################################


##----------------------------------------------##
#' 1. assign an object to a name with <-
##----------------------------------------------##
# name <- expression

# use keyboard shortcut for <-
  # 'alt' and '-'  on windows
# 'option' and '-' on Mac

# store a value in memory...
my_value <- 5

# so that we can use it later
print(my_value * 10)


#' where did `print` come from?
##----------------------------------------------##
?print


#' remove objects with rm()
##----------------------------------------------##
rm(my_value)





##----------------------------------------------##
#' primitive data types
##----------------------------------------------##
# we've seen this type
dbl_val <- 1.2

# integer has an L after it
int_val <- 5L

# but not seen these
chr_val <- 'text or string data'
lgl_val <- FALSE

fct_val <- factor('category1')
date_val <- Sys.Date()

#
missing_val <- NA
not_a_number <- sqrt(-1)
empty_container <- NULL


#' Check out the environment panel, both 'list' and 'grid' views
# now let's clear out all the objects we created (like the broom button)
rm(list = ls())

#' restart R with 'cmd + shft + 0'

##----------------------------------------------##
#' coerce data from one class to another
##----------------------------------------------##
fct_val <- factor('category1')
class(fct_val)
is.factor(fct_val)
is.character(fct_val)

chr_val <- as.character(fct_val)
chr_val
class(chr_val)

as.logical(fct_val)
as.numeric(fct_val)
as.logical(as.numeric(fct_val))

