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
fibonacci(n = 1:10) # huh?
# our function isn't vectorized!

# could do iteration with a map
# get first 10..
tibble(
  n = 1:10,
  fib = map_dbl(n, .f = fibonacci)
)

tibble(
  n = 1:10,
  fib = map_dbl(n, .f = fibonacci)
) |>
  ggplot(aes(n, fib)) +
  geom_point() +
  # scale_y_log10() +
  # geom_smooth() +
  labs(x = 'sequence', y = 'fibonacci')



tibble(
  n = 1:50,
  fib = map_dbl(n, .f = fibonacci)
) |>
  ggplot(aes(n, fib)) +
  geom_point() +
  # scale_y_log10() +
  # geom_smooth() +
  labs(x = 'sequence', y = 'fibonacci')

# do the fibonacci calc from ground up
# with memoization (dynamic programming)
fib_seq <- function(n){
  fib_fill <- rep(NA, times = as.integer(n - 2))
  fib_list <- c(1, 1, fib_fill) # init
  purrr::walk(
    .x = seq(3, n),
    .f = ~{
      fib_list[.x] <<- fib_list[.x - 1] + fib_list[.x - 2] # update
    }
  )
  return(fib_list)
}

n <- 1000

tibble(
  x = seq(n),
  f = fib_seq(n),
) |>
  ggplot(aes(x, f)) +
  geom_point(size = 0) +
  scale_y_continuous(trans = 'log2')

# take the log2 transformed fib seq.
fib_data <- tibble(x = seq(n), fib = fib_seq(n), fib_log2 = log2(fib))

# look at how good this linear model fits... it's wrong but so close.
fib_model <- lm(fib_log2 ~ x, data = fib_data)



fib_data |> bind_cols(resid = fib_model$residuals) |>
  ggplot(aes(x, resid)) +
  geom_point() +
  geom_smooth()


