validate_pigsustainode_data <- function(model_name, initial_values){
  model_name <- match.arg(model_name, .ode_model_types())
  .validate_initial_values(initial_values)
}

# possible model types
.ode_model_types <- function(){
  model_types <- c("LogisticGrowth", "BaseModel")
  return(model_types)
}

# validate initial values for state variables
# @param model name The name of the model
# @param initial_values The vector of initial values
.validate_initial_values <- function(model_name, initial_values){
  if(model_name == "LogisticGrowth"){
    n_states <- match.arg(length(initial_values), .n_model_states())
  }
}

# the number of state variables per model
# @param model name The name of the model
.n_model_states <- function(model_name){
  n_states <- NULL
  if(model_name == "LogisticGrowth"){
    n_states <- 1
  }
  if(model_name == "BaseModel"){
    n_states <- 4
  }
  return(n_states)
}
