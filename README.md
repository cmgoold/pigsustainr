# PigSustainR

Version 0.1. A work in progress!

PigSustainR is an R package for modelling the sustainability of pig industries.
The main inspiration is the UK pig industry, driven by the University of Leeds'
[PigSustain project](https://gtr.ukri.org/projects?ref=BB%2FN020790%2F1).

The package includes a number of pre-defined models, with more to be added. 
Performance is maximised by using pre-compiled models written in `C++`. 

## Installation
To install the package, use the `devtools` package:

```{r}
devtools::install_github("cmgoold/pigsustainr")
```

## Examples
`PigSustainR` has a number of example models. For instance:

```{r}
fit <- pigsustainr::run_example_model(model_name="LogisticGrowth")
pigsustainr::stateplot(fit)
pigsustainr::pigsustainsens(fit)
``` 

