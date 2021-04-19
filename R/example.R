

.run_logistic_example <- function(){
  times <- seq(0, 10, 0.1)
  inits <- c(y=10)
  parameters <- c(r=0.1, k=100)

  fit <- pigsustainode(
    model_name="LogisticGrowth",
    initial_values=inits,
    parameters=parameters,
    times=times,
    backend="cpp"
  )

  return(fit)
}
