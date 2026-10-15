# Data Dictionary and Cohort Flow

**Data source:** CDC NHANES 2017-2018 public-use DEMO_J demographics and GHB_J glycohemoglobin files; join by unique `SEQN`.

## Variables
| Field | Source | Meaning and implementation |
|---|---|---|
| SEQN | DEMO_J / GHB_J | Respondent sequence number; one-to-one merge key |
| RIDAGEYR | DEMO_J | Age at screening, years; domain adults >=20 |
| RIAGENDR | DEMO_J | Participant sex code: 1 male, 2 female |
| RIDRETH3 | DEMO_J | Race/Hispanic-origin categories: 1 Mexican American, 2 other Hispanic, 3 non-Hispanic White, 4 non-Hispanic Black, 6 non-Hispanic Asian, 7 other/multiracial |
| DMDEDUC2 | DEMO_J | Adult education: 1 <9th grade, 2 grades 9–11, 3 high school/GED, 4 some college/AA, 5 college+; 7 refused, 9 don't know (excluded) |
| INDFMPIR | DEMO_J | Ratio of family income to federal poverty guideline; analysis groups <=1, >1 to <=2, >2 to <=4, >4 |
| LBXGH | GHB_J | Measured HbA1c percentage; project outcome is LBXGH >=6.5% |
| WTMEC2YR | DEMO_J | Two-year examination sample weight |
| SDMVSTRA | DEMO_J | Masked variance stratum |
| SDMVPSU | DEMO_J | Masked variance PSU identifier; nested in stratum |

## Cohort derivation
| Stage | Unweighted records | Rule |
|---|---:|---|
| Full all-age demographic source | 9,254 | Joined GHB_J by SEQN with left join |
| Adult population | 5,569 | RIDAGEYR >=20 |
| Adult outcome-observed population | 5,018 | LBXGH observed |
| Regression complete-case population | 4,362 | Nonmissing HbA1c, income, valid education, age, sex, race/ethnicity, design fields and positive MEC weight |

The 551 adults without HbA1c are excluded from outcome-based analysis. Of all 5,569 adults, 791 are missing income-to-poverty ratio and 13 have education refusal/don't-know responses; exclusions overlap. The 4,362 complete-case participants include 648 with diabetes-range HbA1c. Retain all-age respondents when defining the survey object; use domain subsetting in `survey`.

## Data handling
Original source XPT files and derived respondent-level CSVs stay local under ignored `data/raw` and `data/processed`. Aggregated statistics, code and reports are candidates for public release after repository review. Personal-identifying participant records are not present in public-facing analytical reports.

**Verification:** `scripts/01_download_and_audit.py`, `scripts/13_build_full_survey.py`, `scripts/13_adult_domain_validation.R`, `scripts/14_model_replication.R`.
