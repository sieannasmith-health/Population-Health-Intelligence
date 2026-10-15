# Population Health Intelligence | Adjusted socioeconomic model

**Data:** NHANES 2017-2018, adults aged 20+  
**Status:** Exploratory adjusted association model. Not final causal or nationally validated estimates.

## Research question
Are income-to-poverty ratio and adult education associated with HbA1c >=6.5% after adjusting for age, sex, and race/ethnicity?

## Method
- Survey-weighted quasibinomial logistic regression (`survey::svyglm`), using `WTMEC2YR`, `SDMVSTRA`, and `SDMVPSU`.
- Complete case analysis of 4,362 adults: 648 with diabetes-range HbA1c and 3,714 below the threshold.
- Excluded adults with missing outcome, income, education, or covariates. Potential complete-case selection bias has not been quantified.
- Income reference category: PIR <=1. Education reference: <9th grade. Sex reference: male. Age treated continuously.
- Race/ethnicity included as coded NHANES category indicators; labels and substantive interpretation require codebook validation.
- Model uses 15 survey-design degrees of freedom. Results report survey-design based standard errors and exploratory 95% t-intervals with those 15 degrees of freedom, plus t-based p-values. Confirm inferential convention as part of sensitivity analysis.

## Selected model results

| Contrast | Adjusted odds ratio | 95% CI |
|---|---:|---|
| PIR >4 vs <=1 | 0.847 | 0.526-1.364 |
| College graduate+ vs <9th | 0.545 | 0.293-1.012 |
| Age, per year | 1.054 | 1.045-1.064 |
| Female vs male | 0.723 | 0.543-0.963 |

## Interpretation
The unadjusted education gradient attenuates or loses precision after demographic adjustment. The college-graduate contrast points toward lower odds but its 95% interval includes 1. Income category contrasts are imprecise and their 95% intervals include 1. Age shows a strong adjusted association with diabetes-range HbA1c.

Odds ratios are not prevalence ratios. Cross-sectional associations do not demonstrate causality. This outcome is a lab threshold, not a clinical diagnosis. Model coefficients cannot be used to infer individual risk without further validation.

## Required validation before publication
1. Confirm NHANES survey methodology, subpopulation restriction and weight selection.
2. Audit race/ethnicity coding and education categories in the official codebooks.
3. Compare excluded vs. included participants and examine age distribution by SES.
4. Assess model specification (nonlinearity of age, category cell size, confounding, interactions, residual degrees of freedom).
5. Consider adjusted marginal prevalence estimates and contrasts, which may be easier to communicate than odds ratios.
6. Document reproducible data provenance and sensitivity analyses.

**Run from project root:** `Rscript scripts/04_adjusted_model.R`  
**Model results:** `reports/04_adjusted_model_odds_ratios.csv`
