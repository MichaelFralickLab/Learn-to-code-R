##----------------------------------------------##
#' *Welcome Back*
#'
#'
#' Last time we finished up after introducing `data types`.
#'
#'
#' `Data types` are important because they add *semantic meaning* to the characters in our data (eg. numbers have mathematical meaning, dates fall on a timeline, etc.).
#'
#'
#'
#' Certain *operations* are only valid on specific *data types*
#'
#'
#' Eg. adding characters makes no sense (in R)
'a' + 'b'


#' instead we use `paste` for *character* data

paste('a', 'b', sep = ' ')


#' similarly

'1' + '2'

#' but `+` works when we use numeric data

1 + 2
pi + pi



#' *watchout* because R will *coerce* you data when it can

FALSE - TRUE




















##----------------------------------------------##
#'
#' Today, we'll quickly look at:
#'
#' `operators` and `functions` to work with `numeric`
#'  and `logical` data types
#'
#' Handling more complex and realistic data...
#'
#' as series with:
#' - `vector`, made with c()
#' - `list`
#'
#' and as tables with:
#' - `data.frame`  👎
#' - `tibble`      👍
#'
#'
#'
#' If we have time, I'll introduce you to *regular expression*
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
##----------------------------------------------##























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

#' use `functions` to transform values:
#' eg.  log exp sin cos tan abs ...
log(9, base = 2)
abs(-4.25)


#' we can generate even *sequences* of data
seq(10)
seq(1, 10, by = 0.5860)


# simulate 1000 obs from a standard normal distribution
normal_data <- rnorm(n = 1000, mean = 0, sd = 1)

# stats functions
mean(normal_data)
sd(normal_data)
median(normal_data)
quantile(normal_data, probs = c(0, 0.25, 0.5, 0.75, 0.86251))
ecdf(normal_data)

# base plots are easy
hist(normal_data)
plot(ecdf(normal_data))























##----------------------------------------------##
#' **boolean algebra**
##----------------------------------------------##

# data
a <- T
b <- F

#' _what value will return from each of these expressions?_

# | 'or'
a | b

# & 'and'
a & b

# ! 'not'
!a



# what does this return and why?
(a | b) & !(a & b)



# there are other operators that look at (in)equality
# <, >, ==, !=, >=, <=
x <- 1
y <- 2

x == y
x != y

x >  y
x >= y
x <  y
x <= y


# %in% tests for membership in a set
'a' %in% letters
99 %in% letters


# imagine we have collected four different test results
tests <- c(F, F, F, T)

#' now we can check all values easily with `any` and `all`
any(tests)
all(tests)



#' congrats, you're an expert in *logic* now!




































##----------------------------------------------##
#' `Functions`
##----------------------------------------------##

#' define your own `function` by typing: *fun* and hit tab
fun





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

# what in tarnation
jasons_awesome_xor(1, 0)

#


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



