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
fibonacci(n = 1:10) # huh? not vectorized

# could do iteration with a map

# get first 10..
tibble(
  x = 1:10,
  y = map_dbl(x, .f = fibonacci)
)

tibble(
  x = 1:10,
  y = map_dbl(x, .f = fibonacci)
) |>
  ggplot(aes(x, y)) +
  geom_point() +
  # scale_y_log10() +
  # geom_smooth() +
  labs(x = 'sequence', y = 'fibonacci')


# do the fibonacci calc from ground up
# with memoization (dynamic programming)
fib_seq <- function(n){
  fib_fill <- rep(NA, times = as.integer(n - 2))
  fib_list <- c(1, 1, fib_fill) # init
  walk(
    .x = seq(3, n),
    .f = ~{
      fib_list[.x] <<- fib_list[.x - 1] + fib_list[.x - 2] # update
    }
  )
  return(fib_list)
}

n <- 1000

tibble(
  f = fib_seq(n),
  x = 1:n,
) |>
  ggplot(aes(x, log10(f))) + geom_point(size = 0)

# look at how good this linear model fits... it's wrong but so close.
lm(f~x, data = tibble(f = log10(fib_seq(n)), x = 1:n)) |>
  summary()
