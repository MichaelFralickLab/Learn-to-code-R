# kmeans clustering (tidyverse)
library(tidyverse)
library(patchwork)

plot_clusters <- function(clusters, centers){
  ggplot() +
    geom_point(
      data = clusters |> unnest(cols = c(data)),
      aes(petal_length,
          petal_width,
          shape = species,
          color =  as_factor(cluster))
      ) +
    geom_point(
      data = centers |> unnest(cols = c(center)),
      aes(petal_length, petal_width),
      color = 'black'
    ) +
    ggvoronoi::geom_voronoi(
      data = centers |> unnest(cols = c(center)),
      aes(petal_length, petal_width,
          color = as_factor(cluster),
          fill = as_factor(cluster)
          ),
      alpha = 0.1
    ) +
    rcartocolor::scale_color_carto_d('Cluster') +
    rcartocolor::scale_fill_carto_d('Cluster') +
    scale_shape_discrete('Species') +
    labs(x = 'length', y = 'width')
}

prepare_data <- function(data){
  data |>
    group_by(id = row_number()) |>
    nest(data = -id) |>
    ungroup() |>
    mutate(cluster = NA)
}

random_centers <- function(data, k){
  data |>
    slice_sample(n = k) |>
    transmute(cluster = row_number(),
              center = data)
  }

sum_of_squares <- function(obs, center){
  sum((obs - center)**2)
}

assign_data_to_clusters <- function(clusters, centers){
  # check all (point, center) pairs and compute euc. distance squared
  # assign obs to cluster that minimizes distance
  expand_grid(centers, clusters |> select(-cluster)) |>
    mutate(distance = map2_dbl(data, center, ~sum_of_squares(.x, .y))) |>
    group_by(id) |>
    slice_min(distance) |>
    ungroup() |>
    select(-c(distance, center))
}

optimize_centers <- function(data){
  data |>
    select(cluster, data) |>
    unnest(data) |>
    group_by(cluster) |>
    summarise(across(everything(), mean)) |>
    nest(center = -cluster) |>
    ungroup()
}

converged <- function(old_centers, new_centers){
  identical(centers, new_centers)
}

##----------------------------------------------##
## MAIN                                       ----
##----------------------------------------------##

# prepare data
clusters <-
  tibble(iris) |>
  janitor::clean_names() |>
  select(where(is.numeric)) |>
  prepare_data() |>
  print()

# select k random points as initial cluster centers
centers <- clusters |>
  random_centers(k = 3) |>
  print()

# species labels that we are trying to match with kmeans clustering
species <- iris |> transmute(id = row_number(), species = Species)


set.seed(57)
i <- 0
new_centers <- NULL
new_clusters <- NULL
is_converged <- FALSE
plots <- list(rep(NA, 5))

while(!is_converged & i <= 12){
  i <- i + 1
  # link data to closest center
  new_clusters <- assign_data_to_clusters(clusters, centers)
  # find new cluster centers
  new_centers <- optimize_centers(new_clusters)
  # test convergence
  is_converged <- converged(centers, new_centers)
  if (is_converged){
    print(str_glue('converged at iteration = {i}'))
  }
  # update
  centers <- new_centers
  clusters <- new_clusters
  plots[[i]] <- plot_clusters(clusters |> left_join(species, by='id'),
                            centers) +
    labs(subtitle = str_glue('i = {i}'))
}

wrap_plots(plots, guides = 'collect')
# gganimate::(plots)

