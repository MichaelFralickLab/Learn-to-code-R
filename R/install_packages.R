# run this command to get all the packages we'll use
install.packages(
  c('tidyverse', 'lubridate',  'readxl', 'devtools', 'testthat', 'usethis', 'here',
    'Rcartocolor', 'leaftlet', 'patchwork', 'igraph', 'ggiraph',  'janitor', 'crayon',
     'jsonlite', 'skimr', 'ggbeeswarm', 'ggridges', 'ggtext',
    'boot', 'tidymodels', 'glmnet', 'ranger', 'kknn', 'mice', 'lme4', 'brms',
    'cowplot', 'DT', 'gt', 'knitr', 'rmarkdown'
    )
  )

# parallelization packages - might not work on your machine...
install.packages(c('future', 'furrr', 'foreach'))