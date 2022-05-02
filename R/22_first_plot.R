iris <- tibble(iris) |>
  janitor::clean_names()

iris <-
  ggplot(aes(
    x = sepal_length,
    y = sepal_width,
    fill = species,
    color = species
  )) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = 'glm', alpha = 0.25) +
  facet_wrap(facets = ~ species,
             ncol = 3,
             scales = 'free') +
  labs(
    fill = 'Species',
    color = 'Species',
    x = 'Length',
    y = 'Width',
    title = 'Sepal ratio'
  ) +
  theme_classic() +
  theme(legend.position = 'bottom')


mods <- iris |>
  split(~species) |>
  map(~lm(sepal_width ~ sepal_length, data = .x) |> summary())



lm(formula = sepal_width ~ sepal_length + species, data = iris) |>
  summary()


library(tidyverse)
diamonds |> pull(cut) |> levels()

