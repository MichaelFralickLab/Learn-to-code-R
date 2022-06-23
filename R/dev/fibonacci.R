# fibonacci -> p solving / finite maths / algos
library(tidyverse)

# fibonacci # 1 1 2 3 5 8 13 21 34 55 89

# fibonacci(n) = fibonacci(n-1) + fibonacci(n-2)

fibonacci <- function(n) {
  if (n > 2) {
    return(fibonacci(n - 1) + fibonacci(n - 2)) # recursive!
  } else {
    return(1)
  }
}

# fibonacci(n = 0)
fibonacci(n = 1) # yay
fibonacci(n = 2) # yay
fibonacci(n = 10) # yay
fibonacci(n = 1:10) # huh?

# this is happening because our function isn't vectorized!
# it doesn't accept more than a single value because if/else tests the entire input vector at once instead of for each value

# could do iteration with a map
# get first 10..
fib10 <- tibble(
  n = 1:10,
  fib = map_dbl(n, .f = fibonacci)
)

fib10 |>
  ggplot(aes(n, fib)) +
  geom_point() +
  labs(x = 'sequence', y = 'fibonacci number')


# do the fibonacci calc with *memoization*
fib_seq <- function(n){
  # memo store
  fib_memo <- c(1, 1, rep(NA, times = as.integer(n - 2)))
  purrr::walk(
    .x = seq(3, n),
    .f = ~{
      # update fib_list in the parent enviroment with <<-
      fib_memo[.x] <<- fib_memo[.x - 1] + fib_memo[.x - 2]
    }
  )
  return(fib_memo)
}


# get first 10000
n <- 10**4
fib1000 <- tibble(
 fib1 = fib_seq(n),
  # n = seq_along(fib1),
  # fib = map_dbl(n, .f = fibonacci)
)
