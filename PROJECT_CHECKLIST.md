# Population Health Intelligence | Project Checklist

**Project goal:** Investigate associations between socioeconomic characteristics and HbA1c >=6.5% among US adults using NHANES 2017-2018, with reproducible analysis and employer-facing results.

## 1. Research scope and data
- [x] Define primary socioeconomic / cardiometabolic research question
- [x] Select NHANES 2017-2018 and identify demographics and HbA1c files
- [x] Download DEMO_J and GHB_J public-use data
- [x] Join by participant ID and audit basic record counts
- [x] Validate core demographic and HbA1c variable codes against CDC codebooks
- [x] Rebuild all-age NHANES design and verify descriptive adult-domain results
- [x] Refit adjusted models and reproduce standardized marginals on full survey design

## 2. Data preparation and quality
- [x] Create adult (20+) analysis dataset
- [x] Derive HbA1c >=6.5% indicator
- [x] Create income-to-poverty and education group variables
- [x] Document missing-value counts and model complete-case sample
- [x] Audit missingness and included/excluded participants by socioeconomic and demographic groups
- [x] Finalize reproducible data dictionary and analysis cohort flow

## 3. Descriptive analysis
- [x] Produce preliminary weighted HbA1c estimates by age group
- [x] Produce preliminary weighted HbA1c estimates by income and education
- [x] Save socioeconomic results table and initial visualization
- [x] Compare overall weighted HbA1c prevalence across outcome-observed and complete-case samples
- [x] Compare subgroup sample sizes and estimates across measured and complete-case cohorts
- [x] Screen descriptive subgroup reliability on reconstructed survey design

## 4. Modeling and validation
- [x] Fit adjusted survey-weighted logistic model
- [x] Export adjusted odds ratios and confidence intervals
- [x] Compare linear and quadratic age specifications
- [x] Produce adjusted marginal prevalence estimates by income and education
- [x] Calculate covariance-aware adjusted marginal contrasts and uncertainty
- [x] Evaluate income and education test sensitivity to denominator degrees of freedom
- [x] Document parallel descriptive adjustment specifications and inference limitations
- [x] Evaluate observed-outcome sensitivity to income missingness
- [ ] Resolve remaining nonresponse and model-robustness limitations before publication

## 5. Communication and publication
- [x] Save working analysis scripts and preliminary research notes
- [x] Generate preliminary figures and CSV outputs
- [x] Generate labeled dual-model comparison figure and result tables
- [x] Finalize figure caption, interpretation guide and numerical alignment
- [x] Draft integrated methods, results, discussion and limitations report
- [x] Integrate missing-income sensitivity and verify selected reported numbers
- [x] Complete internal manuscript scientific and editorial review (see report 20)
- [ ] Obtain final publication scientific/editorial sign-off
- [x] Run isolated Rscript reproducibility audit in existing local environment
- [x] Verify full rebuild in isolated directory and new Python environment on same Mac
- [x] Prepare portfolio README and public-safe Git exclusions
- [x] Review local Git candidate file list for protected paths
- [x] Inspect rendered figure and local staged Git release file list
- [x] Create first local Git commit for reviewed research files
- [ ] Publish verified GitHub repository (not yet published)
- [ ] Add verified portfolio project to resume, LinkedIn and Recall knowledge base

## Current decision
**Next task:** Obtain final scientific/editorial publication sign-off and explicitly accept remaining exploratory limitations; then connect a GitHub remote and publish. Local Git commit is complete. Internal review is documented in reports/20_publication_review.md. Results are exploratory until the validation and reporting gates are complete.

## Tracking rules
- [x] = Output exists and was executed or checked.
- [ ] = Not completed or not fully verified.
- A completed script is not the same as a finalized, publication-ready research conclusion.
- Update this file whenever a research task is completed; retain unfinished validation work visibly.
