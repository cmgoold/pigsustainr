
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
    if(tolower(model_name) == "seir"){
        fit <- .run_seir_model_example(backend=backend)
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
    sow_replacement_rate = 1/52,
    cost_of_production = 140,
    sow_removal_rate = 1/(2.5*52),
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

.run_seir_model_example <- function(backend){

    parameters <- c(
      replace = 0.02/7, 
      costs_of_production=138.25, 
      remove=0.00005/7,
      service = 0.05/7, 
      abortion = 0.1, 
      gestation=0.06/7,
      n = 12, 
      pre_weaning_mortality = 0.16, 
      wean = 0.25/7,
      grow = 0.167/7, 
      finish=0.05/7, 
      slaughter=0.33/7,
      meat_per_pig=109.9, 
      killing_out_proportion=0.75,
      waste=0.05/7,
      coverage=14, 
      trade_proportion=0.36, 
      ref_demand=50368562/7,
      demand_change=0.02/7, 
      willingness_to_pay=136,
      price_change=0.03/7,
      infection_rate=1.6, 
      disease_start_time = 1, 
      infected_death_rate=1/7.4,
      intervention_efficacy = 0.7, 
      intervention_midpoint = 366 + 5, 
      intervention_growth_rate = 0.1, 
      exposed_infectious=1/7.9,
      trade_drop = 0,
      exports_on = 1
    )

    inits <- c(
          SowsSusceptible=406e3,  SowsExposed=0, SowsInfected=0, SowsInPig=296e3,
          PigletsSusceptible=900e3, PigletsExposed=0, PigletsInfected=0,
          WeanersSusceptible=1000e3, WeanersExposed=0, WeanersInfected=0,
          GrowersSusceptible=1500e3, GrowersExposed=0, GrowersInfected=0,
          FinishersSusceptible=500e3, FinishersExposed=0, FinishersInfected=0,
          Pork=30e6/7 * 14, Demand=30e6/7, Price=160
        )

    n_days <- 365*5
    dt <- 0.1
    times <- seq(0, n_days, dt)


    fit <- pigsustainode(
        model_name="SEIR",
        initial_values=inits,
        parameters=parameters,
        times=times,
        backend=backend
    )

  return(fit)
}
