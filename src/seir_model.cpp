/**
* The SEIR model definition
*/

#include "seir_model.hpp"
#include <vector>
#include <math.h>

SEIR::SEIR() { }

SEIR::SEIR(const std::vector<double>& parameters) : Model(parameters) {
 resolve_parameters();
}

void SEIR::resolve_parameters(){
  sow_replacement_rate = parameters_[0];
  cost_of_production = parameters_[1];
  sow_removal_rate = parameters_[2];
  sow_service_rate = parameters_[3];
  abortion = parameters_[4];
  gestation_rate = parameters_[5];
  litter_size = parameters_[6];
  pre_weaning_mortality = parameters_[7];
  weaning_rate = parameters_[8];
  growing_rate = parameters_[9];
  finishing_rate = parameters_[10];
  slaughter_rate = parameters_[11];
  meat_per_pig = parameters_[12];
  killing_out_proportion = parameters_[13];
  waste_rate = parameters_[14];
  ref_coverage = parameters_[15];
  trade_proportion = parameters_[16];
  ref_demand = parameters_[17];
  demand_change_rate = parameters_[18];
  willingness_to_pay = parameters_[19];
  price_change_rate = parameters_[20];
  infection_rate = parameters_[21];
  disease_start_time = parameters_[22];
  infected_death_rate = parameters_[23];
  intervention_efficacy = parameters_[24];
  intervention_midpoint = parameters_[25];
  intervention_growth_rate = parameters_[26];
  exposed_infectious = parameters_[27];
  trade_drop = parameters_[28];
  exports_on = parameters_[29];
}

double SEIR::intervention_growth(const double& t, const double& max, const double& midpoint, const double& growth_rate){
    double intervention_ = max / (1 + exp(-growth_rate * (t - midpoint)));
    return intervention_;
}

std::vector<double> SEIR::derivatives(const std::vector<double>& states, const double& t) {
 double SowsSusceptible = states[0];
 double SowsExposed = states[1];
 double SowsInfected = states[2];
 double SowsInPig = states[3];
 double PigletsSusceptible = states[4];
 double PigletsExposed = states[5];
 double PigletsInfected = states[6];
 double WeanersSusceptible = states[7];
 double WeanersExposed = states[8];
 double WeanersInfected = states[9];
 double GrowersSusceptible = states[10];
 double GrowersExposed = states[11];
 double GrowersInfected = states[12];
 double FinishersSusceptible = states[13];
 double FinishersExposed = states[14];
 double FinishersInfected = states[15];
 double Pork = states[16];
 double Demand = states[17];
 double Price = states[18];

 derivatives_.clear();

 // total pig numbers
 double total_sows = SowsSusceptible + SowsExposed + SowsInfected; 
 double total_piglets = PigletsSusceptible + PigletsExposed + PigletsInfected;
 double total_weaners = WeanersSusceptible + WeanersExposed + WeanersInfected;
 double total_growers = GrowersSusceptible + GrowersExposed + GrowersInfected;
 double total_finishers = FinishersSusceptible + FinishersExposed + FinishersInfected;
 double total_pigs = total_sows + total_piglets + total_weaners + total_growers + total_finishers;
 double total_infected = SowsInfected + PigletsInfected + WeanersInfected + GrowersInfected + FinishersInfected;

 // disease intervention
 double intervention = 0;
 if(disease_start_time > 0 && t >= disease_start_time)
     intervention = intervention_growth(t, intervention_efficacy, intervention_midpoint, intervention_growth_rate);

 // forces of infection
 double lambda = (1 - intervention) * infection_rate;
 double beta_sows = lambda * SowsInfected / total_sows;
 double beta_piglets = lambda * PigletsInfected / total_piglets;
 double beta_weaners = lambda * WeanersInfected / total_weaners;
 double beta_growers = lambda * GrowersInfected / total_growers;
 double beta_finishers = lambda * FinishersInfected / total_finishers;

 // disease start pig 
 int disease_start = 0;
 if(t == disease_start_time) disease_start = 1;

 /* sow breeding dynamics */
 // Susceptible sows
 double sow_replacements = sow_replacement_rate*SowsSusceptible*(Price/cost_of_production - 1);
 double sow_removals = sow_removal_rate*SowsSusceptible;
 double sows_exposed = beta_sows*SowsSusceptible;
 derivatives_.push_back(sow_replacements - sow_removals - sows_exposed);

 //Exposed sows
 double sows_exposed_removals = sow_removal_rate * SowsExposed;
 double sows_exposed_infectious = exposed_infectious * SowsExposed;
 derivatives_.push_back(sows_exposed - sows_exposed_removals - sows_exposed_infectious + disease_start);

 //Infected sows
 double sows_infected_death = infected_death_rate * SowsInfected;
 derivatives_.push_back(sows_exposed_infectious - sows_infected_death);

 // Sows breeding 
 double sow_services = sow_service_rate*SowsSusceptible;
 double sows_exposed_services = sow_service_rate * (1 - intervention) * SowsExposed;
 double sows_ending_term = gestation_rate*SowsInPig;
 derivatives_.push_back(sow_services + sows_exposed_services - sows_ending_term);

 /* Piglets */
 //Susceptible piglets
 double piglet_births = litter_size * (1 - abortion) * sows_ending_term;
 double piglets_weaning = weaning_rate * PigletsSusceptible;
 double piglets_exposed = beta_piglets * PigletsSusceptible;
 derivatives_.push_back(piglet_births - piglets_weaning - piglets_exposed);

 // Exposed piglets
 double piglets_exposed_weaning = (1 - intervention) * weaning_rate * PigletsExposed;
 double piglets_exposed_infectious = exposed_infectious * PigletsExposed;
 derivatives_.push_back(piglets_exposed - piglets_exposed_weaning - piglets_exposed_infectious + disease_start);

 // Infected piglets
 double piglets_infected_death = infected_death_rate * PigletsInfected;
 derivatives_.push_back(piglets_exposed_infectious - piglets_infected_death);

 /* Weaners */
 // Susceptible weaners
 piglets_weaning *= (1 - pre_weaning_mortality);
 double weaners_growing = growing_rate * WeanersSusceptible;
 double weaners_exposed = beta_weaners * WeanersSusceptible;
 derivatives_.push_back(piglets_weaning - weaners_growing - weaners_exposed);

 // Exposed weaners
 piglets_exposed_weaning *= (1 - pre_weaning_mortality);
 double weaners_exposed_infectious = exposed_infectious * WeanersExposed;
 double weaners_exposed_growing = (1 - intervention) * growing_rate * WeanersExposed;
 derivatives_.push_back(weaners_exposed + piglets_exposed_weaning 
         - weaners_exposed_infectious - weaners_exposed_growing);

 // Infected weaners
 double weaners_infected_death = infected_death_rate * WeanersInfected;
 derivatives_.push_back(weaners_exposed_infectious - weaners_infected_death);

 /* Growers */
 // Susceptible growers
 double growers_finishing = finishing_rate * GrowersSusceptible;
 double growers_exposed = beta_growers * GrowersSusceptible;
 derivatives_.push_back(weaners_growing - growers_finishing - growers_exposed);

 // Exposed growers
 double growers_exposed_infectious = exposed_infectious * GrowersExposed;
 double growers_exposed_finishing = (1 - intervention) * finishing_rate * GrowersExposed;
 derivatives_.push_back(growers_exposed + weaners_exposed_growing - growers_exposed_finishing - growers_exposed_infectious);

 // Infected growers
 double growers_infected_death = infected_death_rate * GrowersInfected;
 derivatives_.push_back(growers_exposed_infectious - growers_infected_death);

 /* Finishers */
 // Susceptible finishers
 double finishers_slaughtered = slaughter_rate * FinishersSusceptible;
 double finishers_exposed = beta_finishers * FinishersSusceptible;
 derivatives_.push_back(growers_finishing - finishers_slaughtered - finishers_exposed);

 // Exposed finishers
 double finishers_exposed_infectious = exposed_infectious * FinishersExposed;
 double finishers_exposed_slaughtered = (1 - intervention) * slaughter_rate * FinishersExposed;
 derivatives_.push_back(finishers_exposed + growers_exposed_finishing - finishers_exposed_slaughtered - finishers_exposed_infectious); 

 // Infected finishers
 double finishers_infected_death = infected_death_rate * FinishersInfected;
 derivatives_.push_back(finishers_exposed_infectious - finishers_infected_death);

 // pork inventory dynamics
 double slaughter_pigs = finishers_slaughtered + finishers_exposed_slaughtered;
 double domestic_production = slaughter_pigs*meat_per_pig*killing_out_proportion;
 double waste_pork = waste_rate*Pork;
 double consumption = Demand*Pork*1/(Demand*ref_coverage + Pork);
 
 double trade_value = trade_proportion;
 if(trade_drop)
     trade_value *= (1 + total_infected/total_pigs);

 double imports = trade_value * ref_demand;

 double exports = trade_value * domestic_production;
 if(!exports_on && t > disease_start_time)
     exports = 0;

 derivatives_.push_back(domestic_production - waste_pork - consumption + imports - exports);

 // demand dynamics
 derivatives_.push_back(demand_change_rate*(ref_demand*willingness_to_pay/Price - Demand));

 // price dynamics
 derivatives_.push_back(price_change_rate*Price*(ref_coverage*Demand/Pork - 1));

 return derivatives_;
}
