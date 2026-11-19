# Exploratory NHANES Cardiometabolic K-means Extension (K = 4)

**Status:** Exploratory portfolio analysis. Results below were documented during the November 19, 2026 RStudio review. The new reproducibility script has been published separately; its outputs should be compared with these recorded values after rerunning locally.

## Data and approach
NHANES August 2021–August 2023; 5,536 adults aged 20+ with complete HbA1c, BMI, mean available systolic BP readings, positive phlebotomy examination weight, and survey-design variables. Each of the three clustering measurements was standardized to a z-score. Conventional **unweighted K-means** used Euclidean distances; survey weighting was applied subsequently to estimate cluster shares.

## Four profiles (recorded RStudio results)
| Descriptive profile | Participants (unweighted) | BMI (kg/m²) | HbA1c (%) | Systolic BP (mmHg) | Survey-weighted share |
|---|---:|---:|---:|---:|---:|
| Comparatively lower measurements | 2,650 | 25.86 | 5.41 | 112.82 | 52.68% |
| Higher BMI | 1,251 | 39.06 | 5.82 | 118.54 | 22.58% |
| Markedly elevated HbA1c | 250 | 33.16 | 9.79 | 126.90 | 4.01% |
| Higher systolic BP | 1,385 | 28.08 | 5.76 | 144.92 | 20.73% |

Profile names are descriptive, not medical diagnoses. K-means numeric labels may be permuted between runs.

## Model selection and validation
- K = 2 within-cluster sum of squares: approximately **12,434.16**.
- K = 4 within-cluster sum of squares: approximately **6,940.78**, a **44.2%** reduction relative to K = 2. Within-cluster sum of squares naturally decreases as K increases; this is not independent proof of superiority.
- Initial silhouette estimates, calculated on different random subsets: **0.3311 (K = 2)** and **0.3301 (K = 4)**.
- Consistent same-1,500-person subset check from RStudio review: **0.3338 (K = 2)** and **0.3359 (K = 4)**, with 187 versus 79 negative silhouettes.
- In the recorded eight-seed repeated-initialization check, all pairwise adjusted Rand indices were **1.000** and the total within-cluster sum of squares was approximately **6,940.78** across runs.

These checks support four groups as an interpretable exploratory description with similar, modest silhouette separation to two groups. Repeated initializations demonstrate **algorithmic repeatability on the same observations**, not resampling or out-of-sample stability.

## Interpretation
The K = 2 solution largely partitions participants into broader lower- and higher-measurement profiles. K = 4 identifies differences that are obscured by that broader partition, including a small group with markedly elevated mean HbA1c and a separate group with higher mean systolic blood pressure. The four-group model may therefore be more informative for descriptive cardiometabolic profiling, without showing materially superior silhouette separation.

## Reproducibility execution, November 19, 2026

**Status: successfully executed on the original Mac using local NHANES source XPT files and R 4.6.1.** Analytic sample: **5,536** adults. The rerun reproduced the four group sizes and centroids recorded above (allowing arbitrary cluster-label permutations). All **28 pairwise** adjusted Rand indices across eight random-seed fits were **1.000**.

The new same-subsample comparison is **not numerically identical to the earlier classroom/RStudio review** because the reproducibility script selects a different seeded subset of 1,500 observations. These are the *actual rerun* values:

| Measure | K = 2 | K = 4 |
|---|---:|---:|
| Within-cluster sum of squares | 12,434.1566 | 6,940.7833 |
| Mean silhouette (same n = 1,500 sample) | **0.334749** | **0.342952** |
| Negative silhouettes (same sample) | **195** | **60** |

The change in silhouette estimate relative to the earlier recorded 0.3338/0.3359 comparison is due to a different sampled comparison set; the substantive conclusion (similar, modest silhouette separation and interpretable K = 4 profiles) remains the same.

Verified raw output files:
- [K = 2 versus K = 4 metrics](kmeans_k4/k2_k4_validation.csv)
- [K = 4 centroids and cluster sizes](kmeans_k4/k4_centroids.csv)
- [Survey-weighted cluster shares and standard errors](kmeans_k4/k4_weighted_shares.csv)
- [Eight-seed pairwise stability](kmeans_k4/k4_seed_stability.csv)

The execution generated `k2_k4_silhouette.png` and `k4_bmi_hba1c.png` locally; these figures are not yet included in this GitHub commit. R emitted a nonfatal *Quick-TRANSfer stage steps exceeded maximum* warning while rendering graphics. The script nevertheless finished, printed the expected results, and produced all four CSV result files.

## Limitations and reproducibility
This is cross-sectional and descriptive: no causation, predictive risk, or diagnosis can be inferred from cluster assignment. Silhouette values are subsample estimates, and cluster profiles may depend on feature selection, scaling, sampling, and survey-aware methodology. Clustering itself was unweighted; weighted proportions describe representation in the target survey population conditional on that clustering.

The repository's pre-existing `reports/kmeans/` CSVs reflect an **earlier K = 2 automatic-selection run**, not the four profiles reported here. **Do not use those older tables as K = 4 evidence.** The added `scripts/29_nhanes_kmeans_k4_validation.R` generates a separate `reports/kmeans_k4/` directory when executed from the project root with source XPT files locally available. No person-level NHANES data are committed to GitHub.

The reproduction script has now been executed and its CSV outputs published. The historical RStudio silhouette numbers above are retained for provenance; use the actual reproducibility-run silhouette values in the table above when reporting the new seeded comparison.
