# Income missingness sensitivity | Population Health Intelligence

**Status:** Completed observed-pattern sensitivity analysis; remaining missing-not-at-random scenarios are unquantified.

## Cohort
From the reconstructed all-age NHANES survey design, restrict to age 20+ with measured HbA1c, usable education, age, sex, race/ethnicity, and survey fields, without requiring nonmissing income. There are 5,007 eligible respondents: 4,362 with observed income-to-poverty ratio and 645 with missing income-to-poverty ratio.

## Survey-weighted outcomes
| Income status | N | HbA1c >=6.5% prevalence | Approx. 95% CI |
|---|---:|---:|---|
| Observed | 4,362 | 10.16% | 8.97%-11.36% |
| Missing | 645 | 10.70% | 7.64%-13.77% |

The unadjusted prevalence difference is +0.54 percentage points (missing minus observed). The survey-weighted adjusted logistic regression for outcome ~ income missingness indicator + education + age + sex + race/ethnicity yielded an adjusted odds ratio of 0.935 (95% CI 0.640-1.364), based on a nominal-design-DF t-interval.

## Interpretation
Observed HbA1c outcomes do not differ substantially between these two groups under this comparison, but missing-at-random cannot be established from measured outcomes. Because true income values are unavailable for missing-income respondents, this analysis cannot directly recover the income-prevalence gradient, test selection mechanisms conditional on unobserved income, or eliminate missing-not-at-random concerns. The complete-case socioeconomic models remain observational and potentially selection-biased.

## Reproduction
`Rscript scripts/19_income_missingness_sensitivity.R`

Outputs: `reports/19_income_missingness_prevalence.csv`, `reports/19_income_missingness_adjusted.csv`.
