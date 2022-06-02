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

# but not seen these
chr_val <- 'text or string data'
lgl_val <- TRUE
fct_val <- factor('category1')
date_val <- Sys.Date()
missing_val <- NA
not_a_number <- sqrt(-1)
empty_container <- NULL

# integer has an L after it
int_val <- 5L

#' Check out the environment panel, both 'list' and 'grid' views
# now let's clear out all the objects we created (like the broom button)
rm(list = ls())

#' restart R with 'cmd + shft + 0'

##----------------------------------------------##
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


# data types are important because they add semantic meaning to the characters.
# Certain operations are only valid on specific data types...







##----------------------------------------------##
#' R is great for **math**
##----------------------------------------------##
# + - * / ** // log exp sin cos tan  %/% %% ....

9 %/% 2
9 %% 2

# generate sequences of data
1:100
seq(100)

# simulate data from a distribution
normal_data <- rnorm(100, mean = 0, sd = 1)
normal_data

# there are plenty of stats functions built in
mean(normal_data)
sd(normal_data)






##----------------------------------------------##
#' ...or **boolean** algebra
##----------------------------------------------##
# | 'or'
# & 'and'
# ! 'not'

a <- T
b <- F

# *what will be the value returned from these expressions?*
a | b
a & b
!a

# what does this return and why?
(a | b) & !(a & b)

# congrats, you've just learned boolean algebra

# there are other operators that you are already familiar with
# <, >, ==, !=, >=, <=

# %in% tests for membership in a set
'a' %in% letters
99 %in% letters







##----------------------------------------------##
#' Functions
##----------------------------------------------##
# Lets' write a function with our boolean expression that evaluates xor

xor <- function(a, b){
  return((a | b) & !(a & b))
}
# xor(a,b): returns TRUE if A or B is true but not both, else returns FALSE

# test it out
xor(T, F)
xor(F, F)
xor(T, T)







##----------------------------------------------##
#' **if/else**
##----------------------------------------------##
# 'if' statements are a way to control what the code does depending on the data

# consider some code that informs us whether some value is negative or positive
value <- -2

if (value < 0) {
  print('value is negative')
} else {
  print('value is positive')
}






##----------------------------------------------##
#' **vectors**
##----------------------------------------------##
# any single value is already a vector...
print('some text')

# the [1] indicates the index of our value.
# our object named chr_val is a vector of length 1.
is.vector('some text')
is.vector(1)
length('some text')
nchar('some text')


# use is.* functions to test
is.vector('some text')
is.numeric('some text')


#' *which is.<class> function would return true for text input?*

# uncomment the next line (cmd + C), delete <class>,
# and hit tab to get autocompletion

# is.<class>('some text')





#' *combine '...' values into a vector with c()*
##----------------------------------------------##
my_vector <- c(1, 2, 3)
my_vector
length(my_vector)


#' *vectorized operations*
##----------------------------------------------##
#' most functions that operate on a single value will
#' also do the operation *for each* value in a vector
my_vector2 <- my_vector * 2

paste('number:', my_vector2)

#' subset with indices
##----------------------------------------------##
another_vector <- letters[1:10]

#' vectors can't have different types of data
#' coercion to simplest type will occur where possible
##----------------------------------------------##
my_vector <- c(1, 2, 3, 'text')
str(my_vector)
class(my_vector)


##----------------------------------------------##
#' *lists can store all types of data, including other lists
##----------------------------------------------##
patient <- list(
  group = 'A',
  weight = 98,
  age = 58,
  treatment = T,
  dose = 30,
  parents = list('Bob', 'Alice')
)
print(patient)
str(patient)

# access values by name
dose <- patient$dose[1]

# increase dose
dose + 5

# or position
dose2 <- patient[5][[1]]
class(dose2)

##----------------------------------------------##
## Data.frames
##----------------------------------------------##
#' data.frame is preferred over list if possible
patient <- as.data.frame(patient)
str(patient)

#' a table with one row
patient <- data.frame(
  group = 'A',
  weight = 98,
  age = 58,
  treatment = T,
  dose = 30
)

# get (first) value of dose column
patient$dose[1]
patient[1, 'dose']

# A better data structure is the 'tibble' from tidyverse
tibble::as_tibble(patient)

# it allows you to work with columns with lists
tibble::tibble(
  group = 'A',
  weight = 98,
  age = 58,
  treatment = T,
  dose = 30,
  parents = list(c('Alice', 'Bob'))
) |>
  tibble::glimpse()


# there are lots of built in datasets
iris


# did I talk about 'the pipe' yet?
iris |>  tibble::tibble()
iris |>  tibble::tibble() |> tibble::glimpse()



## Okay!! Now, we're ready to look at how to manipulate tabular data with dplyr!



