/**
 * Definition of the generic model class
 */

#ifndef PIGSUSTAINSIMULATOR_CODE_CPP_MODEL_
#define PIGSUSTAINSIMULATOR_CODE_CPP_MODEL_

#include <vector>

class Model
{
    public:
        Model();
        Model(const std::vector<double>& parameters);

    protected:
        std::vector<double> parameters_;
        std::vector<double> derivatives_;

    public:
        void show_parameters();
        virtual std::vector<double> derivatives(const std::vector<double>& states, const double& t);
};

#endif
