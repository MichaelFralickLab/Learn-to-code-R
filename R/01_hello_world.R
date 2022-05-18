### Hello World -----

# '<-' is the assignment operator
# we 'assign' the character string 'hello world' to the variable my_value

# use Ctrl + Enter or ⌘ + Enter
greeting <- 'Hello world!'

# print returns the value in the console
print(x = greeting)

### --- functions / documentation

# what is print? It's a function
?print
class(print)

# arguments are the input to functions, x is an argument
# we pass our data to functions as arguments
print(x = greeting)

# some functions don't need any arguments
Sys.Date()

# some take a single argument
factorial(3)

# some arguments are optional / have defaults,
# eg. the natural logarithm is the default
log(x = 2, base = exp(1))
log(x = 2)

# we don't even need to name the arguments,
# BUT make sure to get the correct order!
log(2)
log(exp(1), 2)

# functions can take multiple arguments, lets look at
?paste

# the '...' argument means paste can take any number of arguments
# these must be separated by commas
paste('Hello ', 'World!')



## primitve data types
num <- 1.23456789   # double
char <- 'character' # string
boolean <- TRUE        # logical
d <- date()  #  special
cat <- factor('A')  # has levels

# coerce more complex data into more basic types
time |> as.numeric() |> as.character() |> as.factor()

# vectors (we're standing on them right now....)
my_value
rep('Hello world!', times = 100)

# list_data
list(
  x = 1:4,
  y = (1:4) ** 2
)

# data.frames
data.frame(
  x = 1:4,
  y = (1:4) ** 2
)


tibble::tibble(
  x = 1:4,
  y = x ** 2
)


#
# tbl <- tibble::tibble(df)
#
# print(df)
# print(tbl)
#
# !identical(df, tbl)
# # they're not 'identical', but it's 'all' good
# if (all(df == tbl)) print('saul goodman')
#
# library(tidyverse)
# tibble(x = )



