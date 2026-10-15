# Methodology and publication review | Population Health Intelligence

## Primary analysis decision
Treat the age/sex-adjusted and additionally race/ethnicity-adjusted models as **co-primary descriptive specifications for transparency**, not a hierarchy determined by p-values. A single primary causal/confounding model is not justified by the current cross-sectional design and available covariates. Communicate their differences as specification sensitivity, not evidence that one analysis is correct and the other is wrong.

## Inferential decisions
- Report survey-weighted estimates, design-based standard errors and exact adjustment sets.
- Retain the reported nominal-design-DF (15) t-based intervals as **approximate working intervals**, distinctly noting that regression omnibus tests using residual denominator DF (6 or 1) have limited stability.
- Present adjusted prevalence differences and CIs descriptively. Do not claim definitive or causal evidence for socioeconomic group effects.
- Discuss why pairwise comparisons and omnibus tests answer different hypotheses.
- No post-hoc variable selection based on statistical significance.

## Measurement and selection
- A lab HbA1c >=6.5% is a diabetes-range measurement, not verified diabetes diagnosis.
- Family income-to-poverty ratio missingness (791/5,569 adults) remains a meaningful potential bias source.
- All nine subgroup results were screened using a project approximation of the NCHS proportion reliability concepts; the project **has not implemented Korn-Graubard confidence intervals**, so these checks are not formal NCHS publication clearance.
- Effective sample size must be capped at observed subgroup N, per CDC guidance. This cap is now implemented in script 15.

## Reporting corrections required
1. Label the two models as parallel descriptive specifications rather than a definitive primary and secondary model.
2. Do not describe calculated 95% intervals as NCHS Korn-Graubard CIs.
3. Preserve sensitivity to missingness and adjustment as limitations.
4. Confirm report tables with generated CSVs prior to any external publication.

## Sources
- CDC NHANES reliability guidance: https://wwwn.cdc.gov/nchs/nhanes/tutorials/ReliabilityOfEstimates.aspx
- R survey `regTermTest`: https://r-survey.r-forge.r-project.org/pkgdown/docs/reference/regTermTest.html
