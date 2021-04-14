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
      double a;
      double b;
      double e;
      double f;
      double g;
      double w;
      double s;
      double k;
      double h;
      double m;
      double q;
      double r;

    // member functions
    private:
      void resolve_parameters();
    public:
      std::vector<double> derivatives(const std::vector<double>& states) override;

};

#endif
