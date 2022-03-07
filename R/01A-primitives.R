### Lesson 1

# spend 5 mins making sure R + Rstudio are setup for everyone

## lets talk about primitives (5 min)


## Missing values ---------------------------------------------------------

# these are 'nothing's for different contexts
x <- NULL      # empty list in place of a list.
y <- NA        # single missing value in place of a value.
z <- NaN       # not-a-number in place of a numeric value.


# booleans ----------------------------------------------------------------
TRUE
FALSE

# boolean operators

# 'not': !
!T
!F

# AND: &
T & F

# OR: |
T | F

# any, all
any(T, F, T)
all(T, F, T)
any((T|F), T)

# tests -> result is a boolean
1 == 1
1 != 2
1 == 2
1 != 2
all(1 == 1, 1 != 2)

# using conditionals to control flow
x <- 2
test <- x == 1

if (!test) {
  print('Test failed')
} else {
  print("test passed")
}

# synonymous values of different types -> weird!!!
T == 1
T == 0
T == -1
T == 2

# true is 1 and false is 0, by 'coercion' - forced change between classes
as.logical(1); as.logical(0)
as.numeric(T); as.numeric(F)




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

"hi, i'm character data, otherwise known as a string (of characters)"

# factor: character with defined levels. (internally as integer)
factor(TRUE)
factor(1)
factor('A')

# dates - a special case
Sys.Date()
class(Sys.Date())
c(0,1,2,3)


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

# vector - a set values of a single type
a <- c(1,2,4)
a
class(a)
length(a)
# lots of functions to generate vectors...
seq(1, 100, by = 1)
1:100
rep(1,100)
rnorm(100, mean  = 50, sd = 18)

# vector - a set of values of any type
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
