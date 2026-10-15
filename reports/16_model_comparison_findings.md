# Population Health Intelligence | Adjusted model comparison

**Status:** Model comparison analysis and figure generated; primary model not yet scientifically finalized.

## Design and estimand
NHANES 2017-2018, adult analytic domain aged 20+ with complete HbA1c, income-to-poverty ratio, education and demographic predictors (n=4,362). Full all-age DEMO_J/GHB_J survey design reconstructed before domain restriction. WTMEC2YR, SDMVSTRA and SDMVPSU used in survey-weighted quasibinomial logistic regression. Marginal prevalences are standardized to the observed weighted characteristics of complete-case adult respondents. They are not causal effects.

Two adjustment specifications are compared on the same cohort: (1) age, sex, income and education; (2) those predictors plus race/ethnicity. Both income and education are included in every model. Confidence intervals are approximate t-intervals based on 15 nominal survey design degrees of freedom and delta-method uncertainty. Model-specific full output is in `16_model_comparison_prevalence.csv`.

## Contrasts (comparison minus reference)
| Contrast | Age + sex difference (95% CI), pp | Age + sex + race difference (95% CI), pp |
|---|---|---|
| PIR >4 vs <=1 | -2.70 (-7.10 to 1.70) | -1.42 (-5.48 to 2.64) |
| College+ vs <9th | -8.02 (-14.46 to -1.58) | -5.54 (-11.96 to 0.88) |

Interpretation: adjustment for race/ethnicity changes estimates appreciably. For education, the selected marginal contrast interval excludes zero in the reduced model but not the extended model. An individual contrast need not agree with an omnibus hypothesis test of all categories. Neither model is a causal estimate.

## Boundaries and publication gates
- Primary adjustment choice remains provisional. The full model has just one residual design degree of freedom in some omnibus testing conventions; its joint tests are fragile.
- Omitting race/ethnicity to increase residual degrees of freedom cannot itself justify a primary adjustment set; explain a defensible confounding and structural-determinants rationale.
- Item nonresponse, especially missing family PIR, remains a possible source of selection bias.
- The chart is ready for editorial review, but publication requires final methods, substantive interpretation, accessibility/caption checks and clean-session reproduction.

## Deliverables
- `scripts/16_model_comparison_figures.R`
- `reports/16_model_comparison_prevalence.csv`
- `reports/16_model_comparison_contrasts.csv`
- `reports/16_model_comparison.png`

Run `Rscript scripts/16_model_comparison_figures.R` from the project root.
