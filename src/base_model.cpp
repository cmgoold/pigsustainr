/**
* The base_model definition
*/

#include "base_model.hpp"
#include <vector>

BaseModel::BaseModel() { }

BaseModel::BaseModel(const std::vector<double>& parameters) : Model(parameters) {
 resolve_parameters();
}

void BaseModel::resolve_parameters(){
  a = parameters_[0];
  b = parameters_[1];
  e = parameters_[2];
  f = parameters_[3];
  g = parameters_[4];
  w = parameters_[5];
  s = parameters_[6];
  k = parameters_[7];
  h = parameters_[8];
  m = parameters_[9];
  q = parameters_[10];
  r = parameters_[11];
}


std::vector<double> BaseModel::derivatives(const std::vector<double>& states) {
 double S = states[0];
 double I = states[1];
 double D = states[2];
 double P = states[3];

 derivatives_.clear();

 derivatives_.push_back(a*S - (P/b - 1) - e*S);
 derivatives_.push_back(f*g*S - w*I - D*I / (D*s + I) + k*(h - f*g*S));
 derivatives_.push_back(m*(h*q/P - D));
 derivatives_.push_back(r*P*(s*D/I - 1));

 return derivatives_;
}
