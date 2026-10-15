# Population Health Intelligence | Inference Sensitivity
library(survey)

# 1. Analytic Cohort ------------------------------------------
d <- read.csv("data/processed/adult_hba1c_audit.csv")
d$high <- ifelse(is.na(d$LBXGH), NA, as.integer(d$LBXGH >= 6.5))
d$income <- cut(d$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                labels = c("<=1", "1-2", "2-4", ">4"))
d$education <- factor(d$DMDEDUC2, levels = 1:5,
  labels = c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
d$sex <- factor(d$RIAGENDR, levels = 1:2,
                labels = c("Male", "Female"))
d$race <- factor(d$RIDRETH3)
needed <- c("high", "income", "education", "RIDAGEYR", "sex",
            "race", "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
d$included <- complete.cases(d[needed]) & d$WTMEC2YR > 0
options(survey.lonely.psu = "adjust")
design <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                    weights = ~WTMEC2YR, nest = TRUE, data = d)
a <- subset(design, included)

# 2. Model Specifications -------------------------------------
# Both models are sensitivity analyses, not causal models.
reduced <- svyglm(high ~ income + education + RIDAGEYR + sex,
                  design = a, family = quasibinomial())
full <- svyglm(high ~ income + education + RIDAGEYR + sex + race,
               design = a, family = quasibinomial())

# 3. Denominator Degrees of Freedom ---------------------------
summary_df <- data.frame(
  model = c("Age + sex + SES", "Age + sex + race + SES"),
  design_df = degf(a),
  coefficients = c(length(coef(reduced)), length(coef(full))),
  residual_df = c(df.residual(reduced), df.residual(full))
)
print(summary_df, row.names = FALSE)

# 4. Joint Terms and Explicit DF Sensitivity ------------------
test <- function(model, label, term) {
  fitted_df <- df.residual(model)
  nominal_df <- degf(a)
  conventional <- regTermTest(model, as.formula(paste0("~", term)),
                              df = fitted_df)
  nominal <- regTermTest(model, as.formula(paste0("~", term)),
                         df = nominal_df)
  data.frame(model = label, term = term,
    residual_df = fitted_df, design_df = nominal_df,
    p_residual_df = conventional$p,
    p_design_df = nominal$p)
}
tests <- do.call(rbind, list(
  test(reduced, "Reduced", "income"),
  test(reduced, "Reduced", "education"),
  test(full, "Full", "income"),
  test(full, "Full", "education")
))
print(tests, row.names = FALSE)

# 5. Export ---------------------------------------------------
write.csv(summary_df, "reports/08_model_degrees_of_freedom.csv",
          row.names = FALSE)
write.csv(tests, "reports/08_joint_test_sensitivity.csv",
          row.names = FALSE)
