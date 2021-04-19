validate_pigsustainode_data <- function(model_name, initial_values, parameters){
  model_name <- match.arg(model_name, ode_model_types)
  .validate_initial_values(model_name, initial_values)
  .validate_parameters(model_name, parameters)
}

# possible model types
ode_model_types <- c("LogisticGrowth", "BaseModel")

# validate initial values for state variables
# @param model name The name of the model
# @param initial_values The vector of initial values
.validate_initial_values <- function(model_name, initial_values){
  if(tolower(model_name) == "logisticgrowth"){
    n_states <- match(length(initial_values), .n_model_states(model_name))
  }
  if(tolower(model_name) == "basemodel"){
    n_states <- match(length(initial_values), .n_model_states(model_name))
  }
  if(is.na(n_states)){
    stop("Initial values do not have the correct number of values!")
  }
}

# the number of state variables per model
# @param model name The name of the model
.n_model_states <- function(model_name){
  n_states <- NULL
  if(tolower(model_name) == "logisticgrowth"){
    n_states <- 1
  }
  if(tolower(model_name) == "basemodel"){
    n_states <- 4
  }
  return(n_states)
}

.validate_parameters <- function(model_name, parameters){
  if(tolower(model_name) == "logisticgrowth"){
    valid_names = all(names(parameters) == logistic_parameter_names)
    valid_length = (length(names(parameters)) == length(logistic_parameter_names))
  }
  if(tolower(model_name) == "basemodel"){
    valid_names = all(names(parameters) == base_model_parameter_names)
    valid_length = (length(names(parameters)) == length(base_model_parameter_names))
  }

  if(!valid_names){
    stop("Parameter names are not valid! See examples for setting up pigsustainode model runs")
  }
  if(!valid_length){
    stop("Parameter vectors are not the same! Check you have included all necessary parameters")
  }
}

logistic_parameter_names <- c("r", "k")
base_model_parameter_names <- c("a", "b","e", "f", "g", "w", "s", "k", "h", "m", "q", "r")
