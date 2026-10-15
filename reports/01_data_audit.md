# NHANES 2017-2018: Data audit

**Source:** CDC NHANES public-use DEMO_J and GHB_J SAS XPT files.
**Date:** October 14, 2026.

| Check | Observed count |
|---|---:|
| Demographics participants | 9,254 |
| Glycohemoglobin records | 6,401 |
| Joined participants | 9,254 |
| Participants aged 20 or older | 5,569 |
| Adult records missing HbA1c | 551 |
| Adult records missing income-to-poverty ratio | 791 |
| Adult records with missing or nonpositive examination weight | 0 |

The files are joined on SEQN; DEMO_J is the left-hand participant population. Missingness counts are not necessarily mutually exclusive. These are unweighted records, not population estimates.

## Next decisions
- Examine adult eligibility and missingness by demographic subgroups.
- Confirm the NHANES survey-specific lab measurement inclusion requirements and appropriateness of MEC weights.
- Use survey weights, strata and PSUs in R; account for subpopulation estimation when generating adult estimates.
- Define the primary estimand and model adjustment set before inference.

No inferential result or population prevalence is reported at this stage.
