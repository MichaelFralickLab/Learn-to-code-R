# bayestestR

# remotes::install_github("easystats/easystats")
library(easystats)
# install.packages('rstanarm')
library(rstanarm)

freq_model <- lm(Sepal.Length ~ ., data = iris)


bayes_model <- stan_glm(Sepal.Length ~ ., data = iris)
posteriors <- describe_posterior(bayes_model)
# for a nicer table


print(posteriors, digits = 2)
summary(freq_model)


s <- log2(1/2.2e-16)
s
