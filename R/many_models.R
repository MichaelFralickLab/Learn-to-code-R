# nest-map pattern: (functional programming / iteration)
# good for modelling, simultation, any group-wise task...

iris <- datasets::iris |> as_tibble() |> janitor::clean_names()

iris |>
  ggplot(aes(petal_width, petal_length, color = species)) +
  geom_point(size = .5, alpha  = .5) +
  geom_smooth(method = 'lm', se = F)

models <-
  # group data
  iris |>
  group_by(species) |>
  nest() |>
  # nested models
  expand_grid(preds = c(
    'petal_width',
    'sepal_width',
    'sepal_length',
    'sepal_width + sepal_length',
    'petal_width + sepal_length',
    'petal_width + sepal_width',
    '.')) |>
  mutate(
    formula = str_glue('petal_length ~ {preds}'),
    lm = map2(data, formula, ~ lm(formula(.y), data = .x)),
    tidy = map(lm, tidy),
    glance = map(lm, glance),
    augment = map(lm, augment)
  ) |>
  select(-data, -lm)

models |> unnest(tidy)
models |> unnest(glance)
models |> unnest(augment)

models |>
  unnest(tidy) |>
  select(species, preds, term, estimate, std.error) |>
  # filter(term != '(Intercept)') |>
  ggplot(aes(x = estimate,
             xmin = estimate - std.error,
             xmax = estimate + std.error,
             y = term,
             color = preds
  )
  ) +
  geom_pointrange(position = position_dodge(width = 0.52)) +
  facet_grid(~species)



# iris |>
#   nest_by(Species) |>
#   mutate(lm = lm(petal_length~petal_width, data = data))

# iris |>
#   nest_by(Species) |>
#   mutate(lm = map(data, ~lm(petal_length~petal_width, data = .x)))
