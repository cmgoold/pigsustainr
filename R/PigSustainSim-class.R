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
    results = "matrix",
    parameters = "numeric"
  )
)
