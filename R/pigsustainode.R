#' A function to fit \pkg{pigsustainr} ODE models
#'
#' Fit \pkg{pigsustainr} ODE (ordinary differential equation) models, using
#' either the 'deSolve' R package or the C++.
#'
#' @param model_name The name of the model to simulate
#' @param initial_values Initial values of the state variables
#' @param times The simulation time steps. Should increment by the desired
#'      dt interval
#' @param backend Either "deSolve" or "cpp" (see details)
#'
#' @returns An object of class of \code{PigSustainSim}
#'
#' @author Conor Goold \email{conor.goold@gmail.com}
#' @export
pigsustainode <- function(
  model_name, initial_values, times, backend
  ){

  }
