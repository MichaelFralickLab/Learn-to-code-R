#-----------------------------------------------------

#' *Run a simulation of bootstrap resampling*

# get a bootstrap resample. eq size with replacement
boot <- starwars |>
  slice_sample(n = nrow(starwars), replace = T)

# see how the number sampled is ~60% of all characters?
boot |> distinct()


#' *I claim* that on average, only 63.2% of observations are represented in each bootstrap resample


# write a function to draw a resampled dataset (from any tbl)
draw_bootstrap <- function(data){
  data |> dplyr::slice_sample(n = nrow(data), replace = T)
}


# write a function to get % observations represented
analyse_bootstrap <- function(data){
  n_uniques <- data |>
    dplyr::distinct() |>
    nrow()
  n_data <- nrow(data)
  proportion = n_uniques / n_data
  return(proportion)
}

#' use `map` to repeat a function over an iterable
purrr::map(1:10, ~.x * 2)



# our sample size is N
N <- 1000
# run our simulation B times
B <- 5000

# create sample dataset
data <- tibble(x = seq(N))

# setup simulation data by mapping draw_ then analyse_
resamples <-
  tibble::tibble(
    resample_id = seq(B),
    boot = purrr::map(resample_id, ~draw_bootstrap(data)),
  ) |>
  mutate(
    prop_obs = map_dbl(boot, ~analyse_bootstrap(.x)),
  )

# summarise result, get 90% CI by percentile method
rs_data <-
  resamples |>
  summarise(point_est = mean(prop_obs),
            lower = quantile(prop_obs, p = 0.05),
            upper = quantile(prop_obs, p = 0.95))

# visualize distribution of results
resamples |>
  ggplot(aes(prop_obs)) +
  geom_histogram() +
  geom_vline(data = rs_data,
             aes(xintercept = point_est)) +
  geom_vline(data = rs_data,
             aes(xintercept = lower), lty = 2) +
  geom_vline(data = rs_data,
             aes(xintercept = upper), lty = 2)


