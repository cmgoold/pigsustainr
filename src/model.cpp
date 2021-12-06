/**
 * Generic model class implementation
 */

#include "model.hpp"
#include <vector>
#include <iostream>

Model::Model() {}

Model::Model(const std::vector<double>& parameters){
  parameters_ = parameters;
}

std::vector<double> Model::derivatives(const std::vector<double>& states, const double& t){
  std::cout << "In Model's derivatives function" << std::endl;
  return derivatives_;
}

void Model::show_parameters(){
  int n_params = parameters_.size();

  for(int i = 0; i < n_params; ++i){
    std::cout << "parameter " << i + 1 << " = " << parameters_[i] << ", ";
    std::cout << std::endl;
  }
  std::cout << std::endl;
}
