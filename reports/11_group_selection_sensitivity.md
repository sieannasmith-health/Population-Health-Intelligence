# Population Health Intelligence | Group-level selection sensitivity

**Dataset:** NHANES 2017-2018, adults 20+.  
**Status:** Descriptive group-specific sensitivity completed. This is not a nonresponse-bias correction or proof of missing at random.

## Method
Compare survey-weighted HbA1c >=6.5% prevalence within each income or education category for (a) participants with the grouping variable and HbA1c measured, and (b) complete cases for the full regression model. Use the same MEC weights, masked strata and PSUs in both analyses. Samples overlap; changes are not independent and are not formally tested here.

## Education
| Group | Outcome-observed % | Complete-case % | Change, pp |
|---|---:|---:|---:|
| <9th | 20.28 | 21.39 | +1.11 |
| 9-11th | 11.99 | 11.83 | -0.16 |
| HS/GED | 11.12 | 11.65 | +0.53 |
| Some college | 9.23 | 9.22 | -0.01 |
| College+ | 8.72 | 8.21 | -0.51 |

## Income-to-poverty ratio
| Group | Outcome-observed % | Complete-case % | Change, pp |
|---|---:|---:|---:|
| <=1 | 10.65 | 10.65 | 0.00 |
| 1-2 | 11.86 | 11.76 | -0.10 |
| 2-4 | 10.32 | 10.32 | 0.00 |
| >4 | 9.02 | 9.02 | 0.00 |

Because income is required in both the income-specific and full-model analyses, income-category eligible samples differ by at most a few records. Education-group analysis has more exclusions due to missing income, so group-level shifts can be larger. Report absolute group sample sizes from the accompanying CSV. These descriptive estimates use complete respondents with the indicated observed data; adjustment for differential item nonresponse has not yet been conducted.

## Survey guidance references
- NHANES GHB_J codebook: https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/GHB_J.htm
- 2026 quality guidelines: https://wwwn.cdc.gov/nchs/nhanes/QualityAnalysesGuidelines.aspx

## Pending research decisions
- Verify all demographic codes and use of examination weights/domain analysis.
- Decide primary adjustment set and inference degrees of freedom using scientific objectives, not p-value selection.
- Add missingness sensitivity or explicitly justify the limitations of complete-case analysis.
- Consolidate final, labeled estimates and figures after methodological review.
