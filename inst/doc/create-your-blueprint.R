## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message=FALSE-----------------------------------------------------
library(tidyverse)
library(multitool)

## ----data---------------------------------------------------------------------
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

## ----eval=FALSE---------------------------------------------------------------
#  # Filter out exclusions
#  filtered_data <-
#    the_data |>
#    filter(
#      include1 == 0,           # --
#      include2 != 3,           # Exclusion criteria
#      as.numeric(scale(include3)) > -2.5   # --
#    )
#  
#  # Model the data
#  my_model <- lm(dv1 ~ iv1 * mod, data = filtered_data)
#  
#  # Check the results
#  my_results <- parameters::parameters(my_model)

## ----filters------------------------------------------------------------------
the_data |> 
  add_filters(include1 == 0, include2 != 3, scale(include3) > -2.5)

## ----variables1---------------------------------------------------------------
the_data |>
  add_variables(var_group = "ivs", iv1, iv2, iv3)

## ----variables2---------------------------------------------------------------
the_data |>
  add_variables(var_group = "ivs", iv1, iv2, iv3) |> 
  add_variables(var_group = "dvs", dv1, dv2)

## ----building-----------------------------------------------------------------
the_data |>
  add_filters(include1 == 0, include2 != 3, scale(include3) > -2.5) |> 
  add_variables(var_group = "ivs", iv1, iv2, iv3) |> 
  add_variables(var_group = "dvs", dv1, dv2)

## ----model--------------------------------------------------------------------
the_data |>
  add_filters(include1 == 0, include2 != 3, scale(include3) > -2.5) |> 
  add_variables(var_group = "ivs", iv1, iv2, iv3) |> 
  add_variables(var_group = "dvs", dv1, dv2) |> 
  add_model("linear model", lm(dv1 ~ iv1 * mod))

## -----------------------------------------------------------------------------
the_data |>
  add_filters(include1 == 0, include2 != 3, scale(include3) > -2.5) |>
  add_variables(var_group = "ivs", iv1, iv2, iv3) |> 
  add_variables(var_group = "dvs", dv1, dv2) |> 
  add_model("linear model", "lm(dv1 ~ iv1 * mod)")

## -----------------------------------------------------------------------------
the_data |>
  add_filters(include1 == 0, include2 != 3, scale(include3) > -2.5) |> 
  add_variables(var_group = "ivs", iv1, iv2, iv3) |> 
  add_variables(var_group = "dvs", dv1, dv2) |> 
  add_model("linear model", lm({dvs} ~ {ivs} * mod)) # see the {} here

## ----blueprint-diagram, fig.width=5.75, fig.height=6--------------------------
full_pipeline <- 
  the_data |>
  add_filters(include1 == 0, include2 != 3, scale(include3) > -2.5) |> 
  add_variables(var_group = "ivs", iv1, iv2, iv3) |> 
  add_variables(var_group = "dvs", dv1, dv2) |> 
  add_model("linear model", lm({dvs} ~ {ivs} * mod))

create_blueprint_graph(full_pipeline)

## ----expand-------------------------------------------------------------------
expanded_pipeline <- expand_decisions(full_pipeline)

expanded_pipeline

## -----------------------------------------------------------------------------
2*2*2*3*2 == nrow(expanded_pipeline)

## -----------------------------------------------------------------------------
expanded_pipeline |> unnest(filters)

## -----------------------------------------------------------------------------
expanded_pipeline |> unnest(models)

## -----------------------------------------------------------------------------
expanded_pipeline |> unnest(c(variables, models))

