# Population Health Intelligence | Survey inference sensitivity

**Status:** Sensitivity analysis completed; inferential strategy needs final scientific review.

## Purpose
Assess the effect of residual denominator degrees of freedom on joint socioeconomic Wald tests. NHANES 2017-2018 has 15 nominal design degrees of freedom in this analytic sample.

## Model comparison
| Specification | Model coefficients | Residual design DF |
|---|---:|---:|
| Income, education, age, sex | 10 | 6 |
| Income, education, age, sex, race/ethnicity | 15 | 1 |

Both models use the same complete-case sample and NHANES examination weights, strata, and PSUs. The reduced model omits race/ethnicity solely as a sensitivity analysis, not because race/ethnicity is assumed unnecessary for confounding control.

## Joint test p-values
| Model | Term | Residual-DF p | Nominal design-DF p |
|---|---|---:|---:|
| Reduced | Income | 0.610 | 0.594 |
| Reduced | Education | 0.133 | 0.071 |
| Full | Income | 0.854 | 0.851 |
| Full | Education | 0.596 | 0.370 |

The full-model joint education test is sensitive to the denominator-DF convention. Do not use either version to claim proof of no association. For the reduced model, more residual design degrees of freedom are available, but estimates address a different adjustment set. Models are observational and exploratory.

## Methodological references
- CDC NHANES variance estimation tutorial: https://wwwn.cdc.gov/nchs/nhanes/tutorials/varianceestimation.aspx
- R survey package regTermTest: https://search.r-project.org/CRAN/refmans/survey/help/regTermTest.html
- CDC analytic guidelines: https://wwwn.cdc.gov/nchs/nhanes/analyticguidelines.aspx

## Next research decisions
1. Choose and justify a primary adjustment set using scientific considerations, not which model yields significance.
2. Validate survey weighting and demographic / laboratory eligibility from CDC source documentation.
3. Audit complete-case selection and missingness patterns across the primary socioeconomic groups.
4. Recompute final marginal prevalence and contrasts under the selected primary model, with sensitivity analyses transparently reported.

**Reproduce:** `Rscript scripts/08_inference_sensitivity.R` from project root.
