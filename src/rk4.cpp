/**
 * The implementation of the rk4 integration class
 */

#include "rk4.hpp"

RK4::RK4() { }

RK4::RK4(const double& dt, std::unique_ptr<Model> model, const std::vector<double>& initial_states){
  dt_ = dt;
  // pass ownership of unique ptr
  model_ = std::move(model);
  states_ = initial_states;
}

std::vector<double> RK4::integrate(const int& t){

  std::vector<double> K1;
  std::vector<double> K2;
  std::vector<double> K3;
  std::vector<double> K4;
  int n_states_ = states_.size();

  //constants
  double constant = 1.0/6.0;
  double one_half_ = 0.5;

  // step 1
  std::vector<double> step_k_1_ = model_->derivatives(states_, t);
  for(int k = 0; k < n_states_; ++k){
    K1.push_back(step_k_1_[k] * dt_);
  }

  // step 2
  std::vector<double> step_2_states_;
  for(int k = 0; k < n_states_; ++k){
    step_2_states_.push_back(states_[k] + K1[k] * one_half_ );
  }
  std::vector<double> step_k_2_ = model_->derivatives(step_2_states_, t);
  for(int k = 0; k < n_states_; ++k){
    K2.push_back(step_k_2_[k] * dt_);
  }

  // step 3
  std::vector<double> step_3_states_;
  for(int k = 0; k < n_states_; ++k){
    step_3_states_.push_back(states_[k] + K2[k] * one_half_ );
  }
  std::vector<double> step_k_3_ = model_->derivatives(step_3_states_, t);
  for(int k = 0; k < n_states_; ++k){
    K3.push_back(step_k_3_[k] * dt_);
  }

  // step 4
  std::vector<double> step_4_states_;
  for(int k = 0; k < n_states_; ++k){
    step_4_states_.push_back(states_[k] + K3[k]);
  }
  std::vector<double> step_k_4_ = model_->derivatives(step_4_states_, t);
  for(int k = 0; k < n_states_; ++k){
    K4.push_back(step_k_4_[k] * dt_);
  }

  // update states
  std::vector<double> new_states_;
  for(int k = 0; k < n_states_; ++k){
    new_states_.push_back(states_[k] + constant * (K1[k] + (K2[k] + K3[k]) * 1/one_half_ + K4[k] ) );
  }

  states_ = new_states_;

  return states_;
}
