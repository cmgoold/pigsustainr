
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

      dPork_dt <- slaughter_rate*meat_per_pig*Sows - waste_rate*Pork -
                    Pork/(Demand*ref_coverage + Pork)*Demand +
                    trade_proportion*(ref_demand - slaughter_rate*meat_per_pig*Sows),

      dDemand_dt <- demand_change_rate*(ref_demand*willingness_to_pay/Price - Demand),

      dPrice_dt <- price_change_rate*Price*(ref_coverage*Demand/Pork - 1)

    )))

  })
}
