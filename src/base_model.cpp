/**
* The base_model definition
*/

#include "base_model.hpp"
#include <vector>

BaseModel::BaseModel() { }

BaseModel::BaseModel(const std::vector<double>& parameters) : Model(parameters) {
 resolve_parameters();
}

void BaseModel::resolve_parameters(){
  sow_replacement_rate = parameters_[0];
  cost_of_production = parameters_[1];
  sow_removal_rate = parameters_[2];
  sow_service_rate = parameters_[3];
  farrowing_probability = parameters_[4];
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
}


std::vector<double> BaseModel::derivatives(const std::vector<double>& states, const double& t) {
 double Sows = states[0];
 double SowsInPig = states[1];
 double Piglets = states[2];
 double Weaners = states[3];
 double Growers = states[4];
 double Finishers = states[5];
 double Pork = states[6];
 double Demand = states[7];
 double Price = states[8];

 derivatives_.clear();

 // sow herd dynamics
 double sow_replacements = sow_replacement_rate*Sows*(Price/cost_of_production - 1);
 double sow_removals = sow_removal_rate*Sows;
 derivatives_.push_back(sow_replacements - sow_removals);

 // sow breeding dynamics
 double sow_services = sow_service_rate*Sows;
 double sows_ending_term = gestation_rate*SowsInPig;
 double sow_farrowings = farrowing_probability*sows_ending_term;
 double sow_abortions = (1 - farrowing_probability)*sows_ending_term;
 derivatives_.push_back(sow_services - sow_farrowings - sow_abortions);

 // market pig age dynamics
 double piglet_births = sow_farrowings * litter_size;
 double piglet_deaths = pre_weaning_mortality*weaning_rate*Piglets;
 double piglets_weaning = (1 - pre_weaning_mortality)*weaning_rate*Piglets;
 derivatives_.push_back(piglet_births - piglet_deaths - piglets_weaning);

 double weaners_growing = growing_rate*Weaners;
 derivatives_.push_back(piglets_weaning - weaners_growing);

 double growers_finishing = finishing_rate*Growers;
 derivatives_.push_back(weaners_growing - growers_finishing);

 double finishers_slaughtered = slaughter_rate*Finishers;
 derivatives_.push_back(growers_finishing - finishers_slaughtered);

 // pork inventory dynamics
 double domestic_production = finishers_slaughtered*meat_per_pig*killing_out_proportion;
 double waste_pork = waste_rate*Pork;
 double consumption = Demand*Pork*1/(Demand*ref_coverage + Pork);
 double trade = trade_proportion*(ref_demand  - domestic_production);
 derivatives_.push_back(domestic_production - waste_pork - consumption + trade);

 // demand dynamics
 derivatives_.push_back(demand_change_rate*(ref_demand*willingness_to_pay/Price - Demand));

 // price dynamics
 derivatives_.push_back(price_change_rate*Price*(ref_coverage*Demand/Pork - 1));

 return derivatives_;
}
