# Isolated reproducibility verification

**Result: PASS, October 15, 2026.**

The project was copied into a new temporary directory on the same Mac, including only required public-use raw XPT inputs, source scripts, and the working report. A new Python virtual environment was created and pandas installed independently of the project's existing `.venv`. R and the R survey package came from the host machine.

The first run exposed an incomplete build graph: the report audit expected `reports/10_complete_case_sensitivity.csv`, which the reproducibility script did not regenerate. The workflow was updated to include `scripts/10_complete_case_sensitivity.R` and then passed in the isolated folder.

Passed stages: NHANES all-age reconstruction; complete-case sensitivity; adult-domain validation; adjusted model and marginal replication; subgroup reliability/model decision; dual-model figure; missing-income sensitivity; manuscript numerical checks (16 of 16).

**Scope:** isolated-directory/virtualenv portability on the original Mac. This is not yet independent-machine verification, nor a third-party scientific review.

Command: `./scripts/17_reproducibility_audit.sh` after installing Python pandas and R survey, with raw inputs and the working report present.
