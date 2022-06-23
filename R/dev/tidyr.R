#-----------------------------------------------------
#' *Advanced data handling and two-table verbs*
#'
#' In this segment, we'll look at a few operations that
#' allow us to handle more complex data efficiently.
#'
#' We'll look at these functions from tidyr and purrr:
#'
#' - `bind_*`
#'   * add columns or rows in block
#' - `nest / unnest`
#'   * become a master of hierarchical data handling
#' - `map`
#'   * how to repeat operations over vectors and lists
#' - `pivot_*`s
#'   * making data into columns and viceversa
#' - `*_join`
#'   * operations that involve matching rows between two tables
#'
#-----------------------------------------------------

library(tidyverse)

#-----------------------------------------------------

#' *Bind data*

'rows'
# easy to stack tables with same column names
bind_rows(starwars, starwars) |> arrange(name)

# watch out not to do something nonsensical like this though
bind_rows(starwars, iris) |> view()


'Bind cols'
# imagine we have a linear model
model <- lm(mass ~ height, data = starwars)
summary(model)

pred_mass <- predict(object = model, newdata = df)

df |>
  bind_cols(pred_mass = pred_mass) |>
  relocate(contains('mass'))

#-----------------------------------------------------

#' *Nested data*

#' open up a nested column with `unnest`
pilots <- starwars |>
  select(name, starships) |>
  unnest(starships) |>
  print()

pilots |>
  ggplot(aes(y = name, x = starships)) +
  geom_point() +
  scale_x_discrete(position = 'top') +
  theme(axis.text.x.top = element_text(angle = 60, hjust = 0))



#' note that values in other columns are duplicated to accomodate the rows that are created by unnesting (as necessary). Values in 'name' are no longer distinct

#' fold data up with `nest`
planets <-
  starwars |>
  select(name, homeworld) |>
  nest(characters = name) |>
  print()

#-----------------------------------------------------

#' *Pivot longer and pivot wider*
#' change data from wide to long and viceversa

starships_matrix <-
  pilots |>
  mutate(true = T) |>
  pivot_wider(names_from = starships, values_from = true, values_fill = F) |>
  glimpse()


starships_matrix |>
  pivot_longer(-name, names_to = 'starships') |>
  filter(value) |>
  select(-value)

# using a helper, pivoting, & facetted plots
starwars |>
  select(name, where(is.numeric)) |>
  pivot_longer(-name, names_to = 'attribute') |>
  ggplot(aes(x = value)) +
  geom_histogram() +
  facet_wrap(facets = vars(attribute), scales = 'free_x', ncol = 1)

#-----------------------------------------------------

#' *Join data*

species_lookup <- starwars |>
  count(species, sort = T) |>
  transmute(
    species,
    pooled_species = if_else(condition = (n == 1), 'Other', species)
  )

starwars |>
  left_join(species_lookup, by = "species") |>
  glimpse()




