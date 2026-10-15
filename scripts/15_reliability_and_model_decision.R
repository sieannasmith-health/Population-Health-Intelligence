# Population Health Intelligence | Reliability and Model Decision
library(survey)
d <- read.csv("data/processed/all_age_hba1c_survey.csv")
d$high <- ifelse(is.na(d$LBXGH), NA, as.integer(d$LBXGH >= 6.5))
d$income <- cut(d$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                labels = c("<=1", "1-2", "2-4", ">4"))
d$education <- factor(d$DMDEDUC2, levels = 1:5,
  labels = c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
d$sex <- factor(d$RIAGENDR, levels = 1:2,
                labels = c("Male", "Female"))
d$race <- factor(d$RIDRETH3, levels = c(1, 2, 3, 4, 6, 7))
need <- c("high", "income", "education", "RIDAGEYR", "sex",
          "race", "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
d$included <- d$RIDAGEYR >= 20 & complete.cases(d[need]) &
              !is.na(d$WTMEC2YR) & d$WTMEC2YR > 0
d$included[is.na(d$included)] <- FALSE
options(survey.lonely.psu = "adjust")
s <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
               weights = ~WTMEC2YR, nest = TRUE, data = d)
a <- subset(s, included)

# Reliability: complete-case descriptive subgroup proportions.
audit <- function(variable) {
  out <- lapply(levels(a$variables[[variable]]), function(group) {
    # Use an explicit constant column for the standard subset.
    z <- subset(a, get(variable) == group)
    est <- svymean(~high, z, na.rm = TRUE)
    p <- unname(coef(est)[1]); se <- unname(SE(est)[1])
    ci <- confint(est)[1, ]
    n <- nrow(z$variables)
    eff_n <- if (se > 0 && p > 0 && p < 1)
      min(n, p * (1 - p) / se^2) else NA_real_
    rciw <- if (p > 0) 100 * diff(ci) / p else NA_real_
    data.frame(dimension = variable, category = group, n = n,
      cases = sum(z$variables$high), estimate_pct = 100 * p,
      lower_pct = 100 * ci[1], upper_pct = 100 * ci[2],
      effective_n = eff_n, relative_ci_width_pct = rciw,
      design_df = degf(z))
  })
  do.call(rbind, out)
}
reliability <- rbind(audit("income"), audit("education"))
reliability$review <- with(reliability,
  effective_n < 30 | cases == 0 | design_df < 8 |
    (upper_pct - lower_pct >= 30) |
    ((upper_pct - lower_pct > 5) & relative_ci_width_pct > 130))
print(reliability[, c("dimension", "category", "n", "cases",
 "effective_n", "relative_ci_width_pct", "design_df", "review")],
 row.names = FALSE, digits = 4)

# Prespecified scientific comparison: age/sex baseline vs.
# age/sex/race sensitivity. Race retained in full specification.
models <- list(
  primary = svyglm(high ~ income + education + RIDAGEYR + sex,
                   design = a, family = quasibinomial()),
  extended = svyglm(high ~ income + education + RIDAGEYR + sex + race,
                    design = a, family = quasibinomial()))
tests <- do.call(rbind, lapply(names(models), function(name) {
  f <- models[[name]]
  data.frame(model = name, residual_df = df.residual(f),
    income_p = regTermTest(f, ~income)$p,
    education_p = regTermTest(f, ~education)$p)
}))
print(tests, row.names = FALSE)
write.csv(reliability, "reports/15_subgroup_reliability.csv", row.names = FALSE)
write.csv(tests, "reports/15_primary_model_tests.csv", row.names = FALSE)
