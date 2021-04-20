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
  slaughter_rate = parameters_[3];
  meat_per_pig = parameters_[4];
  waste_rate = parameters_[5];
  ref_coverage = parameters_[6];
  trade_proportion = parameters_[7];
  ref_demand = parameters_[8];
  demand_change_rate = parameters_[9];
  willingness_to_pay = parameters_[10];
  price_change_rate = parameters_[11];
}


std::vector<double> BaseModel::derivatives(const std::vector<double>& states) {
 double Sows = states[0];
 double Pork = states[1];
 double Demand = states[2];
 double Price = states[3];

 derivatives_.clear();

 derivatives_.push_back(sow_replacement_rate*Sows*(Price/cost_of_production - 1) - sow_removal_rate*Sows);
 derivatives_.push_back(
   slaughter_rate*meat_per_pig*Sows - waste_rate*Pork -
   Demand*Pork/(Demand*ref_coverage + Pork) + trade_proportion*(ref_demand - slaughter_rate*meat_per_pig*Sows));
 derivatives_.push_back(demand_change_rate*(ref_demand*willingness_to_pay/Price - Demand));
 derivatives_.push_back(price_change_rate*Price*(ref_coverage*Demand/Pork - 1));

 return derivatives_;
}
