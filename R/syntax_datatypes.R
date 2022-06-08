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



##----------------------------------------------##
#' *Welcome Back*
##----------------------------------------------##

# last time we finished up after introducing data types.

# Data types are important because they add semantic meaning to the characters in our data (eg. numbers have mathematical meaning, dates fall on a timeline, etc.).

#' *Certain operations are only valid on specific data types*

# this operation makes no sense
'a' + 'b'

# but works when we use numbers
pi + pi

##----------------------------------------------##
#' R is a calculator
##----------------------------------------------##

# binary operators
# + - * / **  %/% %% ....
9 + 2
9 - 2
9 * 2
9 / 2

9 %/% 2 # floor division
9 %% 2  # modulo (remainder)

# functions to transform values: eg. log exp sin cos tan abs
log(9, base = 2)
abs(-4.25)

# we can generate even sequences of data
1:100
seq(2, 100, by = 2.5860)

# simulate 1000 obs from a standard normal distribution
normal_data <- rnorm(n = 10**4, mean = 0, sd = 1)

# base:*():  plots is easy (when dealing with univariate data)
base::hist(normal_data)

# there are plenty of stats functions built in
mean(normal_data)
sd(normal_data)
median(normal_data)
quantile(normal_data, probs = c(0, 0.25, 0.5, 0.75, 0.8999))

ecdf(normal_data) |> plot()

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

# there are other operators that you are already familiar with
# <, >, ==, !=, >=, <=

# %in% tests for membership in a set
'a' %in% letters
99 %in% letters

# check a bunch of value for any or all true?
any(F, F, F, T)
all(T, T, T, F)


# congrats, you're an expert in boolean algebra now





##----------------------------------------------##
#' Functions
##----------------------------------------------##
# Lets' write a function with our boolean expression that evaluates xor

jasons_awesome_xor <- function(a, b) {
  xor_result <- (a | b) & !(a & b)
  return(xor_result)
  }

# xor(a,b): returns TRUE if A or B is true but not both, else returns FALSE

# test it out
jasons_awesome_xor(T, F)
jasons_awesome_xor(F, F)
jasons_awesome_xor(T, T)



##----------------------------------------------##
#' **if/else**
##----------------------------------------------##
# 'if' statements are a way to control what the code does depending on the data

# consider some code that informs us whether some value is negative or positive
value <- -0.5

if (value < -1) {
 'value is negative'
} else {
  'value is positive'
}

# else if (value > -1 & value < 0) {
#   'tiny bit negative'
# }


# this is a more compact vectorized representation
ifelse(test = value < 0, # an expression that evaluate to t/f for each value
       yes = 'value is negative',
       no = 'value is positive')




##----------------------------------------------##
#' **vectors and indexing**
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


#' *combine values into a vector with c()*
##----------------------------------------------##
my_vector <- c(1, 2, 3)
my_vector
length(my_vector)


#' *vectorized operations*
##----------------------------------------------##

my_vector > 1.5

#' most functions that operate on a single value will
#' also do the operation *for each* value in a vector

my_vector * 2

paste('number:', my_vector2)

#' subset a vector with another vector of indices
##----------------------------------------------##
letters
letters[1:10]
letters[c(10, 1, 19, 15, 14)]

#' vectors can't have different types of data
#' coercion to simplest type will occur where possible
##----------------------------------------------##
my_vector <- c(1, 2, 3, 'text')
my_vector
str(my_vector) # structure function
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
  diagnoses = list('diabetes', 'gout')
)
print(patient)
str(patient)

# access values by name with $ operator *prefrred
patient$dose[1]

# or by position
patient['dose'][[1]]

# or positions
patient[5][[1]]

# [ does subsetting, returns a list; $ pulls out the vector

##----------------------------------------------##
## Data.frames
##----------------------------------------------##

#' data.frame is preferred over list if possible
patient_df <- as.data.frame(patient)
str(patient_df)

#' do `install.packages('tidyverse')` if you haven't already

# A better data structure is the 'tibble' from tidyverse
tibble::as_tibble_row(patient)


# it allows you to work with columns with lists
tibble::tibble(
  group = 'A',
  weight = 98,
  age = 58,
  treatment = T,
  dose = 30,
  diagnoses = list('diabetes', 'gout')
) |>
  tidyr::nest(diagnoses = diagnoses)

# now we have a tbl with a cell containing it's own tibble. (powerful)


# there are lots of built in datasets in R
iris |> str()

# did I talk about 'the pipe' yet?
tibble::tibble(iris)
iris |>  tibble::tibble()

# we can the result of one function directly to the next (piping)
iris |>  tibble::tibble() |> tibble::glimpse()



## Okay!! Now, we're ready to look at how to manipulate tabular data with dplyr!



