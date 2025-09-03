## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message=FALSE-----------------------------------------------------
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

# expand the pipeline
expanded_pipeline <- expand_decisions(full_pipeline)

# Run the multiverse
multiverse_results <- run_multiverse(expanded_pipeline)

multiverse_results

## ----unnest-------------------------------------------------------------------
multiverse_results |> unnest(model_fitted)

## ----tidy---------------------------------------------------------------------
multiverse_results |> 
  unnest(model_fitted) |> 
  unnest(model_parameters)

## ----glance-------------------------------------------------------------------
multiverse_results |> 
  unnest(model_fitted) |>
  unnest(model_performance)

## ----reveal-------------------------------------------------------------------
multiverse_results |> 
  reveal(.what = model_fitted)

## ----which--------------------------------------------------------------------
multiverse_results |> 
  reveal(.what = model_fitted, .which = model_parameters)

## ----reveal-model-parameters--------------------------------------------------
multiverse_results |> 
  reveal_model_parameters()

## ----reveal-model-performance-------------------------------------------------
multiverse_results |> 
  reveal_model_performance()

## ----unpack-specs-wide--------------------------------------------------------
multiverse_results |> 
  reveal_model_parameters(.unpack_specs = "wide")

## ----unpack-specs-long--------------------------------------------------------
multiverse_results |> 
  reveal_model_performance(.unpack_specs = "long")

## ----condense-----------------------------------------------------------------
# model performance r2 summaries
multiverse_results |>
  reveal_model_performance() |> 
  condense(r2, list(mean = mean, median = median))

# model parameters for our predictor of interest
multiverse_results |>
  reveal_model_parameters() |> 
  filter(str_detect(parameter, "iv")) |>
  condense(unstd_coef, list(mean = mean, median = median))

## ----group_by-condense1-------------------------------------------------------
multiverse_results |>
  reveal_model_parameters(.unpack_specs = "wide") |> 
  filter(str_detect(parameter, "iv")) |>
  group_by(ivs, dvs) |>
  condense(unstd_coef, list(mean = mean, median = median))

## ----group_by-condense2-------------------------------------------------------
multiverse_results |>
  reveal_model_parameters(.unpack_specs = "wide") |> 
  group_by(parameter, dvs) |>
  condense(unstd_coef, list(mean = mean, median = median))

