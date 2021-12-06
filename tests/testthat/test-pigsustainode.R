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
})

testthat::test_that("basemodel using integrate_ode and deSolve match", {

    fit_cpp <- run_example_model(
        model_name="BaseModel", 
        backend="cpp"
        )

    fit_desolve <- run_example_model(
        model_name="BaseModel", 
        backend="deSolve"
        )

    testthat::expect_equal(
        results(fit_cpp)[,-1], results(fit_desolve)[,-1], 
        tolerance=1e-5
        )
})

testthat::test_that("seir using integrate_ode and deSolve match", {

    fit_cpp <- run_example_model(
        model_name="SEIR", 
        backend="cpp"
        )

    fit_desolve <- run_example_model(
        model_name="SEIR", 
        backend="deSolve"
        )

    testthat::expect_equal(
        results(fit_cpp)[,-1], results(fit_desolve)[,-1], 
        tolerance=1e-2
        )
})
