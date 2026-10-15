# Publication review | Population Health Intelligence

**Review date:** 2026-10-15  
**Status:** Internal manuscript review completed; external scientific sign-off and publication remain pending.

## Verified in working manuscript

- Research question, sampling frame, source files, analytical cohort, weights, strata, PSUs, statistical models, reported contrasts, missingness, and limitations are explicitly documented.
- Two models are presented as parallel descriptive specifications, avoiding significance-based primary-model selection.
- The manuscript distinguishes HbA1c >=6.5% from clinical diagnosis and does not assert causal effects.
- Earlier reproducibility and 16-point numerical consistency audits passed in the development workflow. This review did not rerun those checks.

## Publication issues requiring attention

1. **Survey inference:** Joint income/education tests in the race/ethnicity-adjusted model use one residual denominator degree of freedom. Present only with prominently stated fragility, or move their p-values to a technical appendix after methodological review.
2. **Missing-data limitations:** 791 of 5,569 adults lack family income-to-poverty ratio. The supplementary observed-versus-missing income analysis is useful but does not rule out nonignorable missingness.
3. **Reliability claims:** The implemented subgroup screening is not the full NCHS Korn-Graubard method. Avoid claiming formal NCHS reliability clearance.
4. **Figure legibility:** Verify chart labels, confidence intervals, contrast-vs-category distinction, source attribution, and readability in the rendered PNG before publishing.
5. **Reproducibility portability:** An isolated folder and virtual environment passed on the same Mac; independent-machine verification remains outside the demonstrated scope.
6. **Repository release:** Raw and processed respondent-level data are excluded. Perform staged file inspection and secret scanning before any public push.
7. **Research positioning:** Report adjusted differences as specification-dependent, descriptive associations in the complete-case cohort, not nationally causal effects.

## Publication recommendation

Maintain the integrated report as a clearly labeled **exploratory portfolio case study** until scientific review, substantive presentation QA, and release checks are finished. A portfolio can present credible provisional analysis with transparent constraints, but it must not be advertised as peer-reviewed or fully validated.

## Next authorized action

Finish figure legibility and report editing, then inspect the prospective Git commit. Publish only after successful review. No GitHub push was requested or performed as part of this review.
