# Nonresponse scenario stress test | October 15, 2026

This *exploratory stress test* reassigns all 645 otherwise model-eligible adult respondents with missing income-to-poverty ratio (PIR) to one extreme income category, then refits survey-weighted quasibinomial models on 5,007 adults. The original observed-income complete-case cohort has 4,362 adults. All-age NHANES survey design was preserved.

| Scenario | Adjustment | High vs low PIR standardized difference |
|---|---|---:|
| Observed income only | Age + sex + education | -2.70 percentage points |
| Missing income assigned PIR <=1 | Age + sex + education | -2.03 pp |
| Missing income assigned PIR >4 | Age + sex + education | -2.71 pp |
| Observed income only | Extended + race/ethnicity | -1.42 pp |
| Missing income assigned PIR <=1 | Extended + race/ethnicity | -0.85 pp |
| Missing income assigned PIR >4 | Extended + race/ethnicity | -1.70 pp |

The direction of the illustrative highest-versus-lowest income comparison remains negative under these two *extreme-category assignment assumptions*, but its magnitude varies. This is **not** multiple imputation, a formally identified MNAR model, an exhaustive bias bound, or proof of robustness to all nonresponse mechanisms. Inferences continue to be limited by omitted variables, categorical assumptions, small residual degrees of freedom, and cross-sectional data.

**Status:** Required portfolio methodological sensitivity work completed with explicit residual limitations. Independent peer review is not claimed.

Reproduce: `Rscript scripts/20_income_scenario_stress_test.R`. Generated table: `reports/20_income_scenario_stress_test.csv`.
