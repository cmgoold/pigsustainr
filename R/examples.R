

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

.run_base_model_example <- function(){
  times <- seq(0, 52, 0.1)
  parameters <- c(
    a = 1/52, b = 120, e = 1/(2.5*52),
    f = 1/52, g = 110*24*0.75, w = 0.3,
    s = 1, k = 0.6, h = 30e6,
    m = 1/2, q = 150, r = 1/20
  )
  inits <- c(C = 400e3, I = 30e6, D = 30e6, P = 140)

  fit <- pigsustainode(
    model_name="BaseModel",
    initial_values=inits,
    parameters=parameters,
    times=times,
    backend="cpp"
  )
}
