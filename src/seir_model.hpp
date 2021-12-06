/* 
 * Definition of an SEIR model 
 */

#ifndef PIGSUSTAINSIMULATOR_CODE_CPP_SEIR_
#define PIGSUSTAINSIMULATOR_CODE_CPP_SEIR_

#include "model.hpp"
#include<vector>

class SEIR : public Model {

    // constructors
    public:
      SEIR();
      SEIR (const std::vector<double>& parameters);

    // member variables
    private:
      double sow_replacement_rate;
      double cost_of_production;
      double sow_removal_rate;
      double sow_service_rate;
      double abortion;
      double gestation_rate;
      double litter_size;
      double pre_weaning_mortality;
      double weaning_rate;
      double growing_rate;
      double finishing_rate;
      double slaughter_rate;
      double meat_per_pig;
      double killing_out_proportion;
      double waste_rate;
      double ref_coverage;
      double trade_proportion;
      double ref_demand;
      double demand_change_rate;
      double willingness_to_pay;
      double price_change_rate;
      double infection_rate;
      double disease_start_time;
      double infected_death_rate;
      double intervention_efficacy;
      double intervention_midpoint;
      double intervention_growth_rate;
      double exposed_infectious;
      bool trade_drop;
      bool exports_on;

    // member functions
    private:
      void resolve_parameters();
    public:
      std::vector<double> derivatives(const std::vector<double>& states, const double& t) override;
      double intervention_growth(const double& t, const double& max, const double& midpoint, const double& growth_rate);
};

#endif
