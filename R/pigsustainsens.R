#' A function to perform sensitivity analyses on \pkg{pigsustainr} ODE models
#'
#' Local sensitivity is defined as the partial derivative of the state variables with respect
#' to a change in a parameter. Although this is analytically tractable in many cases,
#' we can approximate for any ODE model computationally, which is what the function
#' below provides. The raw sensitivity value is multiplied by
#'
#'
#'
#'
#'
#'@export

pigsustainsens <- function(
  model_name,
  initial_values,
  base_parameters,
  times,
  backend = "cpp",
  sensitivity_parameters = NULL,
  perturb_prop = 0.01,
  n_sims = 1
)
{

  base_fit <- pigsustainode(model_name, initial_values, base_parameters, times, backend="cpp")

  if(is.null(sensitivity_parameters))
    sensitivity_parameters <- names(parameters(base_fit))

  M <- sum(names(parameters(base_fit)) %in% sensitivity_parameters)
  N <- dim(results(base_fit))[[1]]
  K <- dim(results(base_fit))[[2]] - 1

  sensitivity_matrix <- as.data.frame(matrix(NA, nrow=N*K, ncol=M+2))
  sensitivity_matrix[,1] <- rep(times, K)
  sensitivity_matrix[,2] <- rep(colnames(results(base_fit))[-1], each=N)
  colnames(sensitivity_matrix) <- c("times", "states", sensitivity_parameters)

  sensitivity_raw <- sapply(1:M,
    function(x){
      run_parameters <- base_parameters
      focal_par <- run_parameters[sensitivity_parameters[x]][[1]]
      perturb_par <- focal_par + focal_par * perturb_prop
      run_parameters[sensitivity_parameters[x]] <- perturb_par
      new_fit_results <- results(
        pigsustainode(model_name, initial_values, run_parameters, times, backend="cpp")
      )
      (new_fit_results[,-1] - results(base_fit)[,-1])/(focal_par - perturb_par) * perturb_par/results(base_fit)[,-1]
    },
    simplify=F
  )

  for(m in 1:M) sensitivity_matrix[,m+2] <- unlist(sensitivity_raw[[m]])

  # summarise
  summary_matrix <- sensitivity_matrix %>%
    tidyr::pivot_longer(
      -c("times", "states", "base"),
      names_to = "parameter",
      values_to = "sensitivity"
    ) %>%
    dplyr::group_by(parameter, states) %>%
    dplyr::summarise(
      mean = mean(abs(sensitivity)),
      std = sd(abs(sensitivity)),
      .groups="drop"
    )

    return(
      new("PigSustainSens",
      model = model_name,
      sensitivity_matrix = sensitivity_matrix,
      summary_matrix = summary_matrix
    ))
}
