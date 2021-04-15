/**
 * Logistic growth model definition
 */

#include "logistic_growth.hpp"
#include <vector>

LogisticGrowth::LogisticGrowth() { }

LogisticGrowth::LogisticGrowth(const std::vector<double>& parameters) : Model(parameters){
  resolve_parameters();
}

// bit annoying, but need to unpackage parameters vector.
// Chould use a better container
void LogisticGrowth::resolve_parameters(){
  r = parameters_[0];
  k = parameters_[1];
}

std::vector<double> LogisticGrowth::derivatives(const std::vector<double>& states) {
  double y = states[0];
  derivatives_.clear();
  derivatives_.push_back(r * y * (1 - y/k));
  return derivatives_;
}
