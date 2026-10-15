# Population Health Intelligence | Model and marginal replication

**Status:** Replication passed on reconstructed all-age NHANES survey design.

## Scope
Using DEMO_J and GHB_J all-age merged records (9,254 respondents), define the survey design before restricting to adults with complete covariate and laboratory values. Compare against the prior design defined from adults age 20+.

## Verified
- Analytic sample: 4,362 in both designs.
- Survey domain degrees of freedom: 15 in both designs.
- All 15 coefficients and standard errors from the survey-weighted quasibinomial model matched exactly.
- All nine adjusted marginal prevalences (four income groups and five education groups) and their delta-method standard errors matched exactly.

## Interpretation
This replicates coefficients and standardized marginal estimates for the existing model. It does **not** settle selection bias from missing income information, the scientific appropriateness of the adjustment set, the limited residual degrees of freedom for joint Wald tests, or causal interpretation.

## Reproduction
`Rscript scripts/14_model_replication.R`

Results: `reports/14_model_replication.csv` and `reports/14_marginal_replication.csv`.
