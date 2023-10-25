## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message=FALSE-----------------------------------------------------
# load libraries
library(tidyverse)
library(multitool)

# create some data
the_data <-
  data.frame(
    id  = 1:500,
    iv1 = rnorm(500),
    iv2 = rnorm(500),
    iv3 = rnorm(500),
    mod = rnorm(500),
    dv1 = rnorm(500),
    dv2 = rnorm(500),
    include1 = rbinom(500, size = 1, prob = .1),
    include2 = sample(1:3, size = 500, replace = TRUE),
    include3 = rnorm(500)
  )

# create a pipeline blueprint
full_pipeline <- 
  the_data |>
  add_filters(include1 == 0, include2 != 3, include3 > -2.5) |> 
  add_variables(var_group = "ivs", iv1, iv2, iv3) |> 
  add_variables(var_group = "dvs", dv1, dv2) |> 
  add_model("linear model", lm({dvs} ~ {ivs} * mod))

## ----inspect-blueprint--------------------------------------------------------
# Number of unique analysis pipelines
detect_multiverse_n(full_pipeline)

# Number of different versions of analysis variables
detect_n_filters(full_pipeline)

# Number of unique filtering criteria
detect_n_filters(full_pipeline)

# Number of unique models
detect_n_models(full_pipeline)

## -----------------------------------------------------------------------------
summarize_filter_ns(full_pipeline)

## -----------------------------------------------------------------------------
expanded_pipeline <- expand_decisions(full_pipeline)

## -----------------------------------------------------------------------------
# Take a look at the first filter decision
expanded_pipeline |> show_code_filter(decision_num = 1)

## -----------------------------------------------------------------------------
expanded_pipeline |> show_code_model(decision_num = 17)

