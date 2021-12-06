
.LogisticGrowth <- function(t, y, p)
{
  with( as.list(c( y, p )), {
    return(list(c(

      dy_dt = r * y * (1 - y/k)

    )))
  })
}

.BaseModel <- function(t, y, p)
{
  with( as.list(c( y, p )), {

    return(list(c(

      dSows_dt <- sow_replacement_rate * Sows * (Price/cost_of_production - 1) - sow_removal_rate * Sows,
      dSowsInPig_dt <- sow_service_rate*Sows - farrowing_probability*gestation_rate*SowsInPig - (1 - farrowing_probability)*gestation_rate*SowsInPig, 

      dPiglets_dt <- litter_size*farrowing_probability*gestation_rate*SowsInPig - pre_weaning_mortality*weaning_rate*Piglets - 
          (1 - pre_weaning_mortality)*weaning_rate*Piglets, 
      dWeaners_dt <- (1 - pre_weaning_mortality) * weaning_rate * Piglets - growing_rate*Weaners,
      dGrowers_dt <- growing_rate*Weaners - finishing_rate*Growers,
      dFinishers_dt <- finishing_rate*Growers - slaughter_rate*Finishers, 

      dPork_dt <- slaughter_rate*Finishers*meat_per_pig*killing_out_proportion - waste_rate*Pork -
                    Pork/(Demand*ref_coverage + Pork)*Demand +
                    trade_proportion*(ref_demand - slaughter_rate*Finishers*meat_per_pig*killing_out_proportion),

      dDemand_dt <- demand_change_rate*(ref_demand*willingness_to_pay/Price - Demand),

      dPrice_dt <- price_change_rate*Price*(ref_coverage*Demand/Pork - 1)

    )))

  })
}

intervention_growth <- function(t, max, mid_point, growth) max/(1 + exp(-growth * (t - mid_point)))

.SEIR <- function(t, y, p){
    with(as.list(c(y, p)), {

    total_sows <- SowsSusceptible + SowsExposed + SowsInfected
    total_piglets <- PigletsSusceptible + PigletsExposed + PigletsInfected 
    total_weaners <- WeanersSusceptible + WeanersExposed + WeanersInfected  
    total_growers <- GrowersSusceptible + GrowersExposed + GrowersInfected  
    total_finishers <- FinishersSusceptible + FinishersExposed + FinishersInfected 
    total_pigs <- total_sows + total_piglets + total_weaners + total_growers + total_finishers
    total_infected <- SowsInfected+PigletsInfected+WeanersInfected+GrowersInfected+FinishersInfected
    
    intervention <- 0
    if(disease_start_time > 0 & t >= disease_start_time)
      intervention <- intervention_growth(t, intervention_efficacy, intervention_midpoint, intervention_growth_rate) 
    
    lambda <- (1 - intervention) * infection_rate
    beta_sows <- lambda * SowsInfected/total_sows
    beta_piglets <- lambda * PigletsInfected/total_piglets
    beta_weaners <- lambda * WeanersInfected/total_weaners
    beta_growers <- lambda * GrowersInfected/total_growers
    beta_finishers <- lambda * FinishersInfected/total_finishers
    
    # disease start indicator
    disease_start <- 0
    if(t == disease_start_time)
        disease_start <- 1
    
    dSowsSusceptible_dt <- replace*SowsSusceptible*(Price/costs_of_production - 1) - remove*SowsSusceptible - beta_sows*SowsSusceptible 
    dSowsExposed_dt <- beta_sows*SowsSusceptible - remove*SowsExposed - exposed_infectious*SowsExposed + disease_start 
    dSowsInfected_dt <- exposed_infectious*SowsExposed - infected_death_rate*SowsInfected 
    dSowsInPig_dt <- service*SowsSusceptible + (1 - intervention)*service*SowsExposed - gestation*SowsInPig
    
    # Piglets
    dPigletsSusceptible_dt <- n*(1 - abortion)*gestation*SowsInPig - wean*PigletsSusceptible - beta_piglets*PigletsSusceptible
    dPigletsExposed_dt <- beta_piglets*PigletsSusceptible - (1 - intervention)*wean*PigletsExposed - exposed_infectious*PigletsExposed 
    dPigletsInfected_dt <- exposed_infectious*PigletsExposed - infected_death_rate*PigletsInfected 
    
    # Weaners
    dWeanersSusceptible_dt <- (1 - pre_weaning_mortality)*wean*PigletsSusceptible - grow*WeanersSusceptible - beta_weaners*WeanersSusceptible 
    dWeanersExposed_dt <- beta_weaners*WeanersSusceptible + (1 - intervention)*(1 - pre_weaning_mortality)*wean*PigletsExposed - 
      (1 - intervention)*grow*WeanersExposed - exposed_infectious*WeanersExposed 
    dWeanersInfected_dt <- exposed_infectious*WeanersExposed - infected_death_rate*WeanersInfected 
    
    #Growers
    dGrowersSusceptible_dt <- grow*WeanersSusceptible - finish*GrowersSusceptible - beta_growers*GrowersSusceptible
    dGrowersExposed_dt <- beta_growers*GrowersSusceptible + (1 - intervention)*grow*WeanersExposed - 
      (1 - intervention)*finish*GrowersExposed - exposed_infectious*GrowersExposed 
    dGrowersInfected_dt <- exposed_infectious*GrowersExposed - infected_death_rate*GrowersInfected 
    
    # Finishers
    dFinishersSusceptible_dt <- finish*GrowersSusceptible - slaughter*FinishersSusceptible - 
      beta_finishers*FinishersSusceptible
    dFinishersExposed_dt <- beta_finishers*FinishersSusceptible + (1 - intervention)*finish*GrowersExposed - 
      (1 - intervention)*slaughter*FinishersExposed - exposed_infectious*FinishersExposed 
    dFinishersInfected_dt <- exposed_infectious*FinishersExposed - infected_death_rate*FinishersInfected 
    
    domestic_production <- slaughter*(FinishersSusceptible + (1 - intervention)*FinishersExposed)*meat_per_pig*killing_out_proportion
    consumption <- Demand*Pork*1/(Demand*coverage + Pork)
    
    if (trade_drop)
      trade <- trade_proportion*(1+SowsInfected/total_sows)
    else
      trade <- trade_proportion
    
    imports <- trade * ref_demand
    
    if(!exports_on & t > disease_start_time)
      exports <- 0
    else
      exports <- trade * domestic_production
    
    dPork_dt <- domestic_production - waste*Pork - consumption + imports - exports
    
    dDemand_dt <- demand_change * (ref_demand * willingness_to_pay/Price - Demand)
    
    dPrice_dt <- price_change * Price * (coverage * Demand/Pork - 1)
    return(list(
      c(
        dSowsSusceptible_dt, dSowsExposed_dt, dSowsInfected_dt, dSowsInPig_dt,
        dPigletsSusceptible_dt, dPigletsExposed_dt, dPigletsInfected_dt,
        dWeanersSusceptible_dt, dWeanersExposed_dt, dWeanersInfected_dt,
        dGrowersSusceptible_dt, dGrowersExposed_dt, dGrowersInfected_dt,
        dFinishersSusceptible_dt, dFinishersExposed_dt, dFinishersInfected_dt,
        dPork_dt, dDemand_dt, dPrice_dt
      )
    ))
  })
}
