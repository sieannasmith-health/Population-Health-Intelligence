# Socioeconomic Characteristics and Diabetes-Range HbA1c Among U.S. Adults

**Population Health Intelligence | Exploratory epidemiologic analysis**  
**Data:** NHANES 2017-2018  
**Report status:** Working research draft, not yet approved for public release. Age/sex and race/ethnicity-extended adjustment models are presented as parallel descriptive sensitivity specifications; neither is a causal model.

## Executive summary
This analysis examines whether family income-to-poverty ratio and educational attainment are associated with diabetes-range HbA1c (at least 6.5%) among adults aged 20 years and older. Using 2017-2018 National Health and Nutrition Examination Survey (NHANES) public-use demographic and glycohemoglobin data, we estimated survey-weighted prevalence by socioeconomic category, fitted adjusted logistic regressions, and standardized model predictions to a common analytic population. Higher educational attainment corresponded to lower unadjusted HbA1c prevalence, but the magnitude and statistical uncertainty of the association varied after demographic adjustment. Income patterns were comparatively modest. As a cross-sectional observational analysis, the findings do not identify causal effects.

## 1. Research question
**How are income and educational attainment associated with the prevalence of HbA1c at or above 6.5% among U.S. adults?**

HbA1c is a biomarker reflecting average blood glucose over preceding months. A measured HbA1c at or above 6.5% is a diabetes-range laboratory result; it is not equivalent to a verified clinical diabetes diagnosis.

## 2. Design, participants, and data sources
This cross-sectional analysis uses the 2017-2018 NHANES cycle. The original DEMO_J demographic and GHB_J glycohemoglobin transport files were merged by unique participant identifier (SEQN). The reconstructed full source included **9,254 respondents of all ages**; **5,569 were aged 20 years or older**; **5,018 adults had observed HbA1c**. The multivariable complete-case analytic cohort contained **4,362 adults**, including **648 with HbA1c at or above 6.5%**.

NHANES uses a complex, multistage probability sampling design. We defined an all-age survey object with examination weights (WTMEC2YR), masked strata (SDMVSTRA), and masked primary sampling units (SDMVPSU), then used domain restrictions for adults and eligible analytical observations. The 2017-2018 data represented 15 masked strata and 30 masked PSU combinations; 15 nominal design degrees of freedom remained in the modeled domain.

Data documentation:
- DEMO_J: https://wwwn.cdc.gov/nchs/data/nhanes/public/2017/datafiles/DEMO_J.htm
- GHB_J: https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/GHB_J.htm
- CDC analytic guidance: https://wwwn.cdc.gov/nchs/nhanes/analyticguidelines.aspx

## 3. Measures
- **Outcome:** binary indicator for measured HbA1c >=6.5% (LBXGH).
- **Income:** family income-to-poverty ratio (INDFMPIR), grouped as <=1, >1 to <=2, >2 to <=4, and >4. These bins are analytical categories, not official NHANES income labels.
- **Education:** adult educational attainment (DMDEDUC2), categorized as less than ninth grade, ninth to eleventh grade, high school/GED, some college/associate degree, or college graduate and above. Nonresponse codes 7 and 9 were excluded from usable categories.
- **Demographic covariates:** age (RIDAGEYR), NHANES participant sex variable (RIAGENDR), and, in an extended adjustment model, race/ethnicity (RIDRETH3).

## 4. Statistical methods
We calculated descriptive survey-weighted HbA1c prevalence for socioeconomic groups and estimated design-based uncertainty. Survey-weighted quasibinomial logistic regression then modeled HbA1c >=6.5% as a function of income, education, and demographics. Two models use the same complete-case population:
1. **Age-and-sex-adjusted model**, including both socioeconomic variables, as a parsimonious descriptive specification.
2. **Extended demographic model**, additionally adjusting for race/ethnicity, to examine sensitivity to the adjustment strategy.

For each income and education level, we assigned that level to every analytic respondent, retained their other model covariates, predicted probabilities, and averaged with survey weights (marginal standardization). Delta-method standard errors used the survey-weighted model covariance matrix, with approximate 95% t-intervals using 15 nominal design degrees of freedom for estimates and contrasts. Joint socioeconomic term tests were run using residual denominator degrees of freedom; the age-and-sex model had six such degrees of freedom, while the extended model had one. These inferential conventions remain subject to final methodological review.

## 5. Results

### 5.1 Descriptive weighted prevalence
| Income-to-poverty ratio | Weighted HbA1c >=6.5% prevalence | Approx. 95% CI |
|---|---:|---|
| <=1 | 10.65% | 8.43%–12.87% |
| >1 to <=2 | 11.86% | 9.90%–13.82% |
| >2 to <=4 | 10.32% | 7.41%–13.22% |
| >4 | 9.02% | 6.65%–11.40% |

| Education | Weighted HbA1c >=6.5% prevalence | Approx. 95% CI |
|---|---:|---|
| Less than ninth grade | 20.28% | 16.25%–24.31% |
| Ninth to eleventh grade | 11.99% | 8.36%–15.63% |
| High school/GED | 11.12% | 8.60%–13.63% |
| Some college/associate degree | 9.23% | 7.91%–10.55% |
| College graduate and above | 8.72% | 6.47%–10.97% |

The unadjusted education pattern was pronounced, while income prevalence varied less systematically.

### 5.2 Adjusted standardized differences
| Comparison minus reference | Age-and-sex adjusted difference (95% CI) | Extended adjustment difference (95% CI) |
|---|---|---|
| PIR >4 versus <=1 | -2.70 percentage points (-7.10 to 1.70) | -1.42 percentage points (-5.48 to 2.64) |
| College graduate+ versus less than ninth grade | -8.02 percentage points (-14.46 to -1.58) | -5.54 percentage points (-11.96 to 0.88) |

The education difference was less pronounced with race/ethnicity included. The interval for this selected contrast excluded zero in the age-and-sex model but included zero in the extended model. This sensitivity matters for scientific interpretation; it does **not** justify preferentially selecting whichever model gives a more favorable p-value. Contrasts and omnibus multi-category tests assess different null hypotheses.

For the age-and-sex-adjusted model, the residual-DF omnibus income test returned p=0.610 and education test p=0.133. For the extended model, income p=0.854 and education p=0.596; these latter tests have only one residual denominator degree of freedom and are particularly fragile. They should not be treated as definitive evidence that no socioeconomic relationship exists.

### 5.3 Missingness and sample sensitivity
Of 5,569 adults, **551 (9.89%)** lacked HbA1c, **791 (14.20%)** lacked income-to-poverty ratio, and **13 (0.23%)** lacked a usable education category. These counts overlap. The full model excluded **1,207 (21.67%)** adults for missing required values.

Overall survey-weighted HbA1c >=6.5% prevalence was **10.23%** among 5,018 adults with observed HbA1c versus **10.16%** among 4,362 complete cases, a descriptive difference of **-0.07 percentage points**. Among education categories, complete-case selection shifted descriptive prevalence estimates by as much as approximately **1.11 percentage points**. Small changes in aggregate outcome prevalence do not rule out bias in socioeconomic associations.

In a supplementary income-missingness analysis retaining adults with observed HbA1c and complete other model variables regardless of income reporting (n=5,007), 4,362 reported an income-to-poverty ratio and 645 did not. Survey-weighted HbA1c >=6.5% prevalence was **10.16% (95% CI 8.97%-11.36%)** when income was observed and **10.70% (95% CI 7.64%-13.77%)** when it was missing. A model adjusted for age, sex, education and race/ethnicity gave an odds ratio of **0.93 (95% CI 0.64-1.36)** for missing versus observed income. This assesses observed-outcome differences by missingness status, not whether missing income values are ignorable or whether the income association is unbiased.

### 5.4 Robustness and replication
A quadratic-age sensitivity model produced broadly similar selected income and education coefficients to the linear-age extended model. Nine complete-case income and education subgroups passed the project's descriptive reliability screen, but model-based subgroup precision still requires separate judgment. Rebuilding the survey design from all-age source files reproduced the descriptive estimates, all 15 extended-model coefficients and standard errors, and all nine extended-model marginal prevalence estimates and standard errors exactly.

![Two-model adjusted prevalence comparison](16_model_comparison.png)

*Figure 1. Survey-weighted marginal prevalence of HbA1c >=6.5% among NHANES 2017-2018 adults aged 20 or older (complete-case n=4,362). Green circles adjust for age, sex and the other socioeconomic variable; gray triangles additionally adjust for race/ethnicity. Error bars are approximate 95% confidence intervals using model covariance and 15 nominal survey-design degrees of freedom. The plotted intervals concern category prevalence estimates, not pairwise contrasts; findings are descriptive, not causal.*

## 6. Interpretation
The descriptive education gradient indicates a greater prevalence of diabetes-range HbA1c among adults reporting the lowest educational attainment. However, demographic adjustment meaningfully changes the estimated education contrast, and confidence intervals in the more extensively adjusted model span zero. The income relationship is comparatively modest and imprecise in these specifications. Age composition, correlated socioeconomic variables, social and structural determinants, and item nonresponse should be considered when interpreting these patterns.

This analysis establishes no causal link between income or education and HbA1c. Race/ethnicity is treated as a sociodemographic analytic variable and should not be interpreted as a biological mechanism. Adjustment choices need an explicit conceptual rationale grounded in the research question.

## 7. Limitations
- NHANES is cross-sectional. Temporality and causal direction are unresolved.
- A single HbA1c >=6.5% measure is not an independently verified clinical diagnosis.
- The complete-case analysis excludes 21.67% of adult records; income missingness could lead to selection bias.
- Socioeconomic categories and the binary laboratory threshold can hide within-category heterogeneity.
- The two models estimate different conditionally adjusted associations and are presented in parallel. The available data do not establish a unique causal/confounding adjustment model.
- The extended model has just one residual design degree of freedom for certain omnibus tests, making those tests unstable.
- We have not conducted a full nonresponse-weighting, imputation, measurement-error or interaction sensitivity study.
- Model coefficients and standardization do not establish effects of interventions.

## 8. Conclusions
In exploratory survey-weighted analysis of NHANES 2017-2018 adults, diabetes-range HbA1c prevalence varied more visibly across educational attainment categories than across income-to-poverty categories. Adjusted education differences depended substantially on demographic covariate specification. Accordingly, these results support further investigation of socioeconomic health patterns, but not definitive or causal claims about disparities based on this analysis alone.

## 9. Reproducibility and outstanding publication gates
All scripts, processed data, CSV outputs and figures are organized within `Population-Health-Intelligence/`. The key rebuild and comparison steps are:

```sh
.venv/bin/python scripts/13_build_full_survey.py
Rscript scripts/13_adult_domain_validation.R
Rscript scripts/14_model_replication.R
Rscript scripts/15_reliability_and_model_decision.R
Rscript scripts/16_model_comparison_figures.R
Rscript scripts/19_income_missingness_sensitivity.R
python3 scripts/18_report_consistency_audit.py
```

**Before publishing:** retain transparent parallel model specifications; confirm presentation and joint-testing conventions; assess residual missingness risks; review figure accessibility and source captions; run a clean-environment reproducibility audit; then prepare a public-safe repository and portfolio summary.

**Primary source:** National Center for Health Statistics, Centers for Disease Control and Prevention, NHANES 2017-2018 demographic and glycohemoglobin public-use files.
