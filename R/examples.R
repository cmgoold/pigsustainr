

.run_logistic_example <- function(){
  times <- seq(0, 10, 0.1)
  inits <- c(y=10)
  parameters <- c(r=0.1, k=100)

  fit <- pigsustainode(
    model_name="LogisticGrowth",
    initial_values=inits,
    parameters=parameters,
    times=times,
    backend="cpp"
  )

  return(fit)
}

.run_base_model_example <- function(){
  times <- seq(0, 52, 0.1)
  parameters <- c(
    sow_replacement_rate = 1/52,
    cost_of_production = 100,
    sow_removal_rate = 1/(2.5*52),
    slaughter_rate = 24/52,
    meat_per_pig = 110*0.75,
    waste_rate = 0.3,
    ref_coverage = 1,
    trade_proportion = 0.6,
    ref_demand = 30e6,
    demand_change_rate = 1/2,
    willingness_to_pay = 150,
    price_change_rate = 1/20
  )
  inits <- c(Sows = 400e3, Pork = 30e6, Demand = 30e6, Price = 140)

  fit <- pigsustainr::pigsustainode(
    model_name="BaseModel",
    initial_values=inits,
    parameters=parameters,
    times=times,
    backend="cpp"
  )

  sens <- pigsustainr::pigsustainsens(
    model_name="BaseModel",
    initial_values=inits,
    base_parameters=parameters,
    times=times,
    backend="cpp",
    sensitivity_parameters="all"
  )
}
