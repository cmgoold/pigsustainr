/**
 * The definition of the rk4 integration class
 */

#ifndef PIGSUSTAINSIMULATOR_CODE_CPP_RK4_
#define PIGSUSTAINSIMULATOR_CODE_CPP_RK4_

#include "model.hpp"
#include <memory>
#include <vector>

class RK4{

    public:
        RK4();
        RK4(const double& dt, std::unique_ptr<Model> model, const std::vector<double>& initial_states);

     private:
        // holds a unique pointer of the model to be integrated
        std::unique_ptr<Model> model_;
        // integration interval
        double dt_;
        // state variables calculation
        std::vector<double> states_;

     public:
       // integrate the model
       std::vector<double> integrate(const double& t);
};

#endif
