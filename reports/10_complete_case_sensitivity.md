# Population Health Intelligence | Complete-case sensitivity

**Status:** Completed descriptive sample sensitivity, not a complete nonresponse-bias assessment.

## Methods
Compare survey-weighted prevalence of HbA1c >=6.5% among (1) adults with observed HbA1c and positive examination weights and (2) adults with observed HbA1c plus complete income, education, age, sex, race/ethnicity and survey design variables. Use the same 2017-2018 NHANES MEC weights, strata and PSUs. The reported confidence intervals are survey-package intervals for each prevalence estimate, not for their paired difference.

## Results
| Sample | N | Weighted prevalence | 95% CI |
|---|---:|---:|---|
| HbA1c observed | 5,018 | 10.23% | 9.17-11.29% |
| Full model complete case | 4,362 | 10.16% | 8.97-11.36% |

Difference (complete minus broader sample): **-0.07 percentage points**.

## Interpretation
The overall HbA1c >=6.5% prevalence changed little between these samples. This is not evidence that income/education associations are unbiased under complete-case selection. No paired design-based test of the 0.07-point difference was performed, and the two samples overlap.

## Remaining work
- Check income- and education-specific estimates using comparable measured-outcome subsets.
- Consider sensitivity to missing income (14.2% among adult records) and potential differential selection.
- Validate official NHANES domain and design guidance before final inference.
- Resolve inferential strategy, prepare final visuals, and complete reproducibility review.

**Reproduce:** `Rscript scripts/10_complete_case_sensitivity.R` from project root.
**Table:** `reports/10_complete_case_sensitivity.csv`.
