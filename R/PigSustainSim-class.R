#' An S4 class for simulated \pkg{pigsustainr} models
#'
#' Simulation models in \pkg{pigsustainr} are represented as instances of
#' \code{PigSustainSim}, which hold the model type that was run,
#' the results of the simulations by time, the parameters used to run the model,
#' and any relevant diagnostic information.
#'
#' @name PigSustainSim-class
#' @aliases PigSustainSim
#' @docType class
#'
#' @slot model The name of the model to use
#' @slot results A matrix of simulation results
#' @slot parameters A vector containing the parameters used to run the model
#'@export

setClass("PigSustainSim",
  slots = c(
    model = "character",
    backend = "character",
    results = "data.frame",
    parameters = "numeric",
    dt = "numeric"
  )
)

#' Retrieve the simulation results from a
#' PigSustainSim class instance.
#'@export
setMethod("summary", "PigSustainSim", function(object){
    cat(paste0(
      "Summary of PigSustainSim simulation of ", object@model, " ran using ",
      object@backend)
      )
    head(slot(object, "results"), 10)
  }
)

#' Retrieve the results of a simulation
#' @export
setGeneric("results", function(object){
  slot(object, "results")
})

#' Retrieve the parameters of a PigSustainSim instance
#' @export
setGeneric("parameters", function(object){
  slot(object, "parameters")
})

#' Plot the state variables of a PigSustainSim instance
#' @export
setGeneric("stateplot", function(object, ...){})

setMethod("stateplot", "PigSustainSim", function(object, ...){
  res <- slot(object, "results")
  res %>%
  pivot_longer(
    -times,
    names_to = "state",
    values_to = "solution"
  ) %>%
  mutate(
    state = factor(state, levels=unique(state))
  ) %>%
  ggplot2::ggplot() +
  ggplot2::geom_line(ggplot2::aes(times, solution), size=1) +
  ggplot2::facet_wrap(~state, scales="free_y") +
  ggplot2::theme(
    panel.grid=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size=15)
  )
})
