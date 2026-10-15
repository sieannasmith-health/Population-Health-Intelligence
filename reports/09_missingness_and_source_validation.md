# Population Health Intelligence | Missingness and source validation

**Study:** NHANES 2017-2018, adults age 20+.  
**Status:** Descriptive missingness audit completed; missingness sensitivity assessment still pending.

## Cohort audit
- Adult records: 5,569.
- Complete model records: 4,362 (78.33%).
- Excluded records: 1,207 (21.67%).
- HbA1c missing: 551 (9.89%).
- Income-to-poverty ratio missing: 791 (14.20%).
- Adult education lacking a valid 1-5 category: 13 (0.23%).
- Variable-specific missingness overlaps and must not be summed.

Mean age is 51.51 years among included adults and 51.49 among excluded adults (unweighted).

## Socioeconomic inclusion breakdown
| Income PIR | Excluded | Included |
|---|---:|---:|
| <=1 | 78 | 828 |
| 1-2 | 107 | 1,234 |
| 2-4 | 127 | 1,178 |
| >4 | 104 | 1,122 |
| Missing | 791 | 0 |

| Education | Excluded | Included |
|---|---:|---:|
| <9th | 152 | 327 |
| 9-11th | 152 | 486 |
| HS/GED | 272 | 1,053 |
| Some college | 333 | 1,445 |
| College+ | 285 | 1,051 |
| Missing/other | 13 | 0 |

Weighted inclusion is about 85.84% for each sex as coded in the NHANES file. Equal-looking inclusion across sex does not establish missing-at-random conditions.

## CDC documentation check
Official NHANES 2017-2018 files confirm:
- DEMO_J defines WTMEC2YR, SDMVSTRA, SDMVPSU, DMDEDUC2, INDFMPIR and RIDRETH3.
- GHB_J defines LBXGH, glycohemoglobin percentage, with participants eligible for the laboratory file starting at age 12.
- NHANES uses 15 masked variance strata and 30 masked PSUs for the 2017-2018 period.
- GHB_J guidance asks analysts to evaluate missing lab and predictor values before deciding whether item nonresponse adjustment is necessary.

Documentation:
- https://wwwn.cdc.gov/nchs/data/nhanes/public/2017/datafiles/DEMO_J.htm
- https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/GHB_J.htm

## Required before final publication
1. Check item nonresponse patterns using available demographics and examined status.
2. Compare complete-case and outcome-observed-only estimands on a common target population.
3. Evaluate weighting sensitivity and assess whether additional item nonresponse adjustment is warranted.
4. Check NHANES age eligibility, use of adult domain analysis, and all categorical codes with official documentation.
5. Resolve final model and joint-test degrees-of-freedom choices before a definitive hypothesis statement.

Reproduce: `Rscript scripts/09_missingness_audit.R` from project root.
