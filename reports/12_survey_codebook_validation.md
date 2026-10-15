# Population Health Intelligence | Codebook and survey-design validation

**Validation status:** Core codes checked; full all-age survey-design reconstruction pending.

## Source references
- NHANES 2017-2018 DEMO_J: https://wwwn.cdc.gov/nchs/data/nhanes/public/2017/datafiles/DEMO_J.htm
- NHANES GHB_J: https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/GHB_J.htm
- CDC weighting: https://wwwn.cdc.gov/nchs/nhanes/tutorials/weighting.aspx
- CDC variance estimation: https://wwwn.cdc.gov/nchs/nhanes/tutorials/varianceestimation.aspx

## Verified locally
- All 5,569 records have age >=20, and SEQN values are unique.
- DMDEDUC2 observed codes: 1-5 valid adult educational categories; 7 refused, 9 don't know (both excluded from modeled education).
- RIDRETH3 observed codes: 1 Mexican American; 2 other Hispanic; 3 non-Hispanic White; 4 non-Hispanic Black; 6 non-Hispanic Asian; 7 other race including multiracial.
- RIAGENDR: 1 male, 2 female (the data file labels this as gender of participant).
- LBXGH is HbA1c percent, measured in the GHB_J laboratory component for participants aged 12+.
- The adult processed file has 15 masked strata and 30 stratum-PSU combinations; 15 design degrees of freedom in the analytic domain.
- WTMEC2YR is the appropriate examination-weight starting point for this combination of examination-laboratory and demographic variables, subject to checking item nonresponse handling.

## Incomplete methodological item
The current `data/processed/adult_hba1c_audit.csv` contains only ages 20+. A CDC-preferred domain design should be rebuilt starting from the merged all-age NHANES respondents, retaining their masked design variables and using `subset(survey_design, RIDAGEYR >= 20 & analytic_eligibility)` rather than pre-filtering the source data. The current degrees of freedom are intact, but this by itself does not establish that all variance estimates are invariant to the correct domain implementation.

**Next:** Build a reproducible all-age merged survey dataset from raw DEMO_J and GHB_J; compare adult-domain estimates with previous results. Keep previously generated results explicitly provisional until the comparison passes.
