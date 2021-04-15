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
#' @param backend Either "deSolve" or "cpp" (see details)
#'
#' @returns An object of class of \code{PigSustainSim}
#'
#' @author Conor Goold \email{conor.goold@gmail.com}
#' @export
pigsustainode <- function(
  model_name, initial_values, parameters, times, backend
  ){

    # validate the inputs
    validate_pigsustainode_data(
      model_name, initial_values
    )

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
      # deSolve model
      if(model_name == "LogisticGrowth"){
        deSolve_model = .LogisticGrowth
      }
      else{
        deSolve_model = .BaseModel
      }
      sim <- as.data.frame(deSolve::ode(
        func = deSolve_model,
        y = initial_values,
        parms = parameters,
        times = times,
        method = "rk4"
      ))
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
