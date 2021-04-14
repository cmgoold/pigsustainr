/**
 * Test model definition
 */

#include "test_model.hpp"
#include <vector>

TestModel::TestModel() { }

TestModel::TestModel(const std::vector<double>& parameters) : Model(parameters){
  resolve_parameters();
}

// bit annoying, but need to unpackage parameters vector.
// Chould use a better container
void TestModel::resolve_parameters(){
  r = parameters_[0];
  k = parameters_[1];
}

std::vector<double> TestModel::derivatives(const std::vector<double>& states) {
  double y = states[0];
  derivatives_.clear();
  derivatives_.push_back(r * y * (1 - y/k));
  return derivatives_;
}
