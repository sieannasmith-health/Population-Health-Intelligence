# Population Health Intelligence | Adjusted marginal prevalence

**Dataset:** NHANES 2017-2018, adults 20+  
**Outcome:** HbA1c >=6.5%  
**Status:** Exploratory, complete-case survey-weighted marginal standardization.

## Method
- Fit the existing survey-weighted quasibinomial logistic regression for HbA1c >=6.5% on income-to-poverty categories, education, continuous age, sex, and race/ethnicity.
- Analytic sample: 4,362 complete-case adults.
- For each income (or education) category, predict every analytic participant with that category assigned, retaining observed values of the other predictors.
- Average predictions using analytic survey weights to estimate standardized prevalence for the analytic sample's observed covariate distribution.
- Uncertainty calculated using the coefficient covariance matrix and delta-method gradient; approximate 95% t-intervals use 15 design degrees of freedom. Intervals truncated to [0%, 100%].
- The analysis is cross-sectional; no intervention, longitudinal change, or causal effect is established.

## Adjusted prevalence

| Factor | Category | Estimate (%) | Approx. 95% CI (%) |
|---|---|---:|---|
| Income PIR | <=1 | 11.09 | 8.64-13.54 |
| Income PIR | 1-2 | 10.92 | 8.87-12.98 |
| Income PIR | 2-4 | 9.83 | 6.85-12.81 |
| Income PIR | >4 | 9.67 | 7.29-12.06 |
| Education | <9th | 14.15 | 8.09-20.20 |
| Education | 9-11th | 9.88 | 6.12-13.64 |
| Education | HS/GED | 11.51 | 8.38-14.64 |
| Education | Some college | 9.92 | 8.22-11.63 |
| Education | College+ | 8.60 | 6.11-11.10 |

## Interpretation
Adjusted probabilities are easier to communicate than conditional odds ratios, but do not show causal effects. The income gradient is modest; education estimates are not monotonic. Wide intervals for some education groups indicate lower absolute precision. Overlapping group-specific intervals are not a formal test of differences; compute design-covariance-aware pairwise contrasts in the next stage.

## Next checks
- Verify official NHANES survey methodology and sample eligibility for lab-based estimates.
- Compare unadjusted and adjusted estimates on a matched complete-case sample.
- Test prespecified marginal contrasts rather than infer significance from overlapping CIs.
- Audit education and race/ethnicity codes, missing data, potential nonlinear age effects, and age interactions.
- Prepare a publication-quality figure with actual error bars, source details and a concise caption.

**Reproduce:** `Rscript scripts/06_adjusted_prevalence.R` from the project root.  
**Outputs:** `reports/06_adjusted_prevalence.csv`, `reports/06_adjusted_prevalence.png`.
