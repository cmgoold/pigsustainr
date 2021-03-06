#' A function to fit \pkg{pigsustainr} ODE models
#'
#' Fit \pkg{pigsustainr} ODE (ordinary differential equation) models, using
#' either the 'deSolve' R package or C++.
#'
#' @param model_name The name of the model to simulate
#' @param initial_values Initial values of the state variables
#' @param parameters Vector of parameter values for the model
#' @param times The simulation time steps. Should increment by the desired
#'      dt interval
#' @param backend Either "deSolve" or "cpp" (see details); defaults to "cpp"
#'
#' @returns An object of class of \code{PigSustainSim}
#'
#' @author Conor Goold \email{conor.goold@gmail.com}
#' @export
pigsustainode <- function(
  model_name,
  initial_values,
  parameters,
  times,
  backend = "cpp"
  ){

    # validate the inputs
    validate_pigsustainode_data(model_name, initial_values, parameters)

    # get the dt interval
    dt <- times[2] - times[1]

    # run the model
    if(tolower(backend)=="cpp"){
      sim <- integrate_ode(
        model_name = model_name,
        initial_values = initial_values,
        parameters = parameters,
        times = times
      )
    }
    else{
      sim <- as.data.frame(deSolve::ode(
        func = get(paste0(".", model_name)),
        y = initial_values,
        parms = parameters,
        times = times,
        method = "rk4"
      ))

      names(sim)[1] = "times"
    }

    results <- new("PigSustainSim",
      model = model_name,
      backend = tolower(backend),
      results = sim,
      parameters = parameters,
      dt = dt
    )

    return(results)
  }
