
.LogisticGrowth <- function(t, y, p)
{
  with( as.list(c( y, p )), {
    return(list(c(

      dy_dt = r * y * (1 - y/k)

    )))
  })
}

.BaseModel <- function(t, y, p)
{
  with( as.list(c( y, p )), {

    return(list(c(

      dS_dt <- a * C * (P/b - 1) - e * C,

      dI_dt <- f*g*C - w*I - I/(D*s + I)*D + k*(h - f*g*C),

      dD_dt <- m*(h*q/P - D),

      dP_dt <- r*P*( s*D/I - 1)

    )))

  })
}
