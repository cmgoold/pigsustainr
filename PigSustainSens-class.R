#' An S4 class to represent \pkg{pigsustainr} sensitivity analysis results
#'
#' Sensitivity analyses of ODE models inspect how the relative change in
#' the ODE solutions to small changes in the parameter values. Formally,
#' one method of sensitivity analysis is to compute the partial derivative
#' of the solution with respect to the parameters.
#'
#' @name PigSustainSens-class
#' @aliases PigSustainSens
#' @docType class
#'
#'
#'
#'@export

setClass("PigSustainSens",
  slots = c(
    "simulation" = "PigSustainSim",
    "sensitivity_matrix" = "numeric",
    "summary_matrix" = "data.frame"
  )
)

setMethod("summary", "PigSustainSens",
  function(object){
    slots(object, "summary_matrix")
  })
