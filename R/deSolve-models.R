
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
