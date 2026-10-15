# Population Health Intelligence | Socioeconomic patterns

**Study:** NHANES 2017-2018, adults age 20+  
**Outcome:** HbA1c >=6.5% (laboratory threshold, not a confirmed diagnosis)  
**Status:** Exploratory unadjusted analysis; not final model results.

## Analytic sample
- 5,569 adult records.
- Missing HbA1c: 551.
- Missing income-to-poverty ratio (INDFMPIR): 791.
- Missing or nonresponse-coded adult education: 13.
- Complete HbA1c + income records: 4,365.
- Complete HbA1c + education records: 5,007.
- The analysis uses NHANES MEC examination weights (WTMEC2YR), SDMVSTRA, and SDMVPSU.

## Preliminary survey-weighted estimates

| Dimension | Group | Estimated % | 95% CI |
|---|---|---:|---|
| Income-to-poverty ratio | <=1 | 10.65 | 8.43-12.87 |
| Income-to-poverty ratio | 1-2 | 11.86 | 9.90-13.82 |
| Income-to-poverty ratio | 2-4 | 10.32 | 7.41-13.22 |
| Income-to-poverty ratio | >4 | 9.02 | 6.65-11.40 |
| Education | Less than 9th grade | 20.28 | 16.25-24.31 |
| Education | 9th-11th grade | 11.99 | 8.36-15.63 |
| Education | High school/GED | 11.12 | 8.60-13.63 |
| Education | Some college/AA | 9.23 | 7.91-10.55 |
| Education | College graduate+ | 8.72 | 6.47-10.97 |

## Interpretation and next decisions
The unadjusted education pattern is stronger than the income gradient. These descriptive comparisons may be influenced by the age distribution, other confounding variables, and missing data. Confidence intervals are measures of precision, not automatic proof of group differences.

Next: inspect group-specific observation counts, evaluate missingness and age composition, then prespecify an adjusted survey-weighted regression model. Consider whether the MEC-weighted complete-case estimand is appropriate and document possible nonresponse bias before the final report.

## Reproducibility
Run `Rscript scripts/03_socioeconomic_analysis.R` from the project root.
Outputs: `reports/03_socioeconomic_prevalence.csv` and `reports/03_socioeconomic_prevalence.png`.

Original source documentation:
- https://wwwn.cdc.gov/nchs/data/nhanes/public/2017/datafiles/DEMO_J.htm
- https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/GHB_J.htm
- https://wwwn.cdc.gov/nchs/nhanes/analyticguidelines.aspx
