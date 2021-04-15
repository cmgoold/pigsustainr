context("test basic pigsustainode functionality")

testthat::test_that("integrate_ode and deSolve match",{
  times <- seq(0, 100, 0.01)
  inits <- c(y=10)
  parameters <- c(r=0.1, k=100)

  fit_cpp <- pigsustainode(
    model_name="LogisticGrowth",
    initial_values=inits,
    parameters=parameters,
    times=times,
    backend="cpp"
  )

  fit_deSolve <- pigsustainode(
    model_name="LogisticGrowth",
    initial_values=inits,
    parameters=parameters,
    times=times,
    backend="deSolve"
  )

  testthat::expect_equal(
    fit_cpp@results[,2], fit_deSolve@results[,2],
    tolerance=1e-10
  )
}

)
