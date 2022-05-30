#' ---
#' title: "Survey Responses"
#' author: "Learn to Code R"
#' date: "2022-05-28"
#' output:
#'   html_document:
#'     code_folding: hide
#'     theme: flatly
#' ---
#'
#' <details>
#'  <summary>Setup and plot funtions</summary>
# to render script to html: run twice if cold for auth0
# rmarkdown::render('R/survey.R', output_file = here::here('survey.html'))
library(tidyverse)
library(patchwork)
library(ggiraph)
theme_set(theme_classic())
knitr::opts_chunk$set(fig.height = 3, fig.width = 6, fig.align = 'center')

plot_rate <- function(survey){
  survey |>
    ggplot(aes(x = rate)) +
    geom_bar()
}

plot_where <- function(survey){
  survey |>
    mutate(
      Medicine = str_detect(where, 'Medical'),
      Science = str_detect(where, 'Graduate'),
      Industry = str_detect(where, 'Industry'),
      Other = str_detect(where, 'Other')
    ) |>
    pivot_longer(Medicine:Other) |>
    filter(value) |>
    count(name) |>
    ggplot(aes(y = fct_reorder(name, n), x = n)) +
    geom_col() +
    labs('Where do you see yourself applying coding in the future?', y = NULL)
}
.categs <- c('graphics', 'messy', 'tables', 'stats|model', 'web', 'algorithms')

get_skills <- function(survey){
  survey |>
    transmute(what = str_to_lower(what)) |>
    mutate(
      id = row_number(),
      skills = map(what, ~str_detect(.x, pattern = .categs) |> set_names(categs))
    ) |>
    unnest_wider(skills)
}

get_weighted_votes <- function(skills){
  #' Weighted voting
 skills |>
    select(-what) |>
    group_by(id) |>
    nest() |>
    mutate(votes = map_dbl(data, sum)) |>
    unnest(data) |>
    mutate(across(where(is.logical), as.numeric)) |>
    ungroup() |>
    mutate(across(graphics:algorithms, ~.x / (votes + 0.0001) ))

}

plot_skills <- function(skills, votes){
  # skill votes barplot
  unweighted <- skills |>
    select(id, graphics:algorithms) |>
    group_by(id) |>
    pivot_longer(graphics:algorithms) |>
    filter(value) |>
    ggplot(aes(y = name)) +
    geom_bar() +
    labs(x = 'Votes', y = NULL, title = 'Unweighted voting')
  # weighted votes barplot
  weighted <- votes |>
    select(graphics:algorithms) |>
    pivot_longer(everything()) |>
    ggplot(aes(y = name, x = value)) +
    geom_col(position = 'stack') +
    labs(y = NULL, x = 'Weighted votes', title = 'Weighted voting')
  # combine
  return(unweighted + weighted)
}

get_pca <- function(survey){
  survey |>
    select(-c(where, timestamp, what)) |>
    bind_cols(get_skills(survey) |> select(graphics:algorithms)) |>
    mutate(across(where(is.logical), as.numeric)) |>
    janitor::remove_constant() |>
    prcomp(scale = T)
}

plot_pca1 <- function(pca, survey){
  pca$x |>
    as_tibble() |>
    bind_cols(survey) |>
    mutate(date = lubridate::as_date(timestamp) |> as.character(),
           id = row_number()) |>
    ggplot(aes(PC1, PC2)) +
    geom_point(aes(color = PC3)) +
    ggrepel::geom_text_repel(aes(label = id)) +
    coord_fixed(ratio = 1, expand = T) +
    theme_classic() +
    labs(subtitle = "PCA: dimension reduction")
}

plot_pca2 <- function(pca, survey){

  pca$x |>
    as_tibble() |>
    bind_cols(survey) |>
    mutate(date = lubridate::as_date(timestamp) |> as.character()) |>
    ggplot(aes(PC1, PC2)) +
    geom_point(aes(color = PC3)) +
    ggrepel::geom_text_repel(aes(label = date)) +
    coord_fixed(ratio = 1, expand = T) +
    theme_classic() +
    labs(subtitle = "PCA: Early and late respondents")
}

plot_pca3 <- function(pca, survey){
  pca$x |>
    as_tibble() |>
    bind_cols(survey) |>
    mutate(date = lubridate::as_date(timestamp)) |>
    ggplot(aes(PC1, PC2, alpha = PC3)) +
    geom_point(color = 'red') +
    # geom_label(aes(label = date), size = 2) +
    coord_fixed(ratio = 1, expand = T) +
    geom_segment(
      data = data.frame(pca$rotation) |>
        rownames_to_column() |>
        as_tibble() ,
      color = 'black',
      aes(PC1*2, PC2*2, alpha = PC3, xend = 0, yend = 0)
      ) +
    ggrepel::geom_text_repel(
      data = data.frame(pca$rotation) |>
        rownames_to_column() |>
        as_tibble(),
      aes(PC1, PC2, label = rowname),
      show.legend = FALSE,
      color = 'black',
      force_pull = 1.1,
    ) +
    theme_classic() +
    labs(subtitle = "Factors in PC1 and PC2")

}

scree_plot <- function(pca){
  tibble(x = seq_along(pca$sdev),
         var_explained = 100 * pca$sdev^2 / sum(pca$sdev^2)) |>
    ggplot(aes(x, var_explained)) +
    geom_path(alpha = 0.5) +
    geom_point(aes(color = (x > 3)), show.legend = F) +
    scale_x_continuous(breaks = scales::breaks_pretty()) +
    theme_classic() +
    labs(
      subtitle = 'Variation explained',
      x = 'Principle component',
      y = '% variance explained')
}


#' </details>
#'
#'  ----
#'
#' ## Data
#'
#' Survey data were downloaded from a google sheet linked to the form that
#'  you responded to. I renamed the columns for convenience.
#'
survey <- googlesheets4::read_sheet(
  "https://docs.google.com/spreadsheets/d/1lxIH4fXJ-BtsBI62M9gyB5a43v1k_XTNWxRSji1GDlk/edit?usp=sharing") |>
  janitor::clean_names() |>
  rename_with(~str_extract(.x, '^[^_]+'))

survey |> head()

#' ## Results
#'
#' Here are the data from your responses.
#'
plot_rate(survey) + labs(title = 'Rate your coding ability')
#'
#' We have a large range of coding abilities in the audience. I'm hoping that if you rate yourself at 5, you're at least new to R. If you're rating yourself below 3, please don't feel like this material will be over your head! I see you and want to provide enough detail so that you don't feel lost.
#' If your at 3, that's wonderful, the first week might be a bit slow for you but I'll try to never bore you.
#'
#' ----
#'
plot_where(survey) + labs(title = 'Where are you going?')
#'
#' Most of you are indicating that you'd  like to apply coding in science or industry, but I let you choose multiple responses, so these might have attracted a number of second-choice votes.
#' In any case, the basic data manipulation and visualization skills that we'll focus on transcend any specific domain and complement the work you'll do there. This was to help me pick example data.
#'
#' ----
#'
#' ## Skills
#'
#' I let you choose multiple skillsets from a selection of choices.
#'
skills <- get_skills(survey)
votes <- get_weighted_votes(skills)

#'
#' Most people voted for 2-4 skills.
#'
votes |>
  ggplot(aes(votes)) +
  geom_histogram(bins = 5, color = 'white') +
  labs(x = 'Votes', y = 'Persons', title = 'Distribution of votes per person')
#'
#' I represented these choices in absolute and weighted terms (ie. votes normalized to sum 1 per person, divided equally among their choices).
#'
#+ fig.width=8
plot_skills(skills, votes)
#'
#' We see that 'stats, modelling, and machine' learning was the most popular choice. Followed by web stuff, graphics, and dealing with messy data. Weighting votes showed us that a small group is really wanting to do algorithms and comp sci topics, while graphics and tables are brought back towards the mean.
#'
#'
#' What are the associations between the skill choices? Can I at least make cover something that everyone wants to do?
#+ fig.width=6, fig.height=8
skills |>
  transmute(across(graphics:algorithms, as.numeric)) |>
  corrr::correlate(quiet = T) |>
  corrr::network_plot(curved = T,
                      colours = viridis::inferno(123),
                      min_cor = 0)

#' ----
#'
#' ## Can we define clusters of learners?
#'
#' I did a principle components analysis on your survey responses. It remaps the data to new dimensions so that we can capture most of the variation of the data into a visualizable space. The first dimensions (PCs) explain the most variance so we focus on interpreting those.
#'
#+ fig.width=8, fig.height=6
pca <- get_pca(survey)
plot_pca1(pca, survey)
#'
#' What if we labelled points with the response date? This variable wasn't included in the PCA, I'm just adding labels to the points now.
#+ fig.width=8, fig.height=6
plot_pca2(pca, survey)
#'
#' Which factors map to which dimensions?
#'
#+ fig.width=8, fig.height=6
plot_pca3(pca, survey)
#'
#' How well did dimension reduction work? Pretty good!
#'
#+ fig.width=4, fig.height=3
scree_plot(pca)
#'
#' And we can see how each PC is composed by squaring the rotation matrix since each eigenvector has a length of one.
#'
pca$rotation |>
  as.data.frame() |>
  rownames_to_column() |>
  as_tibble() |>
  group_by(rowname) |>
  summarise(across(where(~is.numeric(.x)), ~.x^2)) |>
  pivot_longer(-rowname) |>
  ggplot(aes(name, value, fill = rowname)) +
  geom_col() +
  rcartocolor::scale_fill_carto_d('', palette = 'Safe') +
  labs(fill = 'Factor',
       title = 'Flavour composition of PCs')

#'
#' -----

