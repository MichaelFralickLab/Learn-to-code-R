# functions and arguments

print('Hello world')
# what is print? It's a function
print

# get help for any function
?print

# create a function
# type fun, wait a second for autocompletion
name <- function(variables) {

}

# a really simple function
add_one <- function(x) {
  return(x + 1)
}

# call our function
x_and_one <- add_one(x = 1)
x_and_one

# we're using x as an argument in add_one
# arguments are the input to functions

# some functions don't need any arguments
Sys.Date()

# some take a single argument
factorial(3)

# some arguments are optional / have defaults,
# eg. the natural logarithm is the default
log(x = 2, base = exp(1))
log(x = 2)

# we don't even need to name the arguments,
# BUT then they need to be in the correct order
log(2)
log(exp(1), 2)

# functions can take multiple arguments, lets look at
?paste

# the '...' argument means paste can take any number of arguments
# these must be separated by commans
paste('Hello ', 'World!')

