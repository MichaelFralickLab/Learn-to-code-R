##################################################
## Project: Learn to code
## Script: Dplyr and ggplot2
# select, filter, mutate, summarise, group_by
# basic plots w ggplot2
##################################################

library(tidyverse)

# did I explain the pipe yet?

##----------------------------------------------##
## dplyr
##----------------------------------------------##

# lets use this starwars data
dplyr::starwars
# use
starwars |> glimpse()

starwars |>
  ggplot(aes(height, mass, color = sex)) +
  geom_point(alpha = 0.85, shape = 1) +
  scale_y_log10() +
  theme_classic()


# select gets columns by name (position)
starwars |> select(name, height, mass, sex)




# with tidy select
starwars |> select(name, where(~is.numeric(.x)))

# filter gets the rows that pass some condition
starwars |> filter(species == 'Droid')

# mutate changes a column or creates a new one
starwars |>
  mutate(
    # we can use if_else to do something based on a condition
    hair_color = if_else(
      condition = is.na(hair_color),
      true = 'no hair',
      false = hair_color
      )
  )

# summarise is similar to mutate but reduces all values to a single result
starwars |>
  summarise(
    height_mean = mean(height, na.rm = T),
    height_sd = sd(height, na.rm = T),
    )

# group by allows us to split data for groupwise-computation
starwars |>
  group_by(species) |>
  summarise(
    n = n(),
    height_mean = mean(height, na.rm = T),
    height_sd = sd(height, na.rm = T),
  ) |>
  filter(n>1) |>
  arrange(desc(height_mean))



starwars |>
  group_by(species) |>

  summarise(across(
    .cols = where(is.numeric),
    .fns = list('mean' = mean, 'median' = median),
    .names = "{.col}_{.fn}",
    na.rm = T
    )) |>
  pivot_longer(-species) |>
  mutate(
    attribute = str_extract(name, '^[^_]+'),
    stat = str_extract(name, '[^_]+$')
    )







# using a prefix, pivoting, facetted plot from pair of variables
starwars |>
  select(name, where(is.numeric)) |>
  pivot_longer(-name, names_to = 'attribute') |>
  ggplot(aes(x = value)) +
  geom_histogram() +
  facet_wrap(facets = vars(attribute), scales = 'free_x', ncol = 1)





library(tidyverse)
library(tidylog)

# iris |>
#   as_tibble() |>
#   filter(Sepal.Length > 5, Petal.Width < 2) |>
#   tidylog() |>
#   mutate(x = Sepal.Length*Sepal.Width) |>
#   tidylog()

starwars <- dplyr::starwars

species_lookup <- starwars |>
  count(species, sort = T) |>
  transmute(
    species,
    pooled_species = if_else(condition = (n == 1), 'Other', species)
  )

starwars |>
  left_join(species_lookup, by = "species") |>
  glimpse()

starwars |>
  select(name, starships) |>
  tidylog() |>
  unnest(cols = c(starships)) |>
  tidylog() |>
  ggplot(aes(y = name, x = starships)) +
  geom_point() +
  scale_x_discrete(position = 'top') +
  theme(axis.text.x.top = element_text(angle = 60, hjust = 0))


starwars |>
  left_join(species_lookup, by = "species") |>
  mutate(pooled_species = replace_na(pooled_species, 'Other')) |>
  filter(pooled_species %in% c('Human', 'Droid')) |>
  ggplot(aes(height, mass, color = pooled_species)) +
  geom_point(alpha = 0.5) +
  ggrepel::geom_text_repel(aes(label = name)) +
  geom_smooth(size = 0.5, span = 1.1) +
  scale_y_log10() +
  facet_wrap(~species, scales = 'free', ncol = 1) +
  theme(legend.position = 'none')

df <- starwars |>
  filter(species %in% c('Human', 'Droid')) |>
  select(species, height, mass, gender)

loe

library(broom)

model_rs <-
  tribble(
    ~formula, ~model,
    "mass ~ height", lm(formula = mass ~ height, data = df),
    "mass ~ height + species", lm(formula = mass ~ height + species, data = df),
    "mass ~ height + species*height", lm(formula = mass ~ height + species*height, data = df)
  ) |>
  mutate(tidy = map(model, tidy),
         glance = map(model, glance),
         augment = map(model, augment)
  )

model_rs |>
  select(formula, tidy) |>
  unnest(tidy) |>
  view()


lm(formula = mass ~ height, data = human_v_droid_sizes)

lm(formula = mass ~ height + species, data = human_v_droid_sizes) |> broom::tidy()
lm(formula = mass ~ height, data = human_v_droid_sizes) |> broom::tidy()
lm(formula = mass ~ height, data = human_v_droid_sizes) |> broom::glance()

lm(formula = mass ~ height + species + gender, data = human_v_droid_sizes) |> summary()

# starwars |> filter(is.na(species)) |> view()

