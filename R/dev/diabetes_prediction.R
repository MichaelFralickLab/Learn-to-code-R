# Pima Indians
# All patients here are females at least 21 years old of Pima Indian heritage.

# install.packages(c('mlbench', 'tidyverse', 'tidymodels'))

library(tidyverse)
library(tidymodels) # https://www.tidymodels.org/start/
library(mlbench)
library(future)
data(PimaIndiansDiabetes2)

pima <- PimaIndiansDiabetes2 |>
  as_tibble() |>
  mutate(diabetes = factor(diabetes, levels = c('pos', 'neg')))

rm(PimaIndiansDiabetes2)

glimpse(pima)
skimr::skim(pima)

# pivot all numeric vars to 2 columns: name & value
pima |>
  pivot_longer(-diabetes) |>
  # plot the distribution of each variable for both diabetes & non-diabetes
  ggplot(aes(value, fill = diabetes, color = diabetes)) +
  geom_density(alpha = 0.25) +
  facet_wrap(~name, scales = 'free')

# set the random numbers to be the same: your (random) splits will match mine
set.seed(123)

# train-test split
split <- initial_split(pima, strata = diabetes)

# resamples: 10-fold cross-validation
cv <- vfold_cv(analysis(split))

# log reg model
model_spec <- logistic_reg(
  mode = 'classification',
  engine = 'glmnet',
  penalty = tune(),
  mixture = tune()
)

# model formula
rec <-
  recipe(diabetes ~ ., data = analysis(split)) |>
  step_normalize(all_predictors())

# modelling workflow
wkflw <- workflow(preprocessor = rec, spec = model_spec)

# optional: parallelize model fitting for speed
future::multisession(workers = future::availableCores())

# fit models in tuning grid to find best tuning
rs <- tune_grid(
  object = wkflw,
  resamples = cv,
  grid = 5,
  metrics = yardstick::metric_set(roc_auc, ppv, npv),
  control = control_grid(verbose = T, allow_par = T)
)

# explore tuning results
rs |> collect_metrics()
rs |> autoplot()
rs |> show_best()


# pick a model good auc; finalize the model by fitting on all data
final_model <-
  rs |>
  select_by_one_std_err(penalty, metric = 'roc_auc') |>
  finalize_workflow(wkflw, parameters = _) |>
  fit(data = analysis(split))

# predict test data set with final model
final_perf <-
  predict(final_model, assessment(split)) |>
  bind_cols(predict(final_model, assessment(split), type = "prob")) |>
  bind_cols(assessment(split) |>  select(diabetes))

# evaluate final model's test performance
final_perf |> conf_mat(truth = diabetes, estimate = .pred_class)
auc <- final_perf |> roc_auc(truth = diabetes, estimate = .pred_pos)

roc_pts <- final_perf |>
  roc_curve(truth = diabetes, estimate = .pred_pos) |>
  glimpse()

# plot roc curve
roc_pts |>
  ggplot(aes(1 - specificity, sensitivity)) +
  geom_path() +
  geom_line(data = tibble(x = c(0, 1), y = c(0, 1)),
            aes(x, y), lty = 2) +
  coord_equal() +
  labs(
    title = "Final model: ",
    subtitle = str_glue('ROC AUC = {round(auc$.estimate, 2)}')
    )

