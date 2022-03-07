## Tutorial 2.

#' This tutorial teaches you how to deal with (1) non-tidy data, (2) pivoting data between long and wide forms using `tidyr`, and (3) performing operations on list columns with `purrr`.

## Binding rows or columns -------------------------------------------

# bind_rows()
# bind_cols()


## Joins  ------------------------------------------------------------

# left_join()
# full_join()
# inner_join()
# anti_join()

## Nesting / list columns --------------------------------------------

# nest()
# unnest()

## Functions... ------------------------------------------------------

# define a function
my_function <- function(
  # arguments here
){
  # code here

  # return statement
  return('Hello world')
}

# call it later
my_function()


## Functional programming --------------------------------------------

# map()
# map_*

# mutate and map combo on grouped data columns....

# map to work over a series of complex objects (like models)




# # pipelines.... -----
# map(
#   penguins,
#   ~as_factor(.x) |> levels() |> length()
# ) |>
#   enframe() |>
#   unnest(cols = c(value)) |>
#   filter(value < 5) |>
#   pull(name)
