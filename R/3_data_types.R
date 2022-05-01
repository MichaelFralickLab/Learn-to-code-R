# Objects, vectors, data types, lists

# we can create an object by assigning to a name
x <- 2

# R will place that object's value when we plug it into a function
sqrt(x)

# print the value just by calling the object
x

# we can overwrite that name if we assign a new value
x <- 3
sqrt(x)

# create an object called my_data that stores 10 random values,
# print it to the screen
rnorm(n = 10, mean = 0, sd = 1)

data <- rnorm(n = 10, mean = 0, sd = 1)
print(data)
copy <- data
print(copy)


# remove your object with rm()
rm(data, copy, x)



# naming things is hard... ----

# i_use_snake_case
snake_case_name <- 'this is nice'
CamelCaseName <- 'generally ok too'
reallyUGLYname <- 'dont make me swing on you, bro'


## Syntatic names ----
# no spaces!
bad name <- 'error: unexpected symbol; highlighted as error already'

# never start with a number & don't use symbols
9*lives <- 'error: target of assignment expands to non-language object'

# if you must: wrap the name with quotes.
`9*lives` <- 'works but cumbersome'
`9*lives`






## Vectors: 1d array of values

# a single value is actually just a vector of length one
1

# create a vector with c()
my_vector <- c(1, 5, 4, 2, 7, 8, 5, 5, 6, 7)

# many functions take a vectors an return a single value
sum(my_vector)
max(my_vector)
min(my_vector)
median(my_vector)

# but other operations for single values usually vectorized
# automatic iteration / we don't need to use loops.
my_vector
my_vector + 10
factorial(my_vector)

# some functions take multiple vectors
vec <- 1:5
vec2 <- 5:1
pmax(vec, vec2)

# extract any element with [index]
vec2[3]
vec2[4]
vec2[c(2,3,4)]



## Data types

# dynamic typing - R recognizes your data..
numeric_vec <- c(1,2,3)
# can do math with it

character_vec <- c('a', 'b', 'cdefg')
# can do text ops with it

typeof(character_vec)
typeof(numeric_vec)

#' TODO
#' say that we have a bunch of patient id numbers...
#' {576, 948, 202, 102, 11, 2030}
#' store these as a vector called patients
patients <- c(576, 948, 202, 102, 11, 2030)

#
patients[1] + patients[4]

# does it make sense to do math on id numbers? no...
patients <- as.character(c(576, 948, 202, 102, 11, 2030))


integer_vec <- c(1L, 2L, 3L)
typeof(integer_vec)


# logical values
tests <- c(TRUE, FALSE)
# shorthand
tests2 <- c(T, F)

concordance_test <- identical(tests, tests2)
concordance_test

class(iris)




# Combining types -> vector can only take one type
c(1, TRUE, 'hello')
typeof(c(1, TRUE, 'hello'))
# data are coerced to the simplest type: character!

# numeric is next simplest type!
c(1, TRUE)


## LIST : a set of vectors!

## what we need for complex data are lists...
my_list <- list(1:5, TRUE, 'hello')
print(my_list)
typeof(my_list)

# if you know what i mean...
my_typeof_list <- purrr::map(.x = my_list, .f = typeof)


# can assign names
names(my_list) <- purrr::map(my_list, typeof)

my_list

# access a vector within the list with dollarsign
my_list$character



## Data.frame -> special case of list where all children are same length
# rectagular list of vectors -> table

# simulated bear neck girth measurements
n <- 100

df <- data.frame(
  name = sample(babynames::babynames$name, replace = F, size = n),
  bear_neck_girth = rnbinom(n = n, mu = 40, size = 10)
)

df |> head()


hist(df$bear_neck_girth)

# y = mx + b + error
b <- 25.5
m <- 4
error <- rnorm(n = nrow(df), mean = -20, sd = 500)

df$bear_weight <- beta_1 * df$bear_neck_girth + beta_0 + error

plot(df$bear_neck_girth, df$bear_weight)

lm(bear_weight ~ bear_neck_girth, data = df) |> plot()



