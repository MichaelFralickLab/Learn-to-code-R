##################################################
## Project: R syntax and datatypes. My first R script!
##################################################
#'
#' In this segment, I'll introduce you to R code and data types...
#'
#' Think of this as watching the opening credits for a movie:
#' it's a brief intro to the things we'll be exposed to later.
#'
#' These examples are simple to expose the basic mechanics of R.
#' Don't follow along here just focus, the examples are short and simple.
#'
##################################################

##----------------------------------------------##
#' 1. assign an object to a name with <-
##----------------------------------------------##
# name <- object
# use keyboard shortcut for <- : 'alt' and '-'

# store a value
my_value <- 5

# so that we can use it later
print(my_value * 10)


#' where did `print` come from?
##----------------------------------------------##
?print


#' remove objects with rm()
##----------------------------------------------##
rm(my_value)


#' primitive data types
##----------------------------------------------##
# we've seen this type
dbl_val <- 1.2

# but not seen these
chr_val <- 'text or string data'
lgl_val <- TRUE
fct_val <- factor('category1')
date_val <- Sys.Date()
missing_val <- NA
nothing <- NULL


#' Check out the environment panel list and grid views
# there are other specific types but this is most of what we'll encounter

# clean up the workspace...
rm(list = ls())

#' restart R with 'cmd + shft + 0'
#

#' coerce data from one class to another
##----------------------------------------------##
fct_val <- factor('category1')
class(fct_val)

chr_val <- as.character(fct_val)
chr_val
class(chr_val)

as.logical(fct_val)
as.numeric(fct_val)
as.logical(as.numeric(fct_val))





#' we can do all the **math** you want
##----------------------------------------------##
# + - * / ** // log exp sin cos tan  %/% %% ....

9 %/% 2
9 %% 2

#' ...or **boolean** algebra
##----------------------------------------------##
# | 'or'
# & 'and'
# ! 'not'
a <- T
b <- F
a | b      # true

a | b      # true
a & b      # false
!a         # false

# what does this return and why?
(a | b) & !(a & b)

# 'xor': one or the other is true but not both
base::xor |> View()

# xor <- function(x, y){
#   # cat("powered by Jason\n")
#   (x | y) & !(x & y)
# }
# xor |> View()

xor(T, T)
xor(T, F)
xor(F, T)
xor(F, F)

# congrats, you've just learned boolean algebra



#' **vectors**
##----------------------------------------------##
# any single value is already a vector...
print('some text')

# the [1] indicates the index of our value.
# our object named chr_val is a vector of length 1.
is.vector('some text')
length('some text')

# use is.* functions to test
is.vector('some text')
is.numeric('some text')


#' *which is.<class> function would return true for text input?*
# uncomment the next line (cmd + C), delete <class>,
# and hit tab to get autocompletion

# is.<class>('some text')


#' *combine ... into a vector with c()*
##----------------------------------------------##
my_vector <- c(1, 2, 3)
my_vector

#' *vectorized operations*
##----------------------------------------------##
#' most functions that operate on a single value will
#' also do the operation *for each* value in a vector
my_vector * 2

paste('number:', my_vector)


#' *subset with indices (generally discouraged)*
##----------------------------------------------##
another_vector <- letters[1:10]


#' *vectors can't have different types of data*
##----------------------------------------------##
my_vector <- c(1, 2, 3, '?')
print(my_vector)
class(my_vector)
as.numeric(my_vector)

#' *but lists can store all types of data, including vectors & lists
##----------------------------------------------##
my_list <- list(group = 'A',
                length = 1.5769,
                treatment = T,
                dose = 30
                parents = c('Bob', 'Alice')
                )
print(my_list)

#' but data.frames are better if data is a table
##----------------------------------------------##
my_df <- data.frame(group = 'A',  length = 1.5769, treatment = T, dose = 30)
print(my_df)














