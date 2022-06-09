

# we can use if_else to do something based on a condition

starwars |>
  mutate()


# iris |>
#   as_tibble() |>
#   filter(Sepal.Length > 5, Petal.Width < 2) |>
#   tidylog() |>
#   mutate(x = Sepal.Length*Sepal.Width) |>
#   tidylog()

starwars <- dplyr::starwars






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

