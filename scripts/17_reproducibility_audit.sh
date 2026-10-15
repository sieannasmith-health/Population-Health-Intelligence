#!/bin/sh
# Run from project root; fail if any required build/validation fails.
set -eu
.venv/bin/python scripts/13_build_full_survey.py
for script in 10_complete_case_sensitivity 13_adult_domain_validation 14_model_replication 15_reliability_and_model_decision 16_model_comparison_figures 19_income_missingness_sensitivity 20_income_scenario_stress_test; do
  Rscript "scripts/$script.R" > "reports/17_${script}_run.log" 2>&1
  printf 'PASS %s\n' "$script"
done
Rscript -e 'x<-read.csv("reports/14_model_replication.csv"); y<-read.csv("reports/14_marginal_replication.csv"); stopifnot(max(abs(x$beta_diff))<1e-8, max(abs(x$se_diff))<1e-8,max(abs(y$prevalence_difference_pp))<1e-8,max(abs(y$se_difference_pp))<1e-8); cat("PASS replication assertions\n")'
test -s reports/16_model_comparison.png
test -s reports/17_integrated_research_report.md
printf 'PASS essential research outputs\n'

python3 scripts/18_report_consistency_audit.py
