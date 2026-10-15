# Population Health Intelligence | Model validation

**Status:** Exploratory sensitivity review, October 14, 2026.

## Analytic sample
- Adults in source file: 5,569.
- Complete cases for the adjusted model: 4,362 (78.3%).
- Excluded: 1,207 (21.7%).
- Mean age, included: 51.51 years; excluded: 51.49 years (unweighted descriptive comparison).
- Among excluded records, 551 were missing the HbA1c outcome and 656 had recorded HbA1c but were excluded for other missing fields. Categories overlap, so do not sum per-variable missing counts.

## Complete-case outcome counts
- HbA1c below 6.5%: 3,714.
- HbA1c at least 6.5%: 648.

## Age model specification
| Contrast | Linear age OR (95% CI) | Quadratic age OR (95% CI) |
|---|---|---|
| PIR >4 vs <=1 | 0.847 (0.526-1.364) | 0.811 (0.504-1.303) |
| College+ vs <9th education | 0.545 (0.293-1.012) | 0.554 (0.300-1.024) |
| Female vs male | 0.723 (0.543-0.963) | 0.732 (0.552-0.971) |

Income and education contrasts are similar under the two age specifications. This alone is not a complete model validation. The age coefficient in a quadratic model is not a constant per-year odds ratio and must not be interpreted in isolation.

## Remaining checks
1. Compare included/excluded people by income, education, sex, race/ethnicity and observed outcomes with attention to survey design.
2. Confirm exact NHANES demographic and laboratory coding and survey weight recommendations.
3. Test the quadratic age term jointly and check functional form using model-predicted curves.
4. Examine adjusted marginal prevalence estimates; use these for an accessible portfolio figure.
5. Review complete-case sensitivity and effective sample size / design-based uncertainty.
6. Clearly distinguish association from causality.

Reproduce with `Rscript scripts/05_model_validation.R` from project root.
Results table: `reports/05_model_sensitivity.csv`.
