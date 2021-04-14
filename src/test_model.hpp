/**
 * Test model definition
 */

 #ifndef PIGSUSTAINSIMULATOR_CODE_CPP_TESTMODEL_
 #define PIGSUSTAINSIMULATOR_CODE_CPP_TESTMODEL_

#include "model.hpp"

class TestModel : public Model
{
    public:
      TestModel();
      TestModel(const std::vector<double>& parameters);

    private:
      double r;
      double k;

    // member functions
    private:
      void resolve_parameters();

    public:
      std::vector<double> derivatives(const std::vector<double>& states) override;
};

#endif
