/* The base PigSustain model definition
 */

#ifndef PIGSUSTAINSIMULATOR_CODE_CPP_BASEMODEL_
#define PIGSUSTAINSIMULATOR_CODE_CPP_BASEMODEL_

#include "model.hpp"
#include<vector>

class BaseModel : public Model {

    // constructors
    public:
      BaseModel();
      BaseModel(const std::vector<double>& parameters);

    // member variables
    private:
      double sow_replacement_rate;
      double cost_of_production;
      double sow_removal_rate;
      double slaughter_rate;
      double meat_per_pig;
      double waste_rate;
      double ref_coverage;
      double trade_proportion;
      double ref_demand;
      double demand_change_rate;
      double willingness_to_pay;
      double price_change_rate;

    // member functions
    private:
      void resolve_parameters();
    public:
      std::vector<double> derivatives(const std::vector<double>& states) override;

};

#endif
