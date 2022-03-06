library(tidyverse)

# install.packages('riskCommunicator')
?framingham

df <- riskCommunicator::framingham |> 
  janitor::clean_names() |> 
  mutate(
    sex = ifelse(test = sex == 1, 'Male', 'Female'),
    across(c(period, educ), ~as_factor(.x)),
    across(starts_with('prev'), ~as.logical(.x)),
    across(c(death:hyperten, cursmoke, diabetes, bpmeds), ~as.logical(.x)),
    across(starts_with('time'), ~.x / 365)
    ) |> 
  rename_with(
    ~.x |> 
      str_replace('^prev', 'prev_') |> 
      str_replace('^time[^$]', 'time_') |> 
      str_replace('bp$', '_bp') |> 
      str_replace('lc$', 'l_cholesterol') |> 
      str_replace('hyperten', 'hypertension') |> 
      str_replace('strk', 'stroke')
  ) |> 
  tibble::glimpse()


df |> 
  select(where(~is.logical(.x))) |> 
  pivot_longer(everything()) |> 
  filter(value) |> 
  count(name, sort = T) |> 
  ggplot(aes(n, fct_rev(as_factor(name)))) +
  geom_col() +
  facet_grid() +
  labs(y = NULL, x = 'subjects',
       subtitle = str_glue('n = {nrow(df)}')) +
  theme_light()


  
df |> 
  select(where(is.numeric), period, -starts_with('time'), -randid) |> 
  pivot_longer(-period) |> 
  left_join(
    by = 'name', 
    y = df |> 
      select(where(is.numeric)) |> 
      pivot_longer(everything()) |> 
      group_by(name) |> 
      summarise(new_name = str_glue(
        "missing {round(100*sum(is.na(value)) / nrow(df), 2)} %"),
      ) |> 
      mutate(
        new_name = str_glue("**{name}**<br>{new_name}")
      ),
  ) |> 
  ggplot(aes(x = value, y = period, fill = period, color = period)) +
  ggridges::geom_density_ridges(alpha = 0.2, ) +
  facet_wrap(~new_name, scales = 'free') +
  labs(
    title = 'Continuous data from Framington dataset',
    subtitle = str_glue('n = {nrow(df)}'),
    caption = '',
    x = NULL, 
    fill = 'Period', color = 'Period'
  ) +
  rcartocolor::scale_fill_carto_d() +
  rcartocolor::scale_color_carto_d() +
  # scale_fill_viridis_d(option = 'E', end = 0.9) +
  ggthemes::theme_base() +
  theme(
    legend.position = 'bottom',
    # strip.background = element_rect(fill = 'grey35', color = NULL),
    strip.text = ggtext::element_markdown()
  )
  
