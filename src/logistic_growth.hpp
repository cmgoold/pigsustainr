/**
 * Logistic growth example model definition
 */

 #ifndef PIGSUSTAINSIMULATOR_CODE_CPP_LOGISTICGROWTH_
 #define PIGSUSTAINSIMULATOR_CODE_CPP_LOGISTICGROWTH_

#include "model.hpp"
#include <vector>

class LogisticGrowth : public Model
{
    public:
      LogisticGrowth();
      LogisticGrowth(const std::vector<double>& parameters);

    private:
      double r;
      double k;

    // member functions
    private:
      void resolve_parameters();

    public:
      std::vector<double> derivatives(const std::vector<double>& states, const double& t) override;
};

#endif
