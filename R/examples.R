
run_example_model <- function(
      model_name, 
      backend="cpp"
   ){
    
    if(tolower(model_name) == "logisticgrowth"){
        fit <- .run_logistic_example(backend=backend)
    }
    if(tolower(model_name) == "basemodel"){
        fit <- .run_base_model_example(backend=backend)
    }

    return(fit)

}


.run_logistic_example <- function(backend){
  times <- seq(0, 10, 0.1)
  inits <- c(y=10)
  parameters <- c(r=0.1, k=100)

  fit <- pigsustainode(
    model_name="LogisticGrowth",
    initial_values=inits,
    parameters=parameters,
    times=times,
    backend=backend
  )

  return(fit)
}

.run_base_model_example <- function(backend){
  times <- seq(0, 52, 0.1)
  parameters <- c(
    sow_growth_rate = 1/52,
    cost_of_production = 140,
    sow_death_rate = 1/(2.5*52),
    sow_service_rate = 2.4/52, 
    farrowing_probability = 0.9, 
    gestation_rate = 1/(114/7), 
    litter_size = 12, 
    pre_weaning_mortality = 0.16, 
    weaning_rate = 1/4, 
    growing_rate = 1/6, 
    finishing_rate = 1/20, 
    slaughter_rate = 1/3,
    meat_per_pig = 110, 
    killing_out_proportion=0.75,
    waste_rate = 0.3,
    ref_coverage = 1,
    trade_proportion = 0.6,
    ref_demand = 30e6,
    demand_change_rate = 1/2,
    willingness_to_pay = 150,
    price_change_rate = 1/20
  )

  inits <- c(
      Sows = 400e3, SowsInPig = 200e3, 
      Piglets = 500e3, Weaners = 500e3, 
      Growers = 2e6, Finishers=1e6, 
      Pork = 30e6, Demand = 30e6, Price = 140
  )

  fit <- pigsustainode(
    model_name="BaseModel",
    initial_values=inits,
    parameters=parameters,
    times=times,
    backend=backend
  )

  return(fit)
}
