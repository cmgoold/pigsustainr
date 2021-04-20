/**
 * The main integration functions to be passed to R
 */

#include <Rcpp.h>
#include "rk4.hpp"
#include "model.hpp"
#include "logistic_growth.hpp"
#include "base_model.hpp"
#include <vector>
#include <iostream>
#include <string>
#include <memory>

//' Integrates a \pkg{pigsustainr} model using C++
//' @param model_type A string for the model type to integrate
//' @param times A vector of integration time steps
//' @param inits A vector of initial values of the state variables
//' @param parameters A vector of parameters
//' @return A dataframe of state variable solutions
//[[Rcpp::export]]
Rcpp::DataFrame integrate_ode(
  std::string& model_name,
  const std::vector<double>& initial_values,
  const std::vector<double>& parameters,
  const std::vector<double>& times
 )
 {

   const double dt = times[1] - times[0];
   int n_sim_t = times.size();
   int n_states = initial_values.size();

   // out vector declared
   Rcpp::NumericMatrix out(n_sim_t, n_states+1);

   // initial conditions
   out(0, 0) = 0;
   for(int i = 0; i < n_states; ++i){
     out(0, i+1) = initial_values[i];
   }

   // create unique pointer to model object
   std::unique_ptr<Model> model;

   if(model_name=="LogisticGrowth"){
     model = std::make_unique<LogisticGrowth>(parameters);
     colnames(out) = Rcpp::CharacterVector::create("times", "y");
   }

   if(model_name=="BaseModel"){
     model = std::make_unique<BaseModel>(parameters);
     colnames(out) = Rcpp::CharacterVector::create("times", "Sows", "Pork", "Demand", "Price");
   }

   // integration instance initialised
   RK4 solve(dt, std::move(model), initial_values);

   // integrate
   for(int tt = 0; tt < (n_sim_t-1); ++tt){

     out(tt+1, 0) = (tt+1) * dt;

     // solve
     std::vector<double> sol = solve.integrate();

     // add to state vectors
     for(size_t i = 0; i < sol.size(); ++i){
       out(tt+1, i+1) = sol[i];
     }
   }//tt

   return out;

 }
