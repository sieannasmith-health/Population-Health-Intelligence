# Population Health Intelligence | Adjusted socioeconomic contrasts

**Status:** Exploratory marginal comparisons, not publication-ready inferential conclusions.

## Methods
Using the same complete-case NHANES 2017-2018 survey-weighted logistic model as script 06, predict the outcome for every analytic respondent under two hypothetical socioeconomic categories while holding their other modeled characteristics fixed. Average with survey weights. Subtract the two standardized prevalences; obtain SE by the delta method using the complete model coefficient covariance matrix. Approximate 95% intervals use t critical values with 15 design degrees of freedom.

## Selected adjusted prevalence differences

| Comparison minus reference | Difference, percentage points | Approx. 95% CI | Exploratory p-value |
|---|---:|---|---:|
| PIR >4 minus PIR <=1 | -1.42 | -5.48 to 2.64 | 0.468 |
| College+ minus <9th education | -5.54 | -11.96 to 0.88 | 0.086 |

The intervals cross zero. With this model and these methods, neither specific standardized contrast establishes a difference at the conventional 0.05 threshold. These are associations, not causal effects.

## Major inference limitation discovered
The model has **15 design degrees of freedom** but approximately 15 fitted coefficients, leaving just **1 residual denominator degree of freedom** for the multi-parameter overall socioeconomic Wald tests from `regTermTest`. The reported joint-test p-values (income 0.854, education 0.596) are therefore highly sensitive to the degrees-of-freedom convention and **must not be presented as reliable final evidence of no association**.

## Next required work
- Verify the CDC documentation and choice of survey denominator degrees of freedom for each inference.
- Evaluate a parsimonious prespecified adjustment set, without opportunistic significance selection, to preserve residual degrees of freedom; compare robustness across specifications.
- Inspect complete-case selection, NHANES codebook classifications, and outcome-specific survey design considerations.
- For publication, report clearly labeled estimated differences with compatible design-based uncertainty and the inferential limitations.

**Reproduce:** `Rscript scripts/07_socioeconomic_contrasts.R` from project root.
**Machine-readable result:** `reports/07_adjusted_contrasts.csv`.
