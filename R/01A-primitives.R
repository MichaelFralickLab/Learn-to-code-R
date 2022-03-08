### Lesson 1

# spend 5 mins making sure R + Rstudio are setup for everyone
# this is the Rstudio 'integrated development environment' (IDE)...
# orientation: find your editor,console, environment, and files panes.

# <- any line that starts with # is a comment
#' code syntax is highlighted to help you read it


# '<-' is the assigment operator
my_variable <- 'hello world'

# print returns the value in the console
print(my_variable)

# so does just calling the value
my_variable


## Primitives (5min) ------------------------------------------------------------

# lets talk about 'primitives', the building blocks of data...

# logical or boolean values
TRUE
FALSE
NA # missing value

# numbers
1
pi

# character / string
"i am character data in quotes"

# special cases - more complex
factor('now im a factor')
as.Date('1999-12-31')



## Containers with multiple values -----------------------------------------

# store a series of values

# vector
c(1,2,3)

# list
list('a', 1, T)
c('a', 1, T)

# data.frame -> list of equal length vectors
data.frame(x = c(1,2,3), y = c('a','b','c'))

# matrix (not discussed)

## Missing values (2min) -------------------------------------------------------

# these are 'nothing's for different contexts
x <- NULL      # empty list in place of a list.
y <- NA        # single missing value in place of a value.
z <- NaN       # not-a-number in place of a numeric value.


# booleans (2min) --------------------------------------------------------------

# tests -> result is a boolean
TRUE
FALSE

# equality tests
1 == 1
1 > 2
1 < 2
1 <= 2
1 >= 2

# membership test
1 %in% c(1,2,3)

# boolean operators ! & |
# 'not': !x does negation of x
!T
!F
1 != 2

# AND: x & y
T & F

# OR: x | y
T | F

# any(...), all(...) take multiple values and result a single result
any(T, F)
all(T, F)


# using tests to control flow ----------

# imagine a website where the user tries to guess a number between 1 and 10...
user_guess <- 2
answer <- 9
user_wins <- user_guess == answer

# we would use `if (test) ` as  conditional statement here to control the flow of the program to either
if (user_wins) {
  'Winner!'
} else {
  'Try again'
}

# cleaner way that is 'vectorised'
user_guess <- c(1, 2, 4, 9)
answer <- c(10, 7, 8, 9)
results <- ifelse(test = user_guess == answer, yes = 'Winner!', no =  "Try again")


# synonymous values of different types -> weird!!!
T == 1
T == 0
T == -1
T == 2

# but with coercion, we get T for any non-zero value (except NA)
T == as.logical(2)

# true is 1 and false is 0, by 'coercion' - forced change between classes
as.logical(1);
as.logical(0);
as.numeric(T);
as.numeric(F);




# Numeric values ------------------------------------------------------------

# numbers & basic math;
r <- 4
r + 2
r - 2
r * 2
r / 2
r ** 2
2 ** (r+1)
# 'bedmas'
2**3 - 9*4

pi * r ** 2

# exponentiation, logarithms, ...
exp(r)
10**r
log(r, base = 2)
log10(r)

10**log10(r) == r

sqrt(r)
-r
sqrt(-r)
sqrt(abs(-r))

# trig functions...
cos(pi)
sin(pi)
tan(pi)

5.5 %/% 2 # floor division operator %/%
5.5 %% 2  # modulo operator %% (returns remainder)

# round numbers
round(2.3452348758234, 2)
ceiling(0.000001)
floor(0.999999999)



# character data --------------------------------------------------------

some_text <- "hi, i'm character data, otherwise known as a string (of characters)"


# factor: character with defined levels. (internally as integer)
factor(TRUE)
factor(1)
A <- factor('A')

# dates - a special case
today <- Sys.Date()
today
class(today)

# coerce dates from character with yyyy-mm-dd automatically
as.Date('2021-01-01')
# "character string is not in a standard unambiguous format"
as.Date('December 31st, 1999')
# even worse!
as.Date('31-12-1999')

today <- Sys.Date()
today + 5 # adds five days!
as.numeric(today)
as.numeric(today - 5)

# dates are internally representated as days since 1970-01-01
today - as.numeric(today)



# classes
class(NULL)
class(NA)
class(TRUE)
class(FALSE)
class(NaN)
class(1)
class(pi)
class('hi')
class(factor('hi'))
class(Sys.Date())


# vectors, lists, tibbles

# vector - a set values of a single class
a <- c(1,2,4)
a
class(a)
length(a)

# lots of functions to generate vectors... good for simulation
seq(1, 100, by = 1)
1:100
rep(1,100)
rnorm(100, mean  = 50, sd = 18)

# list - a set of values of any type
b <- list('X', 1, Sys.Date(), list('foo', 'bar'))

# lists can be complex hierarchical / nested data structures.
bb <- list(
  a = 'X',
  b = 1,
  c = Sys.Date(),
  bb = list(a = 'XX', b = 11, c = Sys.Date(), bb = list('foo', 'bar')))

# behold the data.frame,
# a rectangular (same-length) set of vectors and/or lists, where
# each vector/list is a column.

df <- data.frame(
  x = 1:100,
  y = 'a',
  z = sample(c(T, F), size = 100, replace = T)
)

print(df)
str(df)

tibble::tibble(df)

rm(list = ls())
