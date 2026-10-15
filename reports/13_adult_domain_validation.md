# Population Health Intelligence | Full survey-domain reconstruction

**Status:** Descriptive comparison passed. Regression model refitting using the reconstructed all-age design remains to be confirmed.

## Source and method
- Load locally retained original NHANES 2017-2018 DEMO_J.XPT and GHB_J.XPT.
- Left-join all demographic respondents to glycohemoglobin measurements by SEQN, validating unique participant IDs.
- The merged file contains 9,254 all-age records, of which 5,569 are adults aged 20+ and 5,018 adults have measured HbA1c.
- Define survey strata (SDMVSTRA), masked PSUs (SDMVPSU), examination weights (WTMEC2YR) before subsetting with `subset(design, RIDAGEYR >= 20)`.
- Compare resulting unadjusted survey-weighted HbA1c >=6.5% estimates and design-based standard errors with the prior adult-only design.

## Result
All 10 tested estimates (overall + 4 income groups + 5 education groups) and their standard errors matched exactly at the reported machine precision. Maximum absolute estimate difference: 0 percentage points. Maximum standard-error difference: 0 percentage points. This is expected given that all strata and PSUs remain represented in the adult domain, but the direct check establishes agreement for the specific descriptive analyses.

## Boundaries
- Adjusted regression, joint tests and standardized marginal contrasts have **not** yet been rerun using the all-age design.
- Matching estimates do not resolve missing income information or complete-case selection sensitivity.
- The adult domain is the estimand; HbA1c eligibility begins at age 12 in the lab source, but this project focuses on adults 20+.

## Reproduction
Run from the project root:

```
.venv/bin/python scripts/13_build_full_survey.py
Rscript scripts/13_adult_domain_validation.R
```

CSV results: `reports/13_adult_domain_comparison.csv`.

CDC documentation: https://wwwn.cdc.gov/nchs/nhanes/tutorials/varianceestimation.aspx
