# Population Health Intelligence | Reliability and model strategy

**Status:** Subgroup descriptive reliability screening completed. Primary inferential model remains provisional, pending substantive confounding review.

## Data and reliability
Reconstructed full NHANES 2017-2018 design, subset to adults 20+ with complete regression variables (N=4,362). Survey-weighted diabetes-range HbA1c proportions assessed in four income and five education groups. All nine passed the script's NCHS-inspired screen: effective n >=30; nonzero events; subgroup survey DF >=8; confidence interval width <30 percentage points; and relative width <=130% when interval width >5 percentage points. Effective sample sizes are approximate design-based values derived from p(1-p)/SE^2, not independent headcounts.

**Important:** This pass is an exploratory reliability screen of unadjusted complete-case proportions. Review confidence interval method and full NCHS presentation standard, and assess the precision of adjusted model coefficients separately before making publication claims.

## Inference decisions
Two specified survey-weighted quasibinomial logistic regressions using the same complete-case cohort:
- **Provisional primary:** income + education + age + sex; residual denominator DF 6. Joint income p=0.610; joint education p=0.133.
- **Extended sensitivity:** income + education + age + sex + race/ethnicity; residual denominator DF 1. Joint income p=0.854; joint education p=0.596.

The reduced model provides more stable residual-DF inference but omits race/ethnicity, a potentially relevant common cause or marker of structural determinants. This exclusion is **not** a claim that race/ethnicity is scientifically ignorable. Before treating this as the final primary specification, document the estimand, causal structure / confounding rationale, sensitivity to race-adjustment, and lack of causal identification in cross-sectional data. Do not choose models solely based on p-values.

## Next deliverables
1. Generate clearly identified age/sex-adjusted prevalence, confidence intervals and group contrasts, with fully adjusted sensitivity results side by side.
2. Draft the final report with reproducibility instructions, missingness audit, design checks, uncertainties and caveats.
3. Create publication-quality figure with error bars and source caption, then verify reproducibility from a clean session.

Sources:
- https://wwwn.cdc.gov/nchs/nhanes/tutorials/ReliabilityOfEstimates.aspx
- https://search.r-project.org/CRAN/refmans/survey/help/regTermTest.html

Run: `Rscript scripts/15_reliability_and_model_decision.R`.
