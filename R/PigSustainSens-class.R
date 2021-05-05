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
    "model" = "character",
    "sensitivity_matrix" = "data.frame",
    "summary_matrix" = "data.frame"
  )
)

setMethod("summary", "PigSustainSens",
  function(object){
    slot(object, "summary_matrix")
  })

# setMethod("stateplot", "PigSustainSens",
#   function(object){
#     sensmat <- slot(object, "sensitivity_matrix")
#     sensmat %>%
#     pivot_longer(
#       -times,
#       names_to = "state",
#       values_to = "solution"
#     ) %>%
#     mutate(
#       state = factor(state, levels=unique(state))
#     ) %>%
#     ggplot2::ggplot() +
#     ggplot2::geom_line(ggplot2::aes(times, solution), size=1) +
#     ggplot2::facet_wrap(~state, scales="free_y") +
#     ggplot2::theme(
#       panel.grid=ggplot2::element_blank(),
#       strip.text=ggplot2::element_text(size=15)
#     )
#   }
# )
