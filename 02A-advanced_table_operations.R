## Tutorial 2.

#' This tutorial teaches you how to deal with (1) non-tidy data, (2) pivoting data between long and wide forms using `tidyr`, and (3) performing operations on list columns with `purrr`.




## Nesting / list columns --------------------------------------------


## Functional programming....
# pipelines.... -----
map(penguins, ~as_factor(.x) |> levels() |> length()) |>
  enframe() |> unnest(cols = c(value)) |>
  filter(value < 5) |> pull(name)
