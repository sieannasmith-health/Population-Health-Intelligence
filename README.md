# Population Health Intelligence

**NHANES 2021–2023 analysis of socioeconomic characteristics and diabetes-range HbA1c among U.S. adults**

This portfolio project uses public CDC/NCHS NHANES August 2021–August 2023 demographic and glycohemoglobin data to examine whether income-to-poverty ratio and educational attainment are associated with measured HbA1c >=6.5%.

## Current release

- **Cycle:** NHANES 2021–2023
- **Source files:** DEMO_L and GHB_L
- **Population:** U.S. adults age 20+
- **Weighting:** NHANES phlebotomy weight `WTPH2YR` with `SDMVSTRA` and `SDMVPSU`
- **Methods:** survey-weighted prevalence, survey-weighted logistic regression, standardized prevalence contrasts, missingness and cohort audit
- **Software:** R (`survey` package)

## Study at a glance

- 11,933 respondents in the demographic source
- 7,809 adults age 20+
- 5,767 adults with HbA1c data
- 5,028 complete cases in the adjusted analysis
- Survey design degrees of freedom: 15
- Weighted HbA1c >=6.5% prevalence: **10.48% (95% CI 9.07%–11.89%)**

## Selected findings

### Education

Unadjusted HbA1c >=6.5% prevalence ranged from **22.12%** among adults with less than ninth-grade education to **5.20%** among college graduates and above.

After adjustment for age, sex, and race/ethnicity, the standardized prevalence contrast for College+ versus less than ninth grade was **-8.51 percentage points (95% CI -13.72 to -3.29)**.

### Income

Unadjusted HbA1c >=6.5% prevalence was **12.40%** among adults with income-to-poverty ratio <=1 and **7.35%** among adults with ratio >4.

After adjustment for age, sex, and race/ethnicity, the standardized >4 versus <=1 contrast was **-1.63 percentage points (95% CI -4.92 to 1.66)**, indicating a weaker and less precise adjusted income gradient than the education gradient.

## Interpretation

This is a cross-sectional observational analysis. Results describe associations and should not be interpreted as causal effects or individual clinical diagnoses. HbA1c >=6.5% is treated as a laboratory threshold rather than verified diabetes status.

## Current project files

| Location | Content |
|---|---|
| `scripts/2021_2023_refresh.R` | Current end-to-end NHANES 2021–2023 analysis |
| `reports/2021_2023_data_audit.csv` | Cohort counts and missingness audit |
| `reports/2021_2023_summary.csv` | Primary weighted prevalence and design summary |
| `reports/2021_2023_unadjusted_prevalence.csv` | Weighted prevalence by income and education |
| `reports/2021_2023_adjusted_odds_ratios.csv` | Survey-weighted logistic model results |
| `reports/2021_2023_adjusted_prevalence.csv` | Standardized prevalence estimates |
| `reports/2021_2023_adjusted_contrasts.csv` | Standardized income and education contrasts |

## Data and provenance

Source: U.S. National Center for Health Statistics, CDC, NHANES August 2021–August 2023.

- Demographics: `DEMO_L`
- Glycohemoglobin: `GHB_L`
- HbA1c: `LBXGH`
- Phlebotomy weight: `WTPH2YR`

Raw respondent-level XPT files remain excluded from GitHub through `.gitignore`.

## Legacy materials

The repository retains earlier 2017–2018 scripts and reports as historical project-development artifacts. The **2021–2023 files listed above are the current analysis and should be used for portfolio review and résumé claims**.
