/**
 * The main integration functions to be passed to R
 */

#include <Rcpp.h>
#include "rk4.hpp"
#include "model.hpp"
#include "test_model.hpp"
#include "base_model.hpp"
#include <vector>
#include <iostream>
#include <string>
#include <memory>

//' Integrates a PigSustainR model
//' @param model_type A string for the model type to integrate
//' @param times A vector of integration time steps
//' @param inits A vector of initial values of the state variables
//' @param parameters A vector of parameters
//' @return A dataframe of state variable solutions
//[[Rcpp::export]]
Rcpp::DataFrame integrate_ode(
  std::string& model_type,
  const std::vector<double>& times,
  const std::vector<double>& inits,
  const std::vector<double>& parameters,
  const double& dt
 )
 {

   int n_sim_t = times.size();
   int n_states = inits.size();

   // out vector declared
   Rcpp::NumericMatrix out(n_sim_t, n_states+1);

   // initial conditions
   out(0, 0) = 0;
   for(int i = 0; i < n_states; ++i){
     out(0, i+1) = inits[i];
   }

   // create unique pointer to model object
   std::unique_ptr<Model> model;

   if(model_type=="TestModel"){
     model = std::make_unique<TestModel>(parameters);
     colnames(out) = Rcpp::CharacterVector::create("times", "y");
   }

   if(model_type=="BaseModel"){
     model = std::make_unique<BaseModel>(parameters);
     colnames(out) = Rcpp::CharacterVector::create("times", "S", "I", "D", "P");
   }

   // integration instance initialised
   RK4 solve(dt, std::move(model), inits);

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
